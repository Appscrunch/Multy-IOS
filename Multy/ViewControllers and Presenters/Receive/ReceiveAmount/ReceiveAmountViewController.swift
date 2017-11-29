//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import ZFRippleButton

class ReceiveAmountViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var doneBtn: ZFRippleButton!
    @IBOutlet weak var sumLbl: UILabel!
    @IBOutlet weak var currencyNameLbl: UILabel!
    @IBOutlet weak var bottomSumCurrencyLbl: UILabel!
    @IBOutlet weak var constraintBtnBottom: NSLayoutConstraint!
    
    let presenter = ReceiveAmountPresenter()
    
    var sumInCrypto = 0.0
    var sumInFiat = 0.0
    
    var isCrypto = true
    
    var fiatName = "USD"
    var cryptoName = "BTC"
    
    var maxLengthForSum = 12
    
    var delegate: ReceiveSumTransferProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter.receiveAmountVC = self
        self.doneBtn.applyGradient(withColours: [UIColor(ciColor: CIColor(red: 0/255, green: 178/255, blue: 255/255)),
                                                     UIColor(ciColor: CIColor(red: 0/255, green: 122/255, blue: 255/255))],
                                   gradientOrientation: .horizontal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        self.amountTF.becomeFirstResponder()
        
        self.currencyNameLbl.text = self.cryptoName
        self.tabBarController?.tabBar.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changeAction(_ sender: Any) {
        if self.isCrypto {
            if self.sumInFiat != 0.0 {
                self.amountTF.text = "\(self.sumInFiat)"
            } else {
                self.amountTF.text = ""
            }
            self.bottomSumCurrencyLbl.text = "\(self.sumInCrypto) \(self.currencyNameLbl.text?.uppercased() ?? "")"
            self.sumLbl.text = "\(self.sumInFiat)"
            self.currencyNameLbl.text = self.fiatName
        } else {
            if self.sumInCrypto != 0.0 {
                self.amountTF.text = "\(self.sumInCrypto)"
            } else {
                self.amountTF.text = ""
            }
            self.sumLbl.text = "\(self.sumInCrypto)"
            self.currencyNameLbl.text = self.cryptoName
            self.bottomSumCurrencyLbl.text = "\(sumInFiat) \(self.fiatName)"
        }
        self.isCrypto = !self.isCrypto
    }
    
    @IBAction func doneAction(_ sender: Any) {
        if self.isCrypto {
            self.delegate?.transferSum(amount: self.sumInCrypto, currency: self.cryptoName, additionalInfo: self.bottomSumCurrencyLbl.text!)
        } else {
            self.delegate?.transferSum(amount: self.sumInFiat, currency: self.fiatName, additionalInfo: self.bottomSumCurrencyLbl.text!)
        }
        self.navigationController?.popViewController(animated: true)
    }
   
    @objc func keyboardWillShow(_ notification : Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let inset : UIEdgeInsets = UIEdgeInsetsMake(64, 0, keyboardSize.height, 0)
            self.constraintBtnBottom.constant = inset.bottom
        }
    }
    
    @IBAction func tfValueChanged(_ sender: Any) {
        print("cicki")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        
        
//        let str = "Hello, I must be going."
//        let str2 = str.components(separatedBy: "I")
        
        
        if newLength <= self.maxLengthForSum {
            self.amountTF.text = self.amountTF.text?.replacingOccurrences(of: ",", with: ".")
            if string == "," && (self.amountTF.text?.contains("."))!{
                return false
            }
            
            if (self.amountTF.text?.contains("."))! && string != "" {
                let strAfterDot: [String?] = (self.amountTF.text?.components(separatedBy: "."))!
                if self.isCrypto {
                    if strAfterDot[1]?.count == 8 {
                        return false
                    } else {
                        self.sumLbl.text = self.amountTF.text! + string
                        self.saveTfValue()
                    }
                } else {
                    if strAfterDot[1]?.count == 2 {
                        return false
                    } else {
                        self.sumLbl.text = self.amountTF.text! + string
                        self.saveTfValue()
                    }
                }
            }

            if string == "," {
                self.sumLbl.text = self.amountTF.text! + "."
            } else {
                if string != "" {
                    self.sumLbl.text = self.amountTF.text! + string
                } else {
                    self.sumLbl.text?.removeLast()
                }
            }
            self.saveTfValue()
        }
        return newLength <= self.maxLengthForSum
    }
    
    
    func saveTfValue() {
        if self.isCrypto {
            self.sumInCrypto = (self.sumLbl.text! as NSString).doubleValue
            self.sumInFiat = self.sumInCrypto * self.presenter.exchangeCourse
            self.sumInFiat = Double(round(100*self.sumInFiat)/100)
            self.bottomSumCurrencyLbl.text = "\(self.sumInFiat) \(self.fiatName)"
        } else {
            self.sumInFiat = (self.sumLbl.text! as NSString).doubleValue
            self.sumInCrypto = self.sumInFiat / self.presenter.exchangeCourse
            self.sumInCrypto = Double(round(100000000*self.sumInCrypto)/100000000 )
            self.bottomSumCurrencyLbl.text = "\(self.sumInCrypto) \(self.cryptoName)"
        }
    }
}
