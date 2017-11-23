//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class ApiManager: NSObject {
    static let shared = ApiManager()
    
    let apiUrl = "http://192.168.0.121:8080/"
    var requestManager = Alamofire.SessionManager.default
    
    override init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10 // seconds
        configuration.timeoutIntervalForResource = 10
        
        self.requestManager = Alamofire.SessionManager(configuration: configuration)
    }
}
