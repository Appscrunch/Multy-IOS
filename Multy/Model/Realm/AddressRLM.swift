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
    @objc dynamic var address = String()                //Double
    @objc dynamic var amount = NSNumber(value: 0)       //UInt32
    
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
        
        if let addressID = addressInfo["AddressID"]  {
            addressRLM.addressID = NSNumber(value: addressID as! UInt32)
        }
        
        if let addressString = addressInfo["Address"] {
            addressRLM.address = addressString as! String
        }
        
        if let amount = addressInfo["Amount"] {
            addressRLM.amount = NSNumber(value: amount as! UInt32)
        }
        
        return addressRLM
    }
}
