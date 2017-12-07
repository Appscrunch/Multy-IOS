//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import ZFRippleButton

class SendingAnimationViewController: UIViewController {

    @IBOutlet var backView: UIView!
    @IBOutlet weak var sendingImage: UIImageView!
    @IBOutlet weak var sendingLbl: UILabel!
    @IBOutlet weak var closeBtn: ZFRippleButton!
    
    let when = DispatchTime.now() + 3 // change 2 to desired number of seconds

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backView.applyGradient(withColours: [UIColor(ciColor: CIColor(red: 0/255, green: 178/255, blue: 255/255)),
                                                 UIColor(ciColor: CIColor(red: 0/255, green: 122/255, blue: 255/255))],
                                   gradientOrientation: .topRightBottomLeft)
        
        self.closeBtn.applyGradient(withColours: [UIColor(ciColor: CIColor(red: 0/255, green: 178/255, blue: 255/255)),
                                                  UIColor(ciColor: CIColor(red: 0/255, green: 122/255, blue: 255/255))],
                                    gradientOrientation: .horizontal)
        
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.sendOK()
        }
    }
    
    
    @IBAction func closeAction(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func sendOK() {
        self.sendingImage.image = #imageLiteral(resourceName: "completeIcon")
        self.sendingLbl.text = "Complete!"
        self.closeBtn.isHidden = false
    }
}
