//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

extension UIAlertController {
    func setPresentedAlertToDelegate() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.openedAlert = self
    }
}
