//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class SecuritySettingsViewController: UIViewController, AnalyticsProtocol, CancelProtocol {
    
    @IBOutlet weak var seedLbl: UILabel!  // if backup not complete - text = "Backup Seed" - else - text = "View Seed Phrase"
    @IBOutlet weak var entranceView: UIView!
    
    var isNeedToBackup: Bool?
    
    var resetDelegate: CancelProtocol?
    
    let opacityForNotImplementedView: CGFloat = 0.5  // not implemented features
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.detectingSeed()
        sendAnalyticsEvent(screenName: screenSecuritySettings, eventName: screenSecuritySettings)
//        self.entranceView.alpha = opacityForNotImplementedView
//        self.entranceView.isUserInteractionEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (self.tabBarController as! CustomTabBarViewController).menuButton.isHidden = true
        (self.tabBarController as! CustomTabBarViewController).changeViewVisibility(isHidden: true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        sendAnalyticsEvent(screenName: screenSecuritySettings, eventName: closeTap)
    }
    
    @IBAction func resetAllDataAction(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Settings", bundle: nil)
        let resetVC = storyBoard.instantiateViewController(withIdentifier: "resetAllDataVC") as! ResetAllDataViewController
        resetVC.modalPresentationStyle = .overCurrentContext
        resetVC.cancelDelegate = self
        self.present(resetVC, animated: true, completion: nil)
        sendAnalyticsEvent(screenName: screenSecuritySettings, eventName: resetTap)
    }
    
    @IBAction func goToEntranceSettingsAction(_ sender: Any) {
        self.performSegue(withIdentifier: "entranceSettingsVC", sender: sender)
        sendAnalyticsEvent(screenName: screenSecuritySettings, eventName: blockSettingsTap)
    }
    
    @IBAction func restoreSeedAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SeedPhrase", bundle: nil)
        let destVC = storyboard.instantiateViewController(withIdentifier: "seedAbout") as! SeedPhraseAboutViewController
        destVC.whereFrom = self
        destVC.isNeedToBackup = self.isNeedToBackup
        self.navigationController?.pushViewController(destVC, animated: true)
        sendAnalyticsEvent(screenName: screenSecuritySettings, eventName: viewSeedTap)
    }
    
    func detectingSeed() {
        DataManager.shared.getAccount { (acc, erro) in
            if acc?.seedPhrase != nil && acc?.seedPhrase != "" {
                self.isNeedToBackup = true
            } else {
                self.isNeedToBackup = false
            }
            self.setupUi()
        }
    }
    
    func setupUi() {
        if self.isNeedToBackup! {
            self.seedLbl.text = "Backup Seed"
        } else {
            self.seedLbl.text = "View Seed Phrase"
        }
    }
    
    func cancelAction() {
        self.navigationController?.popToRootViewController(animated: true)
        self.resetDelegate?.cancelAction()
//        RealmManager.shared.clearRealm { (ok, err) in
//            if err == nil {
//
////                DispatchQueue.main.async {
////                    self.navigationController?.popToRootViewController(animated: false)
////                    self.tabBarController?.selectedIndex = 0
////                }
//            }
//        }
    }
    
    func presentNoInternet() {
        
    }
}
