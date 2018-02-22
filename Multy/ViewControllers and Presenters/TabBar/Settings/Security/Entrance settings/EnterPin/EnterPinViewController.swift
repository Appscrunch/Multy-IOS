//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class EnterPinViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var numberButtons: [UIButton]!
    @IBOutlet var circleView: [UIView]!
    @IBOutlet weak var viewWithCircles: UIView!
    @IBOutlet weak var pinTF: UITextField!
    
    var cancelDelegate: CancelProtocol?
    
    var counter = 0
    
    var passFromPref = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupButtons()
        self.clearAllCircles()
        self.getPass()
    }
    
    func setupButtons() {
        for btn in self.numberButtons {
            btn.layer.cornerRadius = btn.frame.width/2
        }
    }
    
    @IBAction func tapAction(_ sender: Any) {
        let tappedBtn = sender as! UIButton
        self.pinTF.text?.append(tappedBtn.titleLabel!.text!)
        paintCircleAt(position: counter)
        if counter < 5 {
            counter += 1
        } else {
            self.view.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                self.view.isUserInteractionEnabled = true
                if self.pinTF.text! == self.passFromPref {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    shakeView(viewForShake: self.viewWithCircles)
                    self.clearAllCircles()
                    self.counter = 0
                }
            }
        }
    }
    
    @IBAction func removeLastAction(_ sender: Any) {
        if counter == 0 {
            return
        }
        self.pinTF.text?.removeLast()
        clearCircleAt(position: counter)
        counter -= 1
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.cancelDelegate?.presentNoInternet()
        self.dismiss(animated: true, completion: nil)
    }
    
    func clearAllCircles() {
        for (index, _/*circle*/) in self.circleView.enumerated() {
            self.clearCircleAt(position: index + 1)
        }
        self.pinTF.text = ""
    }
    
    func paintCircleAt(position: Int) {
        let circle = circleView[position]
        circle.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        circle.layer.borderWidth = 0
    }
    
    func clearCircleAt(position: Int) {
        let circleForClear = circleView[position - 1]
        circleForClear.layer.borderWidth = 2
        circleForClear.layer.borderColor = #colorLiteral(red: 0.9999478459, green: 1, blue: 0.9998740554, alpha: 1)
        circleForClear.backgroundColor = .clear
    }
    
    func getPass() {
        UserPreferences.shared.getAndDecryptPin { (pin, err) in
            if pin != nil {
                self.passFromPref = pin!
            }
        }
    }
    
    
    
}
