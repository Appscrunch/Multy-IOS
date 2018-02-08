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
    @IBOutlet weak var commissionSwitch: UISwitch!
    
    @IBOutlet weak var scrollView: UIScrollView!  //
    @IBOutlet weak var swapBtn: UIButton!         // ipad
    
    @IBOutlet weak var constraintNextBtnBottom: NSLayoutConstraint!
    @IBOutlet weak var constratintNextBtnHeight: NSLayoutConstraint!
    
    let presenter = SendAmountPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.sendAmountVC = self
//        self.presenter.setAmountFromQr()
//        self.presenter.cryptoToUsd()
//        self.presenter.setSpendableAmountText()
//        self.presenter.setMaxAllowed()
//        self.presenter.makeMaxSumWithFeeAndDonate()
//        self.setSumInNextBtn()
//        
//        self.presenter.getData()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.fixForIpad()
        self.nextBtn.applyGradient(withColours: [UIColor(ciColor: CIColor(red: 0/255, green: 178/255, blue: 255/255)),
                                                 UIColor(ciColor: CIColor(red: 0/255, green: 122/255, blue: 255/255))],
                                   gradientOrientation: .horizontal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.hideKeyboard), name: NSNotification.Name(rawValue: "hideKeyboard"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showKeyboard), name: NSNotification.Name(rawValue: "showKeyboard"), object: nil)
        self.amountTF.resignFirstResponder()
        self.amountTF.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    @IBAction func payForCommisionAction(_ sender: Any) {
        self.presenter.checkMaxEntered()
        if self.presenter.isMaxEntered {
            self.presentWarning(message: self.presenter.messageForAlert())
            self.commissionSwitch.isOn = false
        } else {
            self.setSumInNextBtn()
        }
        self.presenter.setMaxAllowed()
    }
    
    
    
    
    @IBAction func changeAction(_ sender: Any) {
        if self.presenter.isCrypto {
            self.presenter.isCrypto = !self.presenter.isCrypto
            self.presenter.makeMaxSumWithFeeAndDonate()
            if self.presenter.sumInFiat > (self.presenter.wallet?.sumInFiat)! {
                self.amountTF.text = "\(self.presenter.wallet?.sumInFiat ?? 0.0)"
                self.topSumLbl.text = "\(self.presenter.wallet?.sumInFiat ?? 0.0)"
            } else {
                self.amountTF.text = "\(self.presenter.sumInFiat)"
                self.topSumLbl.text = "\(self.presenter.sumInFiat)"
            }
            if self.presenter.sumInCrypto > (self.presenter.wallet?.sumInCrypto)! {
                self.bottomSumLbl.text = "\(self.presenter.wallet?.sumInCrypto ?? 0.0) "
            } else {
                self.bottomSumLbl.text = "\(self.presenter.sumInCrypto) "
            }
            self.bottomCurrencyLbl.text = "\(self.presenter.cryptoName)"
            self.topCurrencyNameLbl.text = "\(self.presenter.fiatName)"
        } else {
            self.presenter.isCrypto = !self.presenter.isCrypto
            self.presenter.makeMaxSumWithFeeAndDonate()
            if self.presenter.sumInCrypto > (self.presenter.wallet?.sumInCrypto)! || self.presenter.sumInCrypto > self.presenter.cryptoMaxSumWithFeeAndDonate {
                switch self.commissionSwitch.isOn {
                case true:
                    self.amountTF.text = "\(self.presenter.cryptoMaxSumWithFeeAndDonate)"
                    self.topSumLbl.text = "\(self.presenter.cryptoMaxSumWithFeeAndDonate)"
                case false:
                    self.amountTF.text = "\(self.presenter.wallet?.sumInCrypto ?? 0.0)"
                    self.topSumLbl.text = "\(self.presenter.wallet?.sumInCrypto ?? 0.0)"
                }
            } else {
                self.amountTF.text = "\(self.presenter.sumInCrypto)"
                self.topSumLbl.text = "\(self.presenter.sumInCrypto)"
            }
            
            if self.presenter.sumInFiat > (self.presenter.wallet?.sumInFiat)! {
                self.bottomSumLbl.text = "\(self.presenter.wallet?.sumInFiat ?? 0.0) "
            } else {
                 self.bottomSumLbl.text = "\(self.presenter.sumInFiat) "
            }
            self.topCurrencyNameLbl.text = self.presenter.cryptoName
            self.bottomCurrencyLbl.text = "\(self.presenter.fiatName)"
        }
        self.presenter.setSpendableAmountText()
        self.presenter.setMaxAllowed()
        self.setSumInNextBtn()
    }
    
    
    @objc func hideKeyboard() {
        self.amountTF.resignFirstResponder()
    }
    
    @objc func showKeyboard() {
        self.amountTF.becomeFirstResponder()
    }
    
    @objc func keyboardWillShow(_ notification : Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let inset : UIEdgeInsets = UIEdgeInsetsMake(64, 0, keyboardSize.height, 0)
            self.constraintNextBtnBottom.constant = inset.bottom
        }
    }
    
    
    
    @IBAction func maxAction(_ sender: Any) {
        if self.presenter.isCrypto {
            self.commissionSwitch.isOn = false
            self.presenter.setMaxAllowed()
            self.amountTF.text = "\(self.presenter.wallet?.sumInCrypto ?? 0.0)"
            self.topSumLbl.text = "\(self.presenter.wallet?.sumInCrypto ?? 0.0)"
            self.presenter.sumInCrypto = self.presenter.wallet?.sumInCrypto ?? 0.0
            self.presenter.cryptoToUsd()
            self.setSumInNextBtn()
        } else {
            self.commissionSwitch.isOn = false
            self.presenter.setMaxAllowed()
            self.amountTF.text = "\(self.presenter.wallet?.sumInFiat ?? 0.0)"
            self.topSumLbl.text = "\(self.presenter.wallet?.sumInFiat ?? 0.0)"
            self.presenter.sumInFiat = self.presenter.wallet?.sumInFiat ?? 0.0
            self.presenter.usdToCrypto()
            self.setSumInNextBtn()
        }
        self.presenter.saveTfValue()
    }
    
    
    
    @IBAction func nextAction(_ sender: Any) {
        if self.presenter.sumInCrypto != 0.0 || self.presenter.donationObj != nil {
            self.performSegue(withIdentifier: "sendFinishVC", sender: sender)
        } else {
            self.presentWarning(message: "You try to send 0.0 \(self.presenter.cryptoName).\nPlease enter the correct value")
        }
    }
    
    func presentWarning(message: String) {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text == "" {
            if (string as NSString).doubleValue > self.presenter.maxAllowedToSpend {
                self.presentWarning(message: "You trying to enter sum more then you have")
                return false
            }
        }
        if (string != "," || string != ".") && ((self.topSumLbl.text! + string) as NSString).doubleValue > self.presenter.maxAllowedToSpend {
            if string != "" {
                self.presentWarning(message: "You trying to enter sum more then you have")
                return false
            }
        }
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        
        if newLength <= self.presenter.maxLengthForSum {
            self.amountTF.text = self.amountTF.text?.replacingOccurrences(of: ",", with: ".")
            if string == "," && (self.amountTF.text?.contains("."))!{
                return false
            }
            
            if (self.amountTF.text?.contains("."))! && string != "" {
                let strAfterDot: [String?] = (self.amountTF.text?.components(separatedBy: "."))!
                if self.presenter.isCrypto {
                    if strAfterDot[1]?.count == 8 {
                        return false
                    } else {
                        self.topSumLbl.text = self.amountTF.text! + string                                
                        self.presenter.saveTfValue()
                    }
                } else {
                    if strAfterDot[1]?.count == 2 {
                        return false
                    } else {
                        self.topSumLbl.text = self.amountTF.text! + string
                        self.presenter.saveTfValue()
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
            self.presenter.saveTfValue()
        }
//        self.presenter.setMaxAllowed()
        self.presenter.checkMaxEntered()
        self.setSumInNextBtn()
        return newLength <= self.presenter.maxLengthForSum
    }
    
    
    func setSumInNextBtn() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        
        self.perform(#selector(self.changeSum), with: nil, afterDelay: 0.3)
    }
    
    @objc func changeSum() {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        let sumForBtn = self.presenter.getNextBtnSum()
        if self.presenter.isCrypto {
            numberFormatter.maximumFractionDigits = 8
            self.btnSumLbl.text = "\(numberFormatter.string(for: sumForBtn) ?? "0.0") \(self.presenter.cryptoName)"
        } else {
            numberFormatter.maximumFractionDigits = 2
            self.btnSumLbl.text = "\(numberFormatter.string(for: sumForBtn) ?? "0.0") \(self.presenter.fiatName)"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sendFinishVC" {
            let sendFinishVC = segue.destination as! SendFinishViewController
            sendFinishVC.presenter.addressToStr = self.presenter.addressToStr
            sendFinishVC.presenter.walletFrom = self.presenter.wallet
            sendFinishVC.presenter.sumInFiat = self.presenter.sumInFiat
            sendFinishVC.presenter.cryptoName = self.presenter.cryptoName
            sendFinishVC.presenter.fiatName = self.presenter.fiatName
            sendFinishVC.presenter.transactionObj = self.presenter.transactionObj
            sendFinishVC.presenter.sumInCrypto = self.presenter.sumInCrypto
            sendFinishVC.presenter.isCrypto = self.presenter.isCrypto
            sendFinishVC.presenter.endSum = self.presenter.getNextBtnSum()
            sendFinishVC.presenter.rawTransaction = self.presenter.rawTransaction
            sendFinishVC.presenter.account = self.presenter.account
            
            test()
        }
    }
    
    func test () {
        DataManager.shared.getAccount { (account, error) in
            
        }
    }
    
    func fixForIpad() {
        if screenHeight == 480 { 
            let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height - 50)
            scrollView.setContentOffset(bottomOffset, animated: true)
        }
    }
}
