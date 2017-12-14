//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class CustomFeeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var topNameLbl: UILabel!  //gas price
    @IBOutlet weak var topPriceTf: UITextField!
    
    @IBOutlet weak var botNameLbl: UILabel!   //gas limit
    @IBOutlet weak var botLimitTf: UITextField!
    
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint! // for btc   /2 and hide bot elems
    
    let presenter = CustomFeePresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func setupUI() {
        switch self.presenter.chainId {
        case 0 as NSNumber:
            self.botNameLbl.isHidden = true
            self.botLimitTf.isHidden = true
            self.viewHeightConstraint.constant = viewHeightConstraint.constant/2
        default: return
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "," && (textField.text?.contains(","))! {
            return false
        }
        
        return true
    }
    
}
