//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class CheckWordsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var wordTF: UITextField!
    @IBOutlet weak var wordCounterLbl: UILabel!
    @IBOutlet weak var nextWordOrContinue: UIButton!
    var currentWordNumber = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.wordTF.becomeFirstResponder()
        self.wordTF.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    @IBAction func nextWordAndContinueAction(_ sender: Any) {
        //saving word
        self.wordTF.text = ""
        if self.currentWordNumber == 14 {
            self.nextWordOrContinue.setTitle("Continue", for: .normal)
        }
        if self.currentWordNumber < 15 {
            self.currentWordNumber += 1
            self.wordCounterLbl.text = "\(self.currentWordNumber) from 15"
        } else {
            self.performSegue(withIdentifier: "greatVC", sender: UIButton.self)
        }
    }
}
