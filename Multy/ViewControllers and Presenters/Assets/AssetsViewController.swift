//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import RealmSwift

class AssetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    
    let presenter = AssetsPresenter()
    let progressHUD = ProgressHUD(text: "Getting Wallets...")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.presenter.assetsVC = self
        
        self.presenter.tabBarFrame = self.tabBarController?.tabBar.frame
        self.checkOSForConstraints()
        self.registerCells()
        
        self.view.addSubview(progressHUD)
        progressHUD.hide()
        
        //MAKE: first launch
//        let _ = DataManager.shared
        
        //MARK: test
        presenter.auth()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.presenter.isJailed {
            self.presentWarningAlert(message: "Your Device is Jailbroken!\nSory, but we don`t support jailbroken devices.")
        }
    }
    
    //////////////////////////////////////////////////////////////////////
    //test
    
    func fetchAssets() {
        guard presenter.account?.token != nil else {
            return
        }
        
        DataManager.shared.apiManager.getAssets(presenter.account!.token, completion: { (assetsDict, error) in
            print(assetsDict)
        })
    }
    
    func fetchTickets() {
        DataManager.shared.apiManager.getTickets(presenter.account!.token, direction: "") { (dict, error) in
            guard dict != nil  else {
                return
            }
            
            print(dict!)
        }
    }
    
    func getExchange() {
//        DataManager.shared.apiManager.getExchangePrice(presenter.account!.token, direction: "") { (dict, error) in
//            guard dict != nil  else {
//                return
//            }
//            if dict!["USD"] != nil {
//                exchangeCourse = dict!["USD"] as! Double
//            }
//        }
    }
    
    func getTransInfo() {
        DataManager.shared.apiManager.getTransactionInfo(presenter.account!.token,
                                                         transactionString: "d83a5591585f05dc367d5e68579ece93240a6b4646133a38106249cadea53b77") { (transDict, error) in
                                                            guard transDict != nil else {
                                                                return
                                                            }
                                                            
                                                            print(transDict)
        }
    }
    //////////////////////////////////////////////////////////////////////
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.frame = self.presenter.tabBarFrame!
        (self.tabBarController as! CustomTabBarViewController).menuButton.isHidden = false
        
        if presenter.account != nil {
            presenter.fetchAssets()
        }
    }
    
    //MARK: Setup functions
    
    func checkOSForConstraints() {
        if #available(iOS 11.0, *) {
            //OK: Storyboard was made for iOS 11
        } else {
            self.tableViewTopConstraint.constant = 0
        }
    }
    
    func registerCells() {
        let walletCell = UINib.init(nibName: "WalletTableViewCell", bundle: nil)
        self.tableView.register(walletCell, forCellReuseIdentifier: "walletCell")
        
        let portfolioCell = UINib.init(nibName: "PortfolioTableViewCell", bundle: nil)
        self.tableView.register(portfolioCell, forCellReuseIdentifier: "portfolioCell")
        
        let newWalletCell = UINib.init(nibName: "NewWalletTableViewCell", bundle: nil)
        self.tableView.register(newWalletCell, forCellReuseIdentifier: "newWalletCell")
        
        let textCell = UINib.init(nibName: "TextTableViewCell", bundle: nil)
        self.tableView.register(textCell, forCellReuseIdentifier: "textCell")
        
        let logoCell = UINib.init(nibName: "LogoTableViewCell", bundle: nil)
        self.tableView.register(logoCell, forCellReuseIdentifier: "logoCell")
        
        let createOrRestoreCell = UINib.init(nibName: "CreateOrRestoreBtnTableViewCell", bundle: nil)
        self.tableView.register(createOrRestoreCell, forCellReuseIdentifier: "createOrRestoreCell")
    }

    //MARK: Table view delegates
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if presenter.isWalletExist() {
            return 2 + presenter.account!.wallets.count
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath == [0, 0] {                                        // PORTFOLIO CELL  or LOGO
//            let portfolioCell = self.tableView.dequeueReusableCell(withIdentifier: "portfolioCell") as! PortfolioTableViewCell
//            return portfolioCell
            let logoCell = self.tableView.dequeueReusableCell(withIdentifier: "logoCell") as! LogoTableViewCell
            return logoCell
        } else if indexPath == [0, 1] {                                 // !!!NEW!!! WALLET CELL
            let newWalletCell = self.tableView.dequeueReusableCell(withIdentifier: "newWalletCell") as! NewWalletTableViewCell
            
            return newWalletCell
        } else if indexPath == [0, 2] && !presenter.isWalletExist() {   // Text cell
            let textCell = self.tableView.dequeueReusableCell(withIdentifier: "textCell") as! TextTableViewCell
            
            return textCell
        } else {                                                        // Wallet Cell
            let walletCell = self.tableView.dequeueReusableCell(withIdentifier: "walletCell") as! WalletTableViewCell
            walletCell.makeshadow()
            walletCell.wallet = presenter.account?.wallets[indexPath.row - 2]
            walletCell.fillInCell()
            
            return walletCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //проверить авторизацию
        if indexPath == [0, 1] {
            // если  есть авторизация то indexPath = 0, 1
            let actionSheet = UIAlertController(title: "Create or import Wallet", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Create wallet", style: .default, handler: { (result : UIAlertAction) -> Void in
                self.performSegue(withIdentifier: "createWalletVC", sender: Any.self)
            }))
            actionSheet.addAction(UIAlertAction(title: "Import wallet", style: .default, handler: { (result: UIAlertAction) -> Void in
                //go to import wallet
                
            }))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(actionSheet, animated: true, completion: {
                //doint something
            })
        
//        } else if indexPath == [0, 2] {
//            let storyboard = UIStoryboard(name: "Receive", bundle: nil)
//            let initialViewController = storyboard.instantiateViewController(withIdentifier: "ReceiveStart")
//            self.navigationController?.pushViewController(initialViewController, animated: true)
//        } else {//if indexPath == [0, 3] {
//            let stroryboard = UIStoryboard(name: "SeedPhrase", bundle: nil)
//            let vc = stroryboard.instantiateViewController(withIdentifier: "seedAbout")
//            self.navigationController?.pushViewController(vc, animated: true)
//        } else if indexPath == [0, 4] {
            
        } else {
                        let stroryboard = UIStoryboard(name: "SeedPhrase", bundle: nil)
                        let vc = stroryboard.instantiateViewController(withIdentifier: "seedAbout")
                        self.navigationController?.pushViewController(vc, animated: true)
//            if self.presenter.isWalletExist() {
//                let storyboard = UIStoryboard(name: "Wallet", bundle: nil)
//                let initialViewController = storyboard.instantiateViewController(withIdentifier: "WalletMainID")
//                self.navigationController?.pushViewController(initialViewController, animated: true)
//            } 
//            let storyboard = UIStoryboard(name: "Send", bundle: nil)
//            let destVC = storyboard.instantiateViewController(withIdentifier: "sendStart")
//            self.navigationController?.pushViewController(destVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == [0,0] {
//            return 283  //portfolio height
            return 220 //logo height
        } else if indexPath == [0, 1] {
            return 75
        } else {
            return 104   // wallet height
//            return 100
        }
    }
    
    func updateUI() {
        self.tableView.reloadData()
    }
    
    func presentWarningAlert(message: String) {
        let alert = UIAlertController(title: "Warining", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
            DataManager.shared.clearDB(completion: { (err) in
                exit(0)
            })
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createWalletVC" {
            let createVC = segue.destination as! CreateWalletViewController
            createVC.presenter.account = presenter.account
        }
    }
}
