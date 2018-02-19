//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import ZFRippleButton

class SeedPhraseAboutViewController: UIViewController, AnalyticsProtocol {

    @IBOutlet weak var continueBtn: ZFRippleButton!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var firstConstraint: NSLayoutConstraint!   //
    @IBOutlet weak var secondConstraint: NSLayoutConstraint!  // for fix ipad
    @IBOutlet weak var thirdConstraint: NSLayoutConstraint!   //
    
    var whereFrom: UIViewController?
    var isNeedToBackup: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
        self.fixiPadUI()
        sendAnalyticsEvent(screenName: screenViewPhrase, eventName: screenViewPhrase)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (self.tabBarController as! CustomTabBarViewController).menuButton.isHidden = true
        (self.tabBarController as! CustomTabBarViewController).changeViewVisibility(isHidden: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.continueBtn.applyGradient(withColours: [UIColor(ciColor: CIColor(red: 0/255, green: 178/255, blue: 255/255)),
                                                    UIColor(ciColor: CIColor(red: 0/255, green: 122/255, blue: 255/255))],
                                       gradientOrientation: .horizontal)
    }
    
    @IBAction func continueAction(_ sender: Any) {
        self.performSegue(withIdentifier: "seedWordsVC", sender: UIButton.self)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        sendAnalyticsEvent(screenName: screenViewPhrase, eventName: cancelTap)
        self.navigationController?.popViewController(animated: true)
    }
    
    func fixiPadUI() {
        if screenHeight == heightOfiPad {
            self.topConstraint.constant = 15
            self.firstConstraint.constant = 25
            self.secondConstraint.constant = 25
            self.thirdConstraint.constant = 25
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seedWordsVC" {
            let destVC = segue.destination as! SeedPhraseWordViewController
            if self.whereFrom != nil {
                destVC.whereFrom = self.whereFrom
                destVC.isNeedToBackup = self.isNeedToBackup!
            }
        }
    }
    
}
