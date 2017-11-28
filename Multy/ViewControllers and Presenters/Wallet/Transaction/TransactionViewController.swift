//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class TransactionViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    let presenter = TransactionPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.transctionVC = self
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        self.checkHeightForSrollAvailability()
    }

    func checkHeightForSrollAvailability() {
        if screenHeight >= 667 {
            self.scrollView.isScrollEnabled = false
        }
    }
    @IBAction func closeAction() {
        self.navigationController?.popViewController(animated: true)
    }
}
