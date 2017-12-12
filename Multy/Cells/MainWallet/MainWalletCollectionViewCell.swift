//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class MainWalletCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var showAddressesButton : UIButton!
    @IBOutlet weak var cryptoAmountLabel : UILabel!
    @IBOutlet weak var cryptoNameLabel : UILabel!
    @IBOutlet weak var fiatAmountLabel : UILabel!
    @IBOutlet weak var fiatNameLabel : UILabel!
    @IBOutlet weak var addressLabel : UILabel!
    
    var wallet: UserWalletRLM?
    
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
    
    func fillInCell() {
        self.cryptoAmountLabel.text = "\(wallet?.sumInCrypto ?? 0.0)"
        self.cryptoNameLabel.text = "\(wallet?.cryptoName ?? "")"
        self.fiatAmountLabel.text = "\((wallet?.sumInCrypto)! * exchangeCourse)"
        self.fiatNameLabel.text = "\(wallet?.fiatName ?? "")"
        self.addressLabel.text = "\(wallet?.address ?? "")"
    }
}
