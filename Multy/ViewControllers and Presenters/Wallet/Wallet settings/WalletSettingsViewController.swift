//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class WalletSettingsViewController: UIViewController {
    
    let presenter = WalletSettingsPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.walletSettingsVC = self
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
