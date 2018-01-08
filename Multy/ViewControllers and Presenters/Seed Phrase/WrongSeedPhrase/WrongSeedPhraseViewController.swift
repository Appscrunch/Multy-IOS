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
        
        let alert = UIAlertController(title: "Cancel", message: "Are you really want to cancel?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            if allVCs.count > 5 {
                let destinationVC = allVCs[allVCs.count - 6]
                self.navigationController?.popToViewController(destinationVC, animated: true)
            } else {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func tryAgainAction(_ sender : UIButton) {
        let allVCs = self.navigationController!.viewControllers
        if allVCs.count == 3 {
            self.presenter.prevVC?.isNeedToClean = true
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        if allVCs.count > 2 {
            let destinationVC = allVCs[allVCs.count - 3]
            self.navigationController?.popToViewController(destinationVC, animated: true)
        }
    }
}
