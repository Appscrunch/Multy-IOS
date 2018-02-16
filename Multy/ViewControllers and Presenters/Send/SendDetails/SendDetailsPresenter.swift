//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import RealmSwift

class SendDetailsPresenter: NSObject, CustomFeeRateProtocol {
    
    var sendDetailsVC: SendDetailsViewController?
    var transactionDTO = TransactionDTO()
    var historyArray : List<HistoryRLM>? {
        didSet {
            self.blockedAmount = calculateBlockedAmount()
            availableSumInCrypto = self.transactionDTO.choosenWallet!.sumInCrypto - convertSatoshiToBTC(sum: calculateBlockedAmount())
            availableSumInFiat = availableSumInCrypto! * exchangeCourse
        }
    }
    
    var blockedAmount           : UInt32?
    var availableSumInCrypto    : Double?
    var availableSumInFiat      : Double?
    
    var selectedIndexOfSpeed: Int?
    
    var donationInCrypto: Double? = 0.0001
    var donationInFiat: Double?
    var cryptoName = "BTC"
    var fiatName = "USD"
    
//    var addressToStr: String?
//    var amountFromQr: Double?
    
    var maxAllowedToSpend = 0.0
    
    let transactionObj = TransactionRLM()
    
    let donationObj = DonationDTO()
    

    var customFee = UInt32(20)
    
    var feeRate: NSDictionary? {
        didSet {
            sendDetailsVC?.tableView.reloadData()
        }
    }

    
//    self.sumInFiat = Double(round(100*self.sumInFiat)/100)
    
    func getData() {
        DataManager.shared.getAccount { (account, error) in
            if error != nil {
                return
            }
            
            DataManager.shared.getTransactionHistory(currencyID: self.transactionDTO.choosenWallet!.chain, walletID: self.transactionDTO.choosenWallet!.walletID) { (histList, err) in
                if err == nil && histList != nil {
                    self.historyArray = histList!
                }
            }
        }
    }
    
    func getWalletVerbose() {
        //MARK: implement changes
        
//        DataManager.shared.getAccount { (account, err) in
//            DataManager.shared.getOneWalletVerbose(account!.token,
//                                                   walletID: self.choosenWallet!.walletID,
//                                                   completion: { (addresses, error) in
//            })
//        }
    }
    
    func requestFee() {
        DataManager.shared.getFeeRate(currencyID: 0, completion: { (dict, error) in
            if dict != nil {
                self.feeRate = dict
            } else {
                print("Did failed getting feeRate")
            }
        })
    }
    
