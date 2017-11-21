//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class ReceiveAllDetailsViewController: UIViewController {

    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var qrImage: UIImageView!
    @IBOutlet weak var addressLbl: UILabel!
    
    @IBOutlet weak var requestSumBtn: UIButton! // hide title when sum was requested
    @IBOutlet weak var sumValueLbl: UILabel!
    @IBOutlet weak var cryptoNameLbl: UILabel!
    @IBOutlet weak var fiatSumAndNameLbl: UILabel!
    
    @IBOutlet weak var walletNameLbl: UILabel!
    @IBOutlet weak var walletCryptoSumBtn: UIButton! //set title with sum here
    @IBOutlet weak var walletFiatSumLbl: UILabel!
    
    
    let presenter = ReceiveAllDetailsPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.receiveAllDetailsVC = self
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func requestSumAction(_ sender: Any) {
        self.performSegue(withIdentifier: "receiveAmount", sender: UIButton.self)
    }
    
    @IBAction func wirelessScanAction(_ sender: Any) {
    }
    
    @IBAction func addressBookAction(_ sender: Any) {
    }
    
    @IBAction func moreOptionsAction(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "receiveAmount" {
            let destVC = segue.destination as! ReceiveAmountViewController
            destVC.delegate = self.presenter
        }
    }
}
