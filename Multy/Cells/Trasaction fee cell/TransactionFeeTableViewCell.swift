//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class TransactionFeeTableViewCell: UITableViewCell {
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var speedImage: UIImageView!
    @IBOutlet weak var speedLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!             // ∙ 1 hour
    @IBOutlet weak var sumLbl: UILabel!              //  0.0001 BTC / 0.77 USD
    @IBOutlet weak var numberOfBlocksLbl: UILabel!   // 6 blocks
    @IBOutlet weak var checkMarkImage: UIImageView!
    
    var feeRate: NSDictionary? {
        didSet {
            print(feeRate)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func constructString(from rate: Int) -> String {
        let sumInCrypto = Double(rate) / 100000000.0
        let sumInFiat = sumInCrypto * exchangeCourse
        return "\(sumInCrypto.fixedFraction(digits: 8)) BTC / \(sumInFiat.fixedFraction(digits: 2)) USD"
    }
    
    func makeCellBy(indexPath: IndexPath) {
        
        //MARK: number of block - for the future release
        numberOfBlocksLbl.isHidden = true
        
        switch indexPath {
        case [0,0]:
            self.setCornersForFirstCell()
            self.speedImage.image = #imageLiteral(resourceName: "veryFast")
            self.speedLbl.text = "Very Fast"
            self.timeLbl.text = "∙ 10 minutes"
            
            if let rate = feeRate?["VeryFast"] as? Int {
                self.sumLbl.text = constructString(from: rate)
            }
//            self.sumLbl.text = "" //example: 0.0001 BTC / 0.77 USD
            self.numberOfBlocksLbl.text = "6 blocks"
        case [0,1]:
            self.speedImage.image = #imageLiteral(resourceName: "fast")
            self.speedLbl.text = "Fast"
            self.timeLbl.text = "∙ 6 hour"
            
            if let rate = feeRate?["Fast"] as? Int {
                self.sumLbl.text = constructString(from: rate)
            }
//            self.sumLbl.text = "" //example: 0.0001 BTC / 0.77 USD
            self.numberOfBlocksLbl.text = "10 blocks"
        case [0,2]:
            self.speedImage.image = #imageLiteral(resourceName: "mEdium")
            self.speedLbl.text = "Medium"
            self.timeLbl.text = "∙ 5 days"
            
            if let rate = feeRate?["Medium"] as? Int {
                self.sumLbl.text = constructString(from: rate)
            }
//            self.sumLbl.text = "" //example: 0.0001 BTC / 0.77 USD
            self.numberOfBlocksLbl.text = "20 blocks"
        case [0,3]:
            self.speedImage.image = #imageLiteral(resourceName: "slow")
            self.speedLbl.text = "Slow"
            self.timeLbl.text = "∙ 1 week"
            
            if let rate = feeRate?["Slow"] as? Int {
                self.sumLbl.text = constructString(from: rate)
            }
//            self.sumLbl.text = "" //example: 0.0001 BTC / 0.77 USD
            self.numberOfBlocksLbl.text = "50 blocks"
        case [0,4]:
            self.speedImage.image = #imageLiteral(resourceName: "verySlow")
            self.speedLbl.text = "Very Slow"
            self.timeLbl.text = "∙ 2 weeks"
            
            if let rate = feeRate?["VerySlow"] as? Int {
                self.sumLbl.text = constructString(from: rate)
            }
//            self.sumLbl.text = "" //example: 0.0001 BTC / 0.77 USD
            self.numberOfBlocksLbl.text = "70 blocks"
        default:
            return
        }
    }
    
    func setCornersForFirstCell() {
        let maskPath = UIBezierPath.init(roundedRect: self.backView.bounds,
                                         byRoundingCorners:[.topLeft, .topRight],
                                         cornerRadii: CGSize.init(width: 15.0, height: 15.0))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.backView.bounds
        maskLayer.path = maskPath.cgPath
        self.backView.layer.mask = maskLayer
    }
    
    func setCheckmarkHiden() {
        if self.checkMarkImage.isHidden {
            self.checkMarkImage.isHidden = false
        } else {
            self.checkMarkImage.isHidden = true
        }
    }
    
}
