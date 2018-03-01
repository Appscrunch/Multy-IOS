//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class DonationSendViewController: UIViewController, UITextFieldDelegate, AnalyticsProtocol {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var walletNameLbl: UILabel!
    @IBOutlet weak var walletCryptoBtn: UIButton!
    @IBOutlet weak var walletFiatLbl: UILabel!
    
    @IBOutlet weak var donationTF: UITextField!
    @IBOutlet weak var fiatDonationLbl: UILabel!
    @IBOutlet weak var donatView: UIView!
    
    @IBOutlet weak var sendBtn: UIButton!
    
    @IBOutlet weak var bottomBtnConstraint: NSLayoutConstraint!
    
    
    let presenter = DonationSendPresenter()
    var isCustom = false
    
    var isCanDonat = false
    
    var countSymbolsAfterComma = 0
    
    let progressHud = ProgressHUD(text: "Sending...")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(progressHud)
        self.progressHud.hide()
        self.hideKeyboardWhenTappedAround()
        self.registerNotificationFromKeyboard()
        self.presenter.mainVC = self
        self.registerCells()
        
        tableView.layer.shadowColor = UIColor.gray.cgColor
        tableView.layer.shadowOpacity = 1
        tableView.layer.shadowOffset = .zero
        tableView.layer.shadowRadius = 10
        
        self.presenter.getWallets()
    }
    
    
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func registerCells() {
        let transactionCell = UINib(nibName: "TransactionFeeTableViewCell", bundle: nil)
        self.tableView.register(transactionCell, forCellReuseIdentifier: "transactionCell")
        
        let customFeeCell = UINib(nibName: "CustomTrasanctionFeeTableViewCell", bundle: nil)
        self.tableView.register(customFeeCell, forCellReuseIdentifier: "customFeeCell")
    }
    
    @IBAction func sendAction(_ sender: Any) {
        self.view.isUserInteractionEnabled = false
        self.progressHud.show()
        self.presenter.makeTransaction()
    }
    
    func updateUIWithWallet() {
        let cryptoStr = "\(self.presenter.walletPayFrom?.sumInCrypto.fixedFraction(digits: 8) ?? "0.0") \(self.presenter.walletPayFrom?.cryptoName ?? "BTC")"
        let fiatSum = "\(((self.presenter.walletPayFrom?.sumInCrypto)! * exchangeCourse).fixedFraction(digits: 2)) \(self.presenter.walletPayFrom?.fiatName ?? "USD")"
        
        let percentFromSum = 0.03
        let sumForDonat = ((self.presenter.walletPayFrom?.sumInCrypto)! * percentFromSum)
        let fiatDonation = sumForDonat * exchangeCourse
        
        self.walletNameLbl.text = self.presenter.walletPayFrom?.name
        self.walletCryptoBtn.setTitle(cryptoStr, for: .normal)
        self.walletFiatLbl.text = fiatSum
        
        self.donationTF.text = sumForDonat.fixedFraction(digits: 8)
        self.fiatDonationLbl.text = "\(fiatDonation.fixedFraction(digits: 2)) USD"
    }
    
    //MARK: Keyboard to scrollview
    func registerNotificationFromKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(SendDetailsViewController.keyboardWillShow),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SendDetailsViewController.keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height/4
                self.tableView.isUserInteractionEnabled = false
//                if screenHeight == heightOfX {
//                    bottomBtnConstraint.constant = 10
//                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height/4
                self.tableView.isUserInteractionEnabled = true
                self.makeSendAvailable(isAvailable: true)
//                if screenHeight == heightOfX {
//                    bottomBtnConstraint.constant = 0
//                }
            }
        }
    }
    //end
    
    @IBAction func chooseAnoterWalletAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Receive", bundle: nil)
        let walletsVC = storyboard.instantiateViewController(withIdentifier: "ReceiveStart") as! ReceiveStartViewController
        walletsVC.presenter.isNeedToPop = true
        walletsVC.sendWalletDelegate = self.presenter
        walletsVC.titleText = "Send Donation From"
        walletsVC.whereFrom = self
        self.navigationController?.pushViewController(walletsVC, animated: true)
    }
    
    func makeSendAvailable(isAvailable: Bool) {
        var isAvailable = isAvailable
        let donatAmount = self.donationTF.text?.convertStringWithCommaToDouble()
        if donatAmount! > 0.0 {
        } else {
            isAvailable = false
            shakeView(viewForShake: donatView)
        }
        if isAvailable {
            self.sendBtn.isUserInteractionEnabled = true
            self.sendBtn.backgroundColor = #colorLiteral(red: 0.009615149349, green: 0.5124486089, blue: 0.9994245172, alpha: 1)
        } else {
            self.sendBtn.isUserInteractionEnabled = false
            self.sendBtn.backgroundColor = #colorLiteral(red: 0.8196047544, green: 0.8196094632, blue: 0.8390848637, alpha: 1)
        }
    }
    
    func presentWarning(message: String) {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string == "." || string == ",") && ((self.donationTF.text?.contains(","))! || (self.donationTF.text?.contains("."))!){
            return false
        }
        
        if string == "." {
            self.donationTF.text?.append(",")
            return false
        }
        
        if (self.donationTF.text?.contains(","))! && string != "" {
            let strAfterDot: [String?] = (self.donationTF.text?.components(separatedBy: ","))!
            if strAfterDot[1]?.count == 8 {
                return false
            }
        }
        
        if (self.donationTF.text! + string).convertStringWithCommaToDouble() > self.presenter.maxAvailable {
            self.presentWarning(message: "You trying to enter sum more then you have")
            return false
        }
        
        if string == "" {
            self.donationTF.text?.removeLast()
            self.presenter.makeFiatDonat()
            return false
        }
        self.donationTF.text?.append(string) // = return true
        self.presenter.makeFiatDonat()
        return false
    }
    
}

