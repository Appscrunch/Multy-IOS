//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class BlockchainsPresenter: NSObject {
    
    var mainVC: BlockchainsViewController?
    var donateBlockchainArray = [CurrencyObj]()
    var availableBlockchainArray = [CurrencyObj]()
    var selectedBlockchain = BlockchainType.create(currencyID: 0, netType: 0)
    
    func createChains() {
        createAvailableChains()
        createDonationChains()
    }
    
    private func createAvailableChains() {
        addCurrencyObjects(blockchainArray: Constants.DataManager.availableBlockchains, into: &availableBlockchainArray)
    }
    
    private func createDonationChains() {
        addCurrencyObjects(blockchainArray: Constants.DataManager.donationBlockchains, into: &donateBlockchainArray)
    }
    
    private func addCurrencyObjects(blockchainArray: [BlockchainType], into array: inout [CurrencyObj]) {
        for blockchain in blockchainArray {
            let currencyObj = CurrencyObj.createCurrencyObj(blockchain: blockchain)
            array.append(currencyObj)
        }
    }
}
