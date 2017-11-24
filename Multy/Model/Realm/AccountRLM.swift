//
//  AccountRLM.swift
//  Multy
//
//  Created by MacBook on 23.11.2017.
//Copyright © 2017 Idealnaya rabota. All rights reserved.
//

import Foundation
import RealmSwift

class AccountRLM: Object {
    @objc dynamic var expireDateString = String()
    @objc dynamic var token = String()
    @objc dynamic var id: NSNumber = 1
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
