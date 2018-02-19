//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import RealmSwift

class SendAmountPresenter: NSObject {
    
    var sendAmountVC: SendAmountViewController?
    var transactionDTO = TransactionDTO() {
        didSet {
            blockedAmount = calculateBlockedAmount()
            if transactionDTO.sendAmount != nil {
                sumInCrypto = transactionDTO.sendAmount!
            }
            transactionObj = transactionDTO.transaction!.transactionRLM
        }
    }
    var account = DataManager.shared.realmManager.account
    
    //MARK: fix addresses in wallet and delete second ivar
//    var wallet: UserWalletRLM?
//    var historyArray : List<HistoryRLM>? {
//        didSet {
//            self.blockedAmount = calculateBlockedAmount()
//        }
//    }
    
    var blockedAmount           : UInt32? {
        didSet {
            availableSumInCrypto = transactionDTO.choosenWallet!.sumInCrypto - convertSatoshiToBTC(sum: calculateBlockedAmount())
            availableSumInFiat = availableSumInCrypto! * exchangeCourse
        }
    }
    var availableSumInCrypto    : Double?
    var availableSumInFiat      : Double?
    
    var transactionObj: TransactionRLM?
//    var donationObj: DonationDTO?
    
//    var addressToStr: String?
    
    var sumInCrypto = Double(0.0)
    var sumInFiat = Double(0.0)
    
    var fiatName = "USD"
    var cryptoName = "BTC"
    
    var isCrypto = true
    var isMaxEntered = false
    
    var maxLengthForSum = 12
    
    var sumInNextBtn = 0.0
    var maxAllowedToSpend = 0.0
    var cryptoMaxSumWithFeeAndDonate = 0.0
    
    var rawTransaction: String?
    
//    var customFee : UInt32?
    
    //for creating transaction
    var binaryData : BinaryData?
    var addressData : Dictionary<String, Any>?
    
    func getData() {
//        DataManager.shared.getAccount { (account, error) in
//            self.account = account
//
            self.createPreliminaryData()
//
//            DataManager.shared.getTransactionHistory(currencyID: self.wallet!.chain, walletID: self.wallet!.walletID) { (histList, err) in
//                if err == nil && histList != nil {
//                    self.historyArray = histList!
//                }
//            }
//        }
    }
    
    func createPreliminaryData() {
        let core = DataManager.shared.coreLibManager
        let wallet = transactionDTO.choosenWallet!
        binaryData = account!.binaryDataString.createBinaryData()!
        
        addressData = core.createAddress(currencyID:    wallet.chain.uint32Value,
                                         walletID:      wallet.walletID.uint32Value,
                                         addressID:     UInt32(wallet.addresses.count),
                                         binaryData:    &binaryData!)
    }
    
    func estimateTransaction() -> Double {
        let feeAmount = DataManager.shared.coreLibManager.getTotalFee(addressPointer: addressData!["addressPointer"] as! OpaquePointer,
                                                                      feeAmountString: "\(transactionDTO.transaction!.customFee!)",
                                                                      isDonationExists: transactionDTO.transaction?.donationDTO?.sumInCrypto != Double(0.0),
                                                                      isPayCommission: self.sendAmountVC!.commissionSwitch.isOn,
                                                                      inputsCount: DataManager.shared.realmManager.spendableOutput(addresses: transactionDTO.choosenWallet!.addresses).count)
        
        let trData = DataManager.shared.coreLibManager.createTransaction(addressPointer: addressData!["addressPointer"] as! OpaquePointer,
                                                                         sendAddress: transactionDTO.sendAddress!,
                                                                         sendAmountString: self.sumInCrypto.fixedFraction(digits: 8),
                                                                         feePerByteAmount: "\(transactionDTO.transaction!.customFee!)",
                                                                         isDonationExists: true,
                                                                         donationAmount: transactionDTO.transaction!.donationDTO!.sumInCrypto!.fixedFraction(digits: 8),
                                                                         isPayCommission: self.sendAmountVC!.commissionSwitch.isOn,
                                                                         wallet: transactionDTO.choosenWallet!,
                                                                         binaryData: &binaryData!,
                                                                         feeAmount: feeAmount,
                                                                         inputs: transactionDTO.choosenWallet!.addresses)
        
        self.rawTransaction = trData.0
        
        return trData.1
    }
    
    func setAmountFromQr() {
        if self.sumInCrypto != 0.0 {
            self.sendAmountVC?.amountTF.text = self.sumInCrypto.fixedFraction(digits: 8)
            self.sendAmountVC?.topSumLbl.text = self.sumInCrypto.fixedFraction(digits: 8)
            self.sendAmountVC?.btnSumLbl.text = self.sumInCrypto.fixedFraction(digits: 8)
        }
    }
    
    func cryptoToUsd() {
        self.sumInFiat = self.sumInCrypto * exchangeCourse
        self.sumInFiat = Double(round(100 * self.sumInFiat)/100)
        self.sendAmountVC?.bottomSumLbl.text = "\(self.sumInFiat.fixedFraction(digits: 2)) "
    }
    
