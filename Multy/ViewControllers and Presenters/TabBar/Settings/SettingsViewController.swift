//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var pinSwitch: UISwitch!
    
    @IBOutlet weak var pushView: UIView!
    @IBOutlet weak var securityView: UIView!
    @IBOutlet weak var defFiatView: UIView!
    @IBOutlet weak var aboutView: UIView!
    @IBOutlet weak var feedbackView: UIView!
    
    let presenter = SettingsPresenter()
    let authVC = SecureViewController()
    
    let opacityForNotImplementedView: CGFloat = 0.5  // not implemented features
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.settingsVC = self
        setupForNotImplementedViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        (self.tabBarController as! CustomTabBarViewController).changeViewVisibility(isHidden: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        (self.tabBarController as! CustomTabBarViewController).menuButton.isHidden = false
        (self.tabBarController as! CustomTabBarViewController).changeViewVisibility(isHidden: false)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
//        UserPreferences.shared.getAndDecryptCipheredMode(completion: { (pinMode, error) in
//            self.pinSwitch.isOn = (pinMode! as NSString).boolValue
//        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        (self.tabBarController as! CustomTabBarViewController).changeViewVisibility(isHidden: true)
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupForNotImplementedViews() {
        self.pushView.alpha = opacityForNotImplementedView
        self.defFiatView.alpha = opacityForNotImplementedView
        self.aboutView.alpha = opacityForNotImplementedView
        self.feedbackView.alpha = opacityForNotImplementedView
    }
    
    @IBAction func onSwitch(_ sender: Any) {
        if !pinSwitch.isOn {
                NotificationCenter.default.addObserver(self, selector: #selector(self.disablePin), name: Notification.Name("canDisablePin"), object: nil)
                pinSwitch.isOn = true
                authVC.modalPresentationStyle = .overCurrentContext
                self.present(authVC, animated: true, completion: nil)
        } else {
            if self.presenter.canEvaluatePolicy() {
                UserPreferences.shared.writeCipheredPinMode(mode: 1)
            } else {
                pinSwitch.isOn = false
                let message = "Biometric authentication is not configured on your device"
                let alert = UIAlertController(title: "Sorry", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func goToSecuritySettingsAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        let secureSettingsVC = storyboard.instantiateViewController(withIdentifier: "securitySettings")
        self.navigationController?.pushViewController(secureSettingsVC, animated: true)
    }
    
    @objc func disablePin() {
        self.pinSwitch.isOn = false
        NotificationCenter.default.removeObserver(self)
        UserPreferences.shared.writeCipheredPinMode(mode: 0)
    }
}
