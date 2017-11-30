//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class WrongSeedPhraseViewController: UIViewController {
    
    let presenter = WrongSeedPhrasePresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.mainVC = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelAction(_ sender : UIButton) {
        let allVCs = self.navigationController!.viewControllers
        
        if allVCs.count > 5 {
            let destinationVC = allVCs[allVCs.count - 6]
            
            self.navigationController?.popToViewController(destinationVC, animated: true)
        }
    }
    
    @IBAction func tryAgainAction(_ sender : UIButton) {
        let allVCs = self.navigationController!.viewControllers
        
        if allVCs.count > 2 {
            let destinationVC = allVCs[allVCs.count - 3]
            
            self.navigationController?.popToViewController(destinationVC, animated: true)
        }
    }
}
