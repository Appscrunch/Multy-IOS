//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import ZFRippleButton

class CheckWordsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var wordTF: UITextField!
    @IBOutlet weak var wordCounterLbl: UILabel!
    @IBOutlet weak var nextWordOrContinue: ZFRippleButton!
    @IBOutlet weak var bricksView: UIView!
    
    @IBOutlet weak var constraintBtnBottom: NSLayoutConstraint!
    @IBOutlet weak var constraintTop: NSLayoutConstraint!
    @IBOutlet weak var constraintAfterTopLabel: NSLayoutConstraint!
    
    var currentWordNumber = 1
    
    let presenter = CheckWordsPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if screenWidth < 325 {
            constraintTop.constant = 25
            constraintAfterTopLabel.constant = 10
        }
        
        bricksView.addSubview(BricksView(with: bricksView.bounds, and: 0))
        
        self.presenter.checkWordsVC = self
        self.presenter.getSeedPhrase()
        
        self.wordTF.becomeFirstResponder()
        self.wordTF.text = ""
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.nextWordOrContinue.applyGradient(
            withColours: [UIColor(ciColor: CIColor(red: 0/255, green: 178/255, blue: 255/255)),
                          UIColor(ciColor: CIColor(red: 0/255, green: 122/255, blue: 255/255))],
            gradientOrientation: .horizontal)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    @IBAction func nextWordAndContinueAction(_ sender: Any) {
        if !(self.wordTF.text?.isEmpty)! {
            self.presenter.phraseArr.append((self.wordTF.text?.lowercased())!)
            self.wordTF.text = ""
        } else {
            return
        }
        
        bricksView.subviews.forEach({ $0.removeFromSuperview() })
        bricksView.addSubview(BricksView(with: bricksView.bounds, and: currentWordNumber))
        
        if self.currentWordNumber == 14 {
            self.nextWordOrContinue.setTitle("Continue", for: .normal)
        }
        
        if self.currentWordNumber < 15 {
            self.currentWordNumber += 1
            self.wordCounterLbl.text = "\(self.currentWordNumber) from 15"
        } else {
            let isPhraseCorrect = presenter.isSeedPhraseCorrect()
            
            if isPhraseCorrect {
                self.performSegue(withIdentifier: "greatVC", sender: UIButton.self)
            } else {
                self.performSegue(withIdentifier: "wrongVC", sender: UIButton.self)
            }
            
        }
    }
    
    @objc func keyboardWillShow(_ notification : Notification) {
        //just check existing notification
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            let offset = isOperationSystemAtLeast11() ?
                (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height :
                (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height
            

            self.constraintBtnBottom.constant = offset!
        }
    }

}

