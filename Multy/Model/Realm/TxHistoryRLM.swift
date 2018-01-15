//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import RealmSwift

class TxHistoryRLM: Object {
    
    @objc dynamic var address = String()
    @objc dynamic var amount: NSNumber = 0

    public class func initWithArray(txHistoryArr: NSArray) -> List<TxHistoryRLM> {
        let txHistory = List<TxHistoryRLM>()
        
        for obj in txHistoryArr {
            let txHist = TxHistoryRLM.initWithInfo(txHistory: obj as! NSDictionary)
            txHistory.append(txHist)
        }
        
        return txHistory
    }
    
    public class func initWithInfo(txHistory: NSDictionary) -> TxHistoryRLM {
        let txHist = TxHistoryRLM()
        
        if let address = txHistory["address"] {
            txHist.address = address as! String
        }
        
        if let amount = txHistory["amount"] {
            txHist.amount = amount as! NSNumber
        }
        
        return txHist
    }
    
}
