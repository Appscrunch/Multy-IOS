//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import Foundation
import UIKit
import RealmSwift

class WalletPresenter: NSObject {
    
    var mainVC : WalletViewController?
    var historyList = List<HistoryRLM>() {
        didSet {
            blockedAmount = calculateBlockedAmount()
            updateWalletInfo()
        }
    }
    var blockedAmount = UInt32(0)
    var wallet : UserWalletRLM? {
        didSet {
            print("WalletPresenter:\n\(wallet?.addresses)")
        }
    }
    var account : AccountRLM?
    
    var transactionsArray = [TransactionRLM]()
    
    func updateWalletInfo() {
        mainVC?.tableView.reloadData()
    }
    
    func registerCells() {
        let walletHeaderCell = UINib.init(nibName: "MainWalletHeaderCell", bundle: nil)
        self.mainVC?.tableView.register(walletHeaderCell, forCellReuseIdentifier: "MainWalletHeaderCellID")
        
//        let walletCollectionCell = UINib.init(nibName: "MainWalletCollectionViewCell", bundle: nil)
//        self.mainVC?.tableView.register(walletCollectionCell, forCellReuseIdentifier: "WalletCollectionViewCellID")
        
        let mainWalletCell = UINib.init(nibName: "TransactionWalletCell", bundle: nil)
        self.mainVC?.tableView.register(mainWalletCell, forCellReuseIdentifier: "TransactionWalletCellID")
    }
    
    func fixConstraints() {
        if #available(iOS 11.0, *) {
            //OK: Storyboard was made for iOS 11
        } else {
            self.mainVC?.tableViewTopConstraint.constant = 0
        }
    }
    
    func numberOfTransactions() -> Int {
        return self.transactionsArray.count
    }
    
    func getHistory() {
        DataManager.shared.getTransactionHistory(token: (account?.token)!, walletID: (wallet?.walletID)!) { (historyList, err) in
            if err == nil && historyList != nil {
                self.historyList = historyList!
                
                DataManager.shared.realmManager.saveHistoryForWallet(historyArr: historyList!, completion: { (histList) in
                    
                })
            }
        }
    }
    
    func calculateBlockedAmount() -> UInt32 {
        var sum = UInt32(0)
        
        for history in historyList {
            if history.txStatus == "incoming in mempool" {
                sum += history.txOutAmount.uint32Value
            }
        }
        
        return sum
    }
}
