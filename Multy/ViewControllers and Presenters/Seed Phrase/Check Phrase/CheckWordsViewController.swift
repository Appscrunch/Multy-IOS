//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class CheckWordsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var wordTF: UITextField!
    @IBOutlet weak var wordCounterLbl: UILabel!
    @IBOutlet weak var nextWordOrContinue: UIButton!

    @IBOutlet weak var constraintBtnBottom: NSLayoutConstraint!
    
    var currentWordNumber = 1
    
    let presenter = CheckWordsPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter.checkWordsVC = self
        
        self.wordTF.becomeFirstResponder()
        self.wordTF.text = ""
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        self.nextWordOrContinue.applyGradient(
            withColours: [UIColor(ciColor: CIColor(red: 0/255, green: 178/255, blue: 255/255)),
                          UIColor(ciColor: CIColor(red: 0/255, green: 122/255, blue: 255/255))],
            gradientOrientation: .horizontal)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    @IBAction func nextWordAndContinueAction(_ sender: Any) {
        //saving word
        if !(self.wordTF.text?.isEmpty)! {
            self.presenter.phraseArr.append((self.wordTF.text?.lowercased())!)
            self.wordTF.text = ""
        } else {
            return
        }
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
    
    @objc func keyboardWillShow(_ notification : Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let inset : UIEdgeInsets = UIEdgeInsetsMake(64, 0, keyboardSize.height, 0)
            self.constraintBtnBottom.constant = inset.bottom
        }
    }
    
    @objc func someFunc() {
        
    }
}

