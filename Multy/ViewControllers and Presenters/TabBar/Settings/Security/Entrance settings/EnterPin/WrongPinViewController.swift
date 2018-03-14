//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class WrongPinViewController: UIViewController {

    @IBOutlet weak var timeLbl: UILabel!
    
    var timeString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.timeLbl.text = timeString
    }

}
