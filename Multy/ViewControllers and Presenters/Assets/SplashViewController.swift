//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let message = "Please update Multy from App Store"
        let alert = UIAlertController(title: "We have update!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Go to update", style: .cancel, handler: { (action) in
            if let url = URL(string: "itms-apps://itunes.apple.com/"), //"itms-apps://itunes.apple.com/app/id1024941703"
                UIApplication.shared.canOpenURL(url){
                UIApplication.shared.openURL(url)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }

}
