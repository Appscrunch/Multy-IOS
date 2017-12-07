//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import Foundation
import RealmSwift

class SeedPhraseRLM: Object {
    @objc dynamic var seedString = String()
    @objc dynamic var seedData = Data()
    @objc dynamic var id: NSNumber = 1
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
