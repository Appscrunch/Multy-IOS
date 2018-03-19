//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import Foundation

extension Dictionary {
    // dictionary key looks like "currencyid " + "networkid"
    static func createTopIndexes(indexesDict: Array<Dictionary<String, UInt32>>) -> Dictionary<String, UInt32> {
        var indexes = Dictionary<String, UInt32>()
        
        for index in indexesDict {
            indexes["\(index["currencyid"]!) \(index["networkid"]!)"] = index["topindex"]!
        }
        
        return indexes
    }
}

extension Dictionary where Dictionary == Dictionary<String, UInt32> {
    func getTopIndex(currencyID: UInt32, networkID: UInt32) -> UInt32 {
        return self["\(currencyID) \(networkID)"]!
    }
}
