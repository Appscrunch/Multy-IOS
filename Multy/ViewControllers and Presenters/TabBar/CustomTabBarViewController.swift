//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class CustomTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    // MARK: - View lifecycle
    let menuButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMiddleButton()
    }
    
    // MARK: - Setups
    
    func setupMiddleButton() {
        self.menuButton.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
        var menuButtonFrame = menuButton.frame
        menuButtonFrame.origin.y = view.bounds.height - menuButtonFrame.height
        menuButtonFrame.origin.x = view.bounds.width/2 - menuButtonFrame.size.width/2
        menuButton.frame = menuButtonFrame
        
        view.addSubview(menuButton)
        
        menuButton.setImage(#imageLiteral(resourceName: "fastOperationBtn"), for: .normal)
        menuButton.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)
        
        view.layoutIfNeeded()
    }
    
    // MARK: - Actions
    
    @objc private func menuButtonAction(sender: UIButton) {
        selectedIndex = 2
    }
    
    
}
