//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import Foundation
import RealmSwift

class TopIndexRLM: Object {
    @objc dynamic var currencyID = NSNumber(value: 0)
    @objc dynamic var networkID = NSNumber(value: 0)
    @objc dynamic var topIndex = NSNumber(value: 0)
    
    public class func initWithArray(indexesArray: NSArray) -> List<TopIndexRLM> {
        let topIndexes = List<TopIndexRLM>()
        
        for index in indexesArray {
            let topIndex = TopIndexRLM.initWithInfo(indexDict: index as! NSDictionary)
            topIndexes.append(topIndex)
        }
        
        return topIndexes
    }
    
    public class func createDefaultIndex(currencyID: NSNumber, networkID: NSNumber, topIndex: NSNumber) -> TopIndexRLM {
        let newTopIndex = TopIndexRLM()
        newTopIndex.currencyID = currencyID
        newTopIndex.networkID = networkID
        newTopIndex.topIndex = topIndex
        
        return newTopIndex
    }
    
    public class func initWithInfo(indexDict: NSDictionary) -> TopIndexRLM {
        let topIndexRLM = TopIndexRLM()
        
        if let currencyID = indexDict["currencyid"] {
            topIndexRLM.currencyID = NSNumber(value: currencyID as! UInt64)
        }
        
        if let index = indexDict["networkid"] as? UInt32 {
            topIndexRLM.networkID = NSNumber(value: index)
        }
        
        if let index = indexDict["topindex"] as? UInt32 {
            topIndexRLM.topIndex = NSNumber(value: index)
        }
        
        return topIndexRLM
    }
}
