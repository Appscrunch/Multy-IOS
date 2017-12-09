//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class CreateWalletPresenter: NSObject {
    weak var mainVC: CreateWalletViewController?
    var account : AccountRLM?
    
    func createNewWallet(completion: @escaping (_ dict: Dictionary<String, Any>?) -> ()) {
        if account == nil {
            return
        }
        
        var binData : BinaryData = decode(data: account!.binaryData)
        
        let dict = DataManager.shared.createNewWallet(for: &binData, CURRENCY_BITCOIN.rawValue, walletID: account!.walletCount as! UInt32)
        
        let cell = mainVC?.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! CreateWalletNameTableViewCell
        
        let params = [
            "currencyID"  : dict!["currency"] as! UInt32,
            "address"   : dict!["address"] as! String,
            "addressIndex" : dict!["addressID"] as! UInt32,
            "walletIndex" : dict!["walletID"] as! UInt32,
            "walletName"      : cell.walletNameTF.text ?? "Wallet"
            ] as [String : Any]
        
        DataManager.shared.addWallet(self.account!.token, params: params) { (dict, error) in
            print(dict as Any)
            self.mainVC?.cancleAction(UIButton())
        }
    }
}
