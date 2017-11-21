//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class ReceiveAllDetailsViewController: UIViewController {

    @IBOutlet weak var cancelBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func requestSumAction(_ sender: Any) {
        self.performSegue(withIdentifier: "receiveAmount", sender: UIButton.self)
    }
    
}
