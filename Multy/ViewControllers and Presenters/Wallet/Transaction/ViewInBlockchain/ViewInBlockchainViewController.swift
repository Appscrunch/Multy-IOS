//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class ViewInBlockchainViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var spiner: UIActivityIndicatorView!
    
    let presenter = ViewInBlockchainPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.swipeToBack()
        self.presenter.blockchainVC = self
        self.loadPage(txId: presenter.txId!)
        self.webView.delegate = self
        self.spiner.hidesWhenStopped = true
    }
    
    func loadPage(txId: String) {
        self.webView.scalesPageToFit = true
        self.webView.contentMode = .scaleAspectFit
        
        //FIXME:
        //Work for bitcoin only
        let subUrl = presenter.blockchainType!.net_type == 0 ? "" : "testnet."
        
        self.webView.loadRequest(URLRequest(url: URL(string: "https://\(subUrl)blockchain.info/tx/\(txId)")!))
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
