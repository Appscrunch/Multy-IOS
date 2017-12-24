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
        self.tabBarController?.tabBar.isUserInteractionEnabled = false
        let appDel = UIApplication.shared.delegate as! AppDelegate
        appDel.presentedVC = self
        
        self.view.backgroundColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 0.7)
        
        self.touchMe.authenticateUser { (message) in
            if let message = message {
                self.tabBarController?.tabBar.isUserInteractionEnabled = false
                let alert = UIAlertController(title: "Access Denied", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                    
                }))
                self.present(alert, animated: true, completion: nil)
                appDel.openedAlert = alert
            } else {
                self.dismiss(animated: true, completion: nil)
                self.tabBarController?.tabBar.isUserInteractionEnabled = true
//                NotificationCenter.default.post(name: Notification.Name("hideKeyboard"), object: nil)
                NotificationCenter.default.post(name: Notification.Name("showKeyboard"), object: nil)
            }
        }
    }


}
