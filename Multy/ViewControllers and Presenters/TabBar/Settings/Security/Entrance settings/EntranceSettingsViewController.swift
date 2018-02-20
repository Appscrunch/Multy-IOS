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
    @IBOutlet weak var checkMarkOnPin: UIImageView!
    
    let closeAlpha: CGFloat = 0.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backupView.isHidden = true
        topPassConstraint.constant = 20
        
        self.biometricView.alpha = closeAlpha
        sendAnalyticsEvent(screenName: screenBlockSettings, eventName: screenBlockSettings)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.uiSetup()
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
            self.checkMarkOnPin.isHidden = true
            UserDefaults.standard.removeObject(forKey: "pin")
            sendAnalyticsEvent(screenName: screenBlockSettings, eventName: pinDisableTap)
        }
    }
    
    @IBAction func goToPinAction(_ sender: Any) {
        self.performSegue(withIdentifier: "pinVC", sender: sender)
    }

    func uiSetup() {
        UserPreferences.shared.getAndDecryptPin { (pin, err) in
            if pin == nil {
                self.pinView.alpha = self.closeAlpha
                
                return
            }
            
            let alert = UIAlertController(title: "Title", message: "\(pin!)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.pinView.isUserInteractionEnabled = true
            self.usePassSwitch.isOn = true
            self.pinView.alpha = 1.0
            self.checkMarkOnPin.isHidden = false
        }
    }
}
