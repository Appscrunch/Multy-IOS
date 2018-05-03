//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import RealmSwift

class SendAmountEthPresenter: NSObject {
    var sendAmountVC: SendAmountEthViewController?
    var transactionDTO = TransactionDTO() {
        didSet {
            blockedAmount = transactionDTO.choosenWallet!.ethWallet!.pendingBalance
            if transactionDTO.sendAmount != nil {
                sumInCrypto = Constants.BigIntSwift.oneETHInWeiKey * transactionDTO.sendAmount!
            }
            transactionObj = transactionDTO.transaction!.transactionRLM
            cryptoName = transactionDTO.blockchainType!.shortName
            exchangeCourse = transactionDTO.choosenWallet!.exchangeCourse
            
            if transactionDTO.transaction?.customGAS?.gasPrice != nil {
                feeAmount = BigInt("21000") * Int64(transactionDTO.transaction!.customGAS!.gasPrice)
            }
            
            maxLengthForSum = transactionDTO.choosenWallet!.blockchain.blockchain.maxLengthForSum
            maxPrecision = transactionDTO.choosenWallet!.blockchain.blockchain.maxPrecision
        }
    }
    var account = DataManager.shared.realmManager.account
    var blockedAmount = BigInt("0") {
        didSet {
            availableSumInCrypto = transactionDTO.choosenWallet!.ethWallet!.availableBalance
        }
    }
    var availableSumInCrypto = BigInt("0")
    
    var availableSumInFiat: BigInt { // It is sum in crypto multiplyed by blockchain.multiplyerToMinimalUnits
        return availableSumInCrypto * exchangeCourse
    }
    var transactionObj: TransactionRLM?
    var exchangeCourse = Double(0.0)
    
    // entered sum
    var sumInCrypto = BigInt("0") {
        didSet {
            sumInFiat = sumInCrypto * exchangeCourse
        }
    }
    var sumInFiat = BigInt("0")
    
    var fiatName = "USD"
    var cryptoName = "ETH"
    
    var isCrypto = true
    var isMaxEntered = false
    
    var maxLengthForSum = 0
    var maxPrecision = 0
    
    var sumInNextBtn = BigInt("0")
    var maxAllowedToSpend = BigInt("0")
    var cryptoMaxSumWithFeeAndDonate = BigInt("0")
    
    var feeAmount = BigInt("0")
    
    var rawTransaction: String?
    
    //    var customFee : UInt64?
    
    //for creating transaction
    var binaryData : BinaryData?
    var addressData : Dictionary<String, Any>?
    
    func getData() {
        self.createPreliminaryData()
    }
    
    func createPreliminaryData() {
        let core = DataManager.shared.coreLibManager
        let wallet = transactionDTO.choosenWallet!
        binaryData = account!.binaryDataString.createBinaryData()!
        
        addressData = core.createAddress(blockchain:    transactionDTO.blockchainType!,
                                         walletID:      wallet.walletID.uint32Value,
                                         addressID:     UInt32(0),
                                         binaryData:    &binaryData!)
    }
    
    func estimateTransaction() -> Bool {
        let trData = DataManager.shared.coreLibManager.createEtherTransaction(addressPointer: addressData!["addressPointer"] as! UnsafeMutablePointer<OpaquePointer?>,
                                                                              sendAddress: transactionDTO.sendAddress!,
                                                                              sendAmountString: sumInCrypto.stringValue,
                                                                              nonce: transactionDTO.choosenWallet!.ethWallet!.nonce.intValue,
                                                                              balanceAmount: "\(transactionDTO.choosenWallet!.ethWallet!.balance)",
            ethereumChainID: UInt32(transactionDTO.choosenWallet!.blockchain.net_type),
            gasPrice: "\(transactionDTO.transaction?.customGAS?.gasPrice ?? 0)",
            gasLimit: "21000") // "\(transactionDTO.transaction?.customGAS?.gasPrice ?? 0)")
        
        self.rawTransaction = trData.message
        
        return trData.isTransactionCorrect
    }
    
