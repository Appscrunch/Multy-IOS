//
//  AddressRLM.swift
//  Multy
//
//  Created by MacBook on 06.12.2017.
//Copyright © 2017 Idealnaya rabota. All rights reserved.
//

import Foundation
import RealmSwift

class AddressRLM: Object {
    @objc dynamic var addressID = NSNumber(value: 0)    //UInt32
    @objc dynamic var currencyID = NSNumber(value: 0)   //UInt32
//    @objc dynamic var walletID = NSNumber(value: 0)     //UInt32
    
    @objc dynamic var address = String()                //Double
    @objc dynamic var amount = NSNumber(value: 0)       //UInt32
    
   @objc dynamic var spendableOutput = SpendableOutputRLM()
    
    public class func initWithArray(addressesInfo: NSArray) -> List<AddressRLM> {
        let addresses = List<AddressRLM>()
        
        for addressInfo in addressesInfo {
            let wallet = AddressRLM.initWithInfo(addressInfo: addressInfo as! NSDictionary)
            addresses.append(wallet)
        }
        
        return addresses
    }
    
    public class func initWithInfo(addressInfo: NSDictionary) -> AddressRLM {
        let addressRLM = AddressRLM()
        
        if let addressID = addressInfo["addressindex"]  {
            addressRLM.addressID = NSNumber(value: addressID as! UInt32)
        }
        
//        if let currencyID = addressInfo["currencyID"]  {
//            addressRLM.currencyID = NSNumber(value: currencyID as! UInt32)
//        }
        
//        if let walletID = addressInfo["walletID"]  {
//            addressRLM.walletID = NSNumber(value: walletID as! UInt32)
//        }
        
        if let addressString = addressInfo["address"] {
            addressRLM.address = addressString as! String
        }
        
        if let amount = addressInfo["amount"] {
            addressRLM.amount = NSNumber(value: amount as! UInt32)
        }
        
        if let spendableoutputs = addressInfo["spendableoutputs"] {
            addressRLM.spendableOutput = SpendableOutputRLM.initWithInfo(addressInfo: spendableoutputs as! NSDictionary)
        }
        
        return addressRLM
    }
}
