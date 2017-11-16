//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class SeedPhraseWordViewController: UIViewController {

    @IBOutlet weak var nextWordBtn: UIButton!
    
    @IBOutlet weak var topWordLbl: UILabel!
    @IBOutlet weak var mediumWordLbl: UILabel!
    @IBOutlet weak var bottomWord: UILabel!
    
    var countOfTaps = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func nextWordAndContinueAction(_ sender: Any) {
        self.countOfTaps += 1
        //getNextWords
        if self.countOfTaps == 4 {
            self.nextWordBtn.setTitle("Continue", for: .normal)
            self.performSegue(withIdentifier: "backupSeedPhraseVC", sender: UIButton.self)
        }
    }
}
