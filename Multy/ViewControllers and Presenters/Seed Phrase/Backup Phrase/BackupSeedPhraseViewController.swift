//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import ZFRippleButton

class BackupSeedPhraseViewController: UIViewController, AnalyticsProtocol {

    @IBOutlet weak var continueBtn: ZFRippleButton!
    @IBOutlet weak var restartBtn: UIButton!
    @IBOutlet weak var restartLbl: UILabel!
    @IBOutlet weak var infoIconImg: UIImageView!
    
    @IBOutlet weak var bricksConstraint: NSLayoutConstraint!    //
    @IBOutlet weak var firstLblConstraint: NSLayoutConstraint!  // ipad
    @IBOutlet weak var secondLblConstraint: NSLayoutConstraint! //
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var middleText: UILabel!
    
    var isRestore = false
    
    var whereFrom: UIViewController?
    var isNeedToBackup: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        (self.tabBarController as! CustomTabBarViewController).menuButton.isHidden = true
//        self.tabBarController?.tabBar.frame = CGRect.zero
        self.fixForiPad()
        sendAnalyticsEvent(screenName: screenViewPhrase, eventName: screenViewPhrase)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (self.tabBarController as! CustomTabBarViewController).menuButton.isHidden = true
        self.tabBarController?.tabBar.frame = CGRect.zero
        (self.tabBarController as! CustomTabBarViewController).changeViewVisibility(isHidden: true)
        self.uiForRestore()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.continueBtn.applyGradient(withColours: [UIColor(ciColor: CIColor(red: 0/255, green: 178/255, blue: 255/255)),
                                                     UIColor(ciColor: CIColor(red: 0/255, green: 122/255, blue: 255/255))],
                                       gradientOrientation: .horizontal)
    }
    
    func uiForRestore() {
        if self.isRestore {
            self.restartBtn.isEnabled = false
            self.restartLbl.isHidden = true
            self.infoIconImg.isHidden = true
        } else if self.isNeedToBackup == false {
            self.middleText.isHidden = true
        }
    }
    
    @IBAction func continueAction(_ sender: Any) {
        if self.isNeedToBackup != nil && self.isNeedToBackup == false {
            if self.whereFrom != nil {
                self.navigationController?.popToViewController(whereFrom!, animated: true)
                return
            }
        }
        self.performSegue(withIdentifier: "checkPhraseVC", sender: UIButton.self)
    }
    
    @IBAction func repeatAction(_ sender: UIButton) {
        sendAnalyticsEvent(screenName: screenViewPhrase, eventName: repeatTap)
        let allVCs = self.navigationController!.viewControllers
        if allVCs.count > 2 {
            let destinationVC = allVCs[allVCs.count - 3]
            self.navigationController?.popToViewController(destinationVC, animated: true)
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        sendAnalyticsEvent(screenName: screenViewPhrase, eventName: closeTap)
        if self.whereFrom != nil {
            self.navigationController?.popToViewController(whereFrom!, animated: true)
        } else {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "checkPhraseVC" {
            let nextVC = segue.destination as! CheckWordsViewController
            nextVC.isRestore = self.isRestore
        }
    }
    
    func fixForiPad() {
        if screenHeight == heightOfiPad {
            self.bricksConstraint.constant = 15
            self.firstLblConstraint.constant = 20
            self.secondLblConstraint.constant = 9
            self.bottomConstraint.constant = 10
        }
    }
    
    
//    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
//        /* So first we take the inverted set of the characters we want to keep,
//         this will act as the separator set, i.e. those characters we want to
//         take out from the user input */
//        let inverseSet = NSCharacterSet(charactersInString:"ABCDEFGHIJKLMNOPQRSTUVWXUZ")
//
//        /* We then use this separator set to remove those unwanted characters.
//         So we are basically separating the characters we want to keep, by those
//         we don't */
//        let components = string.componentsSeparatedByCharactersInSet(inverseSet)
//
//        /* We then join those characters together */
//        let filtered = components.joinWithSeparator("")
//
//        return string == filtered
//    }
    
}
