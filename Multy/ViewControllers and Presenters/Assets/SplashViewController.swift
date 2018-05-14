//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class SplashViewController: UIViewController {

    var isJailAlert = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch isJailAlert {
        case 0:
            self.updateAlert()
        case 1:
            self.jailAlert()
        default: break
        }
    }
    
    func jailAlert() {
        let message = "Your Device is Jailbroken!\nSory, but we don`t support jailbroken devices."
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
            DataManager.shared.clearDB(completion: { (err) in
                exit(0)
            })
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateAlert() {
        let message = "Please update Multy from App Store"
        let alert = UIAlertController(title: "We have update!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Go to update", style: .cancel, handler: { (action) in
            if let url = URL(string: "itms-apps://itunes.apple.com/us/app/multy-blockchain-wallet/id1328551769"), //"itms-apps://itunes.apple.com/app/id1024941703"
                UIApplication.shared.canOpenURL(url){
                UIApplication.shared.openURL(url)
                exit(0)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
