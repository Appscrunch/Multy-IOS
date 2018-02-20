//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import ZFRippleButton

class BackupFinishViewController: UIViewController, AnalyticsProtocol {
    
    @IBOutlet weak var greatBtn: ZFRippleButton!
    @IBOutlet weak var bricksView: UIView!
    
    var isRestore = false
    
    var seedString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bricksView.subviews.forEach({ $0.removeFromSuperview() })
        bricksView.addSubview(BricksView(with: bricksView.bounds, and: 15))
        sendAnalyticsEvent(screenName: screenSuccessRestore, eventName: screenSuccessRestore)
        sendAnalyticsEvent(screenName: screenSuccessRestore, eventName: seedBackuped)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.greatBtn.applyGradient(
            withColours: [UIColor(ciColor: CIColor(red: 0/255, green: 178/255, blue: 255/255)),
                          UIColor(ciColor: CIColor(red: 0/255, green: 122/255, blue: 255/255))],
            gradientOrientation: .horizontal)
    }
    
    @IBAction func greatAction(_ sender: Any) {
        sendAnalyticsEvent(screenName: screenSuccessRestore, eventName: greatTap)
//        DataManager.shared.auth(rootKey: DataManager.shared.getRootString(from: self.seedString).0) { (acc, err) in
//            print(acc ?? "")
        DataManager.shared.realmManager.clearSeedPhraseInAcc()
        self.navigationController?.popToRootViewController(animated: true)
    }

}
