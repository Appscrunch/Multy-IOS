//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import Foundation
import Firebase

protocol AnalyticsProtocol {
    func sendAnalyticsEvent(screenName: String, eventName: String)
}

extension AnalyticsProtocol {
    func sendAnalyticsEvent(screenName: String, eventName: String) {
        Analytics.logEvent(screenName, parameters: [screenName : eventName])
    }
}
