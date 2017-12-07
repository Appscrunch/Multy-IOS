//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class ReceiveStartPresenter: NSObject {
    
    var receiveStartVC: ReceiveStartViewController?
    
    var isNeedToPop = false
    
    var selectedIndexPath: IndexPath? = nil
    
    var walletsArr = [WalletRLM]()
    
    var selectedIndex: Int?
    
    //test func
    func createWallets() {
        for index in 1...10 {
            let wallet = WalletRLM()
            wallet.name = "Ivan \(index)"
            wallet.cryptoName = "BTC"
            wallet.sumInCrypto = 12.345 + Double(index)
            wallet.sumInFiat = wallet.sumInCrypto * exchangeCourse
            wallet.fiatName = "USD"
            wallet.fiatSymbol = "$"
            wallet.address = "3DA28WCp4Cu5LQiddJnDJJmKWvmmZAKP5K"
            self.walletsArr.append(wallet)
        }
    }
    
    func numberOfWallets() -> Int {
        return self.walletsArr.count
    }
}

