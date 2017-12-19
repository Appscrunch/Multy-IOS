//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class CheckWordsPresenter: NSObject {
    
    var checkWordsVC: CheckWordsViewController?
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
    
    func auth(seedString: String) {
        if let errString = DataManager.shared.getRootString(from: seedString).1 {
            let alert = UIAlertController(title: "Warining", message: errString, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                self.checkWordsVC?.navigationController?.popViewController(animated: true)
            }))
            self.checkWordsVC?.present(alert, animated: true, completion: nil)
            return
        }
        
        checkWordsVC?.nextWordOrContinue.isEnabled = false
        checkWordsVC?.progressHUD.show()
        
        DataManager.shared.auth(rootKey: seedString) { (acc, err) in
//            print(acc ?? "")
            self.checkWordsVC?.navigationController?.popToRootViewController(animated: true)
            
            self.checkWordsVC?.progressHUD.hide()
        }
    }
}
