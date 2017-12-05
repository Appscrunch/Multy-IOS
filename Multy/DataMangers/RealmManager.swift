//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import RealmSwift

class RealmManager: NSObject {
    static let shared = RealmManager()
//    let schemaVersion : UInt64 = 2
    
    private override init() {
        super.init()
        
        MasterKeyGenerator.shared.generateMasterKey { (masterKey, error, string) in
            if masterKey != nil {
                _ = Realm.Configuration(encryptionKey: masterKey!//,
//                                        schemaVersion: self.schemaVersion,
//                                        migrationBlock: { migration, oldSchemaVersion in
//                                            if oldSchemaVersion < self.schemaVersion {
//                                                //some migration if needed
//                                            }
//                                        }
                )
            } else {
                print("Realm error while setting config")
            }
        }
    }
    
    public func getRealm(completion: @escaping (_ realm: Realm?, _ error: NSError?) -> ()) {
        MasterKeyGenerator.shared.generateMasterKey { (masterKey, error, string) in
            guard masterKey != nil else {
                completion(nil, nil)
                
                return
            }
            
            let realmConfig = Realm.Configuration(encryptionKey: masterKey!//,
//                                                  schemaVersion: self.schemaVersion,
//                                                  migrationBlock: nil
            )
            
            do {
                let realm = try Realm(configuration: realmConfig)
                completion(realm, nil)
            } catch let error as NSError {
                completion(nil, error)
                fatalError("Error opening Realm: \(error)")
            }
        }
    }
    
    public func getSeedPhrase(completion: @escaping (_ seedPhrase: String?, _ error: NSError?) -> ()) {
        getRealm { (realmOpt, error) in
            if let realm = realmOpt {
                let seedPhraseOpt = realm.object(ofType: SeedPhraseRLM.self, forPrimaryKey: 1)
                
                if let seedPhrase = seedPhraseOpt {
                    completion(seedPhrase.seedString, nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                print("Error fetching realm:\(#function)")
            }
        }
    }
    
    public func writeSeedPhrase(_ seedPhrase: String, completion: @escaping (_ error: NSError?) -> ()) {
        getRealm { (realmOpt, error) in
            if let realm = realmOpt {
                let seedPhraseOpt = realm.object(ofType: SeedPhraseRLM.self, forPrimaryKey: 1)
                
                try! realm.write {
                    //replace old value if exists
                    let seedRLM = seedPhraseOpt == nil ? SeedPhraseRLM() : seedPhraseOpt!
                    seedRLM.seedString = seedPhrase
                    
                    realm.add(seedRLM, update: true)
                    print("Successful writing seed phrase")
                }
            } else {
                print("Error fetching realm:\(#function)")
            }
        }
    }
    
    public func deleteSeedPhrase(completion: @escaping (_ error: NSError?) -> ()) {
        getRealm { (realmOpt, error) in
            if let realm = realmOpt {
                let seedPhraseOpt = realm.object(ofType: SeedPhraseRLM.self, forPrimaryKey: 1)
                
                if let seedPhrase = seedPhraseOpt {
                    try! realm.write {
                        realm.delete(seedPhrase)
                        
                        completion(nil)
                        print("Successful writing seed phrase")
                    }
                } else {
                    completion(NSError())
                    print("Error fetching seedPhrase")
                }
            } else {
                completion(NSError())
                print("Error fetching realm")
            }
        }
    }
    
    public func writeAccount(_ accountDict: NSDictionary, completion: @escaping (_ account : AccountRLM?, _ error: NSError?) -> ()) {
        getRealm { (realmOpt, error) in
            if let realm = realmOpt {
                let account = realm.object(ofType: AccountRLM.self, forPrimaryKey: 1)
                
                try! realm.write {
                    //replace old value if exists
                    let accountRLM = account == nil ? AccountRLM() : account!
                    
                    if accountDict["expire"] != nil {
                        accountRLM.expireDateString = accountDict["expire"] as! String
                    }
                    
                    if accountDict["token"] != nil {
                        accountRLM.token = accountDict["token"] as! String
                    }
                    
                    if accountDict["deviceid"] != nil {
                        accountRLM.deviceID = accountDict["deviceid"] as! String
                    }
                    
                    if accountDict["password"] != nil {
                        accountRLM.password = accountDict["password"] as! String
                    }
                    
                    if accountDict["username"] != nil {
                        accountRLM.username = accountDict["username"] as! String
                    }
                    
                    realm.add(accountRLM, update: true)
                    
                    completion(accountRLM, nil)
                    
                    print("Successful writing account")
                }
            } else {
                print("Error fetching realm:\(#function)")
                completion(nil, nil)
            }
        }
        
    }
    
    public func createWallet(_ walletDict: Dictionary<String, Any>, completion: @escaping (_ account : WalletRLM?, _ error: NSError?) -> ()) {
        getRealm { (realmOpt, error) in
            if let realm = realmOpt {
                let wallet = WalletRLM.initWithDictionary(walletDict)
                
                try! realm.write {
                    realm.add(wallet, update: true)
                    
                    completion(wallet, nil)
                    
                    print("Successful writing wallet")
                }
            } else {
                print("Error fetching realm:\(#function)")
                completion(nil, nil)
            }
        }
    }
}
