//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class CheckWordsPresenter: NSObject {
    
    weak var checkWordsVC: CheckWordsViewController?
    var phraseArr = [String]()
    var originalSeedPhrase = String()
    
    func isSeedPhraseCorrect() -> Bool {
        return originalSeedPhrase.utf8CString == phraseArr.joined(separator: " ").utf8CString
    }
    
    func getSeedPhrase() {
        DataManager.shared.getSeedPhrase { (seedPhrase, error) in
            if let phrase = seedPhrase {
                self.originalSeedPhrase = phrase
            }
        }
    }
}
