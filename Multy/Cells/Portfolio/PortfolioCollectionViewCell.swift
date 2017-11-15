//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class PortfolioCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var prFirstView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    func makeCornerRadius() {
        let maskPath = UIBezierPath.init(roundedRect: self.prFirstView.bounds, byRoundingCorners:[.bottomRight, .bottomLeft], cornerRadii: CGSize.init(width: 10.0, height: 10.0))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.prFirstView.bounds
        maskLayer.path = maskPath.cgPath
        self.prFirstView.layer.mask = maskLayer
    }
    
}
