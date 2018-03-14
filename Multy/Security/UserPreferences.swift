//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import Foundation
import CryptoSwift

class UserPreferences : NSObject {
    static let shared = UserPreferences()
    
    fileprivate var executedFunction : ((Data?, Error?) -> Void)?
    
    var aes : AES? {
        didSet {
            if aes != nil {
                writeCiperedDatabasePassword()
                
                if executedFunction != nil {
                    getAndDecryptDatabasePassword(completion: executedFunction!)
                }
            }
        }
    }
    
    override init() {
        super.init()
        
        generateAES()
    }
    
    fileprivate func generateAES() {
        let iv = getAESiv()

        generateUserDefaultsPassword { (pass, error) in
            let aes = try! AES(key: pass!, blockMode: .CBC(iv: iv), padding: .pkcs5)
            
            self.aes = aes
        }
    }
    
    fileprivate func getAESiv() -> [UInt8] {
        let ivData = UserDefaults.standard.data(forKey: "AESivKey")
        
        if ivData == nil {
            let iv = AES.randomIV(AES.blockSize)
            let ivData = NSData(bytes: iv, length: iv.count)
            UserDefaults.standard.set(ivData, forKey: "AESivKey")
            
            return iv
        } else {
            let iv = [UInt8](ivData!)
            
            return iv
        }
    }
    
    //MARK: main activity
    func generateUserDefaultsPassword(completion: @escaping (_ databasePassword: [UInt8]?, _ error: Error?) -> ()) {
        MasterKeyGenerator.shared.generateMasterKey { (data, error, string) in
            
            let salt = data!.sha3(.keccak256)
            let pass = salt.sha3(.keccak256)
            
            let databasePassword = try! PKCS5.PBKDF2(password: Array(pass), salt: Array(salt)).calculate()
            
            completion(databasePassword, nil)
        }
    }
    
    func writeCiperedDatabasePassword() {
        let decipheredData = UserDefaults.standard.data(forKey: "databasePassword")
        
        //local pass already in UserDefaults
        if decipheredData != nil {
            return
        }
        
        //MARK: Generate secure KEY
        if aes == nil {
            return
        }
        
        let generatedPass = Data.generateRandom64ByteData()!
        
        let cipheredPass = try! aes!.encrypt(generatedPass.bytes)
        let cipheredData = cipheredPass.nsData
        
        loggingPrint(print("writeCiperedDatabasePassword:\n\n\(generatedPass.base64EncodedString())\n\n\(cipheredData.base64EncodedString())"))
        
        UserDefaults.standard.set(cipheredData, forKey: "databasePassword")
    }
    
    func getAndDecryptDatabasePassword(completion: @escaping (_ password: Data?, _ error: Error?) -> ()) {
        let cipheredData = UserDefaults.standard.data(forKey: "databasePassword")
        
        if cipheredData == nil || aes == nil {
            executedFunction = completion
            
            return
        }
        
        let originalArrayData = try! aes?.decrypt(cipheredData!.bytes)
        loggingPrint("getAndDecryptDatabasePassword:\n\n\(cipheredData!.base64EncodedString())\n\n\(originalArrayData!.data.base64EncodedString())\n\n\(originalArrayData!.data.count)")
        
        completion(originalArrayData!.data, nil)
    }
    
    func writeCipheredPinMode(mode : Int) {
//        let decipheredData = UserDefaults.standard.data(forKey: "pinMode")
//
//        //local pass already in UserDefaults
//        if decipheredData != nil {
//            return
//        }
        
        //MARK: Generate secure KEY 
        if aes == nil {
            return
        }
        
        let cipheredPass = try! aes!.encrypt(Array("\(mode)".utf8))
        let cipheredData = cipheredPass.nsData
        
        UserDefaults.standard.set(cipheredData, forKey: "pinMode")
    }
    
    func getAndDecryptCipheredMode(completion: @escaping (_ password: String?, _ error: Error?) -> ()) {
        let cipheredData = UserDefaults.standard.data(forKey: "pinMode")
        
        if cipheredData == nil {
//            executedFunction = completion
            writeCipheredPinMode(mode: 0)
            completion("0", nil)
            
            return
        }
        
        let originalData = try! aes?.decrypt(cipheredData!.bytes)
        if let decipheredString = String(bytes: originalData!, encoding: .utf8) {
            completion(decipheredString, nil)
        } else {
            self.writeCipheredPinMode(mode: 0)
            completion("0", nil)
        }
    }
    
