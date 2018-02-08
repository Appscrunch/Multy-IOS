//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import RealmSwift

class SendDetailsPresenter: NSObject, CustomFeeRateProtocol {
    
    var sendDetailsVC: SendDetailsViewController?
    
    var choosenWallet: UserWalletRLM?
    var walletAddresses: List<AddressRLM>?
    
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
    

    var customFee = 0
    
    
    var feeRate: NSDictionary?{
        didSet {
            sendDetailsVC?.tableView.reloadData()
        }
    }

    
//    self.sumInFiat = Double(round(100*self.sumInFiat)/100)
    
    func getWalletVerbose() {
        //MARK: implement changes
        
//        DataManager.shared.getAccount { (account, err) in
//            DataManager.shared.getOneWalletVerbose(account!.token,
//                                                   walletID: self.choosenWallet!.walletID,
//                                                   completion: { (addresses, error) in
//                self.walletAddresses = addresses
//            })
//        }
    }
    
    func requestFee() {
        DataManager.shared.getAccount { (account, error) in
            DataManager.shared.getFeeRate(account!.token, currencyID: 0, completion: { (dict, error) in
                if dict != nil {
                    self.feeRate = dict
                } else {
                    print("Did failed getting feeRate")
                }
            })
        }
    }
    
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
        case 5:
            self.trasactionObj.speedName = "Custom"
            self.trasactionObj.speedTimeString = ""
            self.trasactionObj.sumInCrypto = Double(self.customFee)
            self.trasactionObj.sumInFiat = 0.0
            self.trasactionObj.cryptoName = "Satoshi per Byte"
            self.trasactionObj.fiatName = "USD"
            self.trasactionObj.numberOfBlocks = 0
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
        self.maxAllowedToSpend = (self.choosenWallet?.sumInCrypto)!
//        self.maxAllowedToSpend = (self.choosenWallet?.sumInCrypto)! - self.trasactionObj.sumInCrypto
        if self.donationObj.sumInCrypto! > self.maxAllowedToSpend  {
//            self.sendDetailsVC?.presentWarning(message: "Your donation sum and fee cost more than you have in wallet.\n\n Fee cost: \(self.trasactionObj.sumInCrypto) \(self.trasactionObj.cryptoName)\n Donation sum: \(self.donationObj.sumInCrypto ?? 0.0) \(self.cryptoName)\n Sum in Wallet: \(self.choosenWallet?.sumInCrypto ?? 0.0) \(self.cryptoName)")
            self.sendDetailsVC?.presentWarning(message: "Your donation more than you have in wallet.\n\nDonation sum: \(self.donationObj.sumInCrypto ?? 0.0) \(self.cryptoName)\n Sum in Wallet: \(self.choosenWallet?.sumInCrypto ?? 0.0) \(self.cryptoName)")
        } else if self.donationObj.sumInCrypto! == self.maxAllowedToSpend {
            self.sendDetailsVC?.presentWarning(message: "Your donation is equal your wallet sum.\n\nDonation sum: \(self.donationObj.sumInCrypto ?? 0.0) \(self.cryptoName)\n Sum in Wallet: \(self.choosenWallet?.sumInCrypto ?? 0.0) \(self.cryptoName)")
        } else {
            self.sendDetailsVC?.performSegue(withIdentifier: "sendAmountVC", sender: Any.self)
        }
    }
    
    func customFeeData(firstValue: Double, secValue: Double) {
        print(firstValue)
        if selectedIndexOfSpeed != 5 {
           selectedIndexOfSpeed = 5
        }
        let cell = self.sendDetailsVC?.tableView.cellForRow(at: [0, selectedIndexOfSpeed!]) as! CustomTrasanctionFeeTableViewCell
        cell.value = firstValue
        cell.setupUIForBtc()
        self.customFee = Int(firstValue)
        self.sendDetailsVC?.tableView.reloadData()
    }
}
