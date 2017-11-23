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
    
    var delegate: ReceiveSumTransferProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter.receiveAmountVC = self
        self.doneBtn.applyGradient(withColours: [UIColor(ciColor: CIColor(red: 0/255, green: 178/255, blue: 255/255)),
                                                     UIColor(ciColor: CIColor(red: 0/255, green: 122/255, blue: 255/255))],
                                   gradientOrientation: .horizontal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
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
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let inset : UIEdgeInsets = UIEdgeInsetsMake(64, 0, keyboardSize.height, 0)
            self.constraintBtnBottom.constant = inset.bottom
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.amountTF.text = self.amountTF.text?.replacingOccurrences(of: ",", with: ".")
        if string == "," && (self.amountTF.text?.contains("."))! {
            return false
        }
        
        if string == "" {
            self.sumLbl.text?.removeLast()
        } else {
            if string == "," {
                self.sumLbl.text = self.amountTF.text! + "."
            } else {
                self.sumLbl.text = self.amountTF.text! + string
            }
        }
        if self.isCrypto {
            self.sumInCrypto = (self.sumLbl.text! as NSString).doubleValue
        } else {
            self.sumInFiat = (self.sumLbl.text! as NSString).doubleValue
        }
        return true
    }
    
}