    func writeCipheredPin(pin : String) {
        if aes == nil {
            return
        }
        
        let cipheredPass = try! aes!.encrypt(Array(pin.utf8))
        let cipheredData = cipheredPass.nsData
        
        UserDefaults.standard.set(cipheredData, forKey: "pin")
    }
    
    func getAndDecryptPin(completion: @escaping (_ password: String?, _ error: Error?) -> ()) {
        let cipheredData = UserDefaults.standard.data(forKey: "pin")
        
        if cipheredData == nil {
            completion(nil, nil)
            
            return
        }
        
        let originalData = try! aes?.decrypt(cipheredData!.bytes)
        if let decipheredString = String(bytes: originalData!, encoding: .utf8) {
            completion(decipheredString, nil)
        } else {
//            self.writeCipheredPinMode(mode: 0)
            completion(nil, nil)
        }
    }
    
    func writeCipheredBiometric(isBiometircOn: Bool) {
        if aes == nil {
            return
        }
        
        let cipheredPass = try! aes!.encrypt(Array("\(isBiometircOn)".utf8))
        let cipheredData = cipheredPass.nsData
        
        UserDefaults.standard.set(cipheredData, forKey: "biometric")
    }
    
    func getAndDecryptBiometric(completion: @escaping (_ isBiometircOn: Bool?, _ error: Error?) -> ()) {
        let cipheredData = UserDefaults.standard.data(forKey: "biometric")
        
        if cipheredData == nil {
            completion(nil, nil)
            
            return
        }
        
        let originalData = try! aes?.decrypt(cipheredData!.bytes)
        if let decipheredString = String(bytes: originalData!, encoding: .utf8) {
            completion((decipheredString as NSString).boolValue, nil)
        } else {
            //            self.writeCipheredPinMode(mode: 0)
            completion(nil, nil)
        }
    }
    
    func writeChipheredBlockSeconds(seconds: Int) {
        if aes == nil {
            return
        }
        
        let cipheredAttempts = try! aes!.encrypt(Array("\(seconds)".utf8))
        let cipheredData = cipheredAttempts.nsData
        
        UserDefaults.standard.set(cipheredData, forKey: "wrongAttempts")
    }
    
    func getAndDecryptBlockSeconds(completion: @escaping (_ seconds: Int?, _ error: Error?) -> ()) {
        let cipheredData = UserDefaults.standard.data(forKey: "wrongAttempts")
        if cipheredData == nil {
            completion(nil, nil)
            return
        }
        let originalData = try! aes?.decrypt(cipheredData!.bytes)
        if let decipheredString = String(bytes: originalData!, encoding: .utf8) {
            completion(Int(decipheredString as String), nil)
        } else {
            completion(nil, nil)
        }
    }
    
    
    func writeStartBlockTime(time: Date) {
        if aes == nil {
            return
        }
        let timeString = Date.blockDateFormatter().string(from: time)
        
        let cipheredAttempts = try! aes!.encrypt(Array(timeString.utf8))
        let cipheredData = cipheredAttempts.nsData
        UserDefaults.standard.set(cipheredData, forKey: "startBlockTime")
    }
    
    func getAndDecryptStartBlockTime(completion: @escaping(_ time: Date?, _ error: Error?) -> ()) {
        let cipheredData = UserDefaults.standard.data(forKey: "startBlockTime")
        if cipheredData == nil {
            completion(nil, nil)
            return
        }
        let originalData = try! aes?.decrypt(cipheredData!.bytes)
        if let decipheredString = String(bytes: originalData!, encoding: .utf8) {
            completion(decipheredString.toDateTime() as Date, nil)
        } else {
            completion(nil, nil)
        }
    }
    
    func getAndDecryptMaxEnterPinTries() -> Int {
        if aes == nil {
            return 0
        }
        let cipheredTries = try! aes!.encrypt(Array("\(5)".utf8))
        let cipheredData = cipheredTries.nsData
        UserDefaults.standard.set(cipheredData, forKey: "maxPinTries")
     
        
        let cipheredDataToEncrypt = UserDefaults.standard.data(forKey: "maxPinTries")
        if cipheredDataToEncrypt == nil {
            return 0
        }
        let originalData = try! aes?.decrypt(cipheredDataToEncrypt!.bytes)
        if let decipheredString = String(bytes: originalData!, encoding: .utf8) {
            return Int(decipheredString)!
        } else {
            return 0
        }
    }
}
