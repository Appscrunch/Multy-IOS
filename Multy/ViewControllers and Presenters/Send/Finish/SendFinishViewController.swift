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
    
    
    let presenter = SendFinishPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.sendFinishVC = self
        self.presenter.getExchange()
        self.hideKeyboardWhenTappedAround()
        self.presenter.makeEndSum()
        self.setupUI()
    }
    
    func setupUI() {
        self.cryptoSumLbl.text = "\(self.presenter.sumInCrypto ?? 0.0)"
        self.cryptoNamelbl.text = "\(self.presenter.cryptoName ?? "BTC")"
        self.fiatSumAndCurrancyLbl.text = "\(self.presenter.sumInFiat ?? 0.0) \(self.presenter.fiatName ?? "USD")"
        self.addressLbl.text = self.presenter.addressToStr
        self.walletNameLbl.text = self.presenter.walletFrom?.name
        self.walletCryptoSumAndCurrencyLbl.text = "\(self.presenter.walletFrom?.sumInCrypto ?? 0.0) \(self.presenter.walletFrom?.cryptoName ?? "")"
        self.walletFiatSumAndCurrencyLbl.text = "\(self.presenter.walletFrom?.sumInFiat ?? 0.0) \(self.presenter.walletFrom?.fiatName ?? "")"
        self.transactionFeeCostLbl.text = "\(self.presenter.transactionObj?.sumInCrypto ?? 0.0) \(self.presenter.transactionObj?.cryptoName ?? "")/\(self.presenter.transactionObj?.sumInFiat ?? 0.0) \(self.presenter.transactionObj?.fiatName ?? "")"
        self.transactionSpeedNameLbl.text = "\(self.presenter.transactionObj?.speedName ?? "") "
        self.transactionSpeedTimeLbl.text =  "\(self.presenter.transactionObj?.speedTimeString ?? "")"
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    @IBAction func nextAction(_ sender: Any) {
        self.performSegue(withIdentifier: "sendingAnimationVC", sender: sender)
    }

}
