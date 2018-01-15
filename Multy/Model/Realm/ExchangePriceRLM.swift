//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import Foundation
import RealmSwift

class ExchangePriceRLM: Object {
    @objc dynamic var id: NSNumber = 1
    @objc dynamic var btcRate = NSNumber(value: 0.0)    //Double
    @objc dynamic var ethRate = NSNumber(value: 0.0)    //Double
    
    public class func initWithInfo(info: NSDictionary) -> ExchangePriceRLM {
        let exchangePrice = ExchangePriceRLM()
        
        if let btcRate = info["BTC"]  {
            exchangePrice.btcRate = btcRate as! NSNumber
        }
        
        if let ethRate = info["ETH"] {
            exchangePrice.ethRate = ethRate as! NSNumber
        }
        
        return exchangePrice
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }

}
