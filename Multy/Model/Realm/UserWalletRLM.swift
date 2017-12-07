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
//    @objc dynamic var id = NSNumber(value: 0)     //UInt32
    @objc dynamic var chain = NSNumber(value: 0)    //UInt32
    @objc dynamic var walletID = NSNumber(value: 0) //UInt32
    var addresses = List<AddressRLM>()
    
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
        
        if let chain = walletInfo["Chain"]  {
            wallet.chain = NSNumber(value: chain as! UInt32)
        }
        
        if let walletID = walletInfo["WalletID"] {
            wallet.walletID = NSNumber(value: walletID as! UInt32)
        }
        
        if let addresses = walletInfo["Address"] {
            wallet.addresses = AddressRLM.initWithArray(addressesInfo: addresses as! NSArray)
        }
        
        return wallet
    }
    
//    override class func primaryKey() -> String? {
//        return "identifier"
//    }
}