extension DonationSendViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row != 2 {
            let transactionCell = self.tableView.dequeueReusableCell(withIdentifier: "transactionCell") as! TransactionFeeTableViewCell
            transactionCell.feeRate = self.presenter.feeRate
            if indexPath.row == 0 {
                transactionCell.makeCellBy(indexPath: [0, 3])  //Slow
            } else { //indexPath.row = 1
                transactionCell.makeCellBy(indexPath: [0, 2])  //Mediom
            }
            
            return transactionCell
        } else {
            let customFeeCell = self.tableView.dequeueReusableCell(withIdentifier: "customFeeCell") as! CustomTrasanctionFeeTableViewCell
            
            return customFeeCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        switch indexPath.row {
//        case 0:
//            sendAnalyticsEvent(screenName: "\(screenTransactionFeeWithChain)\(self.presenter.transactionDTO.choosenWallet!.chain)", eventName: veryFastTap)
//        case 1:
//            sendAnalyticsEvent(screenName: "\(screenTransactionFeeWithChain)\(self.presenter.transactionDTO.choosenWallet!.chain)", eventName: fastTap)
//        case 2:
//            sendAnalyticsEvent(screenName: "\(screenTransactionFeeWithChain)\(self.presenter.transactionDTO.choosenWallet!.chain)", eventName: mediumTap)
//        case 3:
//            sendAnalyticsEvent(screenName: "\(screenTransactionFeeWithChain)\(self.presenter.transactionDTO.choosenWallet!.chain)", eventName: slowTap)
//        case 4:
//            sendAnalyticsEvent(screenName: "\(screenTransactionFeeWithChain)\(self.presenter.transactionDTO.choosenWallet!.chain)", eventName: verySlowTap)
//        case 5:
//            sendAnalyticsEvent(screenName: "\(screenTransactionFeeWithChain)\(self.presenter.transactionDTO.choosenWallet!.chain)", eventName: customTap)
//        default : break
//        }
        
        if indexPath.row != 2 {
            if self.isCustom {
                let customCell = self.tableView.cellForRow(at: [0,2]) as! CustomTrasanctionFeeTableViewCell
                customCell.reloadUI()
            }
            var cells = self.tableView.visibleCells
            cells.removeLast()
            let trueCells = cells as! [TransactionFeeTableViewCell]
            if trueCells[indexPath.row].checkMarkImage.isHidden == false {
                trueCells[indexPath.row].checkMarkImage.isHidden = true
                self.presenter.selectedIndexOfSpeed = nil
                makeSendAvailable(isAvailable: false)
                return
            }
            for cell in trueCells {
                cell.checkMarkImage.isHidden = true
            }
            makeSendAvailable(isAvailable: true)
            trueCells[indexPath.row].checkMarkImage.isHidden = false
            self.presenter.selectedIndexOfSpeed = indexPath.row
        } else {
            self.isCustom = true
            let storyboard = UIStoryboard(name: "Send", bundle: nil)
            let customVC = storyboard.instantiateViewController(withIdentifier: "customVC") as! CustomFeeViewController
//            customVC.presenter.chainId = self.presenter.transactionDTO.choosenWallet!.chain
            customVC.presenter.chainId = 0
            customVC.delegate = self.presenter
            customVC.rate = Int(self.presenter.customFee)
            self.presenter.selectedIndexOfSpeed = indexPath.row
            self.navigationController?.pushViewController(customVC, animated: true)
            
            var cells = self.tableView.visibleCells
            cells.removeLast()
            let trueCells = cells as! [TransactionFeeTableViewCell]
            for cell in trueCells {
                cell.checkMarkImage.isHidden = true
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
