//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class ReceiveAmountViewController: UIViewController {

    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let presenter = ReceiveAmountPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter.receiveAmountVC = self
    }

    
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
