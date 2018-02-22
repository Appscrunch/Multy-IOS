//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import Foundation

extension String {
    var UTF8CStringPointer: UnsafeMutablePointer<Int8> {
        return UnsafeMutablePointer(mutating: (self as NSString).utf8String!)
    }

    func createBinaryData() -> BinaryData? {
        let pointer = UnsafeMutablePointer<UnsafeMutablePointer<BinaryData>?>.allocate(capacity: 1)
        let mbdfh = make_binary_data_from_hex(self.UTF8CStringPointer, pointer)
        
        if mbdfh != nil {
            DataManager.shared.coreLibManager.returnErrorString(opaquePointer: mbdfh!, mask: "make_binary_data_from_hex")
            
            return nil
        } else {
            return pointer.pointee!.pointee
        }
    }
    
    func toStringWithComma() -> Double {
        if self.isEmpty {
            return 0.0
        }
        
        //        let formatter = NumberFormatter()
        //        formatter.numberStyle = NumberFormatter.Style.decimal
        //        formatter.decimalSeparator = ","
        //        formatter.maximumFractionDigits = 8
        
        //        if formatter.number(from: self) == nil {
        //            return 0
        //        } else {
        //            return formatter.number(from: self)!.doubleValue
        //        }
        return Double(self.replacingOccurrences(of: ",", with: "."))!
    }
}
