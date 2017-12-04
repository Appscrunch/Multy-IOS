//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class SearchAddressTableViewCell: UITableViewCell {

    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var addressInTfLlb: UILabel!
    
    var cancelDelegate: CancelProtocol?
    var sendAddressDelegate: SendAddressProtocol?
    var goToQrDelegate: GoToQrProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        (self.addressTF.value(forKey: "textInputTraits") as AnyObject).setValue(UIColor.clear , forKey:"insertionPointColor")
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
        self.goToQrDelegate?.goToScanQr()
    }
    
    func updateWithAddress(address: String) {
//        self.addressTF.isHidden = true
        self.addressTF.textColor = .white
        self.addressTF.text = address
        self.addressInTfLlb.text = address
    }
}

extension SearchAddressTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.addressTF.resignFirstResponder()
        self.sendAddressDelegate?.sendAddress(address: textField.text!)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "" {
            self.addressInTfLlb.text?.removeLast()
        } else {
//            self.addressTF.isHidden = true
            self.addressInTfLlb.text = self.addressTF.text! + string
        }
        if self.addressInTfLlb.text == "" {
            self.addressTF.isHidden = false
        }
        
        return true
    }
    
}
