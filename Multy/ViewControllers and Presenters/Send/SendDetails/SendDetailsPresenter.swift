//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class SendDetailsPresenter: NSObject {

    var sendDetailsVC: SendDetailsViewController?
    
    var choosenWallet: WalletRLM?
    
    var selectedIndexOfSpeed: Int?
    
    var donationInCrypto: Double? = 0.0001
    var donationInFiat: Double?
}
