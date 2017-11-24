//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class MainWalletCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var showAddressesButton : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func makeCornerRadius() {
        let maskPath = UIBezierPath.init(roundedRect: showAddressesButton.bounds, byRoundingCorners:[.bottomRight, .bottomLeft], cornerRadii: CGSize.init(width: 10.0, height: 10.0))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = showAddressesButton.bounds
        maskLayer.path = maskPath.cgPath
        showAddressesButton.layer.mask = maskLayer
    }
}
