//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class WalletAddressTableViewCell: UITableViewCell {

    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var sumLbl: UILabel!             // 0.0001 BTC / 100 USD
    @IBOutlet weak var creationTimeLbl: UILabel!    // 1.11.2017 ∙  23:15
    
    var wallet: UserWalletRLM?
    
    var sumInCrypto = 0.0
    var sumInFiat = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func fillInCell(index: Int) {
        let exchangeCourse = DataManager.shared.makeExchangeFor(blockchainType: BlockchainType.create(wallet: wallet!))
        let address = self.wallet?.addresses[index]
        
        if address == nil {
            return
        }
        
        self.addressLbl.text = address!.address
        self.creationTimeLbl?.text = Date.walletAddressGMTDateFormatter().string(from: address!.lastActionDate)
        
        if self.wallet?.chain == 0 {
            sumInCrypto = convertSatoshiToBTC(sum: UInt64(self.wallet!.addresses[index].amount.uint64Value))
        }
        sumInFiat = sumInCrypto * exchangeCourse
        
        self.sumLbl.text = "\(sumInCrypto.fixedFraction(digits: 8)) \(self.wallet?.cryptoName ?? "") / \(sumInFiat.fixedFraction(digits: 2)) \(self.wallet?.fiatName ?? "")"
//        self.creationTimeLbl.text = self.wallet?.addresses[index].creationData     // date of creation of wallet
    }
    
    func updateExchange() {
        let exchangeCourse = DataManager.shared.makeExchangeFor(blockchainType: BlockchainType.create(wallet: wallet!))
        sumInFiat = sumInCrypto * exchangeCourse
        self.sumLbl.text = "\(sumInCrypto.fixedFraction(digits: 8)) \(self.wallet?.cryptoName ?? "") / \(sumInFiat.fixedFraction(digits: 2)) \(self.wallet?.fiatName ?? "")"
    }
    
}