    func usdToCrypto() {
        self.sumInCrypto = self.sumInFiat/exchangeCourse
        self.sumInCrypto = Double(round(100000000 * self.sumInCrypto)/100000000)
        if self.sumInCrypto > self.availableSumInCrypto! {
            self.sendAmountVC?.bottomSumLbl.text = "\((self.availableSumInCrypto ?? 0.0).fixedFraction(digits: 8))"
        } else {
            self.sendAmountVC?.bottomSumLbl.text = "\((self.sumInCrypto).fixedFraction(digits: 8))"
        }
    }
    
    func setSpendableAmountText() {
        if self.isCrypto {
            self.sendAmountVC?.spendableSumAndCurrencyLbl.text = "\((self.availableSumInCrypto ?? 0.0).fixedFraction(digits: 8)) \(self.cryptoName)"
        } else {
            self.sendAmountVC?.spendableSumAndCurrencyLbl.text = "\((self.availableSumInFiat ?? 0.0).fixedFraction(digits: 2)) \(self.fiatName)"
        }
    }
    
    func getNextBtnSum() -> Double {
        let satoshiAmount = UInt32(sumInCrypto * pow(10, 8))
        
        if satoshiAmount == 0 {
            return 0
        }
        
        let estimate = satoshiAmount == 0 ? 0.0 : estimateTransaction()
        
        if estimate < 0 {
            let message = rawTransaction!
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in }))
            sendAmountVC!.present(alert, animated: true, completion: nil)
            
            sendAmountVC?.amountTF.text = "0"
            sendAmountVC?.topSumLbl.text = "0"
            saveTfValue()
            checkMaxEntered()
            sendAmountVC?.setSumInNextBtn()
            sendAmountVC?.sendAnalyticsEvent(screenName: "\(screenSendAmountWithChain)\(transactionDTO.choosenWallet!.chain)", eventName: transactionErr)
            return 0
        }
        
        self.transactionObj?.sumInCrypto = estimate
        self.transactionObj?.sumInFiat = estimate * exchangeCourse
        
        switch self.isCrypto {
        case true:
            if (self.sendAmountVC?.commissionSwitch.isOn)! {
                if transactionDTO.transaction?.donationDTO != nil {
                    self.sumInNextBtn = self.sumInCrypto + self.transactionObj!.sumInCrypto + transactionDTO.transaction!.donationDTO!.sumInCrypto!
                } else {
                    self.sumInNextBtn = self.sumInCrypto + (self.transactionObj?.sumInCrypto)!
                }
            } else {  //pay for commision off
                self.sumInNextBtn = self.sumInCrypto
            }
            if self.sumInNextBtn > self.availableSumInCrypto! {
                self.sumInNextBtn = self.availableSumInCrypto ?? 0.0
            }
            return self.sumInNextBtn
        case false:
            if (self.sendAmountVC?.commissionSwitch.isOn)! {
                if transactionDTO.transaction!.donationDTO != nil {
                    self.sumInNextBtn = self.sumInFiat + self.transactionObj!.sumInFiat + transactionDTO.transaction!.donationDTO!.sumInFiat!
                } else {
                    self.sumInNextBtn = self.sumInFiat + (self.transactionObj?.sumInFiat)!
                }
            } else {  //pay for commision off
                self.sumInNextBtn = self.sumInFiat
            }
            if self.sumInNextBtn > self.availableSumInFiat! {
                self.sumInNextBtn = self.availableSumInFiat ?? 0.0
            }
            
            return self.sumInNextBtn
        }
    }
    
    func setMaxAllowed() {
        switch self.isCrypto {
        case true:
            if (self.sendAmountVC?.commissionSwitch.isOn)! {
                if transactionDTO.transaction!.donationDTO != nil {
                    self.maxAllowedToSpend = self.availableSumInCrypto! - self.transactionObj!.sumInCrypto - transactionDTO.transaction!.donationDTO!.sumInCrypto!
                } else {
                    self.maxAllowedToSpend = self.availableSumInCrypto! - self.transactionObj!.sumInCrypto
                }
            } else {
                self.maxAllowedToSpend = self.availableSumInCrypto!
            }
        case false:
            if (self.sendAmountVC?.commissionSwitch.isOn)! {
                if transactionDTO.transaction!.donationDTO != nil {
                    self.maxAllowedToSpend = self.availableSumInFiat! - self.transactionObj!.sumInFiat - transactionDTO.transaction!.donationDTO!.sumInFiat!
                } else {
                    self.maxAllowedToSpend = self.availableSumInFiat! - self.transactionObj!.sumInFiat
                }
            } else {
                self.maxAllowedToSpend = (self.availableSumInFiat)!
            }
        }
    }
    
    func saveTfValue() {
        if self.isCrypto {
            self.sumInCrypto = self.sendAmountVC!.topSumLbl.text!.toStringWithComma()
            self.sumInFiat = self.sumInCrypto * exchangeCourse
            self.sumInFiat = Double(round(100 * self.sumInFiat)/100)
            if self.sumInFiat > transactionDTO.choosenWallet!.sumInFiat {
                self.sendAmountVC?.bottomSumLbl.text = "\((transactionDTO.choosenWallet?.sumInFiat ?? 0.0).fixedFraction(digits: 2)) "
            } else {
                self.sendAmountVC?.bottomSumLbl.text = "\(self.sumInFiat.fixedFraction(digits: 2)) "
            }
            self.sendAmountVC?.bottomCurrencyLbl.text = self.fiatName
        } else {
            self.sumInFiat = self.sendAmountVC!.topSumLbl.text!.toStringWithComma()
            self.sumInCrypto = self.sumInFiat / exchangeCourse
            self.sumInCrypto = Double(round(100000000 * self.sumInCrypto)/100000000)
            if self.sumInCrypto > self.availableSumInCrypto! {
                self.sendAmountVC?.bottomSumLbl.text = "\((self.availableSumInCrypto ?? 0.0).fixedFraction(digits: 8)) "
            } else {
                self.sendAmountVC?.bottomSumLbl.text = "\(self.sumInCrypto.fixedFraction(digits: 8)) "
            }
            
            self.sendAmountVC?.bottomCurrencyLbl.text = self.cryptoName
        }
    }
   
    
    func checkMaxEntered() {
        if self.isCrypto {
            switch self.sendAmountVC?.commissionSwitch.isOn {
            case true?:
                if self.sumInCrypto >= self.cryptoMaxSumWithFeeAndDonate {
                    self.isMaxEntered = true
                } else {
                    self.isMaxEntered = false
                }
            case false?:
                if self.sumInCrypto >= self.availableSumInCrypto!  {
                    self.isMaxEntered = true
                } else {
                    self.isMaxEntered = false
                }
            case .none:
                return
            }
        } else {
            switch self.sendAmountVC?.commissionSwitch.isOn {
            case true?:
                if self.sumInFiat >= self.cryptoMaxSumWithFeeAndDonate {
                    self.isMaxEntered = true
                } else {
                    self.isMaxEntered = false
                }
            case false?:
                if self.sumInFiat >= self.availableSumInFiat!  {
                    self.isMaxEntered = true
                } else {
                    self.isMaxEntered = false
                }
            case .none:
                return
            }
        }
    }
    
    func makeMaxSumWithFeeAndDonate() {
        if self.isCrypto {
            if transactionDTO.transaction!.donationDTO != nil {
                self.cryptoMaxSumWithFeeAndDonate = self.availableSumInCrypto! - self.transactionObj!.sumInCrypto - transactionDTO.transaction!.donationDTO!.sumInCrypto!
            } else {
                self.cryptoMaxSumWithFeeAndDonate = self.availableSumInCrypto! - self.transactionObj!.sumInCrypto
            }
        } else {
            if transactionDTO.transaction!.donationDTO != nil {
                self.cryptoMaxSumWithFeeAndDonate = self.availableSumInFiat! - (self.transactionObj?.sumInFiat)! - transactionDTO.transaction!.donationDTO!.sumInFiat!
            } else {
                self.cryptoMaxSumWithFeeAndDonate = self.availableSumInFiat! - self.transactionObj!.sumInFiat
            }
        }
    }
    
    func messageForAlert() -> String {
        var message = ""
        switch isCrypto {
        case true:
            if transactionDTO.transaction!.donationDTO != nil {
                message = "You can`t spend sum more than you have!\nDon`t forget about Fee and donation.\n\nYour fee is \((self.transactionObj?.sumInCrypto ?? 0.0).fixedFraction(digits: 8)) \(self.cryptoName) \nand donation is \((transactionDTO.transaction!.donationDTO?.sumInCrypto ?? 0.0).fixedFraction(digits: 8)) \(self.cryptoName)"
            } else {
                message = "You can`t spend sum more than you have!\nDon`t forget about Fee.\nYour is fee \((self.transactionObj?.sumInCrypto ?? 0.0).fixedFraction(digits: 8)) \(self.cryptoName)"
            }
        case false:
            if transactionDTO.transaction!.donationDTO != nil {
                message = "You can`t spend sum more than you have!\nDon`t forget about Fee and donation.\n\nYour fee is \((self.transactionObj?.sumInFiat ?? 0.0).fixedFraction(digits: 2)) \(self.fiatName) \nand donation is \((transactionDTO.transaction!.donationDTO?.sumInFiat ?? 0.0).fixedFraction(digits: 2)) \(self.fiatName)"
            } else {
                message = "You can`t spend sum more than you have!\nDon`t forget about Fee.\nYour is fee \((self.transactionObj?.sumInFiat ?? 0.0).fixedFraction(digits: 2)) \(self.fiatName)"
            }
        }
        return message
    }
    
    func calculateBlockedAmount() -> UInt32 {
        var sum = UInt32(0)
        
        if transactionDTO.choosenWallet == nil {
            return sum
        }
        
        if transactionDTO.transaction?.historyArray?.count == 0 {
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
        
        for history in transactionDTO.transaction!.historyArray! {
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
