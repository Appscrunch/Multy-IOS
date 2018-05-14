//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import AURUnlockSlider

class SendFinishViewController: UIViewController, UITextFieldDelegate, AnalyticsProtocol, AURUnlockSliderDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var middle: UIView!
    @IBOutlet weak var bottom: UIView!
    @IBOutlet weak var cryptoImage: UIImageView!
    @IBOutlet weak var cryptoSumLbl: UILabel!
    @IBOutlet weak var cryptoNamelbl: UILabel!
    @IBOutlet weak var fiatSumAndCurrancyLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    
    @IBOutlet weak var noteTF: UITextField!
    
    @IBOutlet weak var walletNameLbl: UILabel!
    @IBOutlet weak var walletCryptoSumAndCurrencyLbl: UILabel!
    @IBOutlet weak var walletFiatSumAndCurrencyLbl: UILabel!
    
    @IBOutlet weak var transactionSpeedNameLbl: UILabel!
    @IBOutlet weak var transactionSpeedTimeLbl: UILabel!
    @IBOutlet weak var transactionFeeCostLbl: UILabel! // exp: 0.002 BTC / 1.54 USD
    
    @IBOutlet weak var sendBtn: UIButton!
    
    @IBOutlet weak var arr1: UIImageView!
    @IBOutlet weak var arr2: UIImageView!
    @IBOutlet weak var arr3: UIImageView!
    @IBOutlet var arrCollection: [UIImageView]!
    
    @IBOutlet weak var btnTopConstraint: NSLayoutConstraint!
    
    let presenter = SendFinishPresenter()
    var imageArr = [#imageLiteral(resourceName: "slideToSend1"),#imageLiteral(resourceName: "slideToSend2"),#imageLiteral(resourceName: "slideToSend3")]
    var timer: Timer?
    
    let label = UILabel(frame: CGRect(x: 33, y: 22, width: 50, height: 20))     //test
    var unlockSlider: AURUnlockSlider?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.swipeToBack()
        self.fixUIForX()
        self.presenter.sendFinishVC = self
        self.hideKeyboardWhenTappedAround()
        self.presenter.makeEndSum()

        self.noteTF.delegate = self
        
        
        self.setupUI()
        sendAnalyticsEvent(screenName: "\(screenSendSummaryWithChain)\(presenter.transactionDTO.choosenWallet!.chain)",
                            eventName: "\(screenSendSummaryWithChain)\(presenter.transactionDTO.choosenWallet!.chain)")
    }
    
    override func viewDidLayoutSubviews() {
        if self.scrollView.contentSize.height != 0.0 {
            createSlideView()
        }
        sendBtn.applyGradient(withColours: [UIColor(ciColor: CIColor(red: 0/255, green: 178/255, blue: 255/255)),
                                            UIColor(ciColor: CIColor(red: 0/255, green: 122/255, blue: 255/255))],
                              gradientOrientation: .horizontal)
    }
    
    func setupUI() {
        let shadowColor = #colorLiteral(red: 0.6509803922, green: 0.6941176471, blue: 0.7764705882, alpha: 0.5)
        topView.setShadow(with: shadowColor)
        middle.setShadow(with: shadowColor)
        bottom.setShadow(with: shadowColor)
        cryptoImage.image = UIImage(named: presenter.transactionDTO.blockchainType!.iconString)
        
        cryptoSumLbl.text = presenter.sumInCryptoString
        cryptoNamelbl.text = presenter.cryptoName
        fiatSumAndCurrancyLbl.text = "\(presenter.sumInFiatString) \(presenter.fiatName)"
        addressLbl.text = presenter.transactionDTO.sendAddress
        walletNameLbl.text = presenter.transactionDTO.choosenWallet?.name
        
        walletCryptoSumAndCurrencyLbl.text = "\(presenter.transactionDTO.choosenWallet!.sumInCryptoString) \(presenter.transactionDTO.choosenWallet!.cryptoName)"
        let fiatSum = presenter.transactionDTO.choosenWallet!.sumInFiatString
        walletFiatSumAndCurrencyLbl.text = "\(fiatSum) \(presenter.transactionDTO.choosenWallet!.fiatName)"
        transactionFeeCostLbl.text = "\(presenter.feeAmountInCryptoString) \(presenter.cryptoName)/\(presenter.feeAmountInFiatString) \(presenter.fiatName)"
        transactionSpeedNameLbl.text = "\(presenter.transactionDTO.transaction?.transactionRLM?.speedName ?? "") "
        transactionSpeedTimeLbl.text =  "\(presenter.transactionDTO.transaction?.transactionRLM?.speedTimeString ?? "")"
        if view.frame.height == 736 {
            btnTopConstraint.constant = 105
        }
        
        animate()
    }
    
    func createSlideView() {
        self.unlockSlider = AURUnlockSlider(frame: self.presenter.makeFrameForSlider())
        unlockSlider!.delegate = self
        
        unlockSlider!.sliderText = "Slide to Send"
        unlockSlider!.sliderTextColor = UIColor.white
        unlockSlider!.sliderTextFont = UIFont(name: "AvenirNext-Medium", size: 18.0)!
        unlockSlider!.sliderBackgroundColor = UIColor.clear
        
        
        label.text = "ABC"  //test
        label.textColor = UIColor.white     //test
        
//        unlockSlider.addSubview(label)
        if self.view.subviews.contains(unlockSlider!) {
            unlockSlider!.removeFromSuperview()
        }
        self.scrollView.addSubview(unlockSlider!) //view.addSubview(unlockSlider)
    }
    
    func animate() {
        self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.decrease), userInfo: nil, repeats: true)
        RunLoop.current.add(self.timer!, forMode: RunLoopMode.commonModes)
    }
    
    @objc func decrease() {
        if label.textColor == UIColor.white {
            UIView.transition(with: label, duration: 1.0, options: .transitionCrossDissolve, animations: {() -> Void in
                self.label.textColor = UIColor.red
            }, completion: {(_ finished: Bool) -> Void in
            })
        } else {
            UIView.transition(with: label, duration: 1.0, options: .transitionCrossDissolve, animations: {() -> Void in
                self.label.textColor = UIColor.white
            }, completion: {(_ finished: Bool) -> Void in
            })
        }
        
        if self.arrCollection[0].image == imageArr[0] {
//            self.arrCollection[0].image = imageArr[2]
            UIView.transition(with: self.arrCollection[0], duration: 1, options: .transitionCrossDissolve, animations: { self.arrCollection[0].image = self.imageArr[2] }, completion: nil)
//            self.arrCollection[1].image = imageArr[0]
            UIView.transition(with: self.arrCollection[1], duration: 1, options: .transitionCrossDissolve, animations: { self.arrCollection[1].image = self.imageArr[0] }, completion: nil)
//            self.arrCollection[2].image = imageArr[1]
            UIView.transition(with: self.arrCollection[2], duration: 1, options: .transitionCrossDissolve, animations: { self.arrCollection[2].image = self.imageArr[1] }, completion: nil)
        } else if self.arrCollection[0].image == imageArr[2] {
//            self.arrCollection[0].image = imageArr[1]
            UIView.transition(with: self.arrCollection[0], duration: 1, options: .transitionCrossDissolve, animations: { self.arrCollection[0].image = self.imageArr[1] }, completion: nil)
//            self.arrCollection[1].image = imageArr[2]
            UIView.transition(with: self.arrCollection[1], duration: 1, options: .transitionCrossDissolve, animations: { self.arrCollection[1].image = self.imageArr[2] }, completion: nil)
//            self.arrCollection[2].image = imageArr[0]
            UIView.transition(with: self.arrCollection[2], duration: 1, options: .transitionCrossDissolve, animations: { self.arrCollection[2].image = self.imageArr[0] }, completion: nil)
        } else if self.arrCollection[0].image == imageArr[1] {
//            self.arrCollection[0].image = imageArr[0]
            UIView.transition(with: self.arrCollection[0], duration: 1, options: .transitionCrossDissolve, animations: { self.arrCollection[0].image = self.imageArr[0] }, completion: nil)
//            self.arrCollection[1].image = imageArr[1]
            UIView.transition(with: self.arrCollection[1], duration: 1, options: .transitionCrossDissolve, animations: { self.arrCollection[1].image = self.imageArr[2] }, completion: nil)
//            self.arrCollection[2].image = imageArr[2]
            UIView.transition(with: self.arrCollection[2], duration: 1, options: .transitionCrossDissolve, animations: { self.arrCollection[2].image = self.imageArr[2] }, completion: nil)
        }
    }
    
    func unlockSliderDidUnlock(_ slider: AURUnlockSlider) {
//        self.presentAlert()
        self.nextAction(Any.self)
    }
    
    
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        sendAnalyticsEvent(screenName: "\(screenSendSummaryWithChain)\(presenter.transactionDTO.choosenWallet!.chain)", eventName: closeTap)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    @IBAction func addNoteAction(_ sender: Any) {
        sendAnalyticsEvent(screenName: "\(screenSendSummaryWithChain)\(presenter.transactionDTO.choosenWallet!.chain)", eventName: addNoteTap)
    }
    
    @IBAction func nextAction(_ sender: Any) {
        let wallet = presenter.transactionDTO.choosenWallet!
        let newAddress = wallet.shouldCreateNewAddressAfterTransaction ? presenter.transactionDTO.transaction!.newChangeAddress! : ""
        
        let newAddressParams = [
            "walletindex"   : wallet.walletID.intValue,
            "address"       : newAddress,
            "addressindex"  : wallet.addresses.count,
            "transaction"   : presenter.transactionDTO.transaction!.rawTransaction!,
            "ishd"          : NSNumber(booleanLiteral: wallet.shouldCreateNewAddressAfterTransaction)
            ] as [String : Any]
        
        let params = [
            "currencyid": wallet.chain,
            "networkid" : wallet.chainType,
            "payload"   : newAddressParams
            ] as [String : Any]
        
        
        DataManager.shared.sendHDTransaction(transactionParameters: params) { (dict, error) in
            print("---------\(dict)")
            
            if error != nil {
                self.unlockSlider = nil
                self.scrollView.subviews.last?.removeFromSuperview()
                self.scrollView.reloadInputViews()
                self.createSlideView()
                self.scrollView.reloadInputViews()
                self.view.reloadInputViews()
                
                self.presentAlert()
//                self.unlockSlider.layoutSubviews()
                print("sendHDTransaction Error: \(error)")
                self.sendAnalyticsEvent(screenName: "\(screenSendAmountWithChain)\(self.presenter.transactionDTO.choosenWallet!.chain)", eventName: transactionErrorFromServer)
                return
            }
            
            if dict!["code"] as! Int == 200 {
                self.performSegue(withIdentifier: "sendingAnimationVC", sender: sender)
            } else {
                self.sendAnalyticsEvent(screenName: "\(screenSendAmountWithChain)\(self.presenter.transactionDTO.choosenWallet!.chain)", eventName: transactionErrorFromServer)
                self.presentAlert()
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func presentAlert() {
        let message = "Error while sending transaction. Please, try again!"
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
            
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func fixUIForX() {
        if screenHeight == heightOfX {
            self.btnTopConstraint.constant = 100
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sendingAnimationVC" {
            let sendAnimationVC = segue.destination as! SendingAnimationViewController
            sendAnimationVC.chainId = presenter.transactionDTO.choosenWallet!.chain as? Int
        }
    }
}
