//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class TransactionPresenter: NSObject {
    var transctionVC: TransactionViewController?
    
    let receiveBackColor = UIColor(red: 95/255, green: 204/255, blue: 125/255, alpha: 1.0)
    let sendBackColor = UIColor(red: 0/255, green: 183/255, blue: 255/255, alpha: 1.0)
    
    var histObj = HistoryRLM()
    var chainId = 0
    
    func blockedAmount(for transaction: HistoryRLM) -> UInt32 {
        var sum = UInt32(0)
        
        if transaction.txStatus.intValue == TxStatus.MempoolIncoming.rawValue {
            sum += transaction.txOutAmount.uint32Value
        } else if transaction.txStatus.intValue == TxStatus.MempoolOutcoming.rawValue {
            for tx in transaction.txOutputs {
                sum += tx.amount.uint32Value
            }
        }
        
        return sum
    }
}


