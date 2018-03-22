//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import Foundation
import UIKit
import RealmSwift

class BTCWalletPresenter: NSObject {
    var mainVC : BTCWalletViewController?
    var blockedAmount = UInt64(0)
    var wallet : UserWalletRLM? {
        didSet {
            mainVC?.titleLbl.text = self.wallet?.name
            mainVC?.tableView.reloadRows(at: [[0, 0]], with: .none)
            blockedAmount = wallet!.calculateBlockedAmount()
//            updateWalletInfo()
        }
    }
    var account : AccountRLM?
    
    var transactionsArray = [TransactionRLM]()
    
    func updateWalletInfo() {
//        mainVC?.titleLbl.text = wallet?.name
//        mainVC?.updateUI()
//        mainVC?.updateExchange()
//        mainVC?.updateHistory()
    }
    
    var historyArray = [HistoryRLM]() {
        didSet {
//            blockedAmount = calculateBlockedAmount()
//            updateWalletInfo()
//            mainVC?.updateHistory()
            reloadTableView()
        }
    }
    
    func reloadTableView() {
        if historyArray.count > 0 {
            mainVC?.hideEmptyLbls()
        }
        
        let contentOffset = mainVC!.tableView.contentOffset
        mainVC!.tableView.reloadData()
        mainVC!.tableView.layoutIfNeeded()
        mainVC!.tableView.setContentOffset(contentOffset, animated: false)
        
        self.mainVC!.refreshControl.endRefreshing()
    }
    
    func registerCells() {
        let walletHeaderCell = UINib.init(nibName: "MainWalletHeaderCell", bundle: nil)
        self.mainVC?.tableView.register(walletHeaderCell, forCellReuseIdentifier: "MainWalletHeaderCellID")
        
//        let walletCollectionCell = UINib.init(nibName: "MainWalletCollectionViewCell", bundle: nil)
//        self.mainVC?.tableView.register(walletCollectionCell, forCellReuseIdentifier: "WalletCollectionViewCellID")
        
        let transactionCell = UINib.init(nibName: "TransactionWalletCell", bundle: nil)
        self.mainVC?.tableView.register(transactionCell, forCellReuseIdentifier: "TransactionWalletCellID")
        
        let transactionPendingCell = UINib.init(nibName: "TransactionPendingCell", bundle: nil)
        self.mainVC?.tableView.register(transactionPendingCell, forCellReuseIdentifier: "TransactionPendingCellID")
    }
    
    func fixConstraints() {
        if #available(iOS 11.0, *) {
            //OK: Storyboard was made for iOS 11
        } else {
            self.mainVC?.tableViewTopConstraint.constant = 0
        }
    }
    
    func numberOfTransactions() -> Int {
        return self.historyArray.count
    }
    
    func isTherePendingMoney(for indexPath: IndexPath) -> Bool {
        return wallet!.blockedAmount(for: historyArray[indexPath.row - 1]) > 0
    }
    
    func getNumberOfPendingTransactions() -> Int {
        var count = 0
        
        for transaction in historyArray {
            if wallet!.blockedAmount(for: transaction) > 0 {
                count += 1
            }
        }
        
        return count
    }
    
    
    func getHistoryAndWallet() {
        DataManager.shared.getOneWalletVerbose(walletID: wallet!.walletID, blockchain: BlockchainType.create(wallet: wallet!)) { (wallet, error) in
            if wallet != nil {
                self.wallet = wallet
            }
        }
        
        
        DataManager.shared.getTransactionHistory(currencyID: wallet!.chain, networkID: wallet!.chainType, walletID: wallet!.walletID) { (histList, err) in
            if err == nil && histList != nil {
                self.mainVC!.refreshControl.endRefreshing()
                self.mainVC!.tableView.isUserInteractionEnabled = true
                self.mainVC!.tableView.contentOffset.y = 0
//                self.mainVC!.tableView.contentOffset = 
                self.historyArray = histList!.sorted(by: { $0.blockTime > $1.blockTime })
                print("transaction history:\n\(histList)")
                self.mainVC!.isSocketInitiateUpdating = false
            }
            
//            self.mainVC?.progressHUD.hide()
//            self.mainVC?.updateUI()
        }
    }
}
