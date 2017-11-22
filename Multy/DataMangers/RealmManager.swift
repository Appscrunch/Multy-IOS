//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import RealmSwift

class RealmManager: NSObject {
    static let shared = RealmManager()
    
    private override init() {
        super.init()
        
        MasterKeyGenerator.shared.generateMasterKey { (masterKey, error, string) in
            if masterKey != nil {
                _ = Realm.Configuration(encryptionKey: masterKey!)
            } else {
                print("Realm error while setting config")
            }
        }
    }
    
//    func getRealm() -> Realm? {
//        var realm : Realm?
//        
//        MasterKeyGenerator.shared.generateMasterKey { (masterKey, error, helpString) in
//            if masterKey != nil {
//                let config = Realm.Configuration(encryptionKey: masterKey!)
//                
//                do {
//                    realm = try Realm(configuration: config)
//                } catch let error as NSError {
//                    // If the encryption key is wrong, error will say that it's an invalid database
//                    fatalError("Error opening realm: \(error)")
//                    
//                    realm = nil
//                }
//            } else {
//                realm = nil
//            }
//        }
//        
//        return realm
//    }
}
