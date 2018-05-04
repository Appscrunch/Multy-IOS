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
    
    func presentAlert(message : String?) {
        var alertMessage = String()
        if message == nil {
            alertMessage = "Not enough amount on choosen wallet!\nYou can`t spend sum more than you have on the wallet!\nYour payment sum equals \(transactionDTO.sendAmount!.fixedFraction(digits: 8)) \(transactionDTO.blockchain!.fullName)"
        } else {
            alertMessage = message!
        }
        
        let alert = UIAlertController(title: "Error", message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
            
        }))
        
        walletChoooseVC?.present(alert, animated: true, completion: nil)
    }
    
    func destinationSegueString() -> String {
        switch transactionDTO.blockchain {
        case BLOCKCHAIN_BITCOIN:
            return "sendBTCDetailsVC"
        case BLOCKCHAIN_ETHEREUM:
            return "sendETHDetailsVC"
        default:
            return ""
        }
    }
}
