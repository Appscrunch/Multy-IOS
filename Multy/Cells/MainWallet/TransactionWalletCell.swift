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
    @IBOutlet weak var emtptyImage: UIImageView!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    var histObj = HistoryRLM()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func fillCell() {
        let dateFormat = DateFormatter()
        dateFormat.timeZone = TimeZone(abbreviation: "GMT")
        dateFormat.dateFormat = "dd MMM yyyy HH:mm"
        if histObj.txStatus == "incoming in mempool" {
            self.transactionImage.image = #imageLiteral(resourceName: "pending")
            let blockedTxInfoColor = UIColor(redInt: 135, greenInt: 161, blueInt: 197, alpha: 0.4)
            self.addressLabel.textColor = blockedTxInfoColor
            self.timeLabel.textColor = blockedTxInfoColor
            self.cryptoAmountLabel.textColor = blockedTxInfoColor
        } else if histObj.txStatus == "incoming in block" || histObj.txStatus == "in block confirmed" {
            self.transactionImage.image = #imageLiteral(resourceName: "recieve")
            self.addressLabel.textColor = .black
            self.timeLabel.textColor = .black
            self.cryptoAmountLabel.textColor = .black
        } else if histObj.txStatus == "spend in mempool" || histObj.txStatus == "spend in block" {
            self.transactionImage.image = #imageLiteral(resourceName: "send")
            self.addressLabel.textColor = .black
            self.timeLabel.textColor = .black
            self.cryptoAmountLabel.textColor = .black
        }
        self.addressLabel.text = histObj.txInputs[0].address
        self.timeLabel.text = dateFormat.string(from: histObj.blockTime)
        self.cryptoAmountLabel.text = "\(convertSatoshiToBTC(sum: histObj.txOutAmount.uint32Value)) BTC"
        
        self.fiatAmountLabel.text = "\((convertSatoshiToBTC(sum: histObj.txOutAmount.uint32Value) * histObj.btcToUsd).fixedFraction(digits: 2)) USD"
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
    
    
    func changeState(isEmpty: Bool) {
        self.transactionImage.isHidden = isEmpty
        self.addressLabel.isHidden = isEmpty
        self.cryptoAmountLabel.isHidden = isEmpty
        self.timeLabel.isHidden = isEmpty
        self.fiatAmountLabel.isHidden = isEmpty
//        self.descriptionLabel.isHidden = isEmpty
        self.emtptyImage.isHidden = !isEmpty
    }
    
    func changeTopConstraint() {
        self.topConstraint.constant = 15
    }
}
