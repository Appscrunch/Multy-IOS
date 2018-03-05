//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import RealmSwift

class ReceiveStartPresenter: NSObject {
    
    var receiveStartVC: ReceiveStartViewController?
    
    var isNeedToPop = false
    
    var selectedIndexPath: IndexPath? = nil
    
//    var walletsArr = [UserWalletRLM?]()
    var walletsArr = Array<UserWalletRLM>()
    
    var selectedIndex: Int?
    
    //test func
//    func createWallets() {
//        for index in 1...10 {
//            let wallet = UserWalletRLM()
//            wallet.name = "Ivan \(index)"
//            wallet.cryptoName = "BTC"
//            wallet.sumInCrypto = 12.345 + Double(index)
//            wallet.sumInFiat = Double(round(100*wallet.sumInCrypto * exchangeCourse)/100)
//            wallet.fiatName = "USD"
//            wallet.fiatSymbol = "$"
//            wallet.address = "3DA28WCp4Cu5LQiddJnDJJmKWvmmZAKP5K"
//
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
                self.walletsArr = acc!.wallets.sorted(by: { $0.availableSumInCrypto > $1.availableSumInCrypto })
                self.receiveStartVC?.updateUI()
            }
        }
    }
}

