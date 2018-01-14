//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

enum StatusEnum: String {
    case createdTx = "createdTx"
    case fromSocketTx = "fromSocketTx"
    case incomingBlockedTx = "incoming in mempool"
    case spendedBlockedTx = "spend in mempool"
    case incomingTx = "incoming in block"
    case spendedTx = "spend in block"
    case inBlock = "in block confirmed"
    case rejected = "rejected block"
}
