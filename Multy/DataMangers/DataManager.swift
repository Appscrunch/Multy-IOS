//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class DataManager: NSObject {
    static let shared = DataManager()
    
    let apiManager = ApiManager.shared
    let realmManager = RealmManager.shared
    let socketManager = SocketManager.shared
    let coreLibManager = CoreLibManager.shared
    
    //MARK: ApiManager
    //DMApiExtension
    
    //MARK: RealmManager
    
    
    //MARK: SocketManager
    
    
    //MARK: CoreLibManager
    //DMCoreLibExtension
}
