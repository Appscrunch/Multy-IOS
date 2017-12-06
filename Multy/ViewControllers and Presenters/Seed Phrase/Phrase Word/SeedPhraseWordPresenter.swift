//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class SeedPhraseWordPresenter: NSObject {
    var mainVC : SeedPhraseWordViewController?
    
    var countOfTaps = -1
    var mnemonicPhraseArray = Array<String>()
    
    func generateMnemonic() {
        mnemonicPhraseArray = DataManager.shared.getMnenonicArray()
    }
    
    func presentNextTripleOrContinue() {
        if self.countOfTaps == 3 {
            self.mainVC?.nextWordBtn.setTitle("Continue", for: .normal)
        }
        
        if self.countOfTaps == 0 {
            self.mainVC?.blocksImage.image = #imageLiteral(resourceName: "02")
        } else if self.countOfTaps == 1 {
            self.mainVC?.blocksImage.image = #imageLiteral(resourceName: "03")
        } else if self.countOfTaps == 2 {
            self.mainVC?.blocksImage.image = #imageLiteral(resourceName: "04")
        } else
            if self.countOfTaps == 3 {
                self.mainVC?.nextWordBtn.setTitle("Continue", for: .normal)
                self.mainVC?.blocksImage.image = #imageLiteral(resourceName: "05")
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
