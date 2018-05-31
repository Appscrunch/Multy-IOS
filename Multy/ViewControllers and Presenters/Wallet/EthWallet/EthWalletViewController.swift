//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class EthWalletViewController: UIViewController, AnalyticsProtocol, CancelProtocol {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var backView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    
    @IBOutlet weak var emptySecondLbl: UILabel!
    @IBOutlet weak var emptyArrowImg: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var backupView : UIView?
    
    
    @IBOutlet weak var bottomTableConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var customHeader: UIView!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var spiner: UIActivityIndicatorView!
    
    var presenter = EthWalletPresenter()
    
    var isBackupOnScreen = true
//    let progressHUD = ProgressHUD(text: "Updating...")
    let loader = PreloaderView(frame: HUDFrame, text: Constants.AssetsScreen.progressString, image: #imageLiteral(resourceName: "walletHuge"))
    
    let visibleCells = 5  // iphone 6  height 667
    let gradientLayer = CAGradientLayer()
    
    var isSocketInitiateUpdating = false
    
    var lastY: CGFloat = 0.0
    
    var recog: UIPanGestureRecognizer?
    var startY: CGFloat = 0.0
    var startHeight: CGFloat = 0.0
    var lastContentOffset: CGFloat = 0
    
    var headerTopY: CGFloat = 0.0
    var backupTopY: CGFloat = 0.0
    var tableTopY: CGFloat = 0.0
    var collectionStartY: CGFloat = 0.0

    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.blue
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spiner.stopAnimating()
        self.view.addSubview(loader)
        self.swipeToBack()
        presenter.mainVC = self
        presenter.fixConstraints()
        presenter.registerCells()

        NotificationCenter.default.addObserver(self, selector: #selector(self.updateExchange), name: NSNotification.Name("exchageUpdated"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateWalletAfterSockets), name: NSNotification.Name("transactionUpdated"), object: nil)
        setupUI()
        sendAnalyticsEvent(screenName: "\(screenWalletWithChain)\(presenter.wallet!.chain)", eventName: "\(screenWalletWithChain)\(presenter.wallet!.chain)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        (self.tabBarController as! CustomTabBarViewController).menuButton.isHidden = true
        (self.tabBarController as! CustomTabBarViewController).changeViewVisibility(isHidden: true)
        self.titleLbl.text = self.presenter.wallet?.name
        self.backUpView(height: 272)
        self.presenter.getHistoryAndWallet()
        self.fixForX()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        
        super.viewDidDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        if #available(iOS 11.0, *) {
//
//        } else {
//            self.tableView.applyGradient(withColours: [UIColor(ciColor: CIColor(red: 0/255, green: 178/255, blue: 255/255)),
//                                                       UIColor(ciColor: CIColor(red: 0/255, green: 122/255, blue: 255/255))],
//                                         gradientOrientation: .topRightBottomLeft)
//        }
        fixForX()
        self.startHeight = self.tableView.frame.size.height
        self.collectionStartY = self.collectionView.frame.origin.y
        self.customHeader.roundCorners(corners: [.topRight, .topLeft], radius: 20)
    }
    
    
    func setupUI() {
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(changeTableY))
        let gestureRecognizer2 = UIPanGestureRecognizer(target: self, action: #selector(changeTableY))
        self.tableView.addGestureRecognizer(gestureRecognizer)
        self.customHeader.addGestureRecognizer(gestureRecognizer2)
        self.recog = gestureRecognizer
        
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(setTableToBot))
        self.backImage.addGestureRecognizer(tap)
        self.backImage.isUserInteractionEnabled = true
        self.customHeader.isUserInteractionEnabled = true
        
        self.tableView.isScrollEnabled = false
        self.tableView.bounces = true
        self.collectionView.backgroundColor = .clear
        self.tableView.backgroundColor = .white
        makeConstantsForAnimation()
    }
    
    @objc func setTableToBot(duration: Double) {
        UIView.animate(withDuration: duration) {
            self.customHeader.frame.origin.y = self.startY - 30
            self.backupView?.frame.origin.y = self.startY - 50
            self.tableView.frame.origin.y = self.startY
            self.tableView.frame.size.height = self.startHeight
            self.tableView.scrollToTop()
            self.tableView.isScrollEnabled = false
            self.collectionView.frame.origin.y = self.collectionStartY
            self.checkrecogOnTable()
        }
    }
    
    @objc func setTableToTop() {
        UIView.animate(withDuration: 0.1) {
            self.customHeader.frame.origin.y = self.headerTopY
            self.backupView?.frame.origin.y = self.backupTopY
            self.tableView.frame.size.height = self.view.frame.height - self.headerTopY - self.bottomView.frame.height - 30
            self.tableView.frame.origin.y = self.tableTopY
            self.tableView.isScrollEnabled = true
        }
    }
    
    func makeConstantsForAnimation() {
        switch screenHeight {
        case heightOfX:
            headerTopY = 100
            backupTopY = 80
            tableTopY = 130
        default:
            headerTopY = 80
            backupTopY = 70
            tableTopY = 110
        }
        if presenter.isTherePendingAmount && self.customHeader.frame.origin.y != self.headerTopY  {
            UIView.animate(withDuration: 0.2) {
                self.backImage.frame.size.height = 392
                self.collectionView.frame.size.height = 305
                self.collectionView.frame.origin.y = self.collectionStartY
                self.customHeader.frame.origin.y = 372
                self.tableView.frame.origin.y = 402
                self.tableView.frame.size.height = screenHeight - self.tableView.frame.origin.y - self.bottomView.frame.height
                self.changeBackupY()
            }
        }
        self.fixForX()
        self.startY = self.backImage.frame.height - 50
        self.startHeight = self.tableView.frame.size.height
    }
    
    func changeBackupY() {
        if self.backupView != nil {
            self.backupView?.frame.origin.y = self.customHeader.frame.origin.y - 10
        }
    }
    
    func checkrecogOnTable() {
        if !self.tableView.gestureRecognizers!.contains(recog!) {
            self.tableView.addGestureRecognizer(recog!)
        }
    }
    
    @objc func updateWalletAfterSockets() {
        if isSocketInitiateUpdating {
            return
        }
        
        if !isVisible() {
            return
        }
        
        isSocketInitiateUpdating = true
        
        presenter.getHistoryAndWallet()
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.tableView.isUserInteractionEnabled = false
        self.presenter.getHistoryAndWallet()
        sendAnalyticsEvent(screenName: "\(screenWalletWithChain)\(presenter.wallet!.chain)", eventName: "\(pullWalletWithChain)\(presenter.wallet?.chain)")
    }
    
    @objc func updateExchange() {
        let firstCell = self.tableView.cellForRow(at: [0,0]) as? BTCWalletHeaderTableViewCell
        firstCell?.updateUI()
    }
    
    func updateHistory() {
        if presenter.historyArray.count > 0 {
            hideEmptyLbls()
        }
        
        for cell in self.tableView.visibleCells {
            if cell.isKind(of: TransactionWalletCell.self) {
                if let indexPath = self.tableView.indexPath(for: cell) {
                    (cell as! TransactionWalletCell).changeState(isEmpty: indexPath.row > presenter.numberOfTransactions()) // since we begin transactions from index 1
                    (cell as! TransactionWalletCell).fillCell()
                } else {
                    //How is that possible?
                }
            } else if cell.isKind(of: TransactionPendingCell.self) {
                (cell as! TransactionPendingCell).fillCell()
            }
        }
    }
    
    func backUpView(height: CGFloat) {
        if self.isBackupOnScreen == false {
            if backupView != nil && backupView!.frame.origin.y + 20 != height {
                backupView!.frame = CGRect(x: 16, y: startY - 50, width: screenWidth - 32, height: 40)
            }
            return
        }
        backupView = UIView()
        backupView!.frame = CGRect(x: 16, y: startY - 50, width: screenWidth - 32, height: 40)
        backupView!.layer.cornerRadius = 20
        backupView!.backgroundColor = .white
        
        backupView!.layer.shadowColor = UIColor.gray.cgColor
        backupView!.layer.shadowOpacity = 1
        backupView!.layer.shadowOffset = .zero
        backupView!.layer.shadowRadius = 10
        
        if self.presenter.account?.seedPhrase != nil && self.presenter.account?.seedPhrase != "" {
            backupView!.isHidden = false
        } else {
            backupView!.isHidden = true
        }
        
        if self.view.subviews.contains(backupView!) {
            return
        }
        
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "warninngBig")
        image.frame = CGRect(x: 13, y: 11, width: 22, height: 22)
        
        let btn = UIButton()
        btn.frame = CGRect(x: 50, y: 0, width: backupView!.frame.width - 35, height: backupView!.frame.height)
        btn.setTitle("Backup is needed!", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.titleLabel?.font = UIFont(name: "Avenir-Next", size: 6)
        btn.contentHorizontalAlignment = .left
        btn.addTarget(self, action: #selector(goToSeed), for: .touchUpInside)
        
        let chevron = UIImageView()
        chevron.image = #imageLiteral(resourceName: "chevronRed")
        chevron.frame = CGRect(x: backupView!.frame.width - 35, y: 15, width: 11, height: 11)
        
        backupView!.addSubview(chevron)
        backupView!.addSubview(btn)
        backupView!.addSubview(image)
        self.view.addSubview(backupView!)
        self.isBackupOnScreen = false
    }
    
    @objc func goToSeed() {
        let stroryboard = UIStoryboard(name: "SeedPhrase", bundle: nil)
        let vc = stroryboard.instantiateViewController(withIdentifier: "seedAbout")
        self.navigationController?.pushViewController(vc, animated: true)
        sendAnalyticsEvent(screenName: "\(screenWalletWithChain)\(presenter.wallet!.chain)", eventName: backupSeedTap)
    }
    
    @IBAction func closeAction() {
        sendAnalyticsEvent(screenName: "\(screenWalletWithChain)\(presenter.wallet!.chain)", eventName: closeTap)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func settingssAction(_ sender: Any) {
        sendAnalyticsEvent(screenName: "\(screenWalletWithChain)\(presenter.wallet!.chain)", eventName: "\(settingsWithChainTap)\(presenter.wallet!.chain)")
        self.performSegue(withIdentifier: "settingsVC", sender: sender)
    }
    
    
    func fixUiWithPendingTransactions() {
        let numberOfPending = presenter.getNumberOfPendingTransactions()
        let numberOfTransactions = presenter.numberOfTransactions()
        if screenHeight == heightOfPlus && numberOfTransactions < 5 {
            if numberOfPending > 2 {
//                self.tableView.isScrollEnabled = true
            }
        } else if screenHeight == heightOfStandard && numberOfTransactions < 5 {
            if numberOfPending > 1 {
//                self.tableView.isScrollEnabled = true
            }
        }
    }
    
    @IBAction func sendAction(_ sender: Any) {
        if presenter.isThereAvailableAmount == false {
            self.presentAlert(with: "You have no available funds")
            
            return
        }
        
        let storyboard = UIStoryboard(name: "Send", bundle: nil)
        let sendStartVC = storyboard.instantiateViewController(withIdentifier: "sendStart") as! SendStartViewController
        sendStartVC.presenter.transactionDTO.choosenWallet = self.presenter.wallet
        sendStartVC.presenter.isFromWallet = true
        self.navigationController?.pushViewController(sendStartVC, animated: true)
        sendAnalyticsEvent(screenName: "\(screenWalletWithChain)\(presenter.wallet!.chain)", eventName: "\(sendWithChainTap)\(presenter.wallet!.chain)")
    }
    
    @IBAction func receiveAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Receive", bundle: nil)
        let receiveDetailsVC = storyboard.instantiateViewController(withIdentifier: "receiveDetails") as! ReceiveAllDetailsViewController
        receiveDetailsVC.presenter.wallet = self.presenter.wallet
        self.navigationController?.pushViewController(receiveDetailsVC, animated: true)
        sendAnalyticsEvent(screenName: "\(screenWalletWithChain)\(presenter.wallet!.chain)", eventName: "\(receiveWithChainTap)\(presenter.wallet!.chain)")
    }
    
    @IBAction func exchangeAction(_ sender: Any) {
        unowned let weakSelf =  self
        self.presentDonationAlertVC(from: weakSelf, with: "io.multy.addingExchange50")
        //        sendAnalyticsEvent(screenName: "\(screenWalletWithChain)\(presenter.wallet!.chain)", eventName: "\(exchangeWithChainTap)\(presenter.wallet!.chain)")
        logAnalytics()
    }
    
    func logAnalytics() {
        sendDonationAlertScreenPresentedAnalytics(code: donationForExchangeFUNC)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "transactionVC" {
            //            let transactionVC = segue.destination as! TransactionViewController
        } else if segue.identifier == "settingsVC" {
            let settingsVC = segue.destination as! WalletSettingsViewController
            settingsVC.presenter.wallet = self.presenter.wallet
        }
    }
    
    func cancelAction() {
//        presentDonationVCorAlert()
        
    }
    
    func presentNoInternet() {
        
    }
    
    func hideEmptyLbls() {
        self.emptySecondLbl.isHidden = true
        self.emptyArrowImg.isHidden = true
    }
    
    func fixForiPad() {
        if screenHeight == heightOfiPad {
            hideEmptyLbls()
        }
    }
    
    func fixForX() {
        if screenHeight == heightOfX {
            self.bottomView.frame.size.height = 83
//            self.heightOfBottomBar.constant = 83
            self.bottomConstraint.constant = 30
        }
    }
    
    func fixForPlus() {
        if screenHeight == heightOfPlus {
            self.bottomTableConstraint.constant = -50
        }
    }
    
    func updateUI() {
        self.tableView.reloadData()
        self.collectionView.reloadData()
    }
    
}

extension EthWalletViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //check number of transactions
        // else return some empty cells
        let countOfHistObjects = self.presenter.numberOfTransactions()
        if countOfHistObjects > 0 {
            self.tableView.isScrollEnabled = true
            if countOfHistObjects < 10 {
                return 10
            } else {
                return countOfHistObjects
            }
        } else {
            if screenHeight == heightOfX {
                return 13
            }
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let countOfHistObjs = self.presenter.numberOfTransactions()
        
        if indexPath.row < countOfHistObjs && presenter.isTherePendingMoney(for: indexPath) {
            let pendingTrasactionCell = tableView.dequeueReusableCell(withIdentifier: "TransactionPendingCellID") as! TransactionPendingCell
            pendingTrasactionCell.selectionStyle = .none
            pendingTrasactionCell.histObj = presenter.historyArray[indexPath.row]
            pendingTrasactionCell.wallet = presenter.wallet
            pendingTrasactionCell.fillCell()
            
            return pendingTrasactionCell
        } else {
            let transactionCell = self.tableView.dequeueReusableCell(withIdentifier: "TransactionWalletCellID") as! TransactionWalletCell
            transactionCell.selectionStyle = .none
            if countOfHistObjs > 0 {
                if indexPath.row >= countOfHistObjs {
                    transactionCell.changeState(isEmpty: true)
                } else {
                    transactionCell.histObj = presenter.historyArray[indexPath.row]
                    transactionCell.wallet = presenter.wallet!
                    transactionCell.fillCell()
                    transactionCell.changeState(isEmpty: false)
                    self.hideEmptyLbls()
                    if indexPath.row != 1 {
                        transactionCell.changeTopConstraint()
                    }
                }
            } else {
                transactionCell.changeState(isEmpty: true)
                fixForiPad()
            }
            
            return transactionCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.presenter.numberOfTransactions() == 0 {
            return
        }
        let countOfHistObjs = self.presenter.numberOfTransactions()
        if indexPath.row >= countOfHistObjs && countOfHistObjs <= visibleCells {
            return
        }
        
        let storyBoard = UIStoryboard(name: "Wallet", bundle: nil)
        let transactionVC = storyBoard.instantiateViewController(withIdentifier: "transaction") as! TransactionViewController
        transactionVC.presenter.histObj = presenter.historyArray[indexPath.row]
        transactionVC.presenter.blockchainType = BlockchainType.create(wallet: presenter.wallet!)
        transactionVC.presenter.wallet = presenter.wallet!
        self.navigationController?.pushViewController(transactionVC, animated: true)
        sendAnalyticsEvent(screenName: "\(screenWalletWithChain)\(presenter.wallet!.chain)", eventName: "\(transactionWithChainTap)\(presenter.wallet!.chain)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < presenter.numberOfTransactions() && presenter.isTherePendingMoney(for: indexPath) { // <= since we begins from 1
            return 135
        } else {
            return 70
        }
    }
    
    @IBAction func changeTableY(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: self.view)
        if self.customHeader.frame.origin.y + translation.y < 100 {
            if self.customHeader.frame.origin.y + translation.y > 80 {
                
            } else {
                self.setTableToTop()
                //                print("table on top")
                if self.presenter.numberOfTransactions() > 5 {
                    self.tableView.removeGestureRecognizer(recog!)
                } else {
                    return
                }
            }
        }
        
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            if translation.y > 0 && self.tableView.frame.origin.y > self.startY {
                UIView.animate(withDuration: 0.2, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: .curveEaseIn, animations: {
                    let transY = translation.y > 200 ? translation.y : translation.y/2
                    self.tableView.frame.size.height = self.tableView.frame.size.height - transY
                    self.tableView.center = CGPoint(x: self.view.center.x, y: self.tableView.center.y + transY)
                    gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
                    self.backupView?.frame.origin.y = self.tableView.frame.origin.y - 50
                    self.customHeader.frame.origin.y = self.tableView.frame.origin.y - 30
                    if self.tableView.frame.origin.y > self.startY + 50 {
                        self.collectionView.frame.origin.y = self.customHeader.frame.origin.y - self.collectionView.frame.height
                        if self.tableView.frame.origin.y > (self.startY + self.tableTopY) / 2 {
                            if self.tableView.frame.origin.y > screenHeight/2 + 50 {
                                self.updateByPull()
                            }
                        }
                    }
                    
                }) { (bool) in
                    
                }
            } else {
                tableView.frame.size.height = tableView.frame.size.height - translation.y
                tableView.center = CGPoint(x: self.view.center.x, y: self.tableView.center.y + translation.y)
                gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
                self.backupView?.frame.origin.y = self.tableView.frame.origin.y - 50
                self.customHeader.frame.origin.y = self.tableView.frame.origin.y - 30
            }
        }
        
        //auto animation for go to top or bottom
        if gestureRecognizer.state == .ended {
            if self.tableView.frame.origin.y > (startY + tableTopY) / 2 {
                self.setTableToBot(duration: 0.5)
            } else {
                self.setTableToTop()
            }
        }
    }
    
    func updateByPull() {
        spiner.startAnimating()
        presenter.getHistoryAndWallet()
        tableView.removeGestureRecognizer(recog!)
    }
}

extension EthWalletViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= -120 {
            setTableToBot(duration: 0.2)
            tableView.scrollToRow(at: [0,0], at: .top, animated: false)
        }
    }
}

extension EthWalletViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: screenWidth, height: presenter.topCellHeight - Constants.ETHWalletScreen.collectionCellDifference)
        
        return CGSize(width: screenWidth, height: presenter.isTherePendingAmount == false ? 140 : 190)
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

extension EthWalletViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        return (self.wallet?.addresses.count)!
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "MainWalletCollectionViewCellID", for: indexPath) as! EthWalletHeaderCollectionViewCell
        cell.wallet = self.presenter.wallet
//        cell.blockedAmount = self.presenter.blockedAmount
        cell.mainVC = self
        cell.fillInCell()
        
        return cell
    }
    
}
