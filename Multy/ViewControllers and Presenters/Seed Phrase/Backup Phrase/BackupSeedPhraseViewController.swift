//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class BackupSeedPhraseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func continueAction(_ sender: Any) {
        self.performSegue(withIdentifier: "checkPhraseVC", sender: UIButton.self)
    }
    
}
