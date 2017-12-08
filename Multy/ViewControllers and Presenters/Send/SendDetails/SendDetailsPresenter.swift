//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class SendDetailsPresenter: NSObject {
    
    var sendDetailsVC: SendDetailsViewController?
    
    var choosenWallet: UserWalletRLM?
    
    var selectedIndexOfSpeed: Int?
    
    var donationInCrypto: Double? = 0.0001
    var donationInFiat: Double?
    var cryptoName = "BTC"
    var fiatName = "USD"
    
    var addressToStr: String?
    var amountFromQr: Double?
    
    var maxAllowedToSpend = 0.0
    
    let trasactionObj = TransactionRLM()
    
    let donationObj = DonationObj()
    
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
    
    func createDonation() {
        self.donationObj.sumInCrypto = self.donationInCrypto
        self.donationObj.cryptoName = self.cryptoName
        self.donationObj.sumInFiat = Double(round(100*self.donationInCrypto!*exchangeCourse/100))
        self.donationObj.fiatName = self.fiatName
    }
    
    func nullifyDonation() {
        self.donationObj.sumInCrypto = 0.0
        self.donationObj.cryptoName = ""
        self.donationObj.sumInFiat = 0.0
        self.donationObj.fiatName = ""
    }
    
    func setMaxAllowed() {
        self.maxAllowedToSpend = (self.choosenWallet?.sumInCrypto)! - self.trasactionObj.sumInCrypto
    }
    
    func checkMaxEvelable() {
        self.maxAllowedToSpend = (self.choosenWallet?.sumInCrypto)! - self.trasactionObj.sumInCrypto
        if self.donationObj.sumInCrypto! >= self.maxAllowedToSpend  {
            self.sendDetailsVC?.presentWarning(message: "Your donation sum and fee cost more than you have in wallet.\n\n Fee cost: \(self.trasactionObj.sumInCrypto) \(self.cryptoName)\n Donation sum: \(self.donationObj.sumInCrypto ?? 0.0) \(self.cryptoName)\n Sum in Wallet: \(self.choosenWallet?.sumInCrypto ?? 0.0) \(self.cryptoName)")
        } else {
            self.sendDetailsVC?.performSegue(withIdentifier: "sendAmountVC", sender: Any.self)
        }
    }
    
    
    func getExchange() {
        DataManager.shared.getExchangeCourse { (error) in
            
        }
    }
}
