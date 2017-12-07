//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class FastOperationsViewController: UIViewController {

    let presenter = FastOperationsPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.fastOperationsVC = self
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        self.navigationController?.navigationBar.isHidden = true
        (self.tabBarController as! CustomTabBarViewController).menuButton.isHidden = true
        self.presenter.getExchange()
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func sendAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Send", bundle: nil)
        let destVC = storyboard.instantiateViewController(withIdentifier: "sendStart")
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    
    @IBAction func receiveAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Receive", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "ReceiveStart")
        self.navigationController?.pushViewController(initialViewController, animated: true)
    }
    
    @IBAction func nfcAction(_ sender: Any) {
    }
    
    @IBAction func scanAction(_ sender: Any) {
    }
    
    
}
