//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class WalletSettingsPresenter: NSObject {

    var walletSettingsVC: WalletSettingsViewController?
    
    var wallet: UserWalletRLM?
    
    
    func delete() {
        DataManager.shared.realmManager.getAccount { (acc, err) in
            DataManager.shared.apiManager.deleteWallet(acc!.token, walletIndex: self.wallet!.walletID, completion: { (answer, err) in
                self.walletSettingsVC?.navigationController?.popToRootViewController(animated: true)
            })
        }
    }
    
    func changeWalletName() {
        DataManager.shared.getAccount { (account, error) in
            DataManager.shared.changeWalletName(account!.token , walletID: self.wallet!.walletID, newName: self.walletSettingsVC!.walletNameTF.text!.trimmingCharacters(in: .whitespaces)) { (dict, error) in
                print(dict)
                self.walletSettingsVC!.navigationController?.popViewController(animated: true)
            }
        }
    }
}
