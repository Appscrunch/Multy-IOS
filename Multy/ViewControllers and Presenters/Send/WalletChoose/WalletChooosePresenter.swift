//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import RealmSwift

class WalletChooosePresenter: NSObject {

    var walletChoooseVC: WalletChoooseViewController?
    
    var walletsArr = List<UserWalletRLM>()
    var addressToStr: String?
    var amountFromQr: Double?
    
    var selectedIndex: Int?
    
//    func createWallets() {
//        for index in 1...10 {
//            let wallet = UserWalletRLM()
//            wallet.name = "Ivan \(index)"
//            wallet.cryptoName = "BTC"
//            wallet.sumInCrypto = 12.345 + Double(index)
//            wallet.sumInFiat = wallet.sumInCrypto * exchangeCourse
//            wallet.sumInFiat = Double(round(100*wallet.sumInFiat)/100)
////            0.455000001
////            0.46
//            wallet.fiatName = "USD"
//            wallet.fiatSymbol = "$"
//            wallet.address = "3DA28WCp4Cu5LQiddJnDJJmKWvmmZAKP5K"
//            self.walletsArr.append(wallet)
//        }
//    }
    
    func numberOfWallets() -> Int {
        return self.walletsArr.count
    }
    
    func getWallets() {
        DataManager.shared.getAccount { (acc, err) in
            if err == nil {
                // MARK: check this
                self.walletsArr = acc!.wallets
                self.walletChoooseVC?.updateUI()
            }
        }
    }
    
    func getExchange() {
        DataManager.shared.getExchangeCourse { (error) in
            
        }
    }
}
