//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class WalletTableViewCell: UITableViewCell {

    @IBOutlet weak var tokenImage: UIImageView!
    @IBOutlet weak var walletNameLbl: UILabel!
    @IBOutlet weak var cryptoSumLbl: UILabel!
    @IBOutlet weak var cryptoNameLbl: UILabel!
    @IBOutlet weak var fiatSumLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
}
