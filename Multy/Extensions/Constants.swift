//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

let screenSize = UIScreen.main.bounds
let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height

//brick view
let segmentsCountUp : Int  = 7
let segmentsCountDown : Int  = 8
let upperSizes : [CGFloat] = [0, 35, 79, 107, 151, 183, 218, 253]
let downSizes : [CGFloat] = [0, 23, 40, 53, 81, 136, 153, 197, 249]

//var exchangeCourse: Double = 10000.0
var exchangeCourse: Double = 1.0 {
    didSet {
        NotificationCenter.default.post(name: NSNotification.Name("exchageUpdated"), object: nil)
    }
}

var isNeedToAutorise = false
var isViewPresented = false

func generateWalletPrimaryKey(currencyID: UInt32, walletID: UInt32) -> String {
    let currencyString = String(currencyID).sha3(.sha256)
    let walletString = String(walletID).sha3(.sha256)
    
    return ("\(currencyString)" + "\(walletString)").sha3(.sha256)
}

func convertSatoshiToBTC(sum: UInt32) -> Double {
    return Double(sum) / pow(10, 8)
}

func convertBTCStringToSatoshi(sum: String) -> UInt32 {
    return UInt32(Double(sum)! * pow(10, 8))
}

