//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class TransactionWalletCell: UITableViewCell {
    
    @IBOutlet weak var transactionImage: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cryptoAmountLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var fiatAmountLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func fillCell() {
    
    }
    
    func setCorners() {
        let maskPath = UIBezierPath.init(roundedRect: bounds,
                                         byRoundingCorners:[.topLeft, .topRight],
                                         cornerRadii: CGSize.init(width: 15.0, height: 15.0))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
}
