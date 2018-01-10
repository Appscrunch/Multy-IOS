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
                
            })
        }
    }
}