    func createTransaction(index: Int) {
        switch index {
        case 0:
            self.transactionObj.speedName = "Very Fast"
            self.transactionObj.speedTimeString = "∙ 10 minutes"
            self.transactionObj.sumInCrypto = 0.00000005
            self.transactionObj.sumInFiat = Double(round(100*self.transactionObj.sumInCrypto * exchangeCourse)/100)
            self.transactionObj.cryptoName = "BTC"
            self.transactionObj.fiatName = "USD"
            self.transactionObj.numberOfBlocks = 6
        case 1:
            self.transactionObj.speedName = "Fast"
            self.transactionObj.speedTimeString = "∙ 6 hour"
            self.transactionObj.sumInCrypto = 0.00000005
            self.transactionObj.sumInFiat = Double(round(100*self.transactionObj.sumInCrypto * exchangeCourse)/100)
            self.transactionObj.cryptoName = "BTC"
            self.transactionObj.fiatName = "USD"
            self.transactionObj.numberOfBlocks = 10
        case 2:
            self.transactionObj.speedName = "Medium"
            self.transactionObj.speedTimeString = "∙ 5 days"
            self.transactionObj.sumInCrypto = 0.00000005
            self.transactionObj.sumInFiat = Double(round(100*self.transactionObj.sumInCrypto * exchangeCourse)/100)
            self.transactionObj.cryptoName = "BTC"
            self.transactionObj.fiatName = "USD"
            self.transactionObj.numberOfBlocks = 20
        case 3:
            self.transactionObj.speedName = "Slow"
            self.transactionObj.speedTimeString = "∙ 1 week"
            self.transactionObj.sumInCrypto = 0.00000005
            self.transactionObj.sumInFiat = Double(round(100*self.transactionObj.sumInCrypto * exchangeCourse)/100)
            self.transactionObj.cryptoName = "BTC"
            self.transactionObj.fiatName = "USD"
            self.transactionObj.numberOfBlocks = 50
        case 4:
            self.transactionObj.speedName = "Very Slow"
            self.transactionObj.speedTimeString = "∙ 2 weeks"
            self.transactionObj.sumInCrypto = 0.00000005
            self.transactionObj.sumInFiat = Double(round(100*self.transactionObj.sumInCrypto * exchangeCourse)/100)
            self.transactionObj.cryptoName = "BTC"
            self.transactionObj.fiatName = "USD"
            self.transactionObj.numberOfBlocks = 70
        case 5:
            self.transactionObj.speedName = "Custom"
            self.transactionObj.speedTimeString = ""
            self.transactionObj.sumInCrypto = convertSatoshiToBTC(sum: self.customFee)
            self.transactionObj.sumInFiat = 0.0
            self.transactionObj.cryptoName = "BTC"
            self.transactionObj.fiatName = "USD"
            self.transactionObj.numberOfBlocks = 0
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
//        self.maxAllowedToSpend = (self.choosenWallet?.availableSumInCrypto)! - self.trasactionObj.sumInCrypto
    }
    
    func checkMaxAvailable() {
        if self.availableSumInCrypto == nil || availableSumInCrypto! < 0.0 {
            self.sendDetailsVC?.presentWarning(message: "Wrong wallet data. Please download wallet data again.")
            
            return
        }
        
        if !sendDetailsVC!.isDonateAvailableSW.isOn {
            self.sendDetailsVC?.performSegue(withIdentifier: "sendAmountVC", sender: Any.self)
            
            return
        }
        
        self.maxAllowedToSpend = self.availableSumInCrypto!

//        self.maxAllowedToSpend = (self.choosenWallet?.sumInCrypto)! - self.trasactionObj.sumInCrypto
        if self.donationObj.sumInCrypto! > self.maxAllowedToSpend  {
//            self.sendDetailsVC?.presentWarning(message: "Your donation sum and fee cost more than you have in wallet.\n\n Fee cost: \(self.trasactionObj.sumInCrypto) \(self.trasactionObj.cryptoName)\n Donation sum: \(self.donationObj.sumInCrypto ?? 0.0) \(self.cryptoName)\n Sum in Wallet: \(self.choosenWallet?.sumInCrypto ?? 0.0) \(self.cryptoName)")
            self.sendDetailsVC?.presentWarning(message: "Your donation more than you have in wallet.\n\nDonation sum: \((self.donationObj.sumInCrypto ?? 0.0).fixedFraction(digits: 8)) \(self.cryptoName)\n Sum in Wallet: \((self.availableSumInCrypto ?? 0.0).fixedFraction(digits: 8)) \(self.cryptoName)")
        } else if self.donationObj.sumInCrypto! == self.maxAllowedToSpend {
            self.sendDetailsVC?.presentWarning(message: "Your donation is equal your wallet sum.\n\nDonation sum: \((self.donationObj.sumInCrypto ?? 0.0).fixedFraction(digits: 8)) \(self.cryptoName)\n Sum in Wallet: \((self.availableSumInCrypto ?? 0.0).fixedFraction(digits: 2)) \(self.cryptoName)")
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
        self.customFee = UInt32(firstValue)
        self.sendDetailsVC?.tableView.reloadData()
        sendDetailsVC?.sendAnalyticsEvent(screenName: "\(screenTransactionFeeWithChain)\(transactionDTO.choosenWallet!.chain)", eventName: customFeeSetuped)
    }
    
    //==============================
    
    func calculateBlockedAmount() -> UInt32 {
        var sum = UInt32(0)
        
        if transactionDTO.choosenWallet == nil {
            return sum
        }
        
        if historyArray?.count == 0 {
            return sum
        }
        
        //        for address in wallet!.addresses {
        //            for out in address.spendableOutput {
        //                if out.transactionStatus.intValue == TxStatus.MempoolIncoming.rawValue {
        //                    sum += out.transactionOutAmount.uint32Value
        //                } else if out.transactionStatus.intValue == TxStatus.MempoolOutcoming.rawValue {
        //                    out.
        //                }
        //            }
        //        }
        
        for history in historyArray! {
            sum += blockedAmount(for: history)
        }
        
        return sum
    }
    
    func blockedAmount(for transaction: HistoryRLM) -> UInt32 {
        var sum = UInt32(0)
        
        if transaction.txStatus.intValue == TxStatus.MempoolIncoming.rawValue {
            sum += transaction.txOutAmount.uint32Value
        } else if transaction.txStatus.intValue == TxStatus.MempoolOutcoming.rawValue {
            let addresses = transactionDTO.choosenWallet!.fetchAddresses()
            
            for tx in transaction.txOutputs {
                if addresses.contains(tx.address) {
                    sum += tx.amount.uint32Value
                }
            }
        }
        
        return sum
    }
}
