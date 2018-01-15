//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import LTMorphingLabel
import ZFRippleButton

class SeedPhraseWordViewController: UIViewController {

    @IBOutlet weak var nextWordBtn: ZFRippleButton!
    
    @IBOutlet weak var blocksImage: UIImageView!
    
    @IBOutlet weak var topWordLbl: LTMorphingLabel!
    @IBOutlet weak var mediumWordLbl: LTMorphingLabel!
    @IBOutlet weak var bottomWord: LTMorphingLabel!
    
    @IBOutlet weak var constraintTopBricks: NSLayoutConstraint!
    
    let presenter =  SeedPhraseWordPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if screenWidth < 325 {
            constraintTopBricks.constant = 90
        }
        
        presenter.mainVC = self
        
        let effect: LTMorphingEffect = .fall
        
        topWordLbl.morphingEffect = effect
        mediumWordLbl.morphingEffect = effect
        bottomWord.morphingEffect = effect
        
        presenter.getSeedFromAcc()
        presenter.presentNextTripleOrContinue()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.nextWordBtn.applyGradient(withColours: [UIColor(ciColor: CIColor(red: 0/255, green: 178/255, blue: 255/255)), UIColor(ciColor: CIColor(red: 0/255, green: 122/255, blue: 255/255))], gradientOrientation: .horizontal)
    }

    @IBAction func nextWordAndContinueAction(_ sender: Any) {
        
        presenter.presentNextTripleOrContinue()
    }
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
