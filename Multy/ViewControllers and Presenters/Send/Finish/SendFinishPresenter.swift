//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class SendFinishPresenter: NSObject {

    var sendFinishVC: SendFinishViewController?
    var transactionDTO = TransactionDTO() {
        didSet {
            cryptoName = transactionDTO.blockchainType?.shortName
        }
    }
    
    var account = DataManager.shared.realmManager.account
    
    var selectedSpeedIndex: Int?
    
    var sumInCrypto: Double?
    var sumInCryptoString = String()
    var sumInFiat: Double?
    var sumInFiatString = String()
    var cryptoName: String?
    var fiatName: String = "USD" // MARK: get from settings
    
    var isCrypto = true
    
    func makeEndSum() {
        switch isCrypto {
        case true:
            if transactionDTO.choosenWallet!.blockchain.blockchain == BLOCKCHAIN_BITCOIN {
                sumInCrypto = transactionDTO.transaction?.endSum
                sumInCryptoString = sumInCrypto!.fixedFraction(digits: 8)
                sumInFiat = sumInCrypto! * transactionDTO.choosenWallet!.exchangeCourse
                sumInFiatString = sumInFiat!.fixedFraction(digits: 2)
            } else if transactionDTO.choosenWallet!.blockchain.blockchain == BLOCKCHAIN_ETHEREUM {
                sumInCryptoString = transactionDTO.transaction!.endSumBigInt!.cryptoValueString(for: BLOCKCHAIN_ETHEREUM)
                sumInFiatString = (transactionDTO.transaction!.endSumBigInt! * transactionDTO.choosenWallet!.exchangeCourse).fiatValueString
            }
            
        case false:
            self.sumInFiat = transactionDTO.transaction?.endSum
            self.sumInCrypto = self.sumInFiat!
        }
    }
    
    func makeFrameForSlider() -> CGRect {
        let y = self.sendFinishVC!.scrollView.contentSize.height - 64    // 64 - height of send btn
        let frame = CGRect(x: 0, y: y, width: screenWidth, height: 64.0)
        
        return frame
    }
}
