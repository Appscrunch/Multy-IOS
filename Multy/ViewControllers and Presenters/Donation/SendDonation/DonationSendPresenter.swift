//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class DonationSendPresenter: NSObject, CustomFeeRateProtocol, SendWalletProtocol {

    var mainVC: DonationSendViewController?
    
    var selectedIndexOfSpeed: Int?
    
    var customFee = UInt32(20)
    
    var walletPayFrom: UserWalletRLM?
    
    var feeRate: NSDictionary? {
        didSet {
            mainVC?.tableView.reloadData()
        }
    }
    
    func customFeeData(firstValue: Double, secValue: Double) {
        print(firstValue)
        if selectedIndexOfSpeed != 5 {
            selectedIndexOfSpeed = 2
        }
        let cell = self.mainVC?.tableView.cellForRow(at: [0, selectedIndexOfSpeed!]) as! CustomTrasanctionFeeTableViewCell
        cell.value = firstValue
        cell.setupUIForBtc()
        self.customFee = UInt32(firstValue)
        self.mainVC?.tableView.reloadData()
        self.mainVC?.makeSendAvailable(isAvailable: true)
//        sendDetailsVC?.sendAnalyticsEvent(screenName: "\(screenTransactionFeeWithChain)\(transactionDTO.choosenWallet!.chain)", eventName: customFeeSetuped)
    }
    
    func getWallets() {
        self.mainVC?.view.isUserInteractionEnabled = false
        DataManager.shared.realmManager.fetchAllWallets { (wallets) in
            self.mainVC?.view.isUserInteractionEnabled = true
            let walletsArr = Array(wallets!.sorted(by: {$0.sumInCrypto > $1.sumInCrypto}))
            self.walletPayFrom = walletsArr.first
            self.mainVC?.updateUIWithWallet()
        }
    }
    
    func sendWallet(wallet: UserWalletRLM) {
        self.walletPayFrom = wallet
        self.mainVC?.updateUIWithWallet()
    }
}
