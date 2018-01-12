//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class WalletViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var backView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var emptyFirstLbl: UILabel!
    @IBOutlet weak var emptySecondLbl: UILabel!
    @IBOutlet weak var emptyArrowImg: UIImageView!
    
    var presenter = WalletPresenter()
    var even = true
    
    var isBackupOnScreen = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.mainVC = self
        
        presenter.fixConstraints()
        presenter.registerCells()
        
//        DataManager.shared.getOneWalletVerbose(presenter.account!.token,
//                                               walletID: presenter.wallet!.walletID) { (dict, error) in
//            print("\n\nok\n\n")
//        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateExchange), name: NSNotification.Name("exchageUpdated"), object: nil)
        (self.tabBarController as! CustomTabBarViewController).changeViewVisibility(isHidden: true)
        self.presenter.getHistory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        (self.tabBarController as! CustomTabBarViewController).menuButton.isHidden = true
        (self.tabBarController as! CustomTabBarViewController).changeViewVisibility(isHidden: true)
        self.titleLbl.text = self.presenter.wallet?.name
        self.backUpView()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func updateExchange() {
//        let offsetBeforeUpdate = self.tableView.contentOffset
//        self.tableView.reloadData()
//        self.tableView.setContentOffset(offsetBeforeUpdate, animated: false)
        
        let firstCell = self.tableView.cellForRow(at: [0,0]) as! MainWalletHeaderCell
        firstCell.updateUI()
        self.tableView.reloadData()
    }
    
    func backUpView() {
        if self.isBackupOnScreen == false {
            return
        }
        let view = UIView()
        view.frame = CGRect(x: 16, y: (300 * (screenWidth / 375.0)) - 20, width: screenWidth - 32, height: 40)
        view.layer.cornerRadius = 20
        view.backgroundColor = .white
        
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
        
        if self.presenter.account?.seedPhrase != nil && self.presenter.account?.seedPhrase != "" {
            view.isHidden = false
        } else {
            view.isHidden = true
        }
        
        if self.view.subviews.contains(view) {
            return
        }
        
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "warninngBig")
        image.frame = CGRect(x: 13, y: 11, width: 22, height: 22)
        
        let btn = UIButton()
        btn.frame = CGRect(x: 50, y: 0, width: view.frame.width - 35, height: view.frame.height)
        btn.setTitle("Backup is not executed", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.titleLabel?.font = UIFont(name: "Avenir-Next", size: 6)
        btn.contentHorizontalAlignment = .left
        btn.addTarget(self, action: #selector(goToSeed), for: .touchUpInside)
        
        let chevron = UIImageView()
        chevron.image = #imageLiteral(resourceName: "chevronRed")
        chevron.frame = CGRect(x: view.frame.width - 35, y: 15, width: 11, height: 11)
        
        view.addSubview(chevron)
        view.addSubview(btn)
        view.addSubview(image)
        self.tableView.addSubview(view)
        self.isBackupOnScreen = false
    }
    
    @objc func goToSeed() {
        let stroryboard = UIStoryboard(name: "SeedPhrase", bundle: nil)
        let vc = stroryboard.instantiateViewController(withIdentifier: "seedAbout")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func closeAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func settingssAction(_ sender: Any) {
        self.performSegue(withIdentifier: "settingsVC", sender: sender)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 11.0, *) {
            
        } else {
            self.tableView.applyGradient(withColours: [UIColor(ciColor: CIColor(red: 0/255, green: 178/255, blue: 255/255)),
                                                       UIColor(ciColor: CIColor(red: 0/255, green: 122/255, blue: 255/255))],
                                         gradientOrientation: .topRightBottomLeft)
        }
        
        self.backView.applyGradient(withColours: [UIColor(ciColor: CIColor(red: 0/255, green: 178/255, blue: 255/255)),
                                                  UIColor(ciColor: CIColor(red: 0/255, green: 122/255, blue: 255/255))],
                                    gradientOrientation: .topRightBottomLeft)
        
        let headerCell = tableView.cellForRow(at:IndexPath(row: 0, section: 0)) as! MainWalletHeaderCell
        
        headerCell.backView.applyGradient(withColours: [UIColor(ciColor: CIColor(red: 0/255, green: 178/255, blue: 255/255)),
                                                        UIColor(ciColor: CIColor(red: 0/255, green: 122/255, blue: 255/255))],
                                          gradientOrientation: .topRightBottomLeft)
        
//        headerCell.podlojkaView.applyGradient(withColours: [UIColor(ciColor: CIColor(red: 0/255, green: 178/255, blue: 255/255)),
//                                                            UIColor(ciColor: CIColor(red: 0/255, green: 122/255, blue: 255/255))],
//                                              gradientOrientation: .topRightBottomLeft)
    }
    
    @IBAction func sendAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Send", bundle: nil)
        let sendStartVC = storyboard.instantiateViewController(withIdentifier: "sendStart") as! SendStartViewController
        sendStartVC.presenter.choosenWallet = self.presenter.wallet
        sendStartVC.presenter.isFromWallet = true
        self.navigationController?.pushViewController(sendStartVC, animated: true)
    }
    
    @IBAction func receiveAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Receive", bundle: nil)
        let receiveDetailsVC = storyboard.instantiateViewController(withIdentifier: "receiveDetails") as! ReceiveAllDetailsViewController
        receiveDetailsVC.presenter.wallet = self.presenter.wallet
        self.navigationController?.pushViewController(receiveDetailsVC, animated: true)
    }
    
    @IBAction func exchangeAction(_ sender: Any) {
    }
    
}

