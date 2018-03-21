//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class EthWalletHeaderCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var showAddressesButton : UIButton!
    @IBOutlet weak var cryptoAmountLabel : UILabel!
    @IBOutlet weak var cryptoNameLabel : UILabel!
    @IBOutlet weak var fiatAmountLabel : UILabel!
    @IBOutlet weak var fiatNameLabel : UILabel!
    @IBOutlet weak var addressLabel : UILabel!
    
    @IBOutlet weak var lockedCryptoAmountLabel : UILabel!
    @IBOutlet weak var lockedFiatAmountLabel : UILabel!
    
    @IBOutlet weak var lockedInfoStackView : UIStackView!
    @IBOutlet weak var lockedInfoConstraint : NSLayoutConstraint!
    
    @IBOutlet weak var lockedPopverWithBorders : UIView!
    
    var blockedAmount = UInt64()
    
    var wallet: UserWalletRLM?
    var mainVC: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func fillInCell() {
        let sumInFiat = ((self.wallet?.sumInCrypto)! * exchangeCourse).fixedFraction(digits: 2)
        self.cryptoAmountLabel.text = "\(wallet?.sumInCrypto.fixedFraction(digits: 8) ?? "0.0")"
        let blockchain = BlockchainType.create(wallet: wallet!)
        //MARK: temporary code
        self.cryptoNameLabel.text = blockchain.shortName //"\(wallet?.cryptoName ?? "")"
        self.fiatAmountLabel.text = sumInFiat
        self.fiatNameLabel.text = "\(wallet?.fiatName ?? "")"
        self.addressLabel.text = "\(wallet?.address ?? "")"
        
        if blockedAmount == 0 {
            lockedInfoStackView.isHidden = true
            lockedInfoConstraint.constant = 20
            
            lockedPopverWithBorders.isHidden = true
        } else {
            lockedInfoStackView.isHidden = false
            lockedInfoConstraint.constant = 80
            
            lockedPopverWithBorders.isHidden = false
            
            lockedPopverWithBorders.layer.borderColor = UIColor.white.cgColor
            lockedPopverWithBorders.layer.cornerRadius = 20;
            lockedPopverWithBorders.layer.masksToBounds = true
            lockedPopverWithBorders.layer.borderWidth = 1.0
            
            
            //some strange info from server
            //MARK: FIX THIS
            var sum = UInt64(0)
            if convertBTCStringToSatoshi(sum: wallet!.sumInCrypto.fixedFraction(digits: 8)) >= blockedAmount {
                sum = convertBTCStringToSatoshi(sum: wallet!.sumInCrypto.fixedFraction(digits: 8)) - blockedAmount
            } else {
                sum = blockedAmount
            }
            
            let availableCryptoAmount = convertSatoshiToBTC(sum: sum)
            let availableFiatAmount = availableCryptoAmount * exchangeCourse
            
            lockedCryptoAmountLabel.text = availableCryptoAmount.fixedFraction(digits: 8)
            lockedFiatAmountLabel.text = availableFiatAmount.fixedFraction(digits: 2)
        }
    }
}
