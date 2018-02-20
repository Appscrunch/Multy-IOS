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
    
    var firstPass: Int?
    var secondPass: Int?
    
    var isRepeat = false
    
    
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
        if counter == 5 && string != "" {
            if isRepeat == false {
                paintCircleAt(position: counter)
                self.view.isUserInteractionEnabled = false
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                    self.pinTextLbl.text = "Repeat your PIN-code"
                    for (index, _/*circle*/) in self.circleView.enumerated() {
                        self.clearCircleAt(position: index + 1)
                    }
                    self.firstPass = Int(self.pinTF.text! + string)
                    self.pinTF.text = ""
                    self.counter = 0
                    self.isRepeat = true
                    self.view.isUserInteractionEnabled = true
                }
                return false
            } else {
                self.view.isUserInteractionEnabled = false
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                    self.view.isUserInteractionEnabled = true
                    if Int(self.pinTF.text! + string) == self.firstPass {
                        UserPreferences.shared.writeCipheredPin(pin: self.firstPass!)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
        
        if string == "" {
            if counter == 0 {
                return false
            }
            clearCircleAt(position: counter)
            counter -= 1
            return true
        }
        
        paintCircleAt(position: counter)
        counter += 1
        return true
    }
    
    //    sendAnalyticsEvent(screenName: screenBlockSettings, eventName: pinSetuped)    // send when pin settuped
    
    func paintCircleAt(position: Int) {
        let circle = circleView[position]
        circle.backgroundColor = #colorLiteral(red: 0.01176470588, green: 0.4769998789, blue: 0.9994105697, alpha: 1)
        circle.layer.borderWidth = 0
    }
    
    func clearCircleAt(position: Int) {
        let circleForClear = circleView[position - 1]
        circleForClear.layer.borderWidth = 2
        circleForClear.layer.borderColor = #colorLiteral(red: 0.7646385431, green: 0.8155806661, blue: 0.8860673904, alpha: 1)
        circleForClear.backgroundColor = .clear
    }
    
}
