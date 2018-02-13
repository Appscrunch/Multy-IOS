//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import Foundation

class TransactionDTO: NSObject {
    var currencyID : NSNumber? {
        didSet {
            createTransactionDTO()
        }
    }
    
    var transactionDTO: BaseTransactionDTO?
    
    func createTransactionDTO() {
        switch currencyID?.uint32Value {
        case CURRENCY_BITCOIN.rawValue?:
            transactionDTO = BTCTransactionDTO()
        case CURRENCY_ETHEREUM.rawValue?:
            transactionDTO = ETHTransactionDTO()
        default:
            transactionDTO = BTCTransactionDTO()
        }
    }
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
