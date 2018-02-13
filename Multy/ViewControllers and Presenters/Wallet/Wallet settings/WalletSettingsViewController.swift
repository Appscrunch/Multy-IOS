//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class WalletSettingsViewController: UIViewController {
    
    @IBOutlet weak var walletNameTF: UITextField!
    
    let presenter = WalletSettingsPresenter()
    
    let progressHUD = ProgressHUD(text: "Deleting Wallet...")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressHUD.backgroundColor = .gray
        view.addSubview(progressHUD)
        progressHUD.hide()
        
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
        if presenter.wallet?.sumInCrypto.fixedFraction(digits: 8) == "0" {
            let message = "Are you sure?"
            let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                self.progressHUD.show()
                
                self.presenter.delete()
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alert, animated: true, completion: nil)
        } else {
            let message = "Cryptocurrency amount should be empty"
            let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func changeWalletName(_ sender: Any) {
        if walletNameTF.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            let message = "Wallet name should be non empty"
            let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {            
            self.presenter.changeWalletName()
        }
    }
}

extension WalletSettingsViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField.text?.count)! + string.count < maxNameLength {
            return true
        } else {
            return false
        }
    }
    
}
