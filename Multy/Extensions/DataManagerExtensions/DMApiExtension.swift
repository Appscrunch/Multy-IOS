//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import Foundation
import RealmSwift
import Alamofire

extension DataManager {
    func auth(rootKey: String?, completion: @escaping (_ account: AccountRLM?,_ error: Error?) -> ()) {
        realmManager.getRealm { (realmOpt, error) in
            if let realm = realmOpt {
                let account = realm.object(ofType: AccountRLM.self, forPrimaryKey: 1)
                
                var params : Parameters = [ : ]
                
                if account != nil {
                    params["userID"] = account?.userID
                    params["deviceID"] = account?.deviceID
                    params["deviceType"] = account?.deviceType
                    params["pushToken"] = account?.pushToken
                } else {
                    //MARK: names
                    let paramsDict = NSMutableDictionary(dictionary: params)
                    if rootKey == nil {
                        let seedPhraseString = self.coreLibManager.createMnemonicPhraseArray().joined(separator: " ")
                        params["userID"] = self.getRootString(from: seedPhraseString).0
                        params["deviceID"] = UUID().uuidString
                        params["deviceType"] = 1
                        params["pushToken"] = UUID().uuidString
                        paramsDict["seedPhrase"] = seedPhraseString
                        paramsDict["binaryData"] = self.coreLibManager.createSeedBinaryData(from: seedPhraseString)?.convertToHexString()
                    } else {
                        params["userID"] = rootKey
                        params["deviceID"] = UUID().uuidString
                        params["deviceType"] = 1
                        params["pushToken"] = UUID().uuidString
                        paramsDict["binaryData"] = self.coreLibManager.createSeedBinaryData(from: rootKey!)?.convertToHexString()
                    }
                    
                    self.realmManager.updateAccount(paramsDict, completion: { (account, error) in
                        
                    })
                }
                
                self.apiManager.auth(with: params, completion: { (dict, error) in
                    if dict != nil {
                        self.realmManager.updateAccount(dict!, completion: { (account, error) in
                            completion(account, error)
                        })
                    } else {
                        completion(nil, nil)
                    }
                })
            } else {
                print("Error fetching realm:\(#function)")
                completion(nil, nil)
            }
        }
    }
    
    func fetchAssets(_ token: String, completion: @escaping (_ assets: List<UserWalletRLM>?,_ error: Error?) -> ()) {
        apiManager.getAssets(token) { (holdingsOpt, error) in
            if let holdings = holdingsOpt {
                if let wallets = holdings["userWallets"] as? NSArray {
                    completion(UserWalletRLM.initWithArray(walletsInfo: wallets), nil)
                } else {
                    completion(nil, nil)
                }
                
                completion(nil, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    func addWallet(_ token: String, params: Parameters, completion: @escaping (_ answer: NSDictionary?,_ error: Error?) -> ()) {
        apiManager.addWallet(token, params) { (responceDict, error) in
            if error != nil {
                completion(NSDictionary(), nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    func addAddress(_ token: String, params: Parameters, completion: @escaping (_ dict: NSDictionary?,_ error: Error?) -> ()) {
        apiManager.addAddress(token, params) { (dict, error) in
            
        }
    }
    
    func getExhanchgeCourse(_ token: String, completion: @escaping (_ dictionary: NSDictionary?, _ error: Error?) -> ()) {
        apiManager.getExchangePrice(token, direction: "BTC/USD") { (dict, err) in
            if err == nil {
                if dict != nil {
                    
                }
                completion(dict!, nil)
            } else {
                completion(nil, err)
            }
        }
    }
    
    func getFeeRate(_ token: String, currencyID: UInt32, completion: @escaping (_ feeRateDict: NSDictionary?,_ error: Error?) -> ()) {
        apiManager.getFeeRate(token, currencyID: currencyID) { (answer, error) in
            if error != nil || (answer!["code"] as! NSNumber).intValue != 200  {
                completion(nil, error)
            } else {
                completion(answer!["speeds"] as? NSDictionary, nil)
            }
        }
    }
    
    func getWalletsVerbose(_ token: String, completion: @escaping (_ answer: NSDictionary?,_ error: Error?) -> ()) {
        apiManager.getWalletsVerbose(token) { (answer, err) in
            if err == nil {
                completion(answer, nil)
            } else {
                completion(nil, err)
            }
        }
    }
    
    func getWalletOutputs(_ token: String, walletID: UInt32, completion: @escaping (_ answer: NSDictionary?,_ error: Error?) -> ()) {
        apiManager.getWalletOutputs(token, walletID: walletID) { (dict, error) in
            completion(dict, error)
        }
    }
    
//    func addAddress(_ token: String, _ walletDict: Parameters, completion: @escaping (_ answer: NSDictionary?,_ error: Error?) -> ()) {
//        DataManager.shared
//    }
}
