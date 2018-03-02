//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class ActivityWebViewViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var spiner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.presenter.blockchainVC = self
        self.loadPage()
        self.webView.delegate = self
        self.spiner.hidesWhenStopped = true
    }
    
    func loadPage() {
        self.webView.scalesPageToFit = true
        self.webView.contentMode = .scaleAspectFit
        self.webView.loadRequest(URLRequest(url: URL(string: "http://multy.io/donation_features")!))
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        spiner.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        spiner.stopAnimating()
    }
}
