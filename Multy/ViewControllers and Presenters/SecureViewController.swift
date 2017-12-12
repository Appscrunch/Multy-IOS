//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class SecureViewController: UIViewController {

    let touchMe = TouchIDAuth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDel = UIApplication.shared.delegate as! AppDelegate
        appDel.presentedVC = self
        
        self.view.backgroundColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 0.7)
        
        self.touchMe.authenticateUser { (message) in
            if let message = message {
                let alert = UIAlertController(title: "Access Denied", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }


}
