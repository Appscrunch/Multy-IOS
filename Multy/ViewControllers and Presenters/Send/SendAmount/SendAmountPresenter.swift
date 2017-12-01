//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class SendAmountPresenter: NSObject {
    var sendAmountVC: SendAmountViewController?
    
    var exchangeCourse: Double = 10239.0 // usd for 1 BTC
    
    var wallet: WalletRLM?
    
    var addressToStr: String?
    
    var selectedSpeedIndex: Int?
    
    var transactionObj: TransactionRLM?
}
