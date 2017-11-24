//This is my custom header

import UIKit
import CryptoSwift

class MasterKeyGenerator : NSObject, GGLInstanceIDDelegate {
    static let shared = MasterKeyGenerator()
    
    fileprivate var localPasswordString : String = ""
    fileprivate var instanceIDToken : String = ""
    fileprivate var deviceUUIDToken : String = ""
    
    fileprivate var executedFunction : ((Data?, Error?, String?) -> Void)?
    
    //synch version
//    public func generateMasterKey() -> Data? {
//        generateGGInstanceID()
//
//        deviceUUIDToken = UIDevice.current.identifierForVendor!.uuidString
//        generateLocalPasswordString()
//
//        print("\(self.deviceUUIDToken) -- \(self.instanceIDToken)")
//
//        return self.generateMasterKeyFromTokens()
//    }
    
    //asynch version
    public func generateMasterKey(completion: @escaping (_ masterKey: Data?, _ error: Error?, String?) -> ()) {
        executedFunction = completion
        
        deviceUUIDToken = UIDevice.current.identifierForVendor!.uuidString
        generateInstanceID()
        generateLocalPasswordString()
    }
    
    fileprivate func generateLocalPasswordString() {
        // Future feature
        // get additional protection from local password/fingerprint
        
        localPasswordString = ""
    }
    
    //version without calling generateMasterKeyFromTokens
//    fileprivate func generateGGInstanceID() {
//        let instanceIDConfig = GGLInstanceIDConfig.default()
//        instanceIDConfig?.delegate = self
//        GGLInstanceID.sharedInstance().start(with: instanceIDConfig)
//
//        let iidInstance = GGLInstanceID.sharedInstance()
//
//        let handler : (String?, Error?) -> Void = { (identity, error) in
//            if let iid = identity {
//                DispatchQueue.main.async {
//                    self.instanceIDToken = iid
//                }
//            } else {
//                print(error ?? "empty error")
//            }
//        }
//
//        iidInstance?.getWithHandler(handler)
//    }
    
    //asynch version
    fileprivate func generateInstanceID() {
        let instanceIDConfig = GGLInstanceIDConfig.default()
        instanceIDConfig?.delegate = self
        GGLInstanceID.sharedInstance().start(with: instanceIDConfig)
        
        let iidInstance = GGLInstanceID.sharedInstance()
        
        let handler : (String?, Error?) -> Void = { (identity, error) in
            if let iid = identity {
                self.instanceIDToken = iid
                print("instanceIDToken: \(self.instanceIDToken)")
                
                DispatchQueue.main.async {
                    //                    if !self.devicePushToken.isEmpty {
                    self.asyncGenerateMasterKeyFromTokens()
                    //                    }
                }
            } else {
                print(error ?? "empty error")
            }
        }
        
        iidInstance?.getWithHandler(handler)
    }
    
    //synch version
//    fileprivate func generateMasterKeyFromTokens() -> Data? {
//        let key = sha512(instanceIDToken + deviceUUIDToken + localPasswordString)
//
//        //clear secure info
//        //MARK: clean
//        cleanTokens()
//
//        guard let masterKey = key else {
//            print("Error generating master key")
//
//            return nil
//        }
//        print(masterKey.map{ String(format: "%02hhx", $0) }.joined())
//
//        return masterKey
//    }
    
    //asynch version
    fileprivate func asyncGenerateMasterKeyFromTokens() {
        print("\(#function): \(deviceUUIDToken) -- \(instanceIDToken)")
        
        let key = sha512(instanceIDToken + UIDevice.current.identifierForVendor!.uuidString + localPasswordString)
        
        //clear secure info
        //MARK: clean
        cleanTokens()
        
        guard let masterKey = key else {
            print("Error generating master key")
            
            return
        }
        
        //send
        if let function = executedFunction {
            function(masterKey, nil, nil)
        }
    }
    
    fileprivate func cleanTokens() {
        instanceIDToken = ""
        //        devicePushToken = ""
        deviceUUIDToken = ""
    }
    
    fileprivate func sha512(_ str: String) -> Data? {
        guard let data = str.data(using: String.Encoding.utf8) else {
            return nil
        }
        
        let sha512Data = data.sha3(.sha512)
//        let sha512String = sha512Data.base64EncodedString(options: [])
        
        return sha512Data
    }
    
    //MARK: GGLInstanceIDDelegate
    internal func onTokenRefresh() {
        print("onTokenRefresh")
    }
}

