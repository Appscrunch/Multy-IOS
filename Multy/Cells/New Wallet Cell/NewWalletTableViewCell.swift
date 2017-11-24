//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class NewWalletTableViewCell: UITableViewCell {

    @IBOutlet weak var topLineView: UIView!
    @IBOutlet weak var cellNameLbl: UILabel!
    @IBOutlet weak var rigthSmallImage: UIImageView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var content: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func setupForSendStartVC() {
        self.content.backgroundColor = UIColor.white
        self.rigthSmallImage.isHidden = true
        self.topLineView.isHidden = true
        self.cellNameLbl.font = UIFont(name: "Avenir Next Medium", size: 16)
        self.cellNameLbl.text = "Recent Addresses"
    }
}
