//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import LTMorphingLabel

class PinCodeViewController: UIViewController, UITextFieldDelegate, AnalyticsProtocol {

    @IBOutlet weak var pinTF: UITextField!
    @IBOutlet weak var pinTextLbl: LTMorphingLabel!
    @IBOutlet var circleView: [UIView]!
    
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pinTF.becomeFirstResponder()
        
        for circle in circleView {
            circle.layer.borderWidth = 2
            circle.layer.borderColor = #colorLiteral(red: 0.7646385431, green: 0.8155806661, blue: 0.8860673904, alpha: 1)
            circle.backgroundColor = .clear
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if counter == 5 {
            pinTextLbl.text = "Repeat your PIN-code"
            for circle in circleView {
                circle.layer.borderWidth = 2
                circle.layer.borderColor = #colorLiteral(red: 0.7646385431, green: 0.8155806661, blue: 0.8860673904, alpha: 1)
                circle.backgroundColor = .clear
            }
            pinTF.text = ""
            counter = 0
            return false
        }
        
        if string == "" {
            if counter == 0 {
                return false
            }
            let circleForClear = circleView[counter - 1]
            circleForClear.layer.borderWidth = 2
            circleForClear.layer.borderColor = #colorLiteral(red: 0.7646385431, green: 0.8155806661, blue: 0.8860673904, alpha: 1)
            circleForClear.backgroundColor = .clear
            
            counter -= 1
            
            return true
        }
        
        let circle = circleView[counter]
        circle.backgroundColor = #colorLiteral(red: 0.01176470588, green: 0.4769998789, blue: 0.9994105697, alpha: 1)
        circle.layer.borderWidth = 0
        
        counter += 1

        return true
    }
    
    //    sendAnalyticsEvent(screenName: screenBlockSettings, eventName: pinSetuped)    // send when pin settuped
    
}
