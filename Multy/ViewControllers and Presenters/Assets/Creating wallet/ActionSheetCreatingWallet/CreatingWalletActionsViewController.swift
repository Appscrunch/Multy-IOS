//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class CreatingWalletActionsViewController: UIViewController, CancelProtocol, AnalyticsProtocol {

    var cancelDelegate: CancelProtocol?
    var createProtocol: CreateWalletProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        (self.tabBarController as! CustomTabBarViewController).changeViewVisibility(isHidden: true)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
        self.cancelDelegate?.presentNoInternet()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.cancelDelegate?.presentNoInternet()
    }
    
    
    @IBAction func createAction(_ sender: Any) {
        self.dismiss(animated: true) {
            self.createProtocol?.goToCreateWallet()
        }
//        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func importWalletAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let donatAlert = storyboard.instantiateViewController(withIdentifier: "donationAlert") as! DonationAlertViewController
        donatAlert.modalPresentationStyle = .overCurrentContext
        donatAlert.cancelDelegate = self
        self.present(donatAlert, animated: true, completion: nil)
        
        logAnalytics()
    }
    
    func logAnalytics() {
        sendDonationAlertScreenPresentedAnalytics(code: donationForImportWallet)
    }
    
    func cancelAction() {
        self.dismiss(animated: true) {
            self.cancelDelegate?.cancelAction()
        }
    }
    
    
    func presentNoInternet() {
        
    }
    
}

