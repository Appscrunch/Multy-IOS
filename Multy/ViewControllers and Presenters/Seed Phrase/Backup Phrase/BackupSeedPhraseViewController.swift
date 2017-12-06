//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import ZFRippleButton

class BackupSeedPhraseViewController: UIViewController {

    @IBOutlet weak var continueBtn: ZFRippleButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.continueBtn.applyGradient(withColours: [UIColor(ciColor: CIColor(red: 0/255, green: 178/255, blue: 255/255)),
                                                     UIColor(ciColor: CIColor(red: 0/255, green: 122/255, blue: 255/255))],
                                       gradientOrientation: .horizontal)
    }
    
    @IBAction func continueAction(_ sender: Any) {
        self.performSegue(withIdentifier: "checkPhraseVC", sender: UIButton.self)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
