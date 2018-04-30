//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class WalletChooseViewController: UIViewController, AnalyticsProtocol {

    @IBOutlet weak var tableView: UITableView!
    
    let presenter = WalletChoosePresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.swipeToBack()
        self.registerCell()
        (self.tabBarController as! CustomTabBarViewController).changeViewVisibility(isHidden: true)
        self.presenter.walletChoooseVC = self
        self.presenter.getWallets()
        sendAnalyticsEvent(screenName: screenSendFrom, eventName: screenSendFrom)
    }
    
    func registerCell() {
        let walletCell = UINib(nibName: "WalletTableViewCell", bundle: nil)
        self.tableView.register(walletCell, forCellReuseIdentifier: "walletCell")
    }

    @IBAction func backAction(_ sender: Any) {
        presenter.transactionDTO.choosenWallet = nil
        self.navigationController?.popViewController(animated: true)
        sendAnalyticsEvent(screenName: screenSendFrom, eventName: closeTap)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sendBTCDetailsVC" {
            let detailsVC = segue.destination as! SendDetailsViewController
            presenter.transactionDTO.choosenWallet = self.presenter.walletsArr[self.presenter.selectedIndex!]
            detailsVC.presenter.transactionDTO = presenter.transactionDTO
        } else if segue.identifier == "sendETHDetailsVC" {
            let detailsVC = segue.destination as! EthSendDetailsViewController
            presenter.transactionDTO.choosenWallet = self.presenter.walletsArr[self.presenter.selectedIndex!]
            detailsVC.presenter.transactionDTO = presenter.transactionDTO
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
        self.navigationController?.popToRootViewController(animated: false)
    }
}

extension WalletChooseViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.numberOfWallets()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let walletCell = self.tableView.dequeueReusableCell(withIdentifier: "walletCell") as! WalletTableViewCell
        walletCell.arrowImage.image = nil
        walletCell.wallet = self.presenter.walletsArr[indexPath.row]
        walletCell.fillInCell()
        
        return walletCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 104
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if presenter.walletsArr[indexPath.row].availableAmount() == 0 {
            presenter.presentAlert(message: "You have no available funds")
            
            return
        }
        
        if presenter.transactionDTO.sendAmount != nil {
            if Double(presenter.walletsArr[indexPath.row].availableAmount()) < presenter.transactionDTO.sendAmount! {
                presenter.presentAlert(message: nil)
                
                return
            }
        }
        
        let isValidDTO = DataManager.shared.isAddressValid(address: presenter.transactionDTO.sendAddress!, for: self.presenter.walletsArr[indexPath.row])
        
        if !isValidDTO.isValid {
            presenter.presentAlert(message: "You entered not valid address for current blockchain.")
            
            return
        }
        
        self.presenter.selectedIndex = indexPath.row
        switch self.presenter.walletsArr[indexPath.row].blockchain.blockchain {
        case BLOCKCHAIN_BITCOIN:
            self.performSegue(withIdentifier: "sendBTCDetailsVC", sender: Any.self)
        case BLOCKCHAIN_ETHEREUM:
            self.performSegue(withIdentifier: "sendETHDetailsVC", sender: Any.self)
        default: break
        }
        
//        let storyboard = UIStoryboard(name: "Send", bundle: nil)   //need to send transactionDTO
//        let ethDetailsVC = storyboard.instantiateViewController(withIdentifier: "EthSendDetails")
//        self.navigationController?.pushViewController(ethDetailsVC, animated: true)
        
        sendAnalyticsEvent(screenName: screenSendFrom, eventName: "\(walletWithChainTap)\(presenter.walletsArr[indexPath.row].chain)")
    }
    
    func updateUI() {
        self.tableView.reloadData()
    }
}
