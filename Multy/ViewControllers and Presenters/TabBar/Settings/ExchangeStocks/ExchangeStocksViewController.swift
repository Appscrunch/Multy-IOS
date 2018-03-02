//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class ExchangeStocksViewController: UIViewController, CancelProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    
    let presenter = ExchangeStocksPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.mainVC = self
        
        self.presenter.createStocks()
        self.registerCell()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func registerCell() {
        let exchangeStockCell = UINib(nibName: "ExchangeStockTableViewCell", bundle: nil)
        self.tableView.register(exchangeStockCell, forCellReuseIdentifier: "exchangeStockCell")
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func cancelAction() {
        DataManager.shared.realmManager.fetchAllWallets { (wallets) in
            if wallets == nil {
                let message = "You don`t have any wallets yet."
                self.donateOrAlert(isHaveNotEmptyWallet: false, message: message)
                return
            }
            for wallet in wallets! {
                if wallet.availableAmount() > 0 {
                    let message = "You have nothing to donate.\nTop up any of your wallets first."  // no money no honey
                    self.donateOrAlert(isHaveNotEmptyWallet: true, message: message)
                    break
                } else { // empty wallet
                    let message = "You have nothing to donate.\nTop up any of your wallets first."  // no money no honey
                    self.donateOrAlert(isHaveNotEmptyWallet: false, message: message)
                    break
                }
            }
            //            self.donateOrAlert()
        }
    }
    
    func presentNoInternet() {
        
    }
    
}

extension ExchangeStocksViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.frame = CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 46.0)
        header.backgroundColor = #colorLiteral(red: 0.9764457345, green: 0.9803969264, blue: 0.9998489022, alpha: 1)
        let label = UILabel()
        label.frame = CGRect(x: 20.0, y: 20.0, width: 150, height: 22)
        label.font = UIFont(name: "AvenirNext-Medium", size: 12.0)
        
        if section == 0 {
            label.textColor = #colorLiteral(red: 0.5294117647, green: 0.631372549, blue: 0.7725490196, alpha: 1)
            label.text = "AVAILABLE"
        } else {
            label.textColor = #colorLiteral(red: 0.9215686275, green: 0.08235294118, blue: 0.231372549, alpha: 1)
            label.text = "WORK IN PROGRESS"
        }
        
        header.addSubview(label)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 46.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let exchangeCell = self.tableView.dequeueReusableCell(withIdentifier: "exchangeStockCell") as! ExchangeStockTableViewCell
        
        if indexPath.section == 0 {
            exchangeCell.fillCell(exchangeStock: self.presenter.availableArr[indexPath.row])
        } else {
            exchangeCell.makeUnAvailable()
            exchangeCell.fillCell(exchangeStock: self.presenter.arr[indexPath.row])
        }
        
        return exchangeCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            self.navigationController?.popViewController(animated: true)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let donatAlert = storyboard.instantiateViewController(withIdentifier: "donationAlert") as! DonationAlertViewController
            donatAlert.modalPresentationStyle = .overCurrentContext
            donatAlert.cancelDelegate = self
            self.present(donatAlert, animated: true, completion: nil)
            (self.tabBarController as! CustomTabBarViewController).changeViewVisibility(isHidden: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}
