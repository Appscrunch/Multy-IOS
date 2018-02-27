//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class DonationSendPresenter: NSObject, CustomFeeRateProtocol {

    var mainVC: DonationSendViewController?
    
    var selectedIndexOfSpeed: Int?
    
    var customFee = UInt32(20)
    
    var feeRate: NSDictionary? {
        didSet {
            mainVC?.tableView.reloadData()
        }
    }
    
    func customFeeData(firstValue: Double, secValue: Double) {
        print(firstValue)
        if selectedIndexOfSpeed != 5 {
            selectedIndexOfSpeed = 5
        }
        let cell = self.mainVC?.tableView.cellForRow(at: [0, selectedIndexOfSpeed!]) as! CustomTrasanctionFeeTableViewCell
        cell.value = firstValue
        cell.setupUIForBtc()
        self.customFee = UInt32(firstValue)
        self.mainVC?.tableView.reloadData()
//        sendDetailsVC?.sendAnalyticsEvent(screenName: "\(screenTransactionFeeWithChain)\(transactionDTO.choosenWallet!.chain)", eventName: customFeeSetuped)
    }
}
