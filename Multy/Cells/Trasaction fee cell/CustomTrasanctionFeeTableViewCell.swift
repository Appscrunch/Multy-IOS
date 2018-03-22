//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class CustomTrasanctionFeeTableViewCell: UITableViewCell {

    @IBOutlet weak var customFeeImage: UIImageView!
    @IBOutlet weak var toplbl: UILabel!
    @IBOutlet weak var middleLbl: UILabel!
    @IBOutlet weak var valuelbl: UILabel!
    @IBOutlet weak var checkImg: UIImageView!
    
    @IBOutlet weak var gasPriceValueLbl: UILabel!
    @IBOutlet weak var gasLimitValueLbl: UILabel!
    @IBOutlet weak var customTopConstraint: NSLayoutConstraint!
    
    var value = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupUI() {
//        self.middleLbl.isHidden = true
        self.checkImg.isHidden = false
//        self.toplbl.isHidden = false
//        self.valuelbl.isHidden = false
//        self.valuelbl.text = "\(Int(self.value))"
    }
    
    func setupUIFor(gasPrice: Int?, gasLimit: Int?) {
        //        self.middleLbl.isHidden = true
        self.checkImg.isHidden = false
        //        self.toplbl.isHidden = false
        //        self.valuelbl.isHidden = false
        if gasLimit != nil && gasPrice != nil {
            gasLimitValueLbl.text = "\(gasLimit!)"
            gasPriceValueLbl.text = "\(gasPrice!)"
            customTopConstraint.constant = 12
        }
        
        //        self.valuelbl.text = "\(Int(self.value))"
    }
    
    func reloadUI() {
        self.customTopConstraint.constant = 20
        self.middleLbl.isHidden = false
        self.checkImg.isHidden = true
        self.toplbl.isHidden = true
        self.valuelbl.isHidden = true
    }
    
}
