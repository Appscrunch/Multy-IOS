//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

let screenSize = UIScreen.main.bounds
let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height

//var exchangeCourse: Double = 10000.0
var exchangeCourse: Double = 2.0

var isNeedToAutorise = false
var isViewPresented = false

func generateWalletPrimaryKey(currencyID: UInt32, walletID: UInt32) -> String {
    let currencyString = String(currencyID).sha3(.sha256)
    let walletString = String(walletID).sha3(.sha256)
    
    return ("\(currencyString)" + "\(walletString)").sha3(.sha256)
}
