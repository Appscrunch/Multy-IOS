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
        
        let dict = DataManager.shared.createNewWallet(for: &binData, 0, walletID: account?.walletCount as! UInt32)
        
        let cell = mainVC?.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! CreateWalletNameTableViewCell
        
        let params = [
            "currency"  : dict!["currency"] as! UInt32,
            "address"   : dict!["address"] as! String,
            "addressID" : dict!["addressID"] as! UInt32,
            "walleetID" : dict!["walletID"] as! UInt32,
            "name"      : cell.walletNameTF.text ?? "Wallet"
            ] as [String : Any]
        
//        DataManager.shared.apiManager.addWallet(self.account!.token, params, completion: { (dict, error) in
//            print(dict)
//        })
        DataManager.shared.addWallet(self.account!.token, params: params) { (dict, error) in
            print(dict)
        }
    }
}
