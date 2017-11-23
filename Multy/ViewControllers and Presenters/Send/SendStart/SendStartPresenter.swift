//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class SendStartPresenter: NSObject, CancelProtocol, SendAddressProtocol {
    
    var sendStartVC: SendStartViewController?
    
    var adressSendTo = ""
    
    func cancelAction() {
        self.sendStartVC?.navigationController?.popViewController(animated: true)
    }
    
    func sendAddress(address: String) {
        self.adressSendTo = address
        self.sendStartVC?.makeAvailableNextBtn()
    }
}
