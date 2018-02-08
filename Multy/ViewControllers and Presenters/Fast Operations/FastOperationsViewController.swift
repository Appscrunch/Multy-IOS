//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import RAMAnimatedTabBarController

class FastOperationsViewController: UIViewController {

    let presenter = FastOperationsPresenter()
    var acc = AccountRLM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.fastOperationsVC = self
        
        DataManager.shared.realmManager.getAccount { (acc, err) in
            self.acc = acc!
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        self.navigationController?.navigationBar.isHidden = true
        (self.tabBarController as! CustomTabBarViewController).menuButton.isHidden = true
    }
    
    @IBAction func closeAction(_ sender: Any) {
        if let tbc = self.tabBarController as? CustomTabBarViewController {
            tbc.setSelectIndex(from: 2, to: tbc.previousSelectedIndex)
        }
    }
    
    @IBAction func sendAction(_ sender: Any) {
        if self.acc.wallets.count == 0 {
            self.alertForCreatingWallet()
        } else {
            let storyboard = UIStoryboard(name: "Send", bundle: nil)
            let destVC = storyboard.instantiateViewController(withIdentifier: "sendStart")
            self.navigationController?.pushViewController(destVC, animated: true)
        }
    }
    
    @IBAction func receiveAction(_ sender: Any) {
        switch self.acc.wallets.count {
        case 0:
            self.alertForCreatingWallet()
        default:
            let storyboard = UIStoryboard(name: "Receive", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "ReceiveStart")
            self.navigationController?.pushViewController(initialViewController, animated: true)
        }
    }
    
    @IBAction func nfcAction(_ sender: Any) {
    }
    
    @IBAction func scanAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Send", bundle: nil)
        let qrScanVC = storyboard.instantiateViewController(withIdentifier: "qrScanVC") as! QrScannerViewController
        qrScanVC.qrDelegate = self.presenter
        qrScanVC.presenter.isFast = true
        self.present(qrScanVC, animated: true, completion: nil)
    }
    
    func alertForCreatingWallet() {
        let alert = UIAlertController(title: "Warning", message: "You don`t have any wallets yet. Please create one", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { (action) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let creatingWalletVC = storyboard.instantiateViewController(withIdentifier: "creatingWallet")
            self.navigationController?.pushViewController(creatingWalletVC, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
