//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class CreateWalletPresenter: NSObject {
    weak var mainVC: CreateWalletViewController?
    var account : AccountRLM?
    
//    func createNewWallet(completion: @escaping (_ dict: Dictionary<String, Any>?) -> ()) {
//        DataManager.shared.createNewAccountWithWallet(0, walletID: account!.walletCount.uint32Value) { (dict) in
//            print("new wallet: \(dict)")
//            
////            completion(dict)
//            var params = [
//                "currency"  : dict!["currency"] as! UInt32,
//                "address"   : dict!["address"] as! String,
//                "addressID" : String((dict!["addressID"] as! UInt32)),
//                "walleetID" : dict!["walletID"] as! String
//                ] as [String : Any]
//            
//            DataManager.shared.apiManager.addWallet(self.account!.token, params, completion: { (dict, error) in
//                print(dict)
//            })
//        }
//    }
}
