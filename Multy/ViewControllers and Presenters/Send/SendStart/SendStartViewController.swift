//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import ZFRippleButton

class SendStartViewController: UIViewController, UITextViewDelegate, AnalyticsProtocol, DonationProtocol, CancelProtocol {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextBtn: ZFRippleButton!
    @IBOutlet weak var middleConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var addressInTfLlb: UILabel!
    @IBOutlet weak var addressTV: UITextView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var botView: UIView!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var noAddressLbl: UILabel!
    
    let presenter = SendStartPresenter()
    var stingIdForInApp = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.swipeToBack()
        self.presenter.sendStartVC = self
        sendAnalyticsEvent(screenName: screenSendTo, eventName: screenSendTo)
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        (self.tabBarController as! CustomTabBarViewController).menuButton.isHidden = true
        (self.tabBarController as! CustomTabBarViewController).changeViewVisibility(isHidden: true)
//        if self.presenter.addressSendTo != "" {
//            self.modifyNextButtonMode()
//        }
    }
    
    func hideKeyboardWhenTappedAroundForSendStart() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissSendKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func setupUI() {
        registerCells()
        ipadFix()
        presenter.getAddresses()
        hideKeyboardWhenTappedAroundForSendStart()
        nextBtn.backgroundColor = UIColor(red: 209/255, green: 209/255, blue: 214/255, alpha: 1.0)
        setupShadow()
        addressTV.delegate = self
        if presenter.transactionDTO.sendAddress != nil && !presenter.transactionDTO.sendAddress!.isEmpty {
            addressTV.text = presenter.transactionDTO.sendAddress!
            placeholderLabel.isHidden = !addressTV.text.isEmpty
        }
    }
    
    @objc func dismissSendKeyboard(gesture: UITapGestureRecognizer) {
        presenter.transactionDTO.sendAddress = addressTV.text
        
        if presenter.transactionDTO.choosenWallet != nil && presenter.isTappedDisabledNextButton(gesture: gesture) {
            let isValidDTO = DataManager.shared.isAddressValid(address: presenter.transactionDTO.sendAddress!, for: presenter.transactionDTO.choosenWallet!)
            
            if !isValidDTO.isValid {
                let message = "You entered not valid address for current blockchain."
                presenter.presentAlert(message: message)
            }
            
            return
        }
        
        if !checkTVisEmpty() {
            modifyNextButtonMode()
        }
        view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let topCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? NewWalletTableViewCell
        topCell?.makeTopCorners()
        
        if presenter.transactionDTO.sendAddress != nil && !presenter.transactionDTO.sendAddress!.isEmpty {
            self.modifyNextButtonMode()
        }
        fixUI()
    }
    
    
    
    func registerCells() {
        let searchAddressCell = UINib(nibName: "SearchAddressTableViewCell", bundle: nil)
        self.tableView.register(searchAddressCell, forCellReuseIdentifier: "searchAddressCell")
        
        let oneLabelCell = UINib(nibName: "NewWalletTableViewCell", bundle: nil)
        self.tableView.register(oneLabelCell, forCellReuseIdentifier: "oneLabelCell")
        
        let recentCell = UINib(nibName: "RecentAddressTableViewCell", bundle: nil)
        self.tableView.register(recentCell, forCellReuseIdentifier: "recentCell")
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.presenter.cancelAction()
    }
    
    
    @IBAction func nextAction(_ sender: Any) {
        if self.presenter.transactionDTO.choosenWallet == nil {
            self.performSegue(withIdentifier: "chooseWalletVC", sender: sender)
        } else {
            self.performSegue(withIdentifier: presenter.destinationSegueString(), sender: sender)
        }
    }
    
    func modifyNextButtonMode() {
//        if presenter.transactionDTO.sendAddress != nil && presenter.isValidCryptoAddress() {
            if !nextBtn.isEnabled {
                self.nextBtn.isEnabled = true
                self.nextBtn.applyGradient(withColours: [UIColor(ciColor: CIColor(red: 0/255, green: 178/255, blue: 255/255)),
                                                         UIColor(ciColor: CIColor(red: 0/255, green: 122/255, blue: 255/255))],
                                           gradientOrientation: .horizontal)
            }
    }
    
    @IBAction func scanQrAction(_ sender: Any) {
        performSegue(withIdentifier: "qrCamera", sender: Any.self)
        sendAnalyticsEvent(screenName: screenSendTo, eventName: scanQrTap)
    }
    
    @IBAction func wirelessScanAction(_ sender: Any) {
        self.donate(idOfInApp: "abc")
        sendDonationAlertScreenPresentedAnalytics(code: donationForWirelessScanFUNC)
    }
    
    @IBAction func addressBookAction(_ sender: Any) {
        self.donate(idOfInApp: "abc")
        sendDonationAlertScreenPresentedAnalytics(code: donationForContactSC)
    }
    
    func setupShadow() {
        let myColor = #colorLiteral(red: 0.6509803922, green: 0.6941176471, blue: 0.7764705882, alpha: 0.3)
        topView.setShadow(with: myColor)
        botView.setShadow(with: myColor)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "chooseWalletVC"?:
            let chooseWalletVC = segue.destination as! WalletChooseViewController
            chooseWalletVC.presenter.transactionDTO = presenter.transactionDTO
        case "qrCamera"?:
            let qrScanerVC = segue.destination as! QrScannerViewController
            qrScanerVC.qrDelegate = presenter
        case "sendBTCDetailsVC"?:
            let sendDetailsVC = segue.destination as! SendDetailsViewController
            sendDetailsVC.presenter.transactionDTO = presenter.transactionDTO
        case "sendETHDetailsVC"?:
            let sendDetailsVC = segue.destination as! EthSendDetailsViewController
            sendDetailsVC.presenter.transactionDTO = presenter.transactionDTO
        default:
            break
        }
    }
    
    
    func donate(idOfInApp: String) {
        unowned let weakSelf =  self
        self.presentDonationAlertVC(from: weakSelf, with: idOfInApp)
        stingIdForInApp = idOfInApp

    }
