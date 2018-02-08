//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import ZFRippleButton

class SendStartViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextBtn: ZFRippleButton!
    @IBOutlet weak var middleConstraint: NSLayoutConstraint!
    
    let presenter = SendStartPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.sendStartVC = self
        self.registerCells()
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        (self.tabBarController as! CustomTabBarViewController).menuButton.isHidden = true
        self.hideKeyboardWhenTappedAround()
        self.nextBtn.backgroundColor = UIColor(red: 209/255, green: 209/255, blue: 214/255, alpha: 1.0)
        self.ipadFix()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.presenter.adressSendTo != "" {
            self.makeAvailableNextBtn()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let topCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? NewWalletTableViewCell
        topCell?.makeTopCorners()
    }
    
    func registerCells() {
        let searchAddressCell = UINib(nibName: "SearchAddressTableViewCell", bundle: nil)
        self.tableView.register(searchAddressCell, forCellReuseIdentifier: "searchAddressCell")
        
        let oneLabelCell = UINib(nibName: "NewWalletTableViewCell", bundle: nil)
        self.tableView.register(oneLabelCell, forCellReuseIdentifier: "oneLabelCell")
        
        let recentCell = UINib(nibName: "RecentAddressTableViewCell", bundle: nil)
        self.tableView.register(recentCell, forCellReuseIdentifier: "recentCell")
    }
    
    @IBAction func nextAction(_ sender: Any) {
        if self.presenter.choosenWallet == nil {
            self.performSegue(withIdentifier: "chooseWalletVC", sender: sender)
        } else {
            self.performSegue(withIdentifier: "transactionDetail", sender: sender)
        }
    }
    
    func makeAvailableNextBtn() {
        self.nextBtn.isEnabled = true
        self.nextBtn.applyGradient(withColours: [UIColor(ciColor: CIColor(red: 0/255, green: 178/255, blue: 255/255)),
                                                 UIColor(ciColor: CIColor(red: 0/255, green: 122/255, blue: 255/255))],
                                   gradientOrientation: .horizontal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "chooseWalletVC"?:
            let chooseWalletVC = segue.destination as! WalletChoooseViewController
            chooseWalletVC.presenter.addressToStr = self.presenter.adressSendTo
            chooseWalletVC.presenter.amountFromQr = self.presenter.amountInCrypto
        case "qrCamera"?:
            let qrScanerVC = segue.destination as! QrScannerViewController
            qrScanerVC.qrDelegate = self.presenter
        case "transactionDetail"?:
            let sendDetailsVC = segue.destination as! SendDetailsViewController
            sendDetailsVC.presenter.choosenWallet = self.presenter.choosenWallet
            sendDetailsVC.presenter.addressToStr = self.presenter.adressSendTo
        default: break
        }
    }
    
}

extension SendStartViewController:  UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath == [0, 0] {
            let searchAddressCell = self.tableView.dequeueReusableCell(withIdentifier: "searchAddressCell") as! SearchAddressTableViewCell
            if self.presenter.adressSendTo != "" {
                searchAddressCell.updateWithAddress(address: self.presenter.adressSendTo)
            }
            searchAddressCell.cancelDelegate = self.presenter
            searchAddressCell.sendAddressDelegate = self.presenter
            searchAddressCell.goToQrDelegate = self.presenter
            return searchAddressCell
        } else if indexPath == [0, 1] {
            let oneLabelCell = self.tableView.dequeueReusableCell(withIdentifier: "oneLabelCell") as! NewWalletTableViewCell
            oneLabelCell.setupForSendStartVC()
            return oneLabelCell
        } else {
            let recentCell = self.tableView.dequeueReusableCell(withIdentifier: "recentCell") as! RecentAddressTableViewCell
            return recentCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == [0, 0] {
            return 305
        } else { //if indexPath == [0, 1] {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 1 {
            let searchCell = self.tableView.cellForRow(at: [0,0]) as! SearchAddressTableViewCell
            let selectedCell = self.tableView.cellForRow(at: indexPath) as! RecentAddressTableViewCell
            searchCell.addressTF.text = selectedCell.addressLbl.text
            searchCell.addressInTfLlb.text = selectedCell.addressLbl.text
            self.presenter.adressSendTo = selectedCell.addressLbl.text!
            self.tableView.deselectRow(at: indexPath, animated: true)
            self.makeAvailableNextBtn()
        }
    }
    
    func updateUI() {
        self.tableView.reloadData()
    }
    
    func ipadFix() {
        if screenHeight == 480 {
            self.middleConstraint.constant = 80
        }
    }
}