extension WalletViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //check number of transactions
        // else retunrn some empty cells
        if self.presenter.numberOfTransactions() > 0 {
            self.tableView.isScrollEnabled = true
            return self.presenter.numberOfTransactions() + 1
        } else {
            self.tableView.isScrollEnabled = false
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath == [0, 0] {         // Main Wallet Header Cell
            let headerCell = self.tableView.dequeueReusableCell(withIdentifier: "MainWalletHeaderCellID") as! MainWalletHeaderCell
            headerCell.selectionStyle = .none
            headerCell.mainVC = self
            headerCell.delegate = self
            headerCell.wallet = self.presenter.wallet
            headerCell.blockedAmount = self.presenter.blockedAmount
            
            return headerCell
        } else {                           //  Wallet Cellx
            let walletCell = self.tableView.dequeueReusableCell(withIdentifier: "TransactionWalletCellID") as! TransactionWalletCell
            walletCell.selectionStyle = .none
            if self.presenter.numberOfTransactions() > 0 {
                walletCell.histObj = self.presenter.historyArray[indexPath.row - 1]
                walletCell.fillCell()
                walletCell.changeState(isEmpty: false)
                self.hideEmptyLbls()
                if indexPath.row != 1 {
                    walletCell.changeTopConstraint()
                }
            } else {
                walletCell.changeState(isEmpty: true)
            }
            
            if indexPath == [0,1] {
                walletCell.setCorners()
//                walletCell.backgroundView?.backgroundColor = .red
//                walletCell.backgroundView?.applyGradient(withColours: [UIColor(ciColor: CIColor(red: 0/255, green: 178/255, blue: 255/255)),
//                                                                      UIColor(ciColor: CIColor(red: 0/255, green: 122/255, blue: 255/255))],
//                                                        gradientOrientation: .topRightBottomLeft)
            }
            
            return walletCell
        }
    }
    
    func hideEmptyLbls() {
        self.emptyFirstLbl.isHidden = true
        self.emptySecondLbl.isHidden = true
        self.emptyArrowImg.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if self.presenter.numberOfTransactions() == 0 {
//            return
//        }
//
//        if indexPath.row % 2 == 0 {
//            self.even = true
//        } else {
//            self.even = false
//        }
//        self.performSegue(withIdentifier: "transactionVC", sender: Any.self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let heightForFirstCell : CGFloat = presenter.blockedAmount == 0 ? 310.0 : 310.0

        if indexPath == [0,0] {
            return heightForFirstCell * (screenWidth / 375.0)
        } else { //if indexPath == [0,1] || self.presenter.numberOfTransactions() > 0 {
            return 70
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath == [0, 1] {
            (cell as! TransactionWalletCell).setCorners()
        }
    }
    
    func updateUI() {
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "transactionVC" {
            let vc = segue.destination as! TransactionViewController
            vc.isForReceive = self.even
        } else if segue.identifier == "settingsVC" {
            let settingsVC = segue.destination as! WalletSettingsViewController
            settingsVC.presenter.wallet = self.presenter.wallet
        }
    }
}

extension WalletViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let heightForFirstCell : CGFloat = presenter.blockedAmount == 0 ? 210.0 : 250.0
        
        return CGSize(width: screenWidth, height: heightForFirstCell * (screenWidth / 375.0))
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
