//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import RealmSwift

class AssetsPresenter: NSObject {

    var assetsVC: AssetsViewController?
    
    var tabBarFrame: CGRect?
    
    var isJailed = false
    var tappedIndexPath = IndexPath(row: 0, section: 0)
    
    var contentOffset = CGPoint.zero
    
    var account : AccountRLM? {
        didSet {
            backupActivity()
            
            if self.assetsVC!.isVisible() {
                (self.assetsVC!.tabBarController as! CustomTabBarViewController).changeViewVisibility(isHidden: account == nil)
            }
            
            wallets = account?.wallets.sorted(byKeyPath: "lastActivityTimestamp", ascending: false)
            
            self.assetsVC?.view.isUserInteractionEnabled = true
            if !assetsVC!.isSocketInitiateUpdating && self.assetsVC!.tabBarController!.viewControllers![0].childViewControllers.count == 1 {
                assetsVC?.tableView.reloadData()
            }
            
            if account != nil {
                assetsVC!.tableView.frame.size.height = screenHeight - assetsVC!.tabBarController!.tabBar.frame.height
            } else {
                assetsVC!.tableView.frame.size.height = screenHeight
            }
        }
    }
    
    var wallets: Results<UserWalletRLM>?
    
    func backupActivity() {
        if account != nil {
            self.assetsVC?.backupView?.isHidden = account!.isSeedPhraseSaved()
            self.assetsVC?.backupView?.isUserInteractionEnabled = !account!.isSeedPhraseSaved()
        }
    }
    
    func auth() {
        //MARK: need refactoring
        self.blockUI()
        DataManager.shared.getAccount { (acc, err) in
            self.unlockUI()
            if acc == nil {
                self.assetsVC?.progressHUD.show()
                DataManager.shared.auth(rootKey: nil) { (account, error) in
                    self.unlockUI()
                    guard account != nil else {
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self.account = account
                        
                        self.getWalletsVerbose(completion: {_ in })
                    }
                }
            } else {
                self.account = acc
                DataManager.shared.auth(rootKey: self.account?.backupSeedPhrase, completion: { (acc, err) in
                    if acc != nil {
                        self.account = acc
                        self.getWalletsVerbose(completion: {_ in})
//                        DataManager.shared.socketManager.start()
                    }
                })
            }
            DataManager.shared.socketManager.start()
            self.assetsVC?.progressHUD.hide()
        }
    }
    
    func guestAuth(completion: @escaping (_ answer: String) -> ()) {
        self.assetsVC?.view.isUserInteractionEnabled = false
        DataManager.shared.auth(rootKey: nil) { (account, error) in
            self.assetsVC?.view.isUserInteractionEnabled = true
            self.assetsVC?.progressHUD.hide()
            guard account != nil else {
                return
            }
            
            self.account = account
            
            DataManager.shared.socketManager.start()
            
            completion("ok")
        }
    }
    
    func updateWalletsInfo() {
        DataManager.shared.getAccount { (acc, err) in
            if acc != nil {
                self.blockUI()
                self.account = acc
                self.getWalletsVerbose(completion: { (_) in
                    self.unlockUI()
                })
            }
        }
    }
    
    func isWalletExist() -> Bool {
        return !(account == nil || wallets?.count == 0)
    }
    
    func registerCells() {
        let walletCell = UINib.init(nibName: "WalletTableViewCell", bundle: nil)
        self.assetsVC?.tableView.register(walletCell, forCellReuseIdentifier: "walletCell")
        
        let portfolioCell = UINib.init(nibName: "PortfolioTableViewCell", bundle: nil)
        self.assetsVC?.tableView.register(portfolioCell, forCellReuseIdentifier: "portfolioCell")
        
        let newWalletCell = UINib.init(nibName: "NewWalletTableViewCell", bundle: nil)
        self.assetsVC?.tableView.register(newWalletCell, forCellReuseIdentifier: "newWalletCell")
    }

    func getWalletsVerbose(completion: @escaping (_ flag: Bool) -> ()) {
        blockUI()
        DataManager.shared.getWalletsVerbose() { (walletsArrayFromApi, err) in
            self.unlockUI()
            if err != nil {
                return
            } else {
                let walletsArr = UserWalletRLM.initWithArray(walletsInfo: walletsArrayFromApi!)
                print("afterVerbose:rawdata: \(walletsArrayFromApi)")
                DataManager.shared.realmManager.updateWalletsInAcc(arrOfWallets: walletsArr, completion: { (acc, err) in
                    self.account = acc
                    print("wallets: \(acc?.wallets)")
                    completion(true)
                })
            }
        }
    }
    
    func getWalletVerboseForSockets(completion: @escaping (_ flag: Bool) -> ()) {
        if account == nil {
            return
        }
        DataManager.shared.getWalletsVerbose() { (walletsArrayFromApi, err) in
            if err != nil {
                return
            } else {
                let walletsArr = UserWalletRLM.initWithArray(walletsInfo: walletsArrayFromApi!)
                print("afterVerboseForSockets:rawdata: \(walletsArrayFromApi)")
                DataManager.shared.realmManager.updateWalletsInAcc(arrOfWallets: walletsArr, completion: { (acc, err) in
                    self.account = acc
                    print("wallets: \(acc?.wallets)")
                    completion(true)
                    DataManager.shared.getAccount(completion: { (acc, err) in
                        print("afterVerbose: \(acc!)")
                    })
                })
            }
        }
    }
    
    func getWalletViewController(indexPath: IndexPath) -> UIViewController {
        if wallets == nil {
            return UIViewController()
        }
        
        let wallet = wallets?[indexPath.row - 2]
        let storyboard = UIStoryboard(name: "Wallet", bundle: nil)
        assetsVC?.sendAnalyticsEvent(screenName: screenMain, eventName: "\(walletOpenWithChainTap)\(wallet!.chain)")
        
        switch wallet!.blockchainType.blockchain {
        case BLOCKCHAIN_BITCOIN:
            let vc = storyboard.instantiateViewController(withIdentifier: "WalletMainID") as! BTCWalletViewController
            vc.presenter.wallet = wallet
            vc.presenter.account = account
            
            return vc
        case BLOCKCHAIN_ETHEREUM:
            let vc = storyboard.instantiateViewController(withIdentifier: "EthWalletID") as! EthWalletViewController
            vc.presenter.wallet = wallet
            vc.presenter.account = account
            
            return vc
        default:
            return UIViewController()
        }
    }
    
    func blockUI() {
        assetsVC!.progressHUD.blockUIandShowProgressHUD()
        assetsVC?.tableView.isUserInteractionEnabled = false
        assetsVC?.tabBarController?.view.isUserInteractionEnabled = false
    }
    
    func unlockUI() {
        assetsVC!.progressHUD.unblockUIandHideProgressHUD()
        assetsVC?.tableView.isUserInteractionEnabled = true
        assetsVC?.tabBarController?.view.isUserInteractionEnabled = true
    }
}
