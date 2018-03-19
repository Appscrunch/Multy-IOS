//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class BlockchainCellTableViewCell: UITableViewCell {

    @IBOutlet weak var chainImg: UIImageView!
    @IBOutlet weak var chainShortNameLbl: UILabel!
    @IBOutlet weak var chainFullNameLbl: UILabel!
    @IBOutlet weak var donatImg: UIImageView!
    @IBOutlet weak var checkmarkImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateIconsVisibility(isAvailable: Bool, isChecked: Bool) {
        if isAvailable {
            self.chainImg.alpha = 1.0
            self.chainShortNameLbl.alpha = 1.0
            self.chainFullNameLbl.alpha = 1.0
            self.checkmarkImg.isHidden = !isChecked
            self.donatImg.isHidden = true
        } else {
            self.chainImg.alpha = 0.5
            self.chainShortNameLbl.alpha = 0.5
            self.chainFullNameLbl.alpha = 0.5
            self.checkmarkImg.isHidden = true
            self.donatImg.isHidden = false
        }
    }
    
    func fillFromArr(curObj: CurrencyObj) {
        self.chainImg.image = UIImage(named: curObj.currencyImgName)
        self.chainShortNameLbl.text = curObj.currencyShortName
        self.chainFullNameLbl.text =  curObj.currencyFullName
    }
    
}
