//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import Foundation

protocol ReceiveSumTransferProtocol {
    func transferSum(cryptoAmount: Double, cryptoCurrency: String, fiatAmount: Double, fiatName: String)
}
