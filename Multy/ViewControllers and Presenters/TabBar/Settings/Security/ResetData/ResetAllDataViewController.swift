//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class ResetAllDataViewController: UIViewController, AnalyticsProtocol {

    @IBOutlet weak var cancelBtn: UIButton!
    
    var cancelDelegate: CancelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cancelBtn.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 15)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        sendAnalyticsEvent(screenName: screenSecuritySettings, eventName: resetDeclined)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetAction(_ sender: Any) {
        let alert = UIAlertController(title: "Warning", message: "Are you sure?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
            self.dismiss(animated: true, completion: {
                self.cancelDelegate?.cancelAction()
            })
            self.sendAnalyticsEvent(screenName: screenSecuritySettings, eventName: resetComplete)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (_) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
