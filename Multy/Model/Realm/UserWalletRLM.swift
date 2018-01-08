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
        
        if let walletName = walletInfo["walletname"] {
            wallet.name = walletName as! String
        }
        
        //MARK: temporary only 0-currency
        //No data from server
        if walletInfo["walletindex"] != nil {
            wallet.id = generateWalletPrimaryKey(currencyID: 0, walletID: wallet.walletID.uint32Value)
        }
        
        wallet.updateWalletWithInfo(walletInfo: walletInfo)
        
        return wallet
    }
    
    public func updateWalletWithInfo(walletInfo: NSDictionary) {
        
        
        if let addresses = walletInfo["Adresses"] {
            self.addresses = AddressRLM.initWithArray(addressesInfo: addresses as! NSArray)
        }
        
        if let addresses = walletInfo["addresses"] {
            if !(addresses is NSNull) {
                self.addresses = AddressRLM.initWithArray(addressesInfo: addresses as! NSArray)
            }
        }
        
        if let name = walletInfo["WalletName"] {
            self.name = name as! String
        }
        
        self.cryptoName = "BTC"
        self.fiatName = "USD"
        self.fiatSymbol = "$"
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
