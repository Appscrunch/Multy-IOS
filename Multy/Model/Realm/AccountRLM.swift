//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import Foundation
import RealmSwift

class AccountRLM: Object {
    @objc dynamic var seedPhrase = String() {
        didSet {
            if seedPhrase != "" {
                self.backupSeedPhrase = seedPhrase
            }
        }
    }
    @objc dynamic var backupSeedPhrase = String()
    @objc dynamic var binaryDataString = String()
    
    @objc dynamic var userID = String()
    @objc dynamic var deviceID = String()
    @objc dynamic var deviceType = 1
    @objc dynamic var pushToken = String()
    
    @objc dynamic var expireDateString = String()
    @objc dynamic var token = String()
    @objc dynamic var id: NSNumber = 1
    
    @objc dynamic var walletCount: NSNumber = 0
    var wallets = List<UserWalletRLM>() {
        didSet {
            walletCount = NSNumber(value: wallets.count)
        }
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
