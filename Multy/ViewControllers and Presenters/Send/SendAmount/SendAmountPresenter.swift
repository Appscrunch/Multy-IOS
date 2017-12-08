//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class SendAmountPresenter: NSObject {
    
    var sendAmountVC: SendAmountViewController?
    
    var wallet: UserWalletRLM?
    var transactionObj: TransactionRLM?
    var donationObj: DonationObj?
    
    var addressToStr: String?
    
    var sumInCrypto = Double(round(100000000*0.0)/100000000)
    var sumInFiat = Double(round(100*0.0)/100)
    
    var fiatName = "USD"
    var cryptoName = "BTC"
    
    var isCrypto = true
    var isMaxEntered = false
    
    var maxLengthForSum = 12
    
    var sumInNextBtn = 0.0
    var maxAllowedToSpend = 0.0
    var cryptoMaxSumWithFeeAndDonate = 0.0
    
    func setAmountFromQr() {
        if self.sumInCrypto != 0.0 {
            self.sendAmountVC?.amountTF.text = "\(self.sumInCrypto)"
            self.sendAmountVC?.topSumLbl.text = "\(self.sumInCrypto)"
            self.sendAmountVC?.btnSumLbl.text = "\(self.sumInCrypto)"
        }
    }
    
    func cryptoToUsd() {
        self.sumInFiat = self.sumInCrypto * exchangeCourse
        self.sumInFiat = Double(round(100*self.sumInFiat)/100)
        self.sendAmountVC?.bottomSumLbl.text = "\(self.sumInFiat) "
    }
    
    func usdToCrypto() {
        self.sumInCrypto = self.sumInFiat/exchangeCourse
        self.sumInCrypto = Double(round(100000000*self.sumInCrypto)/100000000)
        if self.sumInCrypto > (self.wallet?.sumInCrypto)! {
            self.sendAmountVC?.bottomSumLbl.text = "\(self.wallet?.sumInCrypto ?? 0.0)"
        } else {
            self.sendAmountVC?.bottomSumLbl.text = "\(self.sumInCrypto)"
        }
    }
    
    func setSpendableAmountText() {
        if self.isCrypto {
            self.sendAmountVC?.spendableSumAndCurrencyLbl.text = "\(self.wallet?.sumInCrypto ?? 0.0) \(self.cryptoName)"
        } else {
            self.sendAmountVC?.spendableSumAndCurrencyLbl.text = "\(self.wallet?.sumInFiat ?? 0.0) \(self.fiatName)"
        }
    }
    
    func getNextBtnSum() -> Double {
        switch self.isCrypto {
        case true:
            if (self.sendAmountVC?.commissionSwitch.isOn)! {
                if self.donationObj != nil {
                    self.sumInNextBtn = self.sumInCrypto + (self.transactionObj?.sumInCrypto)! + (self.donationObj?.sumInCrypto)!
                } else {
                    self.sumInNextBtn = self.sumInCrypto + (self.transactionObj?.sumInCrypto)!
                }
            } else {  //pay for commision off
                self.sumInNextBtn = self.sumInCrypto
            }
            if self.sumInNextBtn > (self.wallet?.sumInCrypto)! {
                self.sumInNextBtn = self.wallet?.sumInCrypto ?? 0.0
            }
            return Double(round(100000000*self.sumInNextBtn)/100000000)
        case false:
            if (self.sendAmountVC?.commissionSwitch.isOn)! {
                if self.donationObj != nil {
                    self.sumInNextBtn = self.sumInFiat + (self.transactionObj?.sumInFiat)! + (self.donationObj?.sumInFiat)!
                } else {
                    self.sumInNextBtn = self.sumInFiat + (self.transactionObj?.sumInFiat)!
                }
            } else {  //pay for commision off
                self.sumInNextBtn = self.sumInFiat
            }
            if self.sumInNextBtn > (self.wallet?.sumInFiat)! {
                self.sumInNextBtn = self.wallet?.sumInFiat ?? 0.0
            }
            
            return self.sumInNextBtn
        }
    }
    
    func setMaxAllowed() {
        switch self.isCrypto {
        case true:
            if (self.sendAmountVC?.commissionSwitch.isOn)! {
                if self.donationObj != nil {
                    self.maxAllowedToSpend = (self.wallet?.sumInCrypto)! - (self.transactionObj?.sumInCrypto)! - (self.donationObj?.sumInCrypto)!
                } else {
                    self.maxAllowedToSpend = (self.wallet?.sumInCrypto)! - (self.transactionObj?.sumInCrypto)!
                }
            } else {
                self.maxAllowedToSpend = (self.wallet?.sumInCrypto)!
            }
        case false:
            if (self.sendAmountVC?.commissionSwitch.isOn)! {
                if self.donationObj != nil {
                    self.maxAllowedToSpend = (self.wallet?.sumInFiat)! - (self.transactionObj?.sumInFiat)! - (self.donationObj?.sumInFiat)!
                } else {
                    self.maxAllowedToSpend = (self.wallet?.sumInFiat)! - (self.transactionObj?.sumInFiat)!
                }
            } else {
                self.maxAllowedToSpend = (self.wallet?.sumInFiat)!
            }
        }
    }
    
    func saveTfValue() {
        if self.isCrypto {
            self.sumInCrypto = ((self.sendAmountVC?.topSumLbl.text!)! as NSString).doubleValue
            self.sumInFiat = self.sumInCrypto * exchangeCourse
            self.sumInFiat = Double(round(100*self.sumInFiat)/100)
            if self.sumInFiat > (self.wallet?.sumInFiat)! {
                self.sendAmountVC?.bottomSumLbl.text = "\(self.wallet?.sumInFiat ?? 0.0) "
            } else {
                self.sendAmountVC?.bottomSumLbl.text = "\(self.sumInFiat) "
            }
            self.sendAmountVC?.bottomCurrencyLbl.text = self.fiatName
        } else {
            self.sumInFiat = ((self.sendAmountVC?.topSumLbl.text!)! as NSString).doubleValue
            self.sumInCrypto = self.sumInFiat / exchangeCourse
            self.sumInCrypto = Double(round(100000000*self.sumInCrypto)/100000000)
            if self.sumInCrypto > (self.wallet?.sumInCrypto)! {
                self.sendAmountVC?.bottomSumLbl.text = "\(self.wallet?.sumInCrypto ?? 0.0) "
            } else {
                self.sendAmountVC?.bottomSumLbl.text = "\(self.sumInCrypto) "
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
                if self.sumInCrypto >= (self.wallet?.sumInCrypto)!  {
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
                if self.sumInFiat >= (self.wallet?.sumInFiat)!  {
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
            if self.donationObj != nil {
                self.cryptoMaxSumWithFeeAndDonate = (self.wallet?.sumInCrypto)! - (self.transactionObj?.sumInCrypto)! - (self.donationObj?.sumInCrypto)!
            } else {
                self.cryptoMaxSumWithFeeAndDonate = (self.wallet?.sumInCrypto)! - (self.transactionObj?.sumInCrypto)!
            }
        } else {
            if self.donationObj != nil {
                self.cryptoMaxSumWithFeeAndDonate = (self.wallet?.sumInFiat)! - (self.transactionObj?.sumInFiat)! - (self.donationObj?.sumInFiat)!
            } else {
                self.cryptoMaxSumWithFeeAndDonate = (self.wallet?.sumInFiat)! - (self.transactionObj?.sumInFiat)!
            }
        }
    }
    
    func messageForAlert() -> String {
        var message = ""
        switch isCrypto {
        case true:
            if self.donationObj != nil {
                message = "You can`t spend sum more than you have!\nDon`t forget about Fee and donation.\n\nYour fee is \(self.transactionObj?.sumInCrypto ?? 0.0) \(self.cryptoName) \nand donation is \(self.donationObj?.sumInCrypto ?? 0.0) \(self.cryptoName)"
            } else {
                message = "You can`t spend sum more than you have!\nDon`t forget about Fee.\nYour is fee \(self.transactionObj?.sumInCrypto ?? 0.0) \(self.cryptoName)"
            }
        case false:
            if self.donationObj != nil {
                message = "You can`t spend sum more than you have!\nDon`t forget about Fee and donation.\n\nYour fee is \(self.transactionObj?.sumInFiat ?? 0.0) \(self.fiatName) \nand donation is \(self.donationObj?.sumInFiat ?? 0.0) \(self.fiatName)"
            } else {
                message = "You can`t spend sum more than you have!\nDon`t forget about Fee.\nYour is fee \(self.transactionObj?.sumInFiat ?? 0.0) \(self.fiatName)"
            }
        }
        return message
    }
    
    func getExchange() {
        DataManager.shared.getExchangeCourse { (error) in
            
        }
    }
}
