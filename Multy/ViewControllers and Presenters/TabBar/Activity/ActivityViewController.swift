//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class ActivityViewController: UIViewController, CancelProtocol, AnalyticsProtocol {
    @IBOutlet weak var newsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        sendAnalyticsEvent(screenName: screenActivity, eventName: screenActivity)
        
        newsView.layer.shadowColor = UIColor.gray.cgColor
        newsView.layer.shadowOpacity = 1
        newsView.layer.shadowOffset = .zero
        newsView.layer.shadowRadius = 10
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
        let donatAlert = storyboard.instantiateViewController(withIdentifier: "donationAlert") as! DonationAlertViewController
        donatAlert.modalPresentationStyle = .overCurrentContext
        donatAlert.cancelDelegate = self
        self.present(donatAlert, animated: true, completion: nil)
        (self.tabBarController as! CustomTabBarViewController).changeViewVisibility(isHidden: true)
    }
    
    func cancelAction() {
        (self.tabBarController as! CustomTabBarViewController).changeViewVisibility(isHidden: false)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let donatSendVC = storyboard.instantiateViewController(withIdentifier: "donatSendVC") as! DonationSendViewController
        self.navigationController?.pushViewController(donatSendVC, animated: true)
    }
    
    func presentNoInternet() {
        (self.tabBarController as! CustomTabBarViewController).changeViewVisibility(isHidden: false)
    }
}
