//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class FastOperationsPresenter: NSObject {

    var fastOperationsVC: FastOperationsViewController?
    
    func getExchange() {
        DataManager.shared.getExchangeCourse()
    }
    
}
