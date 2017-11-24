//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import Foundation

extension String {
    var UTF8CStringPointer: UnsafeMutablePointer<Int8> {
        return UnsafeMutablePointer(mutating: (self as NSString).utf8String!)
    }
}
