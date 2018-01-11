//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

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
