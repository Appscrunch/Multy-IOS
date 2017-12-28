//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import RealmSwift

class RealmManager: NSObject {
    static let shared = RealmManager()
    
    private var realm : Realm? = nil
    let schemaVersion : UInt64 = 7
    
    private override init() {
        super.init()
        
        MasterKeyGenerator.shared.generateMasterKey { (masterKey, error, string) in
            if masterKey != nil {
                _ = Realm.Configuration(encryptionKey: masterKey!,
                                        schemaVersion: self.schemaVersion,
                                        migrationBlock: { migration, oldSchemaVersion in
                                            if oldSchemaVersion < 7 {
                                                self.migrateFrom6To7(with: migration)
                                            }
                                        }
                )
            } else {
                print("Realm error while setting config")
            }
        }
    }
    
    public func finishRealmSession() {
        realm = nil
    }
    
    public func getRealm(completion: @escaping (_ realm: Realm?, _ error: NSError?) -> ()) {
        if realm != nil {
            completion(realm!, nil)
            
            return
        }
        
        MasterKeyGenerator.shared.generateMasterKey { (masterKey, error, string) in
            guard masterKey != nil else {
                completion(nil, nil)
                
                return
            }
            
            let realmConfig = Realm.Configuration(encryptionKey: masterKey!,
                                                  schemaVersion: self.schemaVersion,
                                                  migrationBlock: { migration, oldSchemaVersion in
                                                    if oldSchemaVersion < 7 {
                                                        self.migrateFrom6To7(with: migration)
                                                    }
            })
            
            do {
                let realm = try Realm(configuration: realmConfig)
                self.realm = realm
                
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
                
                if seedPhraseOpt == nil {
                    completion(nil, nil)
                } else {
                    completion(seedPhraseOpt!.seedString, nil)
                }
            } else {
                print("Error fetching realm:\(#function)")
                completion(nil, nil)
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
    
    public func updateAccount(_ accountDict: NSDictionary, completion: @escaping (_ account : AccountRLM?, _ error: NSError?) -> ()) {
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
                    
                    if accountDict["userID"] != nil {
                        accountRLM.userID = accountDict["userID"] as! String
                    }
                    
                    if accountDict["deviceID"] != nil {
                        accountRLM.deviceID = accountDict["deviceID"] as! String
                    }
                    
                    if accountDict["pushToken"] != nil {
                        accountRLM.pushToken = accountDict["pushToken"] as! String
                    }
                    
                    if accountDict["seedPhrase"] != nil {
                        accountRLM.seedPhrase = accountDict["seedPhrase"] as! String
                    }
                    
                    if accountDict["binaryData"] != nil {
                        accountRLM.binaryDataString = accountDict["binaryData"] as! String
                    }
                    
                    if accountDict["wallets"] != nil {
                        let walletsList = accountDict["wallets"] as! List<UserWalletRLM>
                        
                        for wallet in walletsList {
                            let walletFromDB = realm.object(ofType: UserWalletRLM.self, forPrimaryKey: wallet.id)
                            
                            if walletFromDB != nil {
                                realm.add(wallet, update: true)
                            } else {
                                accountRLM.wallets.append(wallet)
                            }
                        }
                        
                        accountRLM.walletCount = NSNumber(value: accountRLM.wallets.count)
                    }
                    
                    realm.add(accountRLM, update: true)
                    
                    completion(accountRLM, nil)
                    
                    print("Successful writing account: \(accountRLM)")
                }
            } else {
                print("Error fetching realm:\(#function)")
                completion(nil, nil)
            }
        }
    }
//     public func updateAccount(_ accountDict: NSDictionary, completion: @escaping (_ account : AccountRLM?, _ error: NSError?) -> ()) {
//    public func updateAccountWallets(_ wallets) {
//        
//    }
    
