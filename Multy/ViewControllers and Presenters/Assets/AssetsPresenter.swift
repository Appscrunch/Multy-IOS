//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import RealmSwift

class AssetsPresenter: NSObject {

    var assetsVC: AssetsViewController?
    
    var tabBarFrame: CGRect?
    
    var isJailed = false
    
    var amountWallet: UInt64 = 0
    var output: UInt32 = 0
    
    var account : AccountRLM? {
        didSet {
//            fetchTickets()
            getExchange()
//            getTransInfo()
//            getWalletVerbose()
            getWalletOutputs()
            assetsVC?.tableView.reloadData()
        }
    }
    
    func auth() {
        assetsVC?.progressHUD.show()
        DataManager.shared.auth { (account, error) in
            self.assetsVC?.progressHUD.hide()
            guard account != nil else {
                DataManager.shared.getAccount { (acc, err) in
                    if err == nil {
                        // MARK: check this
//                        self.account = acc
                    }
                }
                
                return
            }
            
            DispatchQueue.main.async {
                self.account = account
                self.fetchAssets()
            }
        }
    }
    
    func isWalletExist() -> Bool {
        return !(account == nil || account?.walletCount.intValue == 0)
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
        
        assetsVC?.progressHUD.show()
        DataManager.shared.fetchAssets(account!.token, completion: { (wallets, error) in
            if wallets == nil || wallets is NSNull {
                self.assetsVC?.progressHUD.hide()
                
                return
            }
            
            DataManager.shared.updateAccount(["wallets" : wallets], completion: { (account, error) in
                self.account = account
                self.assetsVC?.progressHUD.hide()
            })
            
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
        DataManager.shared.getExchangeCourse { (error) in
            print(error)
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
    
    func getWalletOutputs() {
        DataManager.shared.getWalletOutputs(account!.token, walletID: 0) { (dict, error) in
            print("getWalletOutputs: \(dict)")
        }
    }
    
    func getWalletVerbose() {
        DataManager.shared.getWalletsVerbose((account?.token)!) { (answer, err) in
            if (answer?["code"] as? NSNumber)?.intValue == 200 {
                DataManager.shared.updateAccount(answer!["wallets"] as! NSDictionary, completion: { (account, error) in
                    
                })
            }
            
            print("OK")
            let answDict = answer
            var spendDict = NSDictionary()
            var spendAddress = String()
            if answDict != nil {
                if answDict!["wallets"] != nil {
                    if answDict!["wallets"] is NSNull {
                        return
                    }
                    
                    print("answer: \(answer)")
                    
                    let arrOfwallets = answDict!["wallets"] as! NSArray
                    let firstWallet = arrOfwallets.firstObject as! NSDictionary
                    let addressArr = firstWallet["addresses"] as! NSArray
                    let amount = (addressArr.firstObject as! NSDictionary)["amount"] as! UInt64
                    self.amountWallet = amount/UInt64(pow(10.0, 8.0))
                    spendAddress = (addressArr.firstObject as! NSDictionary)["address"] as! String
                    let spendableoutputs = (addressArr.firstObject as! NSDictionary)["spendableoutputs"] as! NSArray
                    spendDict = spendableoutputs.firstObject as! NSDictionary
                    
                    self.output = spendDict["txoutamount"] as! UInt32 / UInt32(pow(10.0, 8.0))
                }
            }
            self.assetsVC?.updateUI()
//            UserWalletRLM
            
            if spendDict["txid"] == nil {
                return
            }
            
            let availableSum = spendDict["txoutamount"] as? UInt32
            
            let oriBinData = DataManager.shared.coreLibManager.createSeedBinaryData(from: self.account!.seedPhrase)
            
            var binData : BinaryData = self.account!.binaryDataString.createBinaryData()
            
            let dict = DataManager.shared.coreLibManager.createAddress(currencyID: 0, walletID: 0, addressID: 0, binaryData: &binData)
            let hexString = DataManager.shared.coreLibManager.createTransaction(addressPointer: dict!["addressPointer"] as! OpaquePointer,
                                                                                sendAddress: "mrPnciDNg6gSE5Uu6vJEPWN2d6tyzHV3N8",
                                                                                availableSum: String(describing: availableSum),
                                                                                sendAmountString: "259998000",
                                                                                feeAmountString: "2000",
                                                                                donationAddress: "address",
                                                                                donationAmount: "10",
                                                                                txid: spendDict["txid"] as! String,
                                                                                txoutid: spendDict["txoutid"] as! UInt32,
                                                                                txoutamount: spendDict["txoutamount"] as! UInt32,
                                                                                txoutscript: spendDict["txoutscript"] as! String)

            let params = [
                "transaction" : hexString
                ] as [String : Any]
            DataManager.shared.apiManager.sendRawTransaction(self.account!.token, params, completion: { (dict, error) in
                print("---------\(dict)")
            })
        }
    }
}
