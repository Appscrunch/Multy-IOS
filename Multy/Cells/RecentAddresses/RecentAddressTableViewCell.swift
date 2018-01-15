//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class RecentAddressTableViewCell: UITableViewCell {

    @IBOutlet weak var cryptoImage: UIImageView!
    @IBOutlet weak var addressNameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
