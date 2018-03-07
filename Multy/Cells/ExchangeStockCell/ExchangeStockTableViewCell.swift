//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class ExchangeStockTableViewCell: UITableViewCell {

    @IBOutlet weak var exchangeNameLbl: UILabel!
    @IBOutlet weak var checkmarkImg: UIImageView!
    @IBOutlet weak var donationImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func makeCheckmark(isAvailable: Bool, isChecked: Bool) {
        self.donationImg.isHidden = isAvailable
        
        if isAvailable {
            self.exchangeNameLbl.alpha = 1.0
            self.checkmarkImg.isHidden = !isChecked
        } else {
            self.exchangeNameLbl.alpha = 0.5
            self.checkmarkImg.isHidden = true
        }
    }
    
    func fillCell(exchangeStock: ExchangeStockObj) {
        self.exchangeNameLbl.text = exchangeStock.name
    }
}
