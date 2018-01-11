//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var pinSwitch: UISwitch!
    
    let authVC = SecureViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        (self.tabBarController as! CustomTabBarViewController).changeViewVisibility(isHidden: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        (self.tabBarController as! CustomTabBarViewController).changeViewVisibility(isHidden: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        (self.tabBarController as! CustomTabBarViewController).changeViewVisibility(isHidden: true)
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func onSwitch(_ sender: Any) {
        if !pinSwitch.isOn {
            NotificationCenter.default.addObserver(self, selector: #selector(self.disablePin), name: Notification.Name("canDisablePin"), object: nil)
            pinSwitch.isOn = true
            authVC.modalPresentationStyle = .overCurrentContext
            self.present(authVC, animated: true, completion: nil)
        }
        UserPreferences.shared.writeCipheredPinMode(mode: 1)
    }
    
    @objc func disablePin() {
        self.pinSwitch.isOn = false
        NotificationCenter.default.removeObserver(self)
        UserPreferences.shared.writeCipheredPinMode(mode: 0)
    }
}
