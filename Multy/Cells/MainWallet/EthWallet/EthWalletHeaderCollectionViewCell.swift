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
        self.cryptoAmountLabel.text = wallet?.sumInCryptoString
        let blockchain = BlockchainType.create(wallet: wallet!)
        //MARK: temporary code
        self.cryptoNameLabel.text = blockchain.shortName //"\(wallet?.cryptoName ?? "")"
        self.fiatAmountLabel.text = wallet?.sumInFiatString
        self.fiatNameLabel.text = "\(wallet?.fiatName ?? "")"
        self.addressLabel.text = "\(wallet?.address ?? "")"
        
        let pendingWeiAmountString = wallet!.ethWallet!.pendingWeiAmountString
        
        if pendingWeiAmountString == "0" {
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
            
            let availableCryptoAmount = BigInt(wallet!.ethWallet!.balance) - BigInt(pendingWeiAmountString)
            let availableFiatAmount = availableCryptoAmount * wallet!.exchangeCourse
            
            lockedCryptoAmountLabel.text = availableCryptoAmount.cryptoValueString(for: BLOCKCHAIN_ETHEREUM)
            lockedFiatAmountLabel.text = availableFiatAmount.fiatValueString
        }
    }
    
    @IBAction func showAddressAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Wallet", bundle: nil)
        let adressVC = storyboard.instantiateViewController(withIdentifier: "walletAdressVC") as! AddressViewController
        adressVC.modalPresentationStyle = .overCurrentContext
        adressVC.modalTransitionStyle = .crossDissolve
        adressVC.wallet = self.wallet
        //        self.mainVC.present
        self.mainVC?.present(adressVC, animated: true, completion: nil)
//        sendAnalyticsEvent(screenName: "\(screenWalletWithChain)\(wallet!.chain)", eventName: "\(addressWithChainTap)\(wallet!.chain)")
    }
    
}