//    func donate() {
//        unowned let weakSelf =  self
//        self.presentDonationAlertVC(from: weakSelf)
//    }
    
    func cancelDonation() {
        self.makePurchaseFor(productId: stingIdForInApp)
    }
    
    func cancelAction() {
//        presentDonationVCorAlert()
        self.makePurchaseFor(productId: stingIdForInApp)
    }
    
    func donate50(idOfProduct: String) {
        self.makePurchaseFor(productId: idOfProduct)
    }
    
    func presentNoInternet() {
        
    }
    
    
    func fixUI() {
        if screenHeight == heightOfX {
            self.nextBtn.frame.origin = CGPoint(x: 0, y: 714)
        }
    }
    
    func setTextToTV(address: String) {
        addressTV.text = address
        addressTV.scrollRangeToVisible(NSMakeRange(addressTV.text.count - 1, 0))
        placeholderLabel.isHidden = true
    }
}

extension SendStartViewController:  UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfaddresses()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recentCell = self.tableView.dequeueReusableCell(withIdentifier: "recentCell") as! RecentAddressTableViewCell
        recentCell.fillingCell(recentAddress: presenter.recentAddresses[indexPath.row])
        return recentCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presenter.transactionDTO.update(from: presenter.recentAddresses[indexPath.row].address)
        self.setTextToTV(address: presenter.recentAddresses[indexPath.row].address)
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.modifyNextButtonMode()

    }
    
    func updateUI() {
        self.tableView.reloadData()
        noAddressLbl.isHidden = !self.presenter.recentAddresses.isEmpty
    }
    
    func ipadFix() {
        if screenHeight == heightOfiPad {
            self.middleConstraint.constant = 80
        }
    }
    
    func checkTVisEmpty() -> Bool {
        return addressTV.text.isEmpty
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            self.presenter.sendAddress(address: textView.text!)
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            placeholderLabel.isHidden = !placeholderLabel.isHidden
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
