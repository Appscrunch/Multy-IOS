//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import RealmSwift

class DataManager: NSObject {
    static let shared = DataManager()
    
    let apiManager = ApiManager.shared
    let realmManager = RealmManager.shared
    let socketManager = Socket.shared
    let coreLibManager = CoreLibManager.shared
    
    var seedWordsArray = [String]()
    
    var donationCode = 0
    
    override init() {
        super.init()
        
        seedWordsArray = coreLibManager.mnemonicAllWords()
    }
    
    func getDonationAddressesFromUserDerfaults() -> Dictionary<Int, String> {
        let donationData  = UserDefaults.standard.object(forKey: Constants.UserDefaults.btcDonationAddressesKey) as! Data
        let decodedDonationAddresses = NSKeyedUnarchiver.unarchiveObject(with: donationData) as! Dictionary<Int, String>
        
        return decodedDonationAddresses
    }
    
    func isWordCorrect(word: String) -> Bool {
        if seedWordsArray.count > 0 {
            return seedWordsArray.contains(word)
        } else {
            return true
        }
        
    }
    
    func findPrefixes(prefix: String) -> [String] {
        return seedWordsArray.filter{ $0.hasPrefix(prefix) }
    }
    
    //MARK: ApiManager Functions
    //DMApiExtension
    
    //MARK: RealmManager
    //DMRealmExtension Functions
    
    //MARK: SocketManager
    //DMSocketExtension Functions
    
    //MARK: CoreLibManager
    //DMCoreLibExtension Functions
    
//    func getExchangeCourse(completion: @escaping (_ error: Error?) -> ()) {
//        DataManager.shared.realmManager.getAccount { (acc, err) in
//            if err == nil {
//                DataManager.shared.apiManager.getExchangePrice(acc!.token, direction: "") { (dict, error) in
//                    if dict == nil {
//                        completion(error)
//                        
//                        return
//                    }
//                    
//                    if dict!["USD"] != nil {
//                        exchangeCourse = dict!["USD"] as! Double
//                        completion(nil)
//                    } else {
//                        completion(nil)
//                    }
//                }
//            } else {
//                completion(nil)
//            }
//        }
//    }
    
//    func getHistoryOfWalletAndSaveToDB(token: String, currencyID: NSNumber, walletID: NSNumber, completion: @escaping(_ historyArr: List<HistoryRLM>?,_ error: Error?) -> ()) {
//        DataManager.shared.getTransactionHistory(token: token, currencyID: currencyID, walletID: walletID) { (historyList, err) in
//            if err != nil || historyList == nil {
//                //do something with it
//                return
//            }
//            DataManager.shared.realmManager.saveHistoryForWallet(historyArr: historyList!, completion: { (histList) in
//                completion(histList, nil)
//            })
//            
//        }
//    }
    
    func checkIsFirstLaunch() -> Bool {
        if let isFirst = UserDefaults.standard.value(forKey: "isFirstLaunch") {
            return isFirst as! Bool
        } else {
//            UserDefaults.standard.set(true, forKey: "isFirstLaunch")
            return true
        }
    }
}
