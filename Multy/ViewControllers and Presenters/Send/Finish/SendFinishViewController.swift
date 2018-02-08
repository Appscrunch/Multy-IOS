//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class SendFinishViewController: UIViewController, UITextFieldDelegate {

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
        self.presenter.sendFinishVC = self
        self.hideKeyboardWhenTappedAround()
        self.presenter.makeEndSum()
        self.setupUI()
    }
    
    func setupUI() {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 8
        self.cryptoSumLbl.text = "\(numberFormatter.string(for: self.presenter.sumInCrypto) ?? "0.0")"
        self.cryptoNamelbl.text = "\(self.presenter.cryptoName ?? "BTC")"
        self.fiatSumAndCurrancyLbl.text = "\(self.presenter.sumInFiat ?? 0.0) \(self.presenter.fiatName ?? "USD")"
        self.addressLbl.text = self.presenter.addressToStr
        self.walletNameLbl.text = self.presenter.walletFrom?.name
        self.walletCryptoSumAndCurrencyLbl.text = "\(self.presenter.walletFrom?.sumInCrypto ?? 0.0) \(self.presenter.walletFrom?.cryptoName ?? "")"
        let fiatSum = ((self.presenter.walletFrom?.sumInCrypto)! * exchangeCourse).fixedFraction(digits: 2)
        self.walletFiatSumAndCurrencyLbl.text = "\(fiatSum) \(self.presenter.walletFrom?.fiatName ?? "")"
        self.transactionFeeCostLbl.text = "\(self.presenter.transactionObj?.sumInCrypto ?? 0.0) \(self.presenter.transactionObj?.cryptoName ?? "")/\(self.presenter.transactionObj?.sumInFiat ?? 0.0) \(self.presenter.transactionObj?.fiatName ?? "")"
        self.transactionSpeedNameLbl.text = "\(self.presenter.transactionObj?.speedName ?? "") "
        self.transactionSpeedTimeLbl.text =  "\(self.presenter.transactionObj?.speedTimeString ?? "")"
        if self.view.frame.height == 736 {
            self.btnTopConstraint.constant = 105
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    @IBAction func nextAction(_ sender: Any) {
        let params = [
            "transaction" : presenter.rawTransaction!
            ] as [String : Any]
        
        //MARK: add transaction
        DataManager.shared.apiManager.sendRawTransaction(presenter.account!.token,
                                                         walletID: presenter.walletFrom!.walletID,
                                                         params, completion: { (dict, error) in
            print("---------\(dict)")
        })
        
        self.performSegue(withIdentifier: "sendingAnimationVC", sender: sender)
    }

}
