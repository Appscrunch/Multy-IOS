//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class DonationCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var midLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func makeCellBy(index: Int) {
        switch index {
        case 0:
            self.backgroundImg.image = #imageLiteral(resourceName: "portfolioBgd")
            self.midLbl.text = "Crypto portfolio"
        case 1:
            self.backgroundImg.image = #imageLiteral(resourceName: "chartsBgd")
            self.midLbl.text = "Currencies charts"
        default: break
        }
    }

}
