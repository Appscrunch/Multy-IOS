//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import Foundation
import RealmSwift

extension DataManager {
    func writeSeedPhrase(_ seedPhrase : String, completion: @escaping (_ error: NSError?) -> ()) {
        realmManager.writeSeedPhrase(seedPhrase) { (error) in
            completion(error)
        }
    }
    
    func deleteSeedPhrase(completion: @escaping (_ error: NSError?) -> ()) {
        realmManager.deleteSeedPhrase { (error) in
            completion(error)
        }
    }
    
    func getSeedPhrase(completion: @escaping (_ seedPhrase: String?, _ error: NSError?) -> ()) {
        realmManager.getSeedPhrase { (seedPhrase, error) in
            completion(seedPhrase, error)
        }
    }
    
    func createWallet(from walletDict: Dictionary<String, Any>,
                      completion: @escaping (_ wallet: UserWalletRLM?, _ error: NSError?) -> ()) {
        realmManager.createWallet(walletDict) { (wallet, error) in
            completion(wallet, error)
        }
    }
    
    func getExchangePrice(completion: @escaping (_ exchangePrice : ExchangePriceRLM?, _ error: NSError?) -> ())  {
        realmManager.getExchangePrice { (exchangePrice, error) in
            completion(exchangePrice, error)
        }
    }
    
    func getAccount(completion: @escaping (_ acc: AccountRLM?, _ error: NSError?) -> ()) {
        realmManager.getAccount { (acc, err) in
            completion(acc, err)
        }
    }
    
    func updateAccount(_ accountDict: NSDictionary, completion: @escaping (_ account : AccountRLM?, _ error: NSError?) -> ()) {
        realmManager.updateAccount(accountDict) { (account, error) in
            completion(account, error)
        }
    }
    
    func clearDB(completion: @escaping (_ error: NSError?) -> ()) {
        realmManager.clearRealm()
        completion(nil)
    }
    
    func finishRealmSession() {
        realmManager.finishRealmSession()
    }
    
    func fetchSpendableOutput(wallet: UserWalletRLM) -> [SpendableOutputRLM] {
        return realmManager.spendableOutput(wallet: wallet)
    }
    
    func greedySubSet(outputs: [SpendableOutputRLM], threshold: Double) -> [SpendableOutputRLM] {
        return realmManager.greedySubSet(outputs: outputs, threshold: threshold)
    }
    
    func spendableOutputSum(outputs: [SpendableOutputRLM]) -> UInt32 {
        return realmManager.spendableOutputSum(outputs: outputs)
    }
}
