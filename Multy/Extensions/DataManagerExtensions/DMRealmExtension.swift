//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import Foundation

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
                      completion: @escaping (_ wallet: WalletRLM?, _ error: NSError?) -> ()) {
        realmManager.createWallet(walletDict) { (wallet, error) in
            completion(wallet, error)
        }
    }
    
    func getExchangePrice(completion: @escaping (_ exchangePrice : ExchangePriceRLM?, _ error: NSError?) -> ())  {
        realmManager.getExchangePrice { (exchangePrice, error) in
            completion(exchangePrice, error)
        }
    }
}
