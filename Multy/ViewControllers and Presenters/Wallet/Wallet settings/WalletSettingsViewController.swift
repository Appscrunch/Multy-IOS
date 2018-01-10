//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class WalletSettingsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var walletNameTF: UITextField!
    
    let presenter = WalletSettingsPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.walletSettingsVC = self
        self.hideKeyboardWhenTappedAround()
        self.updateUI()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateUI() {
        self.walletNameTF.text = self.presenter.wallet?.name
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        self.presenter.delete()
    }
}
