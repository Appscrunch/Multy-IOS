//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class BackupFinishViewController: UIViewController {
    
    @IBOutlet weak var greatBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.greatBtn.applyGradient(
            withColours: [UIColor(ciColor: CIColor(red: 0/255, green: 178/255, blue: 255/255)),
                          UIColor(ciColor: CIColor(red: 0/255, green: 122/255, blue: 255/255))],
            gradientOrientation: .horizontal)
    }
    
    @IBAction func greatAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }

}
