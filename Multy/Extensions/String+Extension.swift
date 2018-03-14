//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import Foundation

extension String {
    var UTF8CStringPointer: UnsafeMutablePointer<Int8> {
        return UnsafeMutablePointer(mutating: (self as NSString).utf8String!)
    }
    
    var bigInt: BigInt {
        if let bigIntValue = BigInt(self) {
            return bigIntValue
        }
        
        return BigInt(0)
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
    
    func convertStringWithCommaToDouble() -> Double {
        if self.isEmpty {
            return 0.0
        }
        
        if self == "," || self == "." {
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
    
    private mutating func stringWithoutZeroesFromStart() -> String {
        var modifiedString = self
        while modifiedString.hasPrefix("0") && modifiedString.count > 1 {
            modifiedString.remove(at: self.startIndex)
        }
        
        return modifiedString
    }
    
    private mutating func append(delimeter: Character, atIndexFromEnd: Int) {
        self.insert(delimeter, at: self.index(self.endIndex, offsetBy: -atIndexFromEnd))
    }
    
    private func toStringWithZeroes(precision: Int) -> String {
        let components = self.components(separatedBy: CharacterSet.init(charactersIn: "\(defaultDelimeter)"))
        
        if precision < 1 {
            if self.isEmpty {
                return "0"
            }
            
            return components.first!
        }
        
        //two delimeters - wrong case
        precondition(components.count < 3, "---===Wrong string===---")
        
        if components.count == 1 {
            return self + String(repeating: "0", count: precision)
        } else {
            let firstComponent = components.first!
            let secondComponent = components.last!
            
            var finalString = String()
            
            switch secondComponent.count {
            case 0..<precision:
                finalString = firstComponent + secondComponent + String(repeating: "0", count: precision - secondComponent.count)
            case precision:
                finalString = firstComponent + secondComponent
            case precision...LONG_MAX:
                let index = secondComponent.index(secondComponent.startIndex, offsetBy: precision)
                finalString = firstComponent + secondComponent[..<index]
            default:
                return "0"
            }
            
            return finalString.stringWithoutZeroesFromStart()
        }
    }
    
    func appendDelimeter(at index: Int) -> String {
        if index < 1 {
            return self
        }
        
        var modifiedString = self
        
        if self.count > index {
            modifiedString.append(delimeter: defaultDelimeter, atIndexFromEnd: index)
        } else {
            let zeroesString = String(repeating: "0", count: index - self.count + 1)
            modifiedString = zeroesString + modifiedString
            modifiedString.append(delimeter: defaultDelimeter, atIndexFromEnd: index)
        }
        
        return modifiedString
    }
    
    func convertToSatoshiAmountString() -> String {
        return self.toStringWithZeroes(precision: 8)
    }
    
    func convertToFiatAmountString() -> String {
        return self.toStringWithZeroes(precision: 2)
    }
    
    func toDateTime() -> NSDate {
        //Create Date Formatter
//        let dateFormatter = DateFormatter()
//
//        //Specify Format of String to Parse
//        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss xxxxx"
//        dateFormatter.locale = NSLocale(localeIdentifier: "ru_RU") as Locale!
//
        //Parse into NSDate
        let dateFromString = Date.blockDateFormatter().date(from: self)! as NSDate
        
        //Return Parsed Date
        return dateFromString
    }
}
