//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class SendFinishPresenter: NSObject {

    var sendFinishVC: SendFinishViewController?
    
    var walletFrom: WalletRLM?
    
    var addressToStr: String?
    
    var selectedSpeedIndex: Int?
    
    var sumInCrypto: Double?
    var sumInFiat: Double?
    var cryptoName: String?
    var fiatName: String?
    
    var transactionObj: TransactionRLM?
}
