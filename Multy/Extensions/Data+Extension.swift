//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import Foundation

extension Data {
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}

extension BinaryData {
    func convertToData() -> Data {
        return Data(bytes: self.data, count: self.len)
    }
    
    func convertToHexString() -> String {
        return Data(bytes: self.data, count: self.len).hexEncodedString()
    }
}

