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
    
    func makeUnAvailable() {
        self.exchangeNameLbl.alpha = 0.5
        self.checkmarkImg.isHidden = true
        self.donationImg.isHidden = false
    }
    
    func fillCell(exchangeStock: ExchangeStockObj) {
        self.exchangeNameLbl.text = exchangeStock.name
    }
}
