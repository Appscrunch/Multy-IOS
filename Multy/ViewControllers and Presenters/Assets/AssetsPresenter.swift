//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class AssetsPresenter: NSObject {

    var assetsVC: AssetsViewController?
    
    var tabBarFrame: CGRect?
    
    var account : AccountRLM? {
        didSet {
            fetchAssets()
//            fetchTickets()
            getExchange()
//            getTransInfo()
        }
    }
    
    func openCreateWalletPopup() {
        let actionSheet = UIAlertController(title: "Create or Import New Wallet",
                                            message: nil,
                                            preferredStyle: UIAlertControllerStyle.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Create wallet", style: .default, handler: { (result : UIAlertAction) -> Void in
            self.assetsVC?.performSegue(withIdentifier: "createWalletVC", sender: Any.self)
        }))
        actionSheet.addAction(UIAlertAction(title: "Import wallet", style: .default, handler: { (result: UIAlertAction) -> Void in
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
    
    func updateExchangeCourse() {
        DataManager.shared.getExhanchgeCourse((account?.token)!) { (dict, err) in
            
        }
    }
    
    
    //////////////////////////////////////////////////////////////////////
    //test
    
    func fetchAssets() {
        guard account?.token != nil else {
            return
        }
        
        DataManager.shared.fetchAssets(account!.token, completion: { (wallets, error) in
            print("wallets: \(wallets)")
        })
    }
    
    func fetchTickets() {
        DataManager.shared.apiManager.getTickets(account!.token, direction: "") { (dict, error) in
            guard dict != nil  else {
                return
            }
            
            print(dict!)
        }
    }
    
    func getExchange() {
        DataManager.shared.apiManager.getExchangePrice(account!.token, direction: "") { (dict, error) in
            guard dict != nil  else {
                return
            }
            print(dict!)
        }
    }
    
    func getTransInfo() {
        DataManager.shared.apiManager.getTransactionInfo(account!.token,
                                                         transactionString: "d83a5591585f05dc367d5e68579ece93240a6b4646133a38106249cadea53b77") { (transDict, error) in
                                                            guard transDict != nil else {
                                                                return
                                                            }
                                                            
                                                            print(transDict)
        }
    }
    //////////////////////////////////////////////////////////////////////
}
