//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class PortfolioCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var backView: UIView!
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
    
    func makeshadow() {
        self.backView.dropShadow(color: #colorLiteral(red: 0.9254901961, green: 0.9333333333, blue: 0.968627451, alpha: 1), opacity: 1.0, offSet: CGSize(width: -1, height: 1), radius: 4, scale: true)
    }
    
}

