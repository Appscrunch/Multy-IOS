//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import ZFRippleButton

class CheckWordsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var blockImage: UIImageView!
    @IBOutlet weak var wordTF: UITextField!
    @IBOutlet weak var wordCounterLbl: UILabel!
    @IBOutlet weak var nextWordOrContinue: ZFRippleButton!
    @IBOutlet weak var bricksView: UIView!
    
    @IBOutlet weak var constraintBtnBottom: NSLayoutConstraint!
    
    var currentWordNumber = 1
    
    let presenter = CheckWordsPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        bricksView.subviews.forEach({ $0.removeFromSuperview() })
        bricksView.addSubview(BricksView(with: bricksView.bounds, and: 5))
        
        //saving word
        if self.currentWordNumber == 3 {
            self.blockImage.image = #imageLiteral(resourceName: "0202")
        } else if self.currentWordNumber == 6 {
            self.blockImage.image = #imageLiteral(resourceName: "0303")
        } else if self.currentWordNumber == 9 {
            self.blockImage.image = #imageLiteral(resourceName: "0404")
        } else if self.currentWordNumber == 12 {
            self.blockImage.image = #imageLiteral(resourceName: "0505")
        }
        
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
            let isPhraseCorrect = presenter.isSeedPhraseCorrect()
            
            if isPhraseCorrect {
                self.performSegue(withIdentifier: "greatVC", sender: UIButton.self)
            } else {
                self.performSegue(withIdentifier: "wrongVC", sender: UIButton.self)
            }
            
        }
    }
    
    @objc func keyboardWillShow(_ notification : Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let inset : UIEdgeInsets = UIEdgeInsetsMake(64, 0, keyboardSize.height, 0)
            self.constraintBtnBottom.constant = inset.bottom
        }
    }

}

