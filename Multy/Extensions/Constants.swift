//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

let screenSize = UIScreen.main.bounds
let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height

//var exchangeCourse: Double = 10000.0
var exchangeCourse: Double = 2.0

func encode<T>( value: T) -> NSData {
    var value = value
    return withUnsafePointer(to: &value) { p in
        NSData(bytes: p, length: MemoryLayout.size(ofValue: value))
    }
}

func decode<T>(data: NSData) -> T {
    let pointer = UnsafeMutablePointer<T>.allocate(capacity: MemoryLayout<T.Type>.size)
    //MARK: fix get bytes
    data.getBytes(pointer)
    
    return pointer.move()
}

