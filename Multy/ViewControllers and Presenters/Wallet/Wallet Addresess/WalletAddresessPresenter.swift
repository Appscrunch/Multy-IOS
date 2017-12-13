//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class WalletAddresessPresenter: NSObject {

    var addressesVC: WalletAddresessViewController?
    var wallet: UserWalletRLM?
    
    func numberOfAddress() -> Int{
        return (self.wallet?.addresses.count)!
    }
}
