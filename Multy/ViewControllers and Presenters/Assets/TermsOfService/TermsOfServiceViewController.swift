//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

private typealias LocalizeDelegate = TermsOfServiceViewController

class TermsOfServiceViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var spiner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        (self.tabBarController as! CustomTabBarViewController).changeViewVisibility(isHidden: true)
        self.loadPage()
        self.webView.delegate = self
        self.spiner.hidesWhenStopped = true
    }
    
    func loadPage() {
        let url = "https://raw.githubusercontent.com/wiki/Appscrunch/Multy/Legal:-Terms-of-service.md"
        self.webView.scalesPageToFit = true
        self.webView.contentMode = .scaleAspectFit
        self.webView.loadRequest(URLRequest(url: URL(string: url)!))
    }
    
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        spiner.startAnimating()
        self.view.isUserInteractionEnabled = false
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        spiner.stopAnimating()
        self.view.isUserInteractionEnabled = true
    }
    
    
    @IBAction func acceptAction(_ sender: Any) {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        appDel.registerPush()
        
        UserDefaults.standard.set(false, forKey: "isTermsAccept")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openPrivacyPolicy(_ sender: Any) {
        guard let url = URL(string: "https://raw.githubusercontent.com/wiki/Appscrunch/Multy/Legal:-Privacy-Policy.md") else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let webTextVC = storyboard.instantiateViewController(withIdentifier: "webText") as! WebTextPageViewController
//        webTextVC.tagForLoad = 0
//        self.present(webTextVC, animated: true, completion: nil)
    }
    
    @IBAction func discardAction(_ sender: Any) {
        let message = "In order to use Multy you have to accept Terms of Service. By pressing \"Accept\" you confirm that you have read, understood and agree to the following Terms of Service and that you have the right, power and authority to do so."
        let alert = UIAlertController(title: "Sorry", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: localize(string: Constants.cancelString), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension LocalizeDelegate: Localizable {
    var tableName: String {
        return "Assets"
    }
}
