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
    @IBOutlet weak var biometricSwitch: UISwitch!
    
    let closeAlpha: CGFloat = 0.5
    
    let presenter = EntranceSettingsPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.swipeToBack()
        self.presenter.entranceVC = self
//        backupView.isHidden = true
//        topPassConstraint.constant = 20
        self.setupShadow()
        self.biometricView.alpha = closeAlpha
        sendAnalyticsEvent(screenName: screenBlockSettings, eventName: screenBlockSettings)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getAcc()
    }
    
    func setupShadow() {
        let myColor = #colorLiteral(red: 0.4156862745, green: 0.1490196078, blue: 0.168627451, alpha: 0.3034300086)
        self.backupView.setShadow(with: myColor)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        sendAnalyticsEvent(screenName: screenBlockSettings, eventName: closeTap)
    }
    
    @IBAction func usePassAction(_ sender: Any) {
        if usePassSwitch.isOn {
            shakeView(viewForShake: backupView)
            self.pinView.alpha = 1.0
            self.pinView.isUserInteractionEnabled = true
            sendAnalyticsEvent(screenName: screenBlockSettings, eventName: pinEnabledTap)
        } else {
            self.pinView.alpha = closeAlpha
            self.pinView.isUserInteractionEnabled = false
            self.checkMarkOnPin.isHidden = true
            self.biometricView.alpha = closeAlpha
            self.biometricView.isUserInteractionEnabled = false
            self.biometricSwitch.isOn = false
            UserDefaults.standard.removeObject(forKey: "pin")
            UserPreferences.shared.writeCipheredBiometric(isBiometircOn: false)
            sendAnalyticsEvent(screenName: screenBlockSettings, eventName: pinDisableTap)
        }
    }
    
    @IBAction func goToPinAction(_ sender: Any) {
        self.performSegue(withIdentifier: "pinVC", sender: sender)
    }

    @IBAction func goToSeedBackup(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SeedPhrase", bundle: nil)
        let destVC = storyboard.instantiateViewController(withIdentifier: "seedAbout") as! SeedPhraseAboutViewController
        destVC.whereFrom = self
        destVC.isNeedToBackup = self.presenter.isNeedToBackup
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    
    @IBAction func biometricSwitchAction(_ sender: Any) {
        if self.biometricSwitch.isOn {
            UserPreferences.shared.writeCipheredBiometric(isBiometircOn: true)
        } else {
            UserPreferences.shared.writeCipheredBiometric(isBiometircOn: false)
        }
    }
    
    func uiSetup() {
        UserPreferences.shared.getAndDecryptPin { (pin, err) in
            if !self.presenter.isNeedToBackup! {
                self.backupView.isHidden = true
                self.topPassConstraint.constant = 20
            }
            if pin == nil {
                self.pinView.alpha = self.closeAlpha
                
                return
            }
            // check entered pin
//            let alert = UIAlertController(title: "Title", message: "\(pin!)", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//            self.present(alert, animated: true, completion: nil)
            self.pinView.isUserInteractionEnabled = true
            self.usePassSwitch.isOn = true
            self.pinView.alpha = 1.0
            self.checkMarkOnPin.isHidden = false
            UserPreferences.shared.getAndDecryptBiometric(completion: { (isBiometricOn, err) in
                if isBiometricOn != nil && !isBiometricOn! {
                    return
                }
                self.biometricSwitch.isOn = true
            })
            self.biometricView.isUserInteractionEnabled = true
            self.biometricView.alpha = 1.0
            
        }
    }
    
    func getAcc() {
        DataManager.shared.getAccount { (acc, erro) in
            if acc?.seedPhrase != nil && acc?.seedPhrase != "" {
                self.presenter.isNeedToBackup = true
            } else {
                self.presenter.isNeedToBackup = false
            }
            self.uiSetup()
        }
    }
}
