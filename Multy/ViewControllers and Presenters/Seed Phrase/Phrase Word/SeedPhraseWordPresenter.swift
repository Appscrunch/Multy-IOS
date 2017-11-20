//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class SeedPhraseWordPresenter: NSObject {
    var mainVC : SeedPhraseWordViewController?
    
    var countOfTaps = -1
    var mnemonicPhraseArray = Array<String>()
    
    func generateMnemonic() {
        mnemonicPhraseArray = createMnemonicPhraseArray()
    }
    
    func presentNextTripleOrContinue() {
        if self.countOfTaps == 3 {
            self.mainVC?.nextWordBtn.setTitle("Continue", for: .normal)
        }
        
        //getNextWords
        if self.countOfTaps < 4 {
            self.countOfTaps += 1
            
            self.mainVC?.topWordLbl.text = mnemonicPhraseArray[3 * countOfTaps]
            self.mainVC?.mediumWordLbl.text = mnemonicPhraseArray[3 * countOfTaps + 1]
            self.mainVC?.bottomWord.text = mnemonicPhraseArray[3 * countOfTaps + 2]
        }  else {
            self.mainVC?.performSegue(withIdentifier: "backupSeedPhraseVC", sender: UIButton.self)
        }
    }
}
