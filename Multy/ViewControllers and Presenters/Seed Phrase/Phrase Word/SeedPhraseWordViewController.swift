//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import LTMorphingLabel
import ZFRippleButton

class SeedPhraseWordViewController: UIViewController {

    @IBOutlet weak var nextWordBtn: ZFRippleButton!
    
    @IBOutlet weak var blocksImage: UIImageView!
    
    @IBOutlet weak var topWordLbl: LTMorphingLabel!
    @IBOutlet weak var mediumWordLbl: LTMorphingLabel!
    @IBOutlet weak var bottomWord: LTMorphingLabel!
    
    var countOfTaps = -1
    let seedPhraseArray = ["soda", "siren", "victory", "ozone", "document", "attract", "dragon", "innocent", "aisle", "shallow", "elbow", "make", "organ", "version", "equip"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let effect: LTMorphingEffect = .fall
        
        topWordLbl.morphingEffect = effect
        mediumWordLbl.morphingEffect = effect
        bottomWord.morphingEffect = effect
        
        nextWordAndContinueAction(UIButton());
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.nextWordBtn.applyGradient(withColours: [UIColor(ciColor: CIColor(red: 0/255, green: 178/255, blue: 255/255)), UIColor(ciColor: CIColor(red: 0/255, green: 122/255, blue: 255/255))], gradientOrientation: .horizontal)
    }

    @IBAction func nextWordAndContinueAction(_ sender: Any) {
        if self.countOfTaps == 0 {
            self.blocksImage.image = #imageLiteral(resourceName: "02")
        } else if self.countOfTaps == 1 {
            self.blocksImage.image = #imageLiteral(resourceName: "03")
        } else if self.countOfTaps == 2 {
            self.blocksImage.image = #imageLiteral(resourceName: "04")
        } else
        if self.countOfTaps == 3 {
            self.nextWordBtn.setTitle("Continue", for: .normal)
            self.blocksImage.image = #imageLiteral(resourceName: "05")
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
