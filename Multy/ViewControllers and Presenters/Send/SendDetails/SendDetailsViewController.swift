//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class SendDetailsViewController: UIViewController {

    
    let presenter = SendDetailsPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        self.presenter.sendDetailsVC = self
    }
    
    
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