    func setAmountFromQr() {
        if self.sumInCrypto > Int64(0) {
            self.sendAmountVC?.amountTF.text = self.sumInCrypto.cryptoValueString(for: BLOCKCHAIN_ETHEREUM)
            self.sendAmountVC?.topSumLbl.text = self.sumInCrypto.cryptoValueString(for: BLOCKCHAIN_ETHEREUM)
            self.sendAmountVC?.btnSumLbl.text = self.sumInCrypto.cryptoValueString(for: BLOCKCHAIN_ETHEREUM)
        }
    }
    
    func cryptoToUsd() {
        self.sendAmountVC?.bottomSumLbl.text = sumInFiat.fiatValueString
    }
    
    func usdToCrypto() {
        self.sumInCrypto = self.sumInFiat / exchangeCourse
        if self.sumInCrypto > self.availableSumInCrypto {
            self.sendAmountVC?.bottomSumLbl.text = self.availableSumInCrypto.cryptoValueString(for: BLOCKCHAIN_ETHEREUM)
        } else {
            self.sendAmountVC?.bottomSumLbl.text = self.sumInCrypto.cryptoValueString(for: BLOCKCHAIN_ETHEREUM)
        }
    }
    
    func setSpendableAmountText() {
        if self.isCrypto {
            self.sendAmountVC?.spendableSumAndCurrencyLbl.text = self.availableSumInCrypto.cryptoValueString(for: BLOCKCHAIN_ETHEREUM) + " " + self.cryptoName
        } else {
            self.sendAmountVC?.spendableSumAndCurrencyLbl.text = self.availableSumInFiat.fiatValueString + " " + self.fiatName
        }
    }
    
    func getNextBtnSum() -> BigInt {
        let exchangeCourse = transactionDTO.choosenWallet!.exchangeCourse
        
        if sumInCrypto == Int64(0) {
            return sumInCrypto
        }
        
        let estimate = estimateTransaction()
        
        if estimate == false {
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
            
            return BigInt("-1") // error
        }

        let fiatAmount = feeAmount * exchangeCourse
        
        switch self.isCrypto {
        case true:
            sumInNextBtn = sumInCrypto + feeAmount
        case false:
            sumInNextBtn = sumInFiat + fiatAmount
            
            if sumInNextBtn > availableSumInFiat {
                sumInNextBtn = availableSumInFiat
            }
        }
        
        return self.sumInNextBtn
    }
    
    func setMaxAllowed() {
        switch self.isCrypto {
        case true:
            maxAllowedToSpend = availableSumInCrypto
        case false:
            maxAllowedToSpend = self.availableSumInFiat
        }
    }
    
    func saveTfValue() {
        if isCrypto {
            sumInCrypto = sendAmountVC!.topSumLbl.text!.convertCryptoAmountStringToMinimalUnits(in: BLOCKCHAIN_ETHEREUM)
            if sumInFiat > availableSumInFiat {
                sendAmountVC?.bottomSumLbl.text = availableSumInFiat.cryptoValueString(for: BLOCKCHAIN_ETHEREUM)
            } else {
                sendAmountVC?.bottomSumLbl.text = sumInFiat.fiatValueString
            }
            sendAmountVC?.bottomCurrencyLbl.text = fiatName
        } else {
            sumInFiat = Constants.BigIntSwift.oneETHInWeiKey * Double(sendAmountVC!.topSumLbl.text!.stringWithDot) // fiat * 10^18
            sumInCrypto = sumInFiat / exchangeCourse
            if sumInCrypto > availableSumInCrypto {
                sendAmountVC?.bottomSumLbl.text = self.availableSumInCrypto.cryptoValueString(for: BLOCKCHAIN_ETHEREUM) + " "
            } else {
                self.sendAmountVC?.bottomSumLbl.text = self.sumInCrypto.cryptoValueString(for: BLOCKCHAIN_ETHEREUM) + " "
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
                if self.sumInCrypto >= self.availableSumInCrypto  {
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
                if self.sumInFiat >= self.availableSumInFiat  {
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
        if isCrypto {
            cryptoMaxSumWithFeeAndDonate = availableSumInCrypto
        } else {
            cryptoMaxSumWithFeeAndDonate = availableSumInFiat
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
}
