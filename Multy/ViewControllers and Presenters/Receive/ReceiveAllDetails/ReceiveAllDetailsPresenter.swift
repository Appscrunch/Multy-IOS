//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class ReceiveAllDetailsPresenter: NSObject, ReceiveSumTransferProtocol, SendWalletProtocol {

    var receiveAllDetailsVC: ReceiveAllDetailsViewController?
    
    var cryptoSum: Double?
    var cryptoName: String?
    var fiatSum: Double?
    var fiatName: String?
    
    var walletAddress = ""
    
    var wallet: WalletRLM?
    
    
    
    func transferSum(cryptoAmount: Double, cryptoCurrency: String, fiatAmount: Double, fiatName: String) {
        self.cryptoSum = cryptoAmount
        self.cryptoName = cryptoCurrency
        self.fiatSum = fiatAmount
        self.fiatName = fiatName
        
        self.receiveAllDetailsVC?.setupUIWithAmounts()
    }
    
    func sendWallet(wallet: WalletRLM) {
        self.wallet = wallet
        self.receiveAllDetailsVC?.updateUIWithWallet()
    }
}
