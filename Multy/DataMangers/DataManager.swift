//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class DataManager: NSObject {
    static let shared = DataManager()
    
    let apiManager = ApiManager.shared
    let realmManager = RealmManager.shared
    let socketManager = Socket.shared
    let coreLibManager = CoreLibManager.shared
    
    //MARK: ApiManager Functions
    //DMApiExtension
    
    //MARK: RealmManager
    //DMRealmExtension Functions
    
    //MARK: SocketManager
    //DMSocketExtension Functions
    
    //MARK: CoreLibManager
    //DMCoreLibExtension Functions
    
    func getExchangeCourse(completion: @escaping (_ error: Error?) -> ()) {
        DataManager.shared.realmManager.getAccount { (acc, err) in
            if err == nil {
                DataManager.shared.apiManager.getExchangePrice(acc!.token, direction: "") { (dict, error) in
                    if dict == nil {
                        completion(error)
                        
                        return
                    }
                    
                    if dict!["USD"] != nil {
                        exchangeCourse = dict!["USD"] as! Double
                        completion(nil)
                    } else {
                        completion(nil)
                    }
                }
            } else {
                completion(nil)
            }
        }
    }
}
