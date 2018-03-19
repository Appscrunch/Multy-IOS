//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class CurrencyObj: NSObject {
    
    var currencyImgName = ""
    var currencyShortName = ""
    var currencyFullName = ""
    var currencyBlockchain = BlockchainType.create(currencyID: 0, netType: 0)
    
    class func createCurrencyObj(blockchain: BlockchainType) -> CurrencyObj {
        let currencyObj = CurrencyObj()
        currencyObj.currencyBlockchain = blockchain
        currencyObj.currencyImgName = blockchain.iconString
        currencyObj.currencyShortName = blockchain.shortName
        currencyObj.currencyFullName = blockchain.fullName
        
        return currencyObj
    }
}
