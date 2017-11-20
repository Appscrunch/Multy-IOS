//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import ZFRippleButton

class SeedPhraseAboutViewController: UIViewController {

    @IBOutlet weak var continueBtn: ZFRippleButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
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
    
}
