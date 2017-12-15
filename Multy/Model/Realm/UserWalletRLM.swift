//
//  UserWalletRLM.swift
//  Multy
//
//  Created by MacBook on 06.12.2017.
//Copyright © 2017 Idealnaya rabota. All rights reserved.
//

import Foundation
import RealmSwift

class UserWalletRLM: Object {
    @objc dynamic var id = String()    //
    @objc dynamic var chain = NSNumber(value: 0)    //UInt32
    @objc dynamic var walletID = NSNumber(value: 0) //UInt32
    @objc dynamic var addressID = NSNumber(value: 0) //UInt32
    
    @objc dynamic var privateKey = String()
    @objc dynamic var publicKey = String()
    
    @objc dynamic var name = String()
    @objc dynamic var cryptoName = String()  //like BTC
    @objc dynamic var sumInCrypto: Double = 0.0 {
        didSet {
            sumInFiat = sumInCrypto * exchangeCourse
        }
    }
    @objc dynamic var sumInFiat: Double = 0.0
    @objc dynamic var fiatName = String()
    @objc dynamic var fiatSymbol = String()
    
    @objc dynamic var address = String()
    
    var addresses = List<AddressRLM>() {
        didSet {
            var sum : UInt32 = 0
            
            for address in addresses {
                sum += address.amount.uint32Value
            }
            
            sumInCrypto = Double(sum) / 100000000.0
            
            address = addresses.last?.address ?? ""
        }
    }
    
    public class func initWithArray(walletsInfo: NSArray) -> List<UserWalletRLM> {
        let wallets = List<UserWalletRLM>()
        
        for walletInfo in walletsInfo {
            let wallet = UserWalletRLM.initWithInfo(walletInfo: walletInfo as! NSDictionary)
            wallets.append(wallet)
        }
        
        return wallets
    }
    
    public class func initWithInfo(walletInfo: NSDictionary) -> UserWalletRLM {
        let wallet = UserWalletRLM()
        
        if let chain = walletInfo["CurrencyID"]  {
            wallet.chain = NSNumber(value: chain as! UInt32)
        }
        
        if let walletID = walletInfo["WalletIndex"]  {
            wallet.walletID = NSNumber(value: walletID as! UInt32)
        }
        
        if let walletID = walletInfo["walletindex"]  {
            wallet.walletID = NSNumber(value: walletID as! UInt32)
        }
        
        if walletInfo["CurrencyID"] != nil && walletInfo["WalletIndex"] != nil {
            wallet.id = generateWalletPrimaryKey(currencyID: wallet.chain.uint32Value, walletID: wallet.walletID.uint32Value)
        }
        
        if let addresses = walletInfo["Adresses"] {
            wallet.addresses = AddressRLM.initWithArray(addressesInfo: addresses as! NSArray)
        }
        
        if let addresses = walletInfo["addresses"] {
            wallet.addresses = AddressRLM.initWithArray(addressesInfo: addresses as! NSArray)
        }
        
        if let name = walletInfo["WalletName"] {
            wallet.name = name as! String
        }
        
        wallet.cryptoName = "BTC"
        wallet.fiatName = "USD"
        wallet.fiatSymbol = "$"
        
        return wallet
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
