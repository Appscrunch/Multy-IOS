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
    @IBOutlet weak var bottomSumLbl: UILabel!
    @IBOutlet weak var bottomCurrencyLbl: UILabel!
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
    
    var maxLengthForSum = 12
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.sendAmountVC = self
        self.presenter.countMaxSpendable()
        self.nextBtn.isEnabled = false
        self.nextBtn.backgroundColor = .gray
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        self.amountTF.becomeFirstResponder()
        self.spendableSumAndCurrencyLbl.text = "\(self.presenter.maxSendable) \(self.presenter.wallet?.cryptoName.uppercased() ?? "BTC")"
        
        self.topSumLbl.addObserver(self, forKeyPath: "text", options: [.old, .new], context: nil)
        self.setAmountFromQr()
    }
    
    func setAmountFromQr() {
        if self.sumInCrypto != 0.0 {
            self.amountTF.text = "\(self.sumInCrypto)"
            self.topSumLbl.text = "\(self.sumInCrypto)"
            self.btnSumLbl.text = "\(self.sumInCrypto)"
            self.cryptoToUsd()
        }
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
            self.bottomSumLbl.text = "\(self.sumInCrypto) "
            self.bottomCurrencyLbl.text = "\(self.cryptoName)"
            self.topSumLbl.text = "\(self.sumInFiat)"
            self.topCurrencyNameLbl.text = "\(self.fiatName)"
        } else {
            if self.sumInCrypto != 0.0 {
                self.amountTF.text = "\(self.sumInCrypto)"
            } else {
                self.amountTF.text = ""
            }
            self.topSumLbl.text = "\(self.sumInCrypto)"
            self.topCurrencyNameLbl.text = self.cryptoName
            self.bottomSumLbl.text = "\(sumInFiat) "
            self.bottomCurrencyLbl.text = "\(self.fiatName)"
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
            self.amountTF.text = "\(self.presenter.wallet?.sumInCrypto ?? 0.0)"
            self.topSumLbl.text = "\(self.presenter.wallet?.sumInCrypto ?? 0.0)"
            self.cryptoToUsd()
        } else {
            self.bottomSumLbl.text = "\(self.presenter.wallet?.sumInCrypto ?? 0.0) BTC"
        }
        self.spendableSumAndCurrencyLbl.text = "0.0 BTC"
        self.maxBtn.isEnabled = false
        self.maxLbl.textColor = UIColor.gray
        self.saveTfValue()
    }
    
    func cryptoToUsd() {
        self.sumInFiat = self.sumInCrypto * exchangeCourse
        self.sumInFiat = Double(round(100*self.sumInFiat)/100)
        self.bottomSumLbl.text = "\(self.sumInFiat)"
    }
    
    @IBAction func nextAction(_ sender: Any) {
        self.performSegue(withIdentifier: "sendFinishVC", sender: sender)
    }
    
    func presentWarning() {
        let alert = UIAlertController(title: "Warining", message: "You trying to enter sum more then you have", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string != "," || string != ".") && ((self.topSumLbl.text! + string) as NSString).doubleValue > (self.presenter.maxSendable) {
            if string != "" {
                self.presentWarning()
                return false
            }
        }
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        
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
                        self.topSumLbl.text = self.amountTF.text! + string
                        self.saveTfValue()
                    }
                } else {
                    if strAfterDot[1]?.count == 2 {
                        return false
                    } else {
                        self.topSumLbl.text = self.amountTF.text! + string
                        self.saveTfValue()
                    }
                }
            }
            
            if string == "," {
                self.topSumLbl.text = self.amountTF.text! + "."
            } else {
                if string != "" {
                    self.topSumLbl.text = self.amountTF.text! + string
                } else {
                    self.topSumLbl.text?.removeLast()
                }
            }
            self.saveTfValue()
        }
        return newLength <= self.maxLengthForSum
    }
    
    func saveTfValue() {
        if self.isCrypto {
            self.sumInCrypto = (self.topSumLbl.text! as NSString).doubleValue
            self.sumInFiat = self.sumInCrypto * self.presenter.exchangeCourse
            self.sumInFiat = Double(round(100*self.sumInFiat)/100)
            self.bottomSumLbl.text = "\(self.sumInFiat) "
            self.bottomCurrencyLbl.text = self.fiatName
        } else {
            self.sumInFiat = (self.topSumLbl.text! as NSString).doubleValue
            self.sumInCrypto = self.sumInFiat / self.presenter.exchangeCourse
            self.sumInCrypto = Double(round(100000000*self.sumInCrypto)/100000000 )
            self.bottomSumLbl.text = "\(self.sumInCrypto) "
            self.bottomCurrencyLbl.text = self.cryptoName
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sendFinishVC" {
            let sendFinishVC = segue.destination as! SendFinishViewController
            sendFinishVC.presenter.addressToStr = self.presenter.addressToStr
            sendFinishVC.presenter.walletFrom = self.presenter.wallet
            sendFinishVC.presenter.sumInCrypto = self.sumInCrypto
            sendFinishVC.presenter.sumInFiat = self.sumInFiat
            sendFinishVC.presenter.cryptoName = self.cryptoName
            sendFinishVC.presenter.fiatName = self.fiatName
            sendFinishVC.presenter.transactionObj = self.presenter.transactionObj
        }
    }
}
