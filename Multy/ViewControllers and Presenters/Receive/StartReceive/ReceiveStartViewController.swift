//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import ZFRippleButton

class ReceiveStartViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let presenter = ReceiveStartPresenter()
    
    var sendWalletDelegate: SendWalletProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        self.presenter.receiveStartVC = self
        self.registerCells()
//        self.presenter.createWallets()
        self.presenter.getWallets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (self.tabBarController as! CustomTabBarViewController).menuButton.isHidden = true
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
//            self.deselectCell()
//        })
    }
    
    func registerCells() {
        let walletCell = UINib.init(nibName: "WalletTableViewCell", bundle: nil)
        self.tableView.register(walletCell, forCellReuseIdentifier: "walletCell")
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        if self.presenter.isNeedToPop {
            self.navigationController?.popViewController(animated: true)
        } else {
            if let tbc = self.tabBarController as? CustomTabBarViewController {
                tbc.setSelectIndex(from: 2, to: tbc.previousSelectedIndex)
            }
            self.navigationController?.popToRootViewController(animated: false)
        }
    }

//    Deselecting
//    
//    func deselectCell() {
//        if self.presenter.selectedIndexPath != nil {
//            let walletCell = self.tableView.cellForRow(at: self.presenter.selectedIndexPath!) as! WalletTableViewCell
//            walletCell.clearBorderAndArrow()
//        }
//    }
    
}

extension ReceiveStartViewController: UITableViewDelegate, UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presenter.selectedIndex = indexPath.row
        if self.presenter.isNeedToPop == true {
            self.sendWalletDelegate?.sendWallet(wallet: self.presenter.walletsArr[self.presenter.selectedIndex!])
            self.navigationController?.popViewController(animated: true)
        } else {
            self.performSegue(withIdentifier: "receiveDetails", sender: Any.self)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 104
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let walletCell = cell as! WalletTableViewCell
//        walletCell.makeshadow()
    }
    
    func updateUI() {
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "receiveDetails" {
            let receiveDetails = segue.destination as! ReceiveAllDetailsViewController
            receiveDetails.presenter.wallet = self.presenter.walletsArr[self.presenter.selectedIndex!]
        }
    }
}
