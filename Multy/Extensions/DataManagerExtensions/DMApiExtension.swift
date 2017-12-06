//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import Foundation
import RealmSwift
import Alamofire

extension DataManager {
    func auth(completion: @escaping (_ account: AccountRLM?,_ error: Error?) -> ()) {
        realmManager.getRealm { (realmOpt, error) in
            if let realm = realmOpt {
                let account = realm.object(ofType: AccountRLM.self, forPrimaryKey: 1)
                
                var params : Parameters = [ : ]
                
                if account != nil {
                    params["password"] = account?.password
                    params["username"] = account?.username
                    params["deviceid"] = account?.deviceID
                } else {
                    params["password"] = "admin"
                    //MARK: names
                    params["username"] = UIDevice.current.name
                    params["deviceid"] = UUID().uuidString
                    
                    let paramsDict = NSDictionary(dictionary: params)
                    
                    self.realmManager.updateAccount(paramsDict, completion: { (account, error) in
                        
                    })
                }
                
                self.apiManager.auth(with: params, completion: { (dict, error) in
                    if dict != nil {
                        self.realmManager.updateAccount(dict!, completion: { (account, error) in
                            completion(account, error)
                        })
                    } else {
                        completion(nil, nil)
                    }
                })
            } else {
                print("Error fetching realm:\(#function)")
                completion(nil, nil)
            }
        }
    }
    
    func fetchAssets(_ token: String, completion: @escaping (_ assets: [WalletRLM]?,_ error: Error?) -> ()) {
        apiManager.getAssets(token) { (holdingsOpt, error) in
            if let holdings = holdingsOpt as? NSDictionary {
                
                //save exchange prices
                if let exchnagePrice = holdings["exchangePrice"] as? NSDictionary {
                    self.realmManager.updateExchangePrice(exchnagePrice, completion: { (exchangePrice, error) in
                        
                    })
                }
                
                if let wallets = holdings["wallets"] as? NSDictionary {
                    let accInfo = [ "wallets" : wallets.count ]
                    
                    self.realmManager.updateAccount(NSDictionary(dictionary: accInfo), completion: { (account, error) in
                        print("updated account wallet count: \(account?.walletCount)")
                    })
                }
                
                completion(nil, error)
            } else {
                completion(nil, nil)
            }
        }
    }
    
    func addWallet(completion: @escaping (_ answer: NSDictionary?,_ error: Error?) -> ()) {
        var params = Parameters()
        
        params["currency"] = 0
        params["address"] = 0
        params["addressID"] = 0
        params["walletID"] = 0
    }
}
