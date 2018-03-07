//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class ReceiveAmountPresenter: NSObject {

    var receiveAmountVC: ReceiveAmountViewController?
    
    
    func getMaxValueOfChain(curency: Blockchain) -> Double {
        switch curency {
        case BLOCKCHAIN_BITCOIN:
            return 21000000.0 // 21 mln
        case BLOCKCHAIN_ETHEREUM:
            return 100000000.0 // 100 mln
        default:
            return 1.0
        }
    }
}
