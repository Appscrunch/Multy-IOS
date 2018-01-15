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
    
    var value = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupUIForBtc() {
//        self.middleLbl.isHidden = true
        self.checkImg.isHidden = false
//        self.toplbl.isHidden = false
//        self.valuelbl.isHidden = false
        
//        self.valuelbl.text = "\(Int(self.value))"
    }
    
    func reloadUI() {
        self.middleLbl.isHidden = false
        self.checkImg.isHidden = true
        self.toplbl.isHidden = true
        self.valuelbl.isHidden = true
    }
    
}
