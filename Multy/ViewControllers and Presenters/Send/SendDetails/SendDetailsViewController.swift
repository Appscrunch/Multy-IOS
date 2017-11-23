//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import ZFRippleButton

class SendDetailsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var donationSeparatorView: UIView!
    @IBOutlet weak var donationTitleLbl: UILabel!
    @IBOutlet weak var donationTF: UITextField!
    @IBOutlet weak var donationSumLbl: UILabel!
    @IBOutlet weak var donationFiatNameLbl: UILabel!
    @IBOutlet weak var donationCryptoNameLbl: UILabel!
    @IBOutlet weak var isDonateAvailableSW: UISwitch!
    
    @IBOutlet weak var constraintDonationHeight: NSLayoutConstraint!
    @IBOutlet weak var nextBtn: ZFRippleButton!
    
    let presenter = SendDetailsPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        self.hideKeyboardWhenTappedAround()
        self.presenter.sendDetailsVC = self
        self.registerCells()
        
        NotificationCenter.default.addObserver(self, selector: #selector(SendDetailsViewController.keyboardWillShow),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SendDetailsViewController.keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }
    
    func registerCells() {
        let transactionCell = UINib(nibName: "TransactionFeeTableViewCell", bundle: nil)
        self.tableView.register(transactionCell, forCellReuseIdentifier: "transactionCell")
        
        let customFeeCell = UINib(nibName: "CustomTrasanctionFeeTableViewCell", bundle: nil)
        self.tableView.register(customFeeCell, forCellReuseIdentifier: "customFeeCell")
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func switchDonationAction(_ sender: Any) {
        if self.isDonateAvailableSW.isOn == false {
            self.constraintDonationHeight.constant = self.constraintDonationHeight.constant / 2
            self.scrollView.contentSize.height = self.scrollView.contentSize.height - self.constraintDonationHeight.constant
        } else {
            self.constraintDonationHeight.constant = self.constraintDonationHeight.constant * 2
            self.scrollView.contentSize.height = self.scrollView.contentSize.height + self.constraintDonationHeight.constant
        }
        self.hideOrShowDonationBottom()
        self.scrollView.scrollRectToVisible(self.nextBtn.frame, animated: true)
    }
    
    func hideOrShowDonationBottom() {
        self.donationSeparatorView.isHidden = !self.isDonateAvailableSW.isOn
        self.donationTF.isHidden = !self.isDonateAvailableSW.isOn
        self.donationSumLbl.isHidden = !self.isDonateAvailableSW.isOn
        self.donationFiatNameLbl.isHidden = !self.isDonateAvailableSW.isOn
        self.donationCryptoNameLbl.isHidden = !self.isDonateAvailableSW.isOn
        self.donationTitleLbl.isHidden = !self.isDonateAvailableSW.isOn
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.donationTF.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.scrollView.isScrollEnabled = false
        self.scrollView.scrollRectToVisible(self.nextBtn.frame, animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.scrollView.isScrollEnabled = true
    }
    
}

extension SendDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row != 5 {
            let transactionCell = self.tableView.dequeueReusableCell(withIdentifier: "transactionCell") as! TransactionFeeTableViewCell
            transactionCell.makeCellBy(indexPath: indexPath)
            return transactionCell
        } else {
            let customFeeCell = self.tableView.dequeueReusableCell(withIdentifier: "customFeeCell") as! CustomTrasanctionFeeTableViewCell
            return customFeeCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 5 {
            var cells = self.tableView.visibleCells
            cells.removeLast()
            let trueCells = cells as! [TransactionFeeTableViewCell]
            if trueCells[indexPath.row].checkMarkImage.isHidden == false {
                trueCells[indexPath.row].checkMarkImage.isHidden = true
                return
            }
            for cell in trueCells {
                cell.checkMarkImage.isHidden = true
            }
            trueCells[indexPath.row].checkMarkImage.isHidden = false
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
        
    }
}
