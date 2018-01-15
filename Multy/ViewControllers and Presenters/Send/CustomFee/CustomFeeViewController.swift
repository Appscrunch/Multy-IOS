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
    
    var delegate: CustomFeeRateProtocol?
    
    var rate = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        switch self.presenter.chainId {
        case 0 as NSNumber:
//            break
            self.botNameLbl.isHidden = true
            self.botLimitTf.isHidden = true
            self.viewHeightConstraint.constant = viewHeightConstraint.constant/2
            
            self.topNameLbl.text = "Satoshi per byte"
            self.topPriceTf.placeholder = "Enter Satohi per byte here"
            self.topPriceTf.placeholder = "0"
            if self.rate != 0 {
                self.topPriceTf.text = "\(rate)"
            }
            self.topPriceTf.becomeFirstResponder()
        default: return
        }
    }
    
    @IBAction func cancelAtion(_ sender: Any) {
        self.delegate?.customFeeData(firstValue: (self.topPriceTf.text! as NSString).doubleValue, secValue: (self.botLimitTf.text! as NSString).doubleValue)
        self.navigationController?.popViewController(animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "," && (textField.text?.contains(","))! {
            return false
        }
        
        return true
    }
    
}
