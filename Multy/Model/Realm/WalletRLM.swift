//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import Foundation
import RealmSwift

class WalletRLM: Object {
    @objc dynamic var identifier = String()
    
    @objc dynamic var currencyID = NSNumber(value: 0)       //UInt32
    @objc dynamic var walletID = NSNumber(value: 0)         //UInt32
    @objc dynamic var addressID = NSNumber(value: 0)        //UInt32
    
    @objc dynamic var name = String()
    @objc dynamic var cryptoName = String()  //like BTC
    @objc dynamic var sumInCrypto: Double = 0.0
    @objc dynamic var sumInFiat: Double = 0.0
    @objc dynamic var fiatName = String()
    @objc dynamic var fiatSymbol = String()
    
    @objc dynamic var address = String()
    
    @objc dynamic var privateKey = String()
    @objc dynamic var publicKey = String()
    
    @objc dynamic var seedPhrase = String()
    @objc dynamic var rootKey = String()
    
    override class func primaryKey() -> String? {
        return "identifier"
    }
    
    public class func initWithDictionary(_ dictionary: Dictionary<String, Any>) -> WalletRLM {
        let wallet = WalletRLM()
        
        wallet.currencyID = NSNumber(value: dictionary["currencyID"] as! UInt32)
        wallet.walletID = NSNumber(value: dictionary["walletID"] as! UInt32)
        wallet.addressID = NSNumber(value: dictionary["addressID"] as! UInt32)
        
        if dictionary["name"] != nil {
            wallet.name = dictionary["name"] as! String
        }
        
        if dictionary["cryptoName"] != nil {
            wallet.cryptoName = dictionary["cryptoName"] as! String
        }
        
        if dictionary["sumInCrypto"] != nil {
            wallet.sumInCrypto = dictionary["sumInCrypto"] as! Double
        }
        
        if dictionary["sumInFiat"] != nil {
            wallet.sumInFiat = dictionary["sumInFiat"] as! Double
        }
        
        if dictionary["fiatName"] != nil {
            wallet.fiatName = dictionary["fiatName"] as! String
        }
        
        if dictionary["fiatSymbol"] != nil {
            wallet.fiatSymbol = dictionary["fiatSymbol"] as! String
        }
        
        if dictionary["address"] != nil {
            wallet.address = dictionary["address"] as! String
        }
        
        if dictionary["privateKey"] != nil {
            wallet.privateKey = dictionary["privateKey"] as! String
        }
        
        if dictionary["publicKey"] != nil {
            wallet.publicKey = dictionary["publicKey"] as! String
        }
        
        return WalletRLM()
    }
}
