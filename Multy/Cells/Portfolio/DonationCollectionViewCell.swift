//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class DonationCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var midLbl: UILabel!
    @IBOutlet weak var botView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func makeCellBy(index: Int) {
        switch index {
        case 0:
            self.backgroundImg.image = #imageLiteral(resourceName: "portfolioDonationImage")
            self.midLbl.text = "Crypto portfolio"
        case 1:
            self.backgroundImg.image = #imageLiteral(resourceName: "chartsDonationImage")
            self.midLbl.text = "Currencies charts"
        default: break
        }
    }
    
    func setupUI() {
        botView.layer.shadowColor = UIColor.black.cgColor
        botView.layer.shadowOpacity = 1
        botView.layer.shadowOffset = CGSize.zero
        botView.layer.shadowRadius = 15
    }

}
