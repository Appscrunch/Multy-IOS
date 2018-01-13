//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class WalletAddressTableViewCell: UITableViewCell {

    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var sumLbl: UILabel!             // 0.0001 BTC / 100 USD
    @IBOutlet weak var creationTimeLbl: UILabel!    // 1.11.2017 ∙  23:15
    
    var wallet: UserWalletRLM?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func fillInCell(index: Int) {
        var sumInCrypto = 0.0
        var sumInFiat = 0.0
        self.addressLbl.text = self.wallet?.addresses[index].address
        
        if self.wallet?.chain == 0 {
            sumInCrypto = self.wallet!.addresses[index].amount.doubleValue
        }
        sumInFiat = sumInCrypto * exchangeCourse
        
        self.sumLbl.text = "\(sumInCrypto.fixedFraction(digits: 8)) \(self.wallet?.cryptoName ?? "") / \(sumInFiat.fixedFraction(digits: 2)) \(self.wallet?.fiatName ?? "")"
//        self.creationTimeLbl.text = self.wallet?.addresses[index].creationData     // date of creation of wallet
    }
    
}
