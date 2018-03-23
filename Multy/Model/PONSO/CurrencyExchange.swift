//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class CurrencyExchange: NSObject {
    
//    static let shared = CurrencyExchange()
    
//    var exchangeCourse: Double = 1.0 {
//        didSet {
//            NotificationCenter.default.post(name: NSNotification.Name("exchageUpdated"), object: nil)
//        }
//    }

    var btcToUSD: Double = 1.0
    var ethToUSD: Double = 1.0
    
    func update(exchangeDict: NSDictionary) {
        NotificationCenter.default.post(name: NSNotification.Name("exchageUpdated"), object: nil)
        if let btcUsd = exchangeDict["btc_usd"] as? Double {
            btcToUSD = btcUsd
        }
        
        if let ethUsd = exchangeDict["eth_usd"] as? Double {
            ethToUSD = ethUsd
        }
    }
    
    func update(currencyExchangeRLM: CurrencyExchangeRLM) {
        btcToUSD = currencyExchangeRLM.btcToUSD
        ethToUSD = currencyExchangeRLM.ethToUSD
    }
}
