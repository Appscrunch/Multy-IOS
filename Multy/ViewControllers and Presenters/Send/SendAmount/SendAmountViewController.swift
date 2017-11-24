//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import ZFRippleButton

class SendAmountViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleLbl: UILabel! // "Send \(crypyoName)"
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var topSumLbl: UILabel!
    @IBOutlet weak var topCurrencyNameLbl: UILabel!
    @IBOutlet weak var bottomSumAndCurrencyLbl: UILabel!
    @IBOutlet weak var spendableSumAndCurrencyLbl: UILabel!
    @IBOutlet weak var nextBtn: ZFRippleButton!
    @IBOutlet weak var maxBtn: UIButton!
    @IBOutlet weak var maxLbl: UILabel!
    @IBOutlet weak var btnSumLbl: UILabel!
    
    
    @IBOutlet weak var constraintNextBtnBottom: NSLayoutConstraint!
    @IBOutlet weak var constratintNextBtnHeight: NSLayoutConstraint!
    
    let presenter = SendAmountPresenter()
    
    var sumInCrypto = 0.0
    var sumInFiat = 0.0
    
    var isCrypto = true
    
    var fiatName = "USD"
    var cryptoName = "BTC"
    
    var cryptoSumInWallet = 1.123
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.sendAmountVC = self
        self.nextBtn.isEnabled = false
        self.nextBtn.backgroundColor = .gray
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        self.amountTF.becomeFirstResponder()
        self.spendableSumAndCurrencyLbl.text = "\(self.cryptoSumInWallet) BTC"
        
        self.topSumLbl.addObserver(self, forKeyPath: "text", options: [.old, .new], context: nil)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: change sum in button
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "text" {
            self.btnSumLbl.text = (change?[.newKey] as! String)
            if self.btnSumLbl.text != "0.0" {
                self.nextBtn.isEnabled = true
                self.nextBtn.applyGradient(withColours: [UIColor(ciColor: CIColor(red: 0/255, green: 178/255, blue: 255/255)),
                                                         UIColor(ciColor: CIColor(red: 0/255, green: 122/255, blue: 255/255))],
                                           gradientOrientation: .horizontal)
            }
        }
    }
    
    @IBAction func changeAction(_ sender: Any) {
        if self.isCrypto {
            if self.sumInFiat != 0.0 {
                self.amountTF.text = "\(self.sumInFiat)"
            } else {
                self.amountTF.text = ""
            }
            self.bottomSumAndCurrencyLbl.text = "\(self.sumInCrypto) \(self.topCurrencyNameLbl.text?.uppercased() ?? "")"
            self.topSumLbl.text = "\(self.sumInFiat)"
            self.topCurrencyNameLbl.text = self.fiatName
        } else {
            if self.sumInCrypto != 0.0 {
                self.amountTF.text = "\(self.sumInCrypto)"
            } else {
                self.amountTF.text = ""
            }
            self.topSumLbl.text = "\(self.sumInCrypto)"
            self.topCurrencyNameLbl.text = self.cryptoName
            self.bottomSumAndCurrencyLbl.text = "\(sumInFiat) \(self.fiatName)"
        }
        self.isCrypto = !self.isCrypto
    }
    
    
    @objc func keyboardWillShow(_ notification : Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let inset : UIEdgeInsets = UIEdgeInsetsMake(64, 0, keyboardSize.height, 0)
            self.constraintNextBtnBottom.constant = inset.bottom
        }
    }
    
    @IBAction func maxAction(_ sender: Any) {
        self.sumInCrypto = self.cryptoSumInWallet
        if self.isCrypto {
            self.amountTF.text = "\(self.sumInCrypto)"
            self.topSumLbl.text = "\(self.sumInCrypto)"
        } else {
            self.bottomSumAndCurrencyLbl.text = "\(self.sumInCrypto) BTC"
        }
        self.spendableSumAndCurrencyLbl.text = "0.0 BTC"
        self.maxBtn.isEnabled = false
        self.maxLbl.textColor = UIColor.gray
        
    }
    
    @IBAction func nextAction(_ sender: Any) {
        self.performSegue(withIdentifier: "sendFinishVC", sender: sender)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.amountTF.text = self.amountTF.text?.replacingOccurrences(of: ",", with: ".")
        if string == "," && (self.amountTF.text?.contains("."))! {
            return false
        }
        
        if string == ""{
            self.topSumLbl.text?.removeLast()
        } else {
            if string == "," {
                self.topSumLbl.text = self.amountTF.text! + "."
            } else {
                self.topSumLbl.text = self.amountTF.text! + string
            }
        }
        if self.isCrypto {
            self.sumInCrypto = (self.topSumLbl.text! as NSString).doubleValue
        } else {
            self.sumInFiat = (self.topSumLbl.text! as NSString).doubleValue
        }
        return true
    }
}
