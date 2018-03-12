//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class ContactsViewController: UIViewController, AnalyticsProtocol, CancelProtocol {

    @IBOutlet weak var donatView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.setupView()
        sendAnalyticsEvent(screenName: screenContacts, eventName: screenContacts)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        (self.tabBarController as! CustomTabBarViewController).changeViewVisibility(isHidden: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        (self.tabBarController as! CustomTabBarViewController).changeViewVisibility(isHidden: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        (self.tabBarController as! CustomTabBarViewController).changeViewVisibility(isHidden: true)
    }
    
    @IBAction func donatAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let donatAlert = storyboard.instantiateViewController(withIdentifier: "donationAlert") as! DonationAlertViewController
        donatAlert.modalPresentationStyle = .overCurrentContext
        donatAlert.cancelDelegate = self
        self.present(donatAlert, animated: true, completion: nil)
        (self.tabBarController as! CustomTabBarViewController).changeViewVisibility(isHidden: true)
        
        logAnalytics()
    }
    
    func logAnalytics() {
        sendDonationAlertScreenPresentedAnalytics(code: donationForContactSC)
    }
    
    func setupView() {
        self.donatView.layer.borderColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 0.9994150996, alpha: 1)
        self.donatView.layer.borderWidth = 1
    }
    
    func cancelAction() {
        (self.tabBarController as! CustomTabBarViewController).changeViewVisibility(isHidden: false)
        DataManager.shared.realmManager.fetchAllWallets { (wallets) in
            if wallets == nil {
                let message = "You don`t have any wallets yet."
                self.donateOrAlert(isHaveNotEmptyWallet: false, message: message)
                return
            }
            for wallet in wallets! {
                if wallet.availableAmount() > 0 {
                    let message = "You have nothing to donate.\nTop up any of your wallets first."  // no money no honey
                    self.donateOrAlert(isHaveNotEmptyWallet: true, message: message)
                    break
                } else { // empty wallet
                    let message = "You have nothing to donate.\nTop up any of your wallets first."  // no money no honey
                    self.donateOrAlert(isHaveNotEmptyWallet: false, message: message)
                    break
                }
            }
            //            self.donateOrAlert()
        }
    }
    
    func presentNoInternet() {
        (self.tabBarController as! CustomTabBarViewController).changeViewVisibility(isHidden: false)
    }
}
