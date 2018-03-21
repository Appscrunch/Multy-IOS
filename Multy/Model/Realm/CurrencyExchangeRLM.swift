//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import RealmSwift

class CurrencyExchangeRLM: Object {
    
    @objc dynamic var id: NSNumber = 1
    @objc dynamic var btcToUSD: Double = 1.0
    @objc dynamic var ethToUSD: Double = 1.0
    
    func createCurrencyExchange(currencyExchange: CurrencyExchange) {
//        let curEchange = CurrencyExchangeRLM()
        self.btcToUSD = currencyExchange.btcToUSD
        self.ethToUSD = currencyExchange.ethToUSD
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
