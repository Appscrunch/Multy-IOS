//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import ZFRippleButton

class BackupFinishViewController: UIViewController {
    
    @IBOutlet weak var greatBtn: ZFRippleButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.greatBtn.applyGradient(
            withColours: [UIColor(ciColor: CIColor(red: 0/255, green: 178/255, blue: 255/255)),
                          UIColor(ciColor: CIColor(red: 0/255, green: 122/255, blue: 255/255))],
            gradientOrientation: .horizontal)
    }
    
    @IBAction func greatAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }

}
