//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import Foundation

extension UInt64 {
    var btcValue: Double {
        return Double(self) / pow(10, 8)
    }
}
