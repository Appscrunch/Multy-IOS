//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import Foundation
import RealmSwift

class AccountRLM: Object {
    @objc dynamic var seedPhrase = String()
    @objc dynamic var binaryData = NSData()
    
    @objc dynamic var deviceID = String()
    @objc dynamic var username = String()
    @objc dynamic var password = String()
    
    @objc dynamic var expireDateString = String()
    @objc dynamic var token = String()
    @objc dynamic var id: NSNumber = 1
    
    @objc dynamic var walletCount: NSNumber = 0
    var wallets = List<UserWalletRLM>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
