//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class ContactsViewController: UIViewController, AnalyticsProtocol, CancelProtocol {

    @IBOutlet weak var donatView: UIView!
    var presenter = ContactsPresenter()
    @IBOutlet weak var donationTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.mainVC = self
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.setupView()
        ipadFix()
        sendAnalyticsEvent(screenName: screenContacts, eventName: screenContacts)
        
        presenter.tabBarFrame = tabBarController?.tabBar.frame
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.frame = presenter.tabBarFrame!
//        tabBarController?.tabBar.frame = CGRect(x: 0, y: screenHeight - 49, width: screenWidth, height: 49)
        (self.tabBarController as! CustomTabBarViewController).changeViewVisibility(isHidden: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func ipadFix() {
        if screenHeight == heightOfiPad {
            self.donationTopConstraint.constant = 0
        }
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
        presentDonationVCorAlert()
    }
    
    func presentNoInternet() {
        (self.tabBarController as! CustomTabBarViewController).changeViewVisibility(isHidden: false)
    }
}
