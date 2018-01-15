//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class CustomTabBarPresenter: NSObject {

    var tabBarVC: CustomTabBarViewController?
    
    func getExchange() {
        DataManager.shared.getExchangeCourse { (error) in
            print(error)
        }
    }
}
