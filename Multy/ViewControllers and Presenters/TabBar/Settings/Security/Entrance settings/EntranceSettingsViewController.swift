//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class EntranceSettingsViewController: UIViewController, AnalyticsProtocol {

    @IBOutlet weak var backupView: UIView!
    @IBOutlet weak var topPassConstraint: NSLayoutConstraint!
    @IBOutlet weak var usePassSwitch: UISwitch!
    @IBOutlet weak var pinView: UIView!
    @IBOutlet weak var biometricView: UIView!
    
    let closeAlpha: CGFloat = 0.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backupView.isHidden = true
        topPassConstraint.constant = 20
        
        self.pinView.alpha = closeAlpha
        self.biometricView.alpha = closeAlpha
        sendAnalyticsEvent(screenName: screenBlockSettings, eventName: screenBlockSettings)
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        sendAnalyticsEvent(screenName: screenBlockSettings, eventName: closeTap)
    }
    
    @IBAction func usePassAction(_ sender: Any) {
        if usePassSwitch.isOn {
            self.pinView.alpha = 1.0
            self.pinView.isUserInteractionEnabled = true
            sendAnalyticsEvent(screenName: screenBlockSettings, eventName: pinEnabledTap)
        } else {
            self.pinView.alpha = closeAlpha
            self.pinView.isUserInteractionEnabled = false
            sendAnalyticsEvent(screenName: screenBlockSettings, eventName: pinDisableTap)
        }
    }
    
    @IBAction func goToPinAction(_ sender: Any) {
        self.performSegue(withIdentifier: "pinVC", sender: sender)
    }
}
