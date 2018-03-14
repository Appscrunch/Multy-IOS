//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import ObjectiveC.NSObject

extension NSObject {
    var className: String {
        return String(describing: type(of: self)).components(separatedBy: ".").last!
    }
    
    class var className: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
}
