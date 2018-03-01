//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class CurrencyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var currencyImg: UIImageView!
    @IBOutlet weak var currencyShortnameLbl: UILabel!
    @IBOutlet weak var currencyFullNameLbl: UILabel!
    @IBOutlet weak var checkmarkImg: UIImageView!
    @IBOutlet weak var donationImg: UIImageView!
    

    //donat obj
    var currenciesArr = [CurrencyObj]()
    //
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func makeNotAvailable() {
        self.currencyImg.alpha = 0.5
        self.currencyShortnameLbl.alpha = 0.5
        self.currencyFullNameLbl.alpha = 0.5
        self.checkmarkImg.isHidden = true
        self.donationImg.isHidden = false
    }
    
    func createCurrency() {
        let currencyEUR = CurrencyObj()
        currencyEUR.currencyImgName = "flagEur"
        currencyEUR.currencyShortName = "EUR"
        currencyEUR.currencyFullName = "Euro"
        
        let currencyETH = CurrencyObj()
        currencyETH.currencyImgName = "ETH_medium_icon"
        currencyETH.currencyShortName = "ETH"
        currencyETH.currencyFullName = "Ethereum"
        
        self.currenciesArr.append(currencyEUR)
        self.currenciesArr.append(currencyETH)
    }
    
    func fillFromArr(index: Int) {
        self.currencyImg.image = UIImage(named: self.currenciesArr[index].currencyImgName)
        self.currencyShortnameLbl.text = self.currenciesArr[index].currencyShortName
        self.currencyFullNameLbl.text =  self.currenciesArr[index].currencyFullName
    }
    
}
