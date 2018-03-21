//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import RealmSwift

class BTCWalletHeaderCollectionViewCell: UICollectionViewCell, AnalyticsProtocol {

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
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//        
//    }
    
    func makeCornerRadius() {
        let maskPath = UIBezierPath.init(roundedRect: showAddressesButton.bounds,
                                         byRoundingCorners:[.bottomRight, .bottomLeft],
                                         cornerRadii: CGSize.init(width: 10.0, height: 10.0))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = showAddressesButton.bounds
        maskLayer.path = maskPath.cgPath
        showAddressesButton.layer.mask = maskLayer
    }
    
    func fillInCell() {
        let exchangeCourse = DataManager.shared.makeExchangeFor(blockchainType: BlockchainType.create(wallet: wallet!))
        let sumInFiat = ((self.wallet?.sumInCrypto)! * exchangeCourse).fixedFraction(digits: 2)
        self.cryptoAmountLabel.text = "\(wallet?.sumInCrypto.fixedFraction(digits: 8) ?? "0.0")"
        //FIXME: BLOCKCHAIN
        let blockchain = BlockchainType.create(wallet: wallet!)
        self.cryptoNameLabel.text = blockchain.shortName // "\(wallet?.cryptoName ?? "")"
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
            //FIXME: FIX THIS
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
    
    @IBAction func cryptoAction(_ sender: Any) {
        sendAnalyticsEvent(screenName: "\(screenWalletWithChain)\(wallet!.chain)", eventName: "\(cryptoAmountWithChainTap)\(wallet!.chain)")
    }
    
    @IBAction func fiatAction(_ sender: Any) {
        sendAnalyticsEvent(screenName: "\(screenWalletWithChain)\(wallet!.chain)", eventName: "\(fiatAmountWithChainTap)\(wallet!.chain)")
    }
    
    @IBAction func showAddressAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Wallet", bundle: nil)
        let adressVC = storyboard.instantiateViewController(withIdentifier: "walletAdressVC") as! AddressViewController
        adressVC.modalPresentationStyle = .overCurrentContext
        adressVC.wallet = self.wallet
//        self.mainVC.present
        self.mainVC?.present(adressVC, animated: true, completion: nil)
        sendAnalyticsEvent(screenName: "\(screenWalletWithChain)\(wallet!.chain)", eventName: "\(addressWithChainTap)\(wallet!.chain)")
    }
    
    @IBAction func showAllAddressessAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Wallet", bundle: nil)
        let adressesVC = storyboard.instantiateViewController(withIdentifier: "walletAddresses") as! WalletAddresessViewController
        adressesVC.presenter.wallet = self.wallet
        self.mainVC?.navigationController?.pushViewController(adressesVC, animated: true)
        sendAnalyticsEvent(screenName: "\(screenWalletWithChain)\(wallet!.chain)", eventName: "\(allAddressesWithChainTap)\(wallet!.chain)")
    }
}
