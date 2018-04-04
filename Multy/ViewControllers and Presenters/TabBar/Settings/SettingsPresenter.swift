//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import LocalAuthentication

class SettingsPresenter: NSObject {

    var settingsVC: SettingsViewController?
    var tabBarFrame: CGRect?
    
    func canEvaluatePolicy() -> Bool {
        let context = LAContext()
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
}
