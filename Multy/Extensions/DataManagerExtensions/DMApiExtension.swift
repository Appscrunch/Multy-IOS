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
                    
                    self.realmManager.writeAccount(paramsDict, completion: { (account, error) in
                        
                    })
                }
                
                self.apiManager.auth(with: params, completion: { (dict, error) in
                    if dict != nil {
                        self.realmManager.writeAccount(dict!, completion: { (account, error) in
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
}
