//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import ZFRippleButton

class BackupSeedPhraseViewController: UIViewController {

    @IBOutlet weak var continueBtn: ZFRippleButton!
    @IBOutlet weak var restartBtn: UIButton!
    @IBOutlet weak var restartLbl: UILabel!
    @IBOutlet weak var infoIconImg: UIImageView!
    
    var isRestore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        (self.tabBarController as! CustomTabBarViewController).menuButton.isHidden = true
//        self.tabBarController?.tabBar.frame = CGRect.zero
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (self.tabBarController as! CustomTabBarViewController).menuButton.isHidden = true
        self.tabBarController?.tabBar.frame = CGRect.zero
        (self.tabBarController as! CustomTabBarViewController).changeViewVisibility(isHidden: true)
        self.uiForRestore()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.continueBtn.applyGradient(withColours: [UIColor(ciColor: CIColor(red: 0/255, green: 178/255, blue: 255/255)),
                                                     UIColor(ciColor: CIColor(red: 0/255, green: 122/255, blue: 255/255))],
                                       gradientOrientation: .horizontal)
    }
    
    func uiForRestore() {
        if self.isRestore {
            self.restartBtn.isEnabled = false
            self.restartLbl.isHidden = true
            self.infoIconImg.isHidden = true
        }
    }
    
    @IBAction func continueAction(_ sender: Any) {
        self.performSegue(withIdentifier: "checkPhraseVC", sender: UIButton.self)
    }
    
    @IBAction func repeatAction(_ sender: UIButton) {
        let allVCs = self.navigationController!.viewControllers
        
        if allVCs.count > 2 {
            let destinationVC = allVCs[allVCs.count - 3]
            
            self.navigationController?.popToViewController(destinationVC, animated: true)
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "checkPhraseVC" {
            let nextVC = segue.destination as! CheckWordsViewController
            nextVC.isRestore = self.isRestore
        }
    }
}