    public func createWallet(_ walletDict: Dictionary<String, Any>, completion: @escaping (_ account : UserWalletRLM?, _ error: NSError?) -> ()) {
        getRealm { (realmOpt, error) in
            if let realm = realmOpt {
                let wallet = UserWalletRLM.initWithInfo(walletInfo: NSDictionary(dictionary: walletDict))
                
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
    
    public func updateExchangePrice(_ ratesDict: NSDictionary, completion: @escaping (_ exchangePrice : ExchangePriceRLM?, _ error: NSError?) -> ()) {
        getRealm { (realmOpt, error) in
            if let realm = realmOpt {
                let exchange = ExchangePriceRLM.initWithInfo(info: ratesDict)
                
                try! realm.write {
                    realm.add(exchange, update: true)

                    completion(exchange, nil)

                    print("Successful writing exchange price")
                }
            } else {
                print("Error fetching realm:\(#function)")
                completion(nil, nil)
            }
        }
    }
    
    public func getExchangePrice(completion: @escaping (_ exchangePrice : ExchangePriceRLM?, _ error: NSError?) -> ()) {
        getRealm { (realmOpt, error) in
            if let realm = realmOpt {
                let prices = realm.object(ofType: ExchangePriceRLM.self, forPrimaryKey: 1)
                
                if prices != nil {
                    completion(prices, nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                print("Error fetching realm:\(#function)")
                completion(nil, nil)
            }
        }
    }
    
    public func getAccount(completion: @escaping (_ account: AccountRLM?, _ error: NSError?) -> ()) {
        getRealm { (realmOpt, err) in
            if let realm = realmOpt {
                let acc = realm.object(ofType: AccountRLM.self, forPrimaryKey: 1)
                if acc != nil {
                    completion(acc, nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                print("Err from realm GetAcctount:\(#function)")
                completion(nil,nil)
            }
        }
    }
    
    public func clearSeedPhraseInAcc() {
        getRealm { (realmOpt, err) in
            if let realm = realmOpt {
                let acc = realm.object(ofType: AccountRLM.self, forPrimaryKey: 1)
                try! realm.write {
                    acc?.seedPhrase = ""
                    print("Seed phrase was deleted from db by realm Manager")
                }
            }
        }
    }
    
    public func createOrUpdateAccount(accountInfo: NSArray, completion: @escaping(_ account: AccountRLM?, _ error: NSError?)->()) {
        getRealm { (realmOpt, err) in
            guard let realm = realmOpt else {
                completion(nil, nil)
                
                return
            }
            
            let account = realm.object(ofType: AccountRLM.self, forPrimaryKey: 1)
            
            guard account != nil else {
                completion(nil, nil)
                
                return
            }
            
            let accountWallets = account!.wallets
            let newWallets = List<UserWalletRLM>()
            
            for wallet in accountInfo {
                let wallet = wallet as! NSDictionary
                let walletID = wallet["WalletIndex"] != nil ? wallet["WalletIndex"] : wallet["walletindex"]
                
                let modifiedWallet = accountWallets.filter("walletID = \(walletID)").first

                try! realm.write {
//                    if modifiedWallet != nil {
//                        modifiedWallet!.addresses = wallet.addresses
//                        newWallets.append(modifiedWallet!)
//                    } else {
//                        newWallets.append(wallet)
//                    }
                }
            }
            
            try! realm.write {
                account!.wallets.removeAll()
                for wallet in newWallets {
                    account!.wallets.append(wallet)
                    
                    account!.wallets.last!.addresses.removeAll()
                    for address in wallet.addresses {
                        account!.wallets.last!.addresses.append(address)
                        
                        account!.wallets.last!.addresses.last!.spendableOutput.removeAll()
                        for ouput in address.spendableOutput {
                            account?.wallets.last!.addresses.last!.spendableOutput.append(ouput)
                        }
                    }
                }
                
                //                        acc!.wallets = newWallets
                //                        acc?.wallets = arrOfWallets
                completion(account, nil)
            }
        }
    }
    
    public func updateWalletsInAcc(arrOfWallets: List<UserWalletRLM>, completion: @escaping(_ account: AccountRLM?, _ error: NSError?)->()) {
        getRealm { (realmOpt, err) in
            if let realm = realmOpt {
                let acc = realm.object(ofType: AccountRLM.self, forPrimaryKey: 1)
                if acc != nil {
                    let accWallets = acc!.wallets
                    let newWallets = List<UserWalletRLM>()
                    
                    for wallet in arrOfWallets {
                        let modifiedWallet = accWallets.filter("walletID = \(wallet.walletID)").first
                        
                        try! realm.write {
                            if modifiedWallet != nil {
                                modifiedWallet!.addresses = wallet.addresses
                                newWallets.append(modifiedWallet!)
                            } else {
                                newWallets.append(wallet)
                            }
                        }
                    }
                    
                    //append wallets without spendOut
//                    for wallet in accWallets {
//                        let unmodifiedWallet = newWallets.filter("walletID = \(wallet.walletID)").first
//
//                        if (unmodifiedWallet == nil) {
//                            newWallets.append(wallet)
//                        }
//                    }
                    
                    try! realm.write {
                        acc!.wallets.removeAll()
                        for wallet in newWallets {
                            acc!.wallets.append(wallet)
                            
                            acc!.wallets.last!.addresses.removeAll()
                            for address in wallet.addresses {
                                acc!.wallets.last!.addresses.append(address)
                                
                                acc!.wallets.last!.addresses.last!.spendableOutput.removeAll()
                                for ouput in address.spendableOutput {
                                    acc?.wallets.last!.addresses.last!.spendableOutput.append(ouput)
                                }
                            }
                        }
                        
//                        acc!.wallets = newWallets
//                        acc?.wallets = arrOfWallets
                        completion(acc, nil)
                    }
                } else {
                    completion(nil, err)
                }
            }
        }
    }
    
    public func clearRealm() {
        getRealm { (realmOpt, err) in
            if let realm = realmOpt {
                try! realm.write {
                    realm.deleteAll()
                }
            }
        }
    }
    
    // MARK: - Migrations
    func migrateFrom6To7(with migration: Migration) {
        // Add an email property
        migration.enumerateObjects(ofType: SpendableOutputRLM.className()) { (_, newSpendOut) in
            newSpendOut?["addressID"] = NSNumber(value: 0)
        }
    }
    
    //Greedy algorithm
    func spendableOutput(addresses: List<AddressRLM>) -> [SpendableOutputRLM] {
        let ouputs = List<SpendableOutputRLM>()
        
        for address in addresses {
            //add checking output (in/out)
            
            for out in address.spendableOutput {
                ouputs.append(out)
            }
        }
        
        let results = ouputs.sorted(by: { (out1, out2) -> Bool in
            out1.transactionOutAmount.uint32Value > out2.transactionOutAmount.int32Value
        })
        
        return results
    }
    
    func spendableOutput(wallet: UserWalletRLM) -> [SpendableOutputRLM] {
        let ouputs = List<SpendableOutputRLM>()
        
        let addresses = wallet.addresses
        for address in addresses {
            //add checking output (in/out)
            
            for out in address.spendableOutput {
                ouputs.append(out)
            }
        }
        
        let results = ouputs.sorted(by: { (out1, out2) -> Bool in
            out1.transactionOutAmount.uint32Value > out2.transactionOutAmount.int32Value
        })
        
        return results
    }
    
    func greedySubSet(outputs: [SpendableOutputRLM], threshold: UInt32) -> [SpendableOutputRLM] {
        var sum = spendableOutputSum(outputs: outputs)
        var result = outputs
        
        if sum < threshold {
            return [SpendableOutputRLM]()
        }
        
        var index = 0
        while index < result.count {
            let output = result[index]
            if sum > threshold + output.transactionOutAmount.uint32Value {
                sum = sum - output.transactionOutAmount.uint32Value
                result.remove(at: index)
            } else {
                index += 1
            }
        }
        
        return result
    }
    
    func spendableOutputSum(outputs: [SpendableOutputRLM]) -> UInt32 {
        var sum = UInt32(0)
        
        for output in outputs {
            sum += output.transactionOutAmount.uint32Value
        }
        
        return sum
    }
}
