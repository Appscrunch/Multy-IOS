//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class ReceiveAllDetailsPresenter: NSObject, ReceiveSumTransferProtocol {

    var receiveAllDetailsVC: ReceiveAllDetailsViewController?
    
    func transferSum(amount: Double, currency: String, additionalInfo: String) {
        self.receiveAllDetailsVC!.requestSumBtn.titleLabel?.isHidden = true
        self.receiveAllDetailsVC!.sumValueLbl.text = "\(amount)"
        self.receiveAllDetailsVC!.sumValueLbl.isHidden = false
        self.receiveAllDetailsVC!.cryptoNameLbl.text = currency
        self.receiveAllDetailsVC!.cryptoNameLbl.isHidden = false
        self.receiveAllDetailsVC!.fiatSumAndNameLbl.text = additionalInfo
        self.receiveAllDetailsVC!.fiatSumAndNameLbl.isHidden = false
    }
}
