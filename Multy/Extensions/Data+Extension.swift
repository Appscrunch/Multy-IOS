//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import Foundation

extension Data {
    var bytes : [UInt8] {
        return [UInt8](self)
    }
    
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
    
    init?(hexString: String) {
        let len = hexString.count / 2
        var data = Data(capacity: len)
        for i in 0..<len {
            let j = hexString.index(hexString.startIndex, offsetBy: i*2)
            let k = hexString.index(j, offsetBy: 2)
            let bytes = hexString[j..<k]
            if var num = UInt8(bytes, radix: 16) {
                data.append(&num, count: 1)
            } else {
                return nil
            }
        }
        
        self = data
    }
    
    static func generateRandom64ByteData() -> Data? {
        
        var keyData = Data(count: 64)
        let result = keyData.withUnsafeMutableBytes {
            SecRandomCopyBytes(kSecRandomDefault, keyData.count, $0)
        }
        if result == errSecSuccess {
            print("keyData:\(keyData.base64EncodedString())")
            return keyData
        } else {
            print("Problem generating random bytes")
            return nil
        }
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

