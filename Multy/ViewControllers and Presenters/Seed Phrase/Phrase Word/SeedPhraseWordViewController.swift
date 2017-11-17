//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class SeedPhraseWordViewController: UIViewController {

    @IBOutlet weak var nextWordBtn: UIButton!
    
    @IBOutlet weak var topWordLbl: UILabel!
    @IBOutlet weak var mediumWordLbl: UILabel!
    @IBOutlet weak var bottomWord: UILabel!
    
    var countOfTaps = -1
    let seedPhraseArray = ["soda", "siren", "victory", "ozone", "document", "attract", "dragon", "innocent", "aisle", "shallow", "elbow", "make", "organ", "version", "equip"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextWordAndContinueAction(UIButton());
    }

    @IBAction func nextWordAndContinueAction(_ sender: Any) {
        if self.countOfTaps == 3 {
            self.nextWordBtn.setTitle("Continue", for: .normal)
        }
        
        //getNextWords
        if self.countOfTaps < 4 {
            self.countOfTaps += 1
            
            self.topWordLbl.text = seedPhraseArray[3 * countOfTaps]
            self.mediumWordLbl.text = seedPhraseArray[3 * countOfTaps + 1]
            self.bottomWord.text = seedPhraseArray[3 * countOfTaps + 2]
        }  else {
            self.performSegue(withIdentifier: "backupSeedPhraseVC", sender: UIButton.self)
        }
    }
}
