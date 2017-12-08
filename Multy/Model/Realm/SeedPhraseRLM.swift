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
    
    public class func initWithInfo(seedPhraseInfo: NSDictionary) -> SeedPhraseRLM {
        let seedPhrase = SeedPhraseRLM()
        
        if let seedString = seedPhraseInfo["seedString"]  {
            seedPhrase.seedString = seedString as! String
        }
        
        if let seedData = seedPhraseInfo["seedData"]  {
            seedPhrase.seedData = seedData as! Data
        }
        
        return seedPhrase
    }
}
