//This is my custom header

import UIKit
import CryptoSwift

class MasterKeyGenerator : NSObject, GGLInstanceIDDelegate {
    static let sharedGenerator = MasterKeyGenerator()
    
    fileprivate var instanceIDToken : String = ""
    fileprivate var devicePushToken : String = ""
    fileprivate var deviceUUIDToken : String = ""
    
    fileprivate var executedFunction : ((String?, Error?, String?) -> Void)?
    
    public func generateTokens(completion: @escaping (_ masterKey: String?, _ error: Error?, String?) -> ()) {
        executedFunction = completion
        
        deviceUUIDToken = UIDevice.current.identifierForVendor!.uuidString
        fetchDeviceToken()
        generateInstanceID()
    }
    
    fileprivate func fetchDeviceToken() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.getDevicePushToken),
                                               name: NSNotification.Name(rawValue: "deviceTokenNotification"),
                                               object: nil)
        
        DispatchQueue.main.async {
            let settings = UIUserNotificationSettings(types: [/*.badge, .sound, .alert*/], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
    }
    
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
                    if !self.devicePushToken.isEmpty {
                        self.generateMasterKey()
                    }
                }
            } else {
                print(error ?? "empty error")
            }
        }
        
        iidInstance?.getWithHandler(handler)
    }
    
    @objc func getDevicePushToken(notification: NSNotification) {
        devicePushToken = notification.object! as! String
        
        if !instanceIDToken.isEmpty {
            generateMasterKey()
        }
    }
    
    fileprivate func generateMasterKey() {
        let key = sha256(instanceIDToken + devicePushToken + deviceUUIDToken)
        
        //clear secure info
        //MARK: clean
//        cleanTokens()
        
        guard let masterKey = key else {
            print("Error generating master key")
            
            return
        }
        
        //send
        if let function = executedFunction {
            function(masterKey, nil, "\(instanceIDToken)\n\n\(devicePushToken)\n\n\(deviceUUIDToken)")
        }
    }
    
    fileprivate func cleanTokens() {
        instanceIDToken = ""
        devicePushToken = ""
        deviceUUIDToken = ""
    }
    
    fileprivate func sha256(_ str: String) -> String? {
        guard let data = str.data(using: String.Encoding.utf8) else {
            return nil
        }

        let sha256Data = data.sha256
        let sha256String = sha256Data().base64EncodedString(options: [])
        
        return sha256String
    }
    
    //MARK: GGLInstanceIDDelegate
    internal func onTokenRefresh() {
//        print("onTokenRefresh")
    }
}
