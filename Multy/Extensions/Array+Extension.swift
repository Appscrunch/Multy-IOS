//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import Foundation

extension Array where Element == UInt8 {
    var data: Data {
        return Data(bytes:(self))
    }
    
    var nsData: NSData {
        return NSData(bytes: self, length: self.count)
    }
}
