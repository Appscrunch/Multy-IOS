//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class ExchangeStocksPresenter: NSObject {

    var mainVC: ExchangeStocksViewController?
    var arr = [ExchangeStockObj]()
    
    var availableArr = [ExchangeStockObj]()
    
    func createStocks() {
        let binanceStock = ExchangeStockObj()
        binanceStock.name = "Binance"
        self.arr.append(binanceStock)
        
        let okexStock = ExchangeStockObj()
        okexStock.name = "OKEx"
        self.arr.append(okexStock)
        
        let huobiStock = ExchangeStockObj()
        huobiStock.name = "Huobi"
        self.arr.append(huobiStock)
        
        let upbitStock = ExchangeStockObj()
        upbitStock.name = "Upbit"
        self.arr.append(upbitStock)
        
        let bitfinexStock = ExchangeStockObj()
        bitfinexStock.name = "Bitfinex"
        self.arr.append(bitfinexStock)
        
        let bittrexStock = ExchangeStockObj()
        bittrexStock.name = "Bittrex"
        self.arr.append(bittrexStock)
        
        let bitthumbStock = ExchangeStockObj()
        bitthumbStock.name = "Bithumb"
        self.arr.append(bitthumbStock)
        
        let gdaxStock = ExchangeStockObj()
        gdaxStock.name = "GDAX"
        self.arr.append(gdaxStock)
        
        let krakenStock = ExchangeStockObj()
        krakenStock.name = "Kraken"
        self.arr.append(krakenStock)
        
        let hitBtcStock = ExchangeStockObj()
        hitBtcStock.name = "HitBTC"
        self.arr.append(hitBtcStock)
        
        let poloniexStock = ExchangeStockObj()
        poloniexStock.name = "Poloniex"
        self.availableArr.append(poloniexStock)
    }
    
}
