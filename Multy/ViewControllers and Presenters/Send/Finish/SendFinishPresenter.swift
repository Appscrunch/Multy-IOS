//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class SendFinishPresenter: NSObject {

    var sendFinishVC: SendFinishViewController?
    var transactionDTO = TransactionDTO() {
        didSet {
            cryptoName = transactionDTO.choosenWallet!.cryptoName
        }
    }
    
    var account = DataManager.shared.realmManager.account
    
    var selectedSpeedIndex: Int?
    
    var sumInCrypto: Double?
    var sumInFiat: Double?
    var cryptoName: String?
    var fiatName: String = "USD"//MARK: get from settingds
    
    var isCrypto = true
    
    func makeEndSum() {
        switch self.isCrypto {
        case true:
            self.sumInCrypto = transactionDTO.transaction?.endSum
            self.sumInFiat = self.sumInCrypto! * exchangeCourse
        case false:
            self.sumInFiat = transactionDTO.transaction?.endSum
            self.sumInCrypto = self.sumInFiat!
        }
    }
}
