//
//  RecentAddressesRLM.swift
//  Multy
//
//  Created by MacBook on 21.12.2017.
//Copyright © 2017 Idealnaya rabota. All rights reserved.
//

import Foundation
import RealmSwift

class RecentAddressesRLM: Object {
    
    @objc dynamic var id = String()    //
    @objc dynamic var address = String()
    @objc dynamic var name = String()
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
// Logic
// after successful sendind temporary unconfirmed address become confirmed
// unconfirmed address will be the last - and no more then 1
