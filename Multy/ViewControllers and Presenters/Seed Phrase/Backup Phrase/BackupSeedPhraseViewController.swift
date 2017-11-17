//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class BackupSeedPhraseViewController: UIViewController {

    @IBOutlet weak var continueBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.continueBtn.applyGradient(withColours: [UIColor(ciColor: CIColor(red: 0/255, green: 178/255, blue: 255/255)),
                                                     UIColor(ciColor: CIColor(red: 0/255, green: 122/255, blue: 255/255))],
                                       gradientOrientation: .horizontal)
    }
    
    @IBAction func continueAction(_ sender: Any) {
        self.performSegue(withIdentifier: "checkPhraseVC", sender: UIButton.self)
    }
    
}
