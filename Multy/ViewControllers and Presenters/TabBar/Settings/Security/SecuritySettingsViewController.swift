//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class SecuritySettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (self.tabBarController as! CustomTabBarViewController).menuButton.isHidden = true
        (self.tabBarController as! CustomTabBarViewController).changeViewVisibility(isHidden: true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resetAllDataAction(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Settings", bundle: nil)
        let resetVC = storyBoard.instantiateViewController(withIdentifier: "resetAllDataVC") as! ResetAllDataViewController
        resetVC.modalPresentationStyle = .overCurrentContext
        self.present(resetVC, animated: true, completion: nil)
    }
}
