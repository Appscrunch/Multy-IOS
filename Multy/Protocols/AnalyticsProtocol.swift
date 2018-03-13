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
    
    //Donation Alert
    func sendDonationAlertScreenPresentedAnalytics(code: Int) {
        DataManager.shared.donationCode = code
        sendAnalyticsEvent(screenName: screeenDonationAlert, eventName: screeenDonationAlertWith_ + "\(code)")
    }
    
    func sendDonationAlertScreenCancelledAnalytics() {
        let code = DataManager.shared.donationCode
        sendAnalyticsEvent(screenName: screeenDonationAlert, eventName: buttonClose + "\(code)")
    }
    
    func sendDonationAlertScreenPressDonateAnalytics() {
        let code = DataManager.shared.donationCode
        sendAnalyticsEvent(screenName: screeenDonationAlert, eventName: buttonDonate + "\(code)")
    }
    
    //Donation Screen
    func sendDonationScreenPresentedAnalytics() {
        let code = DataManager.shared.donationCode
        sendAnalyticsEvent(screenName: screenSendDonation, eventName: screenSendDonationwith_ + "\(code)")
    }
    
    func sendDonationScreenPressSendAnalytics() {
        let code = DataManager.shared.donationCode
        sendAnalyticsEvent(screenName: screenSendDonation, eventName: buttonSendDonate + "\(code)")
    }
    
    //Donation Success
    func sendDonationSuccessAnalytics() {
        let code = DataManager.shared.donationCode
        sendAnalyticsEvent(screenName: screenDonationSuccess, eventName: screenDonationSuccessWith_ + "\(code)")
    }
}
