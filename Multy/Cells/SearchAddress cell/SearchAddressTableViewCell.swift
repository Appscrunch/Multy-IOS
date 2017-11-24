//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class SearchAddressTableViewCell: UITableViewCell {

    @IBOutlet weak var addressTF: UITextField!
    
    var cancelDelegate: CancelProtocol?
    var sendAddressDelegate: SendAddressProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.cancelDelegate?.cancelAction()
    }
    
    @IBAction func addressBookAction(_ sender: Any) {
    }
    
    @IBAction func wirelessScanAction(_ sender: Any) {
    }
    
    @IBAction func scanQrAction(_ sender: Any) {
    }
}

extension SearchAddressTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.addressTF.resignFirstResponder()
        self.sendAddressDelegate?.sendAddress(address: textField.text!)
        return true
    }
}
