//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import Alamofire

class ApiManager: NSObject {
    static let shared = ApiManager()
    
    let apiUrl = "http://88.198.47.112:7778/"//"http://192.168.0.121:7778/"
    let apiUrlTest = "http://192.168.0.125:8080/"
    let nonLocalURL = "http://88.198.47.112:7778/"
    
    var requestManager = Alamofire.SessionManager.default
    
    override init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10 // seconds
        configuration.timeoutIntervalForResource = 10
        
        self.requestManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    func auth(with parameters: Parameters, completion: @escaping (_ answer: NSDictionary?,_ error: Error?) -> ()) {
        
        let header: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        requestManager.request("\(self.apiUrl)auth", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header).debugLog().responseJSON { (response: DataResponse<Any>) in
            
            print("----------------------AUTH")
            
            switch response.result {
            case .success(_):
                if response.result.value != nil {
                    completion((response.result.value as! NSDictionary), nil)
                }
            case .failure(_):
                completion(nil, response.result.error)
                break
            }
        }
    }
    
    func getAssets(_ token: String, completion: @escaping (_ holdings: NSDictionary?,_ error: Error?) -> ()) {
        
        let header: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : "Bearer \(token)"
            
        ]
        
        requestManager.request("\(self.apiUrl)api/v1/wallets", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response: DataResponse<Any>) in
            switch response.result {
            case .success(_):
                if response.result.value != nil {
                    completion((response.result.value as! NSDictionary), nil)
                }
            case .failure(_):
                completion(nil, response.result.error)
                break
            }
        }
    }
    
    func getTickets(_ token: String, direction: String, completion: @escaping (_ answer: NSDictionary?,_ error: Error?) -> ()) {
        
        let header: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : "Bearer \(token)"
        ]
        
        //MARK: change btc_eth
        requestManager.request("\(self.apiUrl)api/v1/gettickets/btc_eth", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response: DataResponse<Any>) in
            switch response.result {
            case .success(_):
                if response.result.value != nil {
                    completion((response.result.value as! NSDictionary), nil)
                }
            case .failure(_):
                completion(nil, response.result.error)
                break
            }
        }
    }
    
    func getExchangePrice(_ token: String, direction: String, completion: @escaping (_ answer: NSDictionary?,_ error: Error?) -> ()) {
        
        let header: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : "Bearer \(token)"
        ]
        
        //MARK: USD
        requestManager.request("\(self.apiUrl)api/v1/getexchangeprice/BTC/USD", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response: DataResponse<Any>) in
            switch response.result {
            case .success(_):
                if response.result.value != nil {
                    completion((response.result.value as! NSDictionary), nil)
                }
            case .failure(_):
                completion(nil, response.result.error)
                break
            }
        }
    }
    
    func getTransactionInfo(_ token: String, transactionString: String, completion: @escaping (_ answer: NSDictionary?,_ error: Error?) -> ()) {
        
        let header: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : "Bearer \(token)"
        ]
        
        //MARK: USD
        requestManager.request("\(self.apiUrl)api/v1/gettransactioninfo/\(transactionString)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response: DataResponse<Any>) in
            switch response.result {
            case .success(_):
                if response.result.value != nil {
                    completion((response.result.value as! NSDictionary), nil)
                }
            case .failure(_):
                completion(nil, response.result.error)
                break
            }
        }
    }
    
    func addWallet(_ token: String, _ walletDict: Parameters, completion: @escaping (_ answer: NSDictionary?,_ error: Error?) -> ()) {
        
        let header: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : "Bearer \(token)"
        ]
        
        requestManager.request("\(self.apiUrl)api/v1/wallet", method: .post, parameters: walletDict, encoding: JSONEncoding.default, headers: header).debugLog().responseJSON { (response: DataResponse<Any>) in
            switch response.result {
            case .success(_):
                
                print("api/v1/wallet: \(response.result.value)")
                if response.result.value != nil {
                    if ((response.result.value! as! NSDictionary) ["code"] != nil) {
                        completion(NSDictionary(), nil)
                    } else {
                        completion(nil, nil)
                    }
                    
                    
                }
            case .failure(_):
                completion(nil, response.result.error)
                break
            }
        }
    }
    
    func deleteWallet(_ token: String, walletIndex: NSNumber, completion: @escaping (_ answer: NSDictionary?,_ error: Error?) -> ()) {
        let header: HTTPHeaders = [
            "Authorization" : "Bearer \(token)"
        ]
        requestManager.request("\(self.apiUrl)api/v1/wallet/\(walletIndex)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).debugLog().responseJSON { (response: DataResponse<Any>) in
            switch response.result {
            case .success(_):
                if response.result.value != nil {
                    print(response.result.value)
                    completion(response.result.value as? NSDictionary, nil)
                }
            case .failure(_):
                completion(nil, response.result.error)
                break
            }
        }
    }
    
    func addAddress(_ token: String, _ walletDict: Parameters, completion: @escaping (_ answer: NSDictionary?,_ error: Error?) -> ()) {
        
        let header: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : "Bearer \(token)"
        ]
        
        requestManager.request("\(self.apiUrl)api/v1/address", method: .post, parameters: walletDict, encoding: JSONEncoding.default, headers: header).debugLog().responseJSON { (response: DataResponse<Any>) in
            switch response.result {
            case .success(_):
                if response.result.value != nil {
                    completion((response.result.value as! NSDictionary), nil)
                }
            case .failure(_):
                completion(nil, response.result.error)
                break
            }
        }
    }
    
    func getFeeRate(_ token: String, currencyID: UInt32, completion: @escaping (_ answer: NSDictionary?,_ error: Error?) -> ()) {
        
        let header: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : "Bearer \(token)"
        ]
        
        //MARK: USD
        requestManager.request("\(self.apiUrl)api/v1/transaction/feerate", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).debugLog().responseJSON { (response: DataResponse<Any>) in
            switch response.result {
            case .success(_):
                if response.result.value != nil {
                    completion((response.result.value as! NSDictionary), nil)
                }
            case .failure(_):
                completion(nil, response.result.error)
                break
            }
        }
    }
    
    func getWalletsVerbose(_ token: String, completion: @escaping(_ answer: NSDictionary?,_ error: Error?) -> ()) {
        let header: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : "Bearer \(token)"
        ]
        
        requestManager.request("\(self.apiUrl)api/v1/wallets/verbose", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).debugLog().responseJSON { (response: DataResponse<Any>) in
            switch response.result {
            case .success(_):
                if response.result.value != nil {
                    completion((response.result.value as! NSDictionary), nil)
                }
            case .failure(_):
                completion(nil, response.result.error)
                break
            }
        }
    }
    
    func getOneWalletVerbose(_ token: String, walletID: NSNumber, completion: @escaping(_ answer: NSDictionary?,_ error: Error?) -> ()) {
        
        let header: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : "Bearer \(token)"
        ]
        
        requestManager.request("\(self.apiUrl)api/v1/wallet/\(walletID)/verbose", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).debugLog().responseJSON { (response: DataResponse<Any>) in
            switch response.result {
            case .success(_):
                if response.result.value != nil {
                    completion((response.result.value as! NSDictionary), nil)
                }
            case .failure(_):
                completion(nil, response.result.error)
                break
            }
        }
    }
    
    func anotherWalletVerbose(_ token: String, walletID: NSNumber, completion: @escaping(_ dict: NSDictionary?, _ error: Error?) -> ()) {
        let header: HTTPHeaders = [
            "authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        requestManager.request("\(self.apiUrl)api/v1/wallet/\(walletID)/verbose", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).debugLog().responseJSON { (response: DataResponse<Any>) in
            switch response.result {
            case .success(_):
                if response.result.value != nil {
                    completion((response.result.value as! NSDictionary), nil)
                }
            case .failure(_):
                completion(nil, response.result.error)
                break
            }
        }
    }
    
    func sendRawTransaction(_ token: String, walletID: NSNumber, _ transactionParameters: Parameters, completion: @escaping (_ answer: NSDictionary?,_ error: Error?) -> ()) {
        
        let header: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : "Bearer \(token)"
        ]
        
        //MARK: TESTNET - send currency is 1
        requestManager.request("\(self.apiUrl)api/v1/transaction/send/\(walletID)", method: .post, parameters: transactionParameters, encoding: JSONEncoding.default, headers: header).responseJSON { (response: DataResponse<Any>) in
            switch response.result {
            case .success(_):
                if response.result.value != nil {
                    completion((response.result.value as! NSDictionary), nil)
                }
            case .failure(_):
                completion(nil, response.result.error)
                break
            }
        }
    }
    
    func getWalletOutputs(_ token: String, currencyID: UInt32, address: String, completion: @escaping(_ answer: NSDictionary?,_ error: Error?) -> ()) {
        let header: HTTPHeaders = [
            "Authorization" : "Bearer \(token)"
        ]
        
        requestManager.request("\(self.apiUrl)api/v1/outputs/spendable/\(currencyID)/\(address)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).debugLog().responseJSON { (response: DataResponse<Any>) in
            switch response.result {
            case .success(_):
                if response.result.value != nil {
                    completion((response.result.value as! NSDictionary), nil)
                }
            case .failure(_):
                completion(nil, response.result.error)
                break
            }
        }
    }
}

//mjNQJu5QxQNVZf769WWz7zdmPeJMdg4YRA
//mrHaPLH3rXDj3udV4R6p3ifPoQwZEYZtq1

