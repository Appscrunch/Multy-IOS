//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import Foundation

struct BigInt {
    // main stored value
    var bigInt = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
    
    init(_ stringValue: String) {
        let mbi = make_big_int(stringValue.UTF8CStringPointer, bigInt)
        
        let _ = DataManager.shared.coreLibManager.errorString(from: mbi, mask: "\n\ninit big int\n\n")
    }
    
    func setBigInt(string: String) {
        let bisv = big_int_set_value(bigInt.pointee, string.UTF8CStringPointer)
        
        let _ = DataManager.shared.coreLibManager.errorString(from: bisv, mask: "\n\nbig int: set value\n\n")
    }
    
    // arithmetic methods
    func add(by right: BigInt) -> BigInt {
        let bia = big_int_add(bigInt.pointee, right.bigInt.pointee)
        
        let _ = DataManager.shared.coreLibManager.errorString(from: bia, mask: "\n\nbig int: add\n\n")
        
        return self
    }
    
    func subtract(by right: BigInt) -> BigInt {
        let bis = big_int_sub(bigInt.pointee, right.bigInt.pointee)
        
        let _ = DataManager.shared.coreLibManager.errorString(from: bis, mask: "\n\nsubtract int: add\n\n")
        
        return self
    }
    
    func multiply(by right: BigInt) -> BigInt {
        let bim = big_int_mul(bigInt.pointee, right.bigInt.pointee)
        
        let _ = DataManager.shared.coreLibManager.errorString(from: bim, mask: "\n\nbig int: multiply\n\n")
        
        return self
    }
    
    func divide(by right: BigInt) -> BigInt {
        let bid = big_int_div(bigInt.pointee, right.bigInt.pointee)
        
        let _ = DataManager.shared.coreLibManager.errorString(from: bid, mask: "\n\nbig int: divide\n\n")
        
        return self
    }
    
    static func + (left: BigInt, right: BigInt) -> BigInt {
        return left.add(by: right)
    }
    
    static func - (left: BigInt, right: BigInt) -> BigInt {
        return left.subtract(by: right)
    }
    
    static func * (left: BigInt, right: BigInt) -> BigInt {
        return left.multiply(by: right)
    }
    
    static func / (left: BigInt, right: BigInt) -> BigInt {
        return left.divide(by: right)
    }
    
    // arithmetic methods
    var stringValue: String {
        let amountStringPointer = UnsafeMutablePointer<UnsafePointer<Int8>?>.allocate(capacity: 1)
        defer {
            free_string(amountStringPointer.pointee)
        }
        
        big_int_get_value(bigInt.pointee, amountStringPointer)
        
        return String(cString: amountStringPointer.pointee!)
    }
    
    var ethValueString: String {
        return stringValue.appendDelimeter(at: 18)
    }
    
    var btcValueString: String {
        return stringValue.appendDelimeter(at: 8)
    }
    
    func freeBigIntSwift() {
        free_big_int(bigInt.pointee)
    }
}
