//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class ActivityViewController: UIViewController, CancelProtocol, AnalyticsProtocol {
    @IBOutlet weak var newsView: UIView!
    @IBOutlet weak var donatView: UIView!
    
    var message = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        sendAnalyticsEvent(screenName: screenActivity, eventName: screenActivity)
        
        newsView.layer.shadowColor = UIColor.gray.cgColor
        newsView.layer.shadowOpacity = 1
        newsView.layer.shadowOffset = .zero
        newsView.layer.shadowRadius = 10
        
        setupView()
    }
    
    func setupView() {
        self.donatView.layer.borderColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 0.9994150996, alpha: 1)
        self.donatView.layer.borderWidth = 1
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
    
    @IBAction func goToAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let donatAlert = storyboard.instantiateViewController(withIdentifier: "donationAlert") as! DonationAlertViewController
//        donatAlert.modalPresentationStyle = .overCurrentContext
//        donatAlert.cancelDelegate = self
//        self.present(donatAlert, animated: true, completion: nil)
        let webView = storyboard.instantiateViewController(withIdentifier: "ActivityWebViewVC")
        self.navigationController?.pushViewController(webView, animated: true)
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
        sendDonationAlertScreenPresentedAnalytics(code: donationForActivitySC)
    }
    
    func cancelAction() {
        (self.tabBarController as! CustomTabBarViewController).changeViewVisibility(isHidden: false)
        presentDonationVCorAlert()
    }
    
    func presentNoInternet() {
        (self.tabBarController as! CustomTabBarViewController).changeViewVisibility(isHidden: false)
    }
}
