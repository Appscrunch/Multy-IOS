//
//  SeedPhraseRLM.swift
//  Multy
//
//  Created by MacBook on 22.11.2017.
//Copyright © 2017 Idealnaya rabota. All rights reserved.
//

import Foundation
import RealmSwift

class SeedPhraseRLM: Object {
    @objc dynamic var seedString = String()
    @objc dynamic var id: NSNumber = 1
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
