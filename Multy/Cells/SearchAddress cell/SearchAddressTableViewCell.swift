//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class SearchAddressTableViewCell: UITableViewCell, AnalyticsProtocol {

//    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var addressInTfLlb: UILabel!
    @IBOutlet weak var addressTV: UITextView!
    
    var cancelDelegate: CancelProtocol?
    var sendAddressDelegate: SendAddressProtocol?
    var goToQrDelegate: GoToQrProtocol?
    var donationDelegate: DonationProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.addressTV.delegate = self
//        (self.addressTV.value(forKey: "textInputTraits") as AnyObject).setValue(UIColor.clear , forKey:"insertionPointColor")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func cancelAction(_ sender: Any) {
        self.cancelDelegate?.cancelAction()
        sendAnalyticsEvent(screenName: screenSendTo, eventName: closeTap)
    }
    
    @IBAction func addressBookAction(_ sender: Any) {
        donationDelegate?.donate()
//        sendAnalyticsEvent(screenName: screenSendTo, eventName: addressBookTap)
        sendDonationAlertScreenPresentedAnalytics(code: donationForContactSC)
    }
    
    @IBAction func wirelessScanAction(_ sender: Any) {
        donationDelegate?.donate()
//        sendAnalyticsEvent(screenName: screenSendTo, eventName: wirelessScanTap)
        sendDonationAlertScreenPresentedAnalytics(code: donationForWirelessScanFUNC)
    }
    
    @IBAction func scanQrAction(_ sender: Any) {
        self.goToQrDelegate?.goToScanQr()
        sendAnalyticsEvent(screenName: screenSendTo, eventName: scanQrTap)
    }
    
    func updateWithAddress(address: String) {
//        self.addressTF.isHidden = true
//        self.addressTF.textColor = .white
        self.addressTV.text = address
        self.addressInTfLlb.text = address
    }
}

extension SearchAddressTableViewCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            cancelDelegate?.presentNoInternet()
            self.sendAddressDelegate?.sendAddress(address: textView.text!)
            return false
        }
        return true
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        if string == "" {
//            self.addressInTfLlb.text?.removeLast()
//        } else {
////            self.addressTF.isHidden = true
//            self.addressInTfLlb.text = self.addressTF.text! + string
//        }
//        if self.addressInTfLlb.text == "" {
//            self.addressTF.isHidden = false
//        }
//
//        return true
//    }
    
}
