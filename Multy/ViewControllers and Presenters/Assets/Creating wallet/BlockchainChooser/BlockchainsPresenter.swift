//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class BlockchainsPresenter: NSObject {
    
    var mainVC: BlockchainsViewController?
    var arr = [CurrencyObj]()
    
    func createChains() {
//        let btc = CurrencyObj()
//        btc.currencyImgName = "BTC_medium_icon"
//        btc.currencyShortName = "BTC"
//        btc.currencyFullName = "Bitcoin"
//        self.arr.append(btc)
        
        let curForAppend = CurrencyObj()
        curForAppend.currencyImgName = "chainLbtc"
        curForAppend.currencyShortName = "LBTC"
        curForAppend.currencyFullName = "Bitcoin lightning"
        self.arr.append(curForAppend)
        
        let curForAppend2 = CurrencyObj()
        curForAppend2.currencyImgName = "chainEth"
        curForAppend2.currencyShortName = "ETH"
        curForAppend2.currencyFullName = "Ethereum"
        self.arr.append(curForAppend2)
        
        let curForAppend3 = CurrencyObj()
        curForAppend3.currencyImgName = "chainGolos"
        curForAppend3.currencyShortName = "GOLOS"
        curForAppend3.currencyFullName = "Golos"
        self.arr.append(curForAppend3)
        
        let curForAppend4 = CurrencyObj()
        curForAppend4.currencyImgName = "chainSteem"
        curForAppend4.currencyShortName = "STEEM"
        curForAppend4.currencyFullName = "Steem Dollars"
        self.arr.append(curForAppend4)
        
        let curForAppend5 = CurrencyObj()
        curForAppend5.currencyImgName = "chainBts"
        curForAppend5.currencyShortName = "BTS"
        curForAppend5.currencyFullName = "BitShares"
        self.arr.append(curForAppend5)
        
        let curForBitCash = CurrencyObj()
        curForBitCash.currencyImgName = "chainBch"
        curForBitCash.currencyShortName = "BCH"
        curForBitCash.currencyFullName = "Bitcoin Cash"
        self.arr.append(curForBitCash)
        
        let curForAppend6 = CurrencyObj()
        curForAppend6.currencyImgName = "chainLtc"
        curForAppend6.currencyShortName = "LTC"
        curForAppend6.currencyFullName = "Litecoin"
        self.arr.append(curForAppend6)
        
        let curForAppend7 = CurrencyObj()
        curForAppend7.currencyImgName = "chainDash"
        curForAppend7.currencyShortName = "DASH"
        curForAppend7.currencyFullName = "Dash"
        self.arr.append(curForAppend7)
        
        let curForAppend8 = CurrencyObj()
        curForAppend8.currencyImgName = "chainEtc"
        curForAppend8.currencyShortName = "ETC"
        curForAppend8.currencyFullName = "Ethereum Classic"
        self.arr.append(curForAppend8)
        
        let curForAppend9 = CurrencyObj()
        curForAppend9.currencyImgName = "chainErc20"
        curForAppend9.currencyShortName = "ERC20"
        curForAppend9.currencyFullName = "ERC20 Tokens"
        self.arr.append(curForAppend9)
        
    }
}
