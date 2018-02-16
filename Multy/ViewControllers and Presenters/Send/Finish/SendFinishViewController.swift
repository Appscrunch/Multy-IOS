//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class SendFinishViewController: UIViewController, UITextFieldDelegate, AnalyticsProtocol {

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
    
    @IBOutlet weak var btnTopConstraint: NSLayoutConstraint!
    
    let presenter = SendFinishPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fixUIForX()
        self.presenter.sendFinishVC = self
        self.hideKeyboardWhenTappedAround()
        self.presenter.makeEndSum()

        self.noteTF.delegate = self

        self.setupUI()
        sendAnalyticsEvent(screenName: "\(screenSendSummaryWithChain)\(presenter.transactionDTO.choosenWallet!.chain)", eventName: "\(screenSendSummaryWithChain)\(presenter.transactionDTO.choosenWallet!.chain)")
    }
    
    func setupUI() {
        self.cryptoSumLbl.text = "\(presenter.sumInCrypto?.fixedFraction(digits: 8) ?? "0.0")"
        self.cryptoNamelbl.text = "\(self.presenter.cryptoName ?? "BTC")"
        self.fiatSumAndCurrancyLbl.text = "\(self.presenter.sumInFiat?.fixedFraction(digits: 2) ?? "0.0") \(self.presenter.fiatName ?? "USD")"
        self.addressLbl.text = presenter.transactionDTO.sendAddress
        self.walletNameLbl.text = presenter.transactionDTO.choosenWallet?.name
        
        self.walletCryptoSumAndCurrencyLbl.text = "\(presenter.transactionDTO.choosenWallet?.sumInCrypto.fixedFraction(digits: 8) ?? "0.0") \(presenter.transactionDTO.choosenWallet?.cryptoName ?? "")"
        let fiatSum = ((presenter.transactionDTO.choosenWallet?.sumInCrypto)! * exchangeCourse).fixedFraction(digits: 2)
        self.walletFiatSumAndCurrencyLbl.text = "\(fiatSum) \(presenter.transactionDTO.choosenWallet?.fiatName ?? "")"
        self.transactionFeeCostLbl.text = "\((presenter.transactionDTO.transaction?.transactionRLM?.sumInCrypto ?? 0.0).fixedFraction(digits: 8)) \(presenter.transactionDTO.transaction?.transactionRLM?.cryptoName ?? "")/\((presenter.transactionDTO.transaction?.transactionRLM?.sumInFiat ?? 0.0).fixedFraction(digits: 2)) \(presenter.transactionDTO.transaction?.transactionRLM?.fiatName ?? "")"
        self.transactionSpeedNameLbl.text = "\(presenter.transactionDTO.transaction?.transactionRLM?.speedName ?? "") "
        self.transactionSpeedTimeLbl.text =  "\(presenter.transactionDTO.transaction?.transactionRLM?.speedTimeString ?? "")"
        if self.view.frame.height == 736 {
            self.btnTopConstraint.constant = 105
        }
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
        let newAddressParams = [
            "walletindex"   : wallet.walletID.intValue,
            "address"       : presenter.transactionDTO.transaction!.newChangeAddress!,
            "addressindex"  : wallet.addresses.count,
            "transaction"   : presenter.transactionDTO.transaction!.rawTransaction!,
            "ishd"          : NSNumber(booleanLiteral: true)
            ] as [String : Any]
        
        let params = [
            "currencyid": wallet.chain,
            "payload"   : newAddressParams
            ] as [String : Any]
        
        DataManager.shared.sendHDTransaction(transactionParameters: params) { (dict, error) in
            print("---------\(dict)")
            
            if error != nil {
                self.presentAlert()
                
                print("sendHDTransaction Error: \(error)")
                
                return
            }
            
            if dict!["code"] as! Int == 200 {
                self.performSegue(withIdentifier: "sendingAnimationVC", sender: sender)
            } else {
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
            self.btnTopConstraint.constant = 110
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sendingAnimationVC" {
            let sendAnimationVC = segue.destination as! SendingAnimationViewController
            sendAnimationVC.chainId = presenter.transactionDTO.choosenWallet!.chain as? Int
        }
    }
}
