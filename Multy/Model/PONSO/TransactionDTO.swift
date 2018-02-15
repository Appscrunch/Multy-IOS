//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import Foundation
import RealmSwift

class TransactionDTO: NSObject {
    var sendAddress : String?
    var sendAmount: Double?
    var choosenWallet: UserWalletRLM? {
        didSet {
            if choosenWallet != nil {
                currencyID = choosenWallet?.chain
            }
        }
    }
    
    var currencyID : NSNumber? {
        didSet {
            createTransactionDTO()
        }
    }
    
    var transaction: BaseTransactionDTO?
    
    func createTransactionDTO() {
        switch currencyID?.uint32Value {
        case CURRENCY_BITCOIN.rawValue?:
            transaction = BTCTransactionDTO()
        case CURRENCY_ETHEREUM.rawValue?:
            transaction = ETHTransactionDTO()
        default:
            transaction = BTCTransactionDTO()
        }
    }
    
    
}

class BaseTransactionDTO {
    var finalSendSum: Double?
    var donationDTO: DonationDTO?
    var transactionRLM: TransactionRLM?
    var historyArray: List<HistoryRLM>?
    var customFee: UInt32?
    var rawTransaction: String?
    var newChangeAddress: String?
    var endSum: Double?
}

class BTCTransactionDTO: BaseTransactionDTO {
    
}

class ETHTransactionDTO: BaseTransactionDTO {
    
}

class GOLOSTransactionDTO: BaseTransactionDTO {
    
}
