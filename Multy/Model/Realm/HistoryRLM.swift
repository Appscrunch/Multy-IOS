//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import RealmSwift

class HistoryRLM: Object {
    
    @objc dynamic var address = String()
    @objc dynamic var blockHeight = Int()
    @objc dynamic var blockTime = Date()
    @objc dynamic var btcToUsd = Double()
    @objc dynamic var txFee: NSNumber = 0
    @objc dynamic var txHash = String()
    @objc dynamic var txId = String()
    var txInputs = List<TxHistoryRLM>()
    @objc dynamic var txOutAmount: NSNumber = 0
    @objc dynamic var txOutId = Int()
    var txOutputs = List<TxHistoryRLM>()
    @objc dynamic var txOutScript = String()
    @objc dynamic var txStatus = NSNumber(value: 0)
    @objc dynamic var walletIndex = NSNumber(value: 0)
    
    
    public class func initWithArray(historyArr: NSArray) -> List<HistoryRLM> {
        let history = List<HistoryRLM>()
        
        for obj in historyArr {
            let histElement = HistoryRLM.initWithInfo(historyDict: obj as! NSDictionary)
            history.append(histElement)
        }
        
        return history
    }
    
    public class func initWithInfo(historyDict: NSDictionary) -> HistoryRLM {
        let hist = HistoryRLM()
        
//        if let address = txHistory["address"] {
//            txHist.address = address as! String
//        }
        if let address = historyDict["address"] {
            hist.address = address as! String
        }
        
        if let blockheight = historyDict["blockheight"] {
            hist.blockHeight = blockheight as! Int
        }
        
        if let blocktime = historyDict["blocktime"] {
            hist.blockTime = NSDate(timeIntervalSince1970: (blocktime as! Double)) as Date
        }
        
        if let btctousd = historyDict["btctousd"] {
            hist.btcToUsd = btctousd as! Double
        }
        
        if let txfee = historyDict["txfee"] {
            hist.txFee = txfee as! NSNumber
        }
        
        if let txhash = historyDict["txhash"] {
            hist.txHash = txhash as! String
        }
        
        if let txid = historyDict["txid"] {
            hist.txId = txid as! String
        }
        
        if let txinputs = historyDict["txinputs"] {
            hist.txInputs = TxHistoryRLM.initWithArray(txHistoryArr: txinputs as! NSArray)
        }

        if let txoutamount = historyDict["txoutamount"] {
            hist.txOutAmount = txoutamount as! NSNumber
        }
        
        if let txoutid = historyDict["txoutid"] {
            hist.txOutId = txoutid as! Int
        }
        
        if let txoutputs = historyDict["txoutputs"] {
            hist.txOutputs = TxHistoryRLM.initWithArray(txHistoryArr: txoutputs as! NSArray)
        }

        if let txoutscript = historyDict["txoutscript"] {
            hist.txOutScript = txoutscript as! String
        }
        
        if let txstatus = historyDict["txstatus"] {
            hist.txStatus = txstatus as! NSNumber
        }
        
        if let walletindex = historyDict["walletindex"] {
            hist.walletIndex = walletindex as! NSNumber
        }
        
        return hist
    }
    
    override class func primaryKey() -> String? {
        return "txId"
    }
}
