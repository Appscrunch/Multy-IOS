//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class SeedPhraseAboutViewController: UIViewController {

    @IBOutlet weak var continueBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.continueBtn.applyGradient(withColours: [UIColor(red: 0, green: 178, blue: 255, alpha: 1), UIColor.red], gradientOrientation: GradientOrientation.horizontal)
    }
    
    @IBAction func continueAction(_ sender: Any) {
        self.performSegue(withIdentifier: "seedWordsVC", sender: UIButton.self)
    }
    
}
