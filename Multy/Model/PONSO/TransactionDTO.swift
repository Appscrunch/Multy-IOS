//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import Foundation

class TransactionDTO: NSObject {
    var currencyID : NSNumber? {
        didSet {
            
        }
    }
    
    var transactionDTO: BaseTransactionDTO?
}

class BaseTransactionDTO {
    var sendAddress : String?
    
}

class BTCTransactionDTO: BaseTransactionDTO {
    
    
}

class ETHTransactionDTO: BaseTransactionDTO {
    
}

class GOLOSTransactionDTO: BaseTransactionDTO {
    
}
