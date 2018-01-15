//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import RealmSwift

class TransactionPendingCell: UITableViewCell {
//    @IBOutlet weak var transactionImage: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cryptoAmountLabel: UILabel!
    @IBOutlet weak var fiatAmountLabel: UILabel!

    @IBOutlet weak var lockedCryptoAmountLabel: UILabel!
    @IBOutlet weak var lockedFiatAmountLabel: UILabel!
    
    var histObj = HistoryRLM()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func fillCell() {
        self.addressLabel.text = histObj.txInputs[0].address
        
        self.cryptoAmountLabel.text = "\(convertSatoshiToBTC(sum: histObj.txOutAmount.uint32Value)) BTC"
        self.fiatAmountLabel.text = "\((convertSatoshiToBTC(sum: histObj.txOutAmount.uint32Value) * histObj.btcToUsd).fixedFraction(digits: 2)) USD"
        
        if histObj.txStatus == "incoming in block" {
//            lockedCryptoAmountLabel.text = "\"
//            lockedFiatAmountLabel.text = "\((amountInDouble * histObj.btcToUsd).fixedFraction(digits: 2))"
        } else if histObj.txStatus == "spend in mempool" {
            let amount = self.calculateAmount(transactions: histObj.txInputs)
            let amountInDouble = convertSatoshiToBTC(sum: amount)
            lockedCryptoAmountLabel.text = "\(amountInDouble.fixedFraction(digits: 8))"
            lockedFiatAmountLabel.text = "\((amountInDouble * histObj.btcToUsd).fixedFraction(digits: 2))"
        }
    }
    
    func calculateAmount(transactions: List<TxHistoryRLM>) -> UInt32 {
        var sum = UInt32()
        
        transactions.forEach({ sum += $0.amount.uint32Value })
        
        return sum
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
