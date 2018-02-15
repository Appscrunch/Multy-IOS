//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import RealmSwift

class WalletChoosePresenter: NSObject {

    var walletChoooseVC: WalletChooseViewController?
    var transactionDTO = TransactionDTO()
    
    var walletsArr = List<UserWalletRLM>()
    var selectedIndex: Int?
    
    func numberOfWallets() -> Int {
        return self.walletsArr.count
    }
    
    func getWallets() {
        DataManager.shared.getAccount { (acc, err) in
            if err == nil {
                // MARK: check this
                self.walletsArr = acc!.wallets
                self.walletChoooseVC?.updateUI()
            }
        }
    }
    
    func presentAlert() {
        let message = "Not enough amount on choosen wallet!\nYou can`t spend sum more than you have on the wallet!\nYour payment sum equals \(transactionDTO.sendAmount!.fixedFraction(digits: 8)) BTC"
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
            
        }))
        
        walletChoooseVC?.present(alert, animated: true, completion: nil)
    }
}
