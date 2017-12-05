//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class AssetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    
    let presenter = AssetsPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.presenter.mainVC = self
        self.presenter.tabBarFrame = self.tabBarController?.tabBar.frame
        self.checkOSForConstraints()
        self.presenter.registerCells()
        
        let mnemoString = DataManager.shared.coreLibManager.createMnemonicPhraseArray().joined(separator: " ")
        print("mnemoString: \(mnemoString)")
        let rootID = DataManager.shared.coreLibManager.restoreSeed(from: mnemoString)
        print("rootID: \(rootID)")
        
        //MAKE: first launch
//        let _ = DataManager.shared
        
        
        //MARK: test
        DataManager.shared.auth { (account, error) in
            guard account != nil else {
                return
            }
            
            DispatchQueue.main.async {
                self.presenter.account = account
            }
        }
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.frame = self.presenter.tabBarFrame!
    }
    
    //MARK: Setup functions
    
    func checkOSForConstraints() {
        if #available(iOS 11.0, *) {
            //OK: Storyboard was made for iOS 11
        } else {
            self.tableViewTopConstraint.constant = 0
        }
    }

    //MARK: Table view delegates
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath == [0, 0] {         // PORTFOLIO CELL
            let portfolioCell = self.tableView.dequeueReusableCell(withIdentifier: "portfolioCell") as! PortfolioTableViewCell
            return portfolioCell
        } else if indexPath == [0, 1] {   // !!!NEW!!! WALLET CELL
            let newWalletCell = self.tableView.dequeueReusableCell(withIdentifier: "newWalletCell") as! NewWalletTableViewCell
            return newWalletCell
        } else {                           //  Wallet Cell
            let walletCell = self.tableView.dequeueReusableCell(withIdentifier: "walletCell") as! WalletTableViewCell
            walletCell.makeshadow()
            return walletCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == [0, 1] {
            presenter.openCreateWalletPopup()
        }  else if indexPath == [0, 2] {
            let storyboard = UIStoryboard(name: "Receive", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "ReceiveStart")
            self.navigationController?.pushViewController(initialViewController, animated: true)
        } else if indexPath == [0, 3] {
            let stroryboard = UIStoryboard(name: "SeedPhrase", bundle: nil)
            let vc = stroryboard.instantiateViewController(withIdentifier: "seedAbout")
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath == [0, 4] {
            let storyboard = UIStoryboard(name: "Wallet", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "WalletMainID")
            self.navigationController?.pushViewController(initialViewController, animated: true) 
        } else {
            let storyboard = UIStoryboard(name: "Send", bundle: nil)
            let destVC = storyboard.instantiateViewController(withIdentifier: "sendStart")
            self.navigationController?.pushViewController(destVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == [0,0] {
            return 283
        } else if indexPath == [0, 1] {
            return 75
        } else {
            return 104
        }
    }
    
}
