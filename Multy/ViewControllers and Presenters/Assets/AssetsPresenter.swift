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
            print("")
//            fetchTickets()
//            getTransInfo()
//            getWalletVerbose()
//            getWalletOutputs()
            
            backupActivity()
            
            if self.assetsVC!.isVisible() {
                (self.assetsVC!.tabBarController as! CustomTabBarViewController).changeViewVisibility(isHidden: account == nil)
            }
            
            self.assetsVC?.view.isUserInteractionEnabled = true
            if !assetsVC!.isSocketInitiateUpdating && self.assetsVC!.tabBarController!.viewControllers![0].childViewControllers.count == 1 {
                assetsVC?.tableView.reloadData()
            }
        }
    }
    
    func backupActivity() {
        if account != nil {
            self.assetsVC?.backupView?.isHidden = account!.isSeedPhraseSaved()
            self.assetsVC?.backupView?.isUserInteractionEnabled = !account!.isSeedPhraseSaved()
        }
    }
    
    func auth() {
        //MARK: need refactoring
        self.assetsVC?.view.isUserInteractionEnabled = false
        assetsVC?.progressHUD.show()
        DataManager.shared.getAccount { (acc, err) in
            self.assetsVC?.view.isUserInteractionEnabled = true
            if acc == nil {
                self.assetsVC?.progressHUD.show()
                DataManager.shared.auth(rootKey: nil) { (account, error) in
                    self.assetsVC?.progressHUD.hide()
                    guard account != nil else {
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self.account = account
                        DataManager.shared.socketManager.start()
                        self.getWalletsVerbose(completion: {_ in })
                    }
                }
            } else {
                self.account = acc
                DataManager.shared.auth(rootKey: self.account?.backupSeedPhrase, completion: { (acc, err) in
                    if acc != nil {
                        self.account = acc
                        self.getWalletsVerbose(completion: {_ in})
                        DataManager.shared.socketManager.start()
                    }
                })
            }
            
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
        assetsVC!.progressHUD.show()
        DataManager.shared.getAccount { (acc, err) in
            self.assetsVC!.progressHUD.hide()
            if acc != nil {
                self.account = acc
                self.getWalletsVerbose(completion: {_ in })
            }
        }
    }
    
    func isWalletExist() -> Bool {
        return !(account == nil || account?.wallets.count == 0)
    }
    
    func openCreateWalletPopup() {
        let actionSheet = UIAlertController(title: Constants.AssetsScreen.createOrImportWalletString,
                                            message: nil,
                                            preferredStyle: UIAlertControllerStyle.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: Constants.AssetsScreen.createWalletString,
                                            style: .default,
                                            handler: { (result : UIAlertAction) -> Void in
            self.assetsVC?.performSegue(withIdentifier: Constants.Storyboard.createWalletVCSegueID,
                                        sender: Any.self)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Import wallet",
                                            style: .default,
                                            handler: { (result: UIAlertAction) -> Void in
            //go to import wallet
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.assetsVC?.present(actionSheet, animated: true, completion: nil)
    }
    
    func registerCells() {
        let walletCell = UINib.init(nibName: "WalletTableViewCell", bundle: nil)
        self.assetsVC?.tableView.register(walletCell, forCellReuseIdentifier: "walletCell")
        
        let portfolioCell = UINib.init(nibName: "PortfolioTableViewCell", bundle: nil)
        self.assetsVC?.tableView.register(portfolioCell, forCellReuseIdentifier: "portfolioCell")
        
        let newWalletCell = UINib.init(nibName: "NewWalletTableViewCell", bundle: nil)
        self.assetsVC?.tableView.register(newWalletCell, forCellReuseIdentifier: "newWalletCell")
    }
    
//    func updateExchangeCourse() {
//        DataManager.shared.getExhanchgeCourse((account?.token)!) { (dict, err) in
//            
//        }
//    }
    
    //////////////////////////////////////////////////////////////////////
    //test
    
    func getTransInfo() {
        DataManager.shared.apiManager.getTransactionInfo(transactionString: "d83a5591585f05dc367d5e68579ece93240a6b4646133a38106249cadea53b77") { (transDict, error) in
                                                            guard transDict != nil else {
                                                                return
                                                            }
                                                            
                                                            print(transDict)
        }
    }
    
    func getWalletOutputs() {
        DataManager.shared.getWalletOutputs(currencyID: 0, address: account!.wallets[0].address) { (dict, error) in
            print("getWalletOutputs: \(dict)")
        }
    }
    
    func getWalletsVerbose(completion: @escaping (_ flag: Bool) -> ()) {
        DataManager.shared.getWalletsVerbose() { (walletsArrayFromApi, err) in
            if err != nil {
                return
            } else {
                let walletsArr = UserWalletRLM.initWithArray(walletsInfo: walletsArrayFromApi!)
                print("afterVerbose:rawdata: \(walletsArrayFromApi)")
                DataManager.shared.realmManager.updateWalletsInAcc(arrOfWallets: walletsArr, completion: { (acc, err) in
                    self.account = acc
                    
                    print("wallets: \(acc?.wallets)")
                    
                    completion(true)
                    
//                    DataManager.shared.getAccount(completion: { (acc, err) in
//                        print("afterVerbose: \(acc!)")
//                    })
                })
            }
        }
    }
    
    func getWalletVerboseForSockets(completion: @escaping (_ flag: Bool) -> ()) {
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
        let wallet = account?.wallets[indexPath.row - 2]
        let storyboard = UIStoryboard(name: "Wallet", bundle: nil)
        assetsVC?.sendAnalyticsEvent(screenName: screenMain, eventName: "\(walletOpenWithChainTap)\(wallet!.chain)")
        
        switch wallet!.chain.uint32Value {
        case BLOCKCHAIN_BITCOIN.rawValue:
            let vc = storyboard.instantiateViewController(withIdentifier: "WalletMainID") as! BTCWalletViewController
            vc.presenter.wallet = wallet
            vc.presenter.account = account
            
            return vc
        case BLOCKCHAIN_ETHEREUM.rawValue:
            let vc = storyboard.instantiateViewController(withIdentifier: "EthWalletID") as! EthWalletViewController
            vc.presenter.wallet = wallet
            vc.presenter.account = account
            
            return vc
        default:
            return UIViewController()
        }
    }
}
