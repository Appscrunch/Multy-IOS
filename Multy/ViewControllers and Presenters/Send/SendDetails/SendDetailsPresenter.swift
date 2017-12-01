//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class SendDetailsPresenter: NSObject {
    
    var sendDetailsVC: SendDetailsViewController?
    
    var choosenWallet: WalletRLM?
    
    var selectedIndexOfSpeed: Int?
    
    var donationInCrypto: Double? = 0.0001
    var donationInFiat: Double?
    
    var addressToStr: String?
    
    let trasactionObj = TransactionRLM()
    
//    self.sumInFiat = Double(round(100*self.sumInFiat)/100)
    
    func createTransaction(index: Int) {
        switch index {
        case 0:
            self.trasactionObj.speedName = "Very Fast"
            self.trasactionObj.speedTimeString = "∙ 10 minutes"
            self.trasactionObj.sumInCrypto = 0.0001
            self.trasactionObj.sumInFiat = Double(round(100*self.trasactionObj.sumInCrypto * exchangeCourse)/100)
            self.trasactionObj.cryptoName = "BTC"
            self.trasactionObj.fiatName = "USD"
            self.trasactionObj.numberOfBlocks = 6
        case 1:
            self.trasactionObj.speedName = "Fast"
            self.trasactionObj.speedTimeString = "∙ 6 hour"
            self.trasactionObj.sumInCrypto = 0.0001
            self.trasactionObj.sumInFiat = Double(round(100*self.trasactionObj.sumInCrypto * exchangeCourse)/100)
            self.trasactionObj.cryptoName = "BTC"
            self.trasactionObj.fiatName = "USD"
            self.trasactionObj.numberOfBlocks = 10
        case 2:
            self.trasactionObj.speedName = "Medium"
            self.trasactionObj.speedTimeString = "∙ 5 days"
            self.trasactionObj.sumInCrypto = 0.0001
            self.trasactionObj.sumInFiat = Double(round(100*self.trasactionObj.sumInCrypto * exchangeCourse)/100)
            self.trasactionObj.cryptoName = "BTC"
            self.trasactionObj.fiatName = "USD"
            self.trasactionObj.numberOfBlocks = 20
        case 3:
            self.trasactionObj.speedName = "Slow"
            self.trasactionObj.speedTimeString = "∙ 1 week"
            self.trasactionObj.sumInCrypto = 0.0001
            self.trasactionObj.sumInFiat = Double(round(100*self.trasactionObj.sumInCrypto * exchangeCourse)/100)
            self.trasactionObj.cryptoName = "BTC"
            self.trasactionObj.fiatName = "USD"
            self.trasactionObj.numberOfBlocks = 50
        case 4:
            self.trasactionObj.speedName = "Very Slow"
            self.trasactionObj.speedTimeString = "∙ 2 weeks"
            self.trasactionObj.sumInCrypto = 0.0001
            self.trasactionObj.sumInFiat = Double(round(100*self.trasactionObj.sumInCrypto * exchangeCourse)/100)
            self.trasactionObj.cryptoName = "BTC"
            self.trasactionObj.fiatName = "USD"
            self.trasactionObj.numberOfBlocks = 70
        default:
            return
        }
    }
    
}
