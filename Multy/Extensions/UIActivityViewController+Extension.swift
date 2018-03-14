//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

extension UIActivityViewController {
    func setPresentedShareDialogToDelegate() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.sharedDialog = self
    }
}
