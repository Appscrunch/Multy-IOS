//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import Foundation
import CryptoSwift

class UserPreferences : NSObject {
    static let shared = UserPreferences()
    
    fileprivate var executedFunction : ((String?, Error?) -> Void)?
    
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
    
    func generateAES() {
        let iv = getAESiv()

        generateUserDefaultsPassword { (pass, error) in
            let aes = try! AES(key: pass!, blockMode: .CBC(iv: iv), padding: .pkcs5)
            
            self.aes = aes
        }
    }
    
    func getAESiv() -> [UInt8] {
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
        
        let generatedPass = String.generateRandomString()!
        
        let cipheredPass = try! aes!.encrypt(Array(generatedPass.utf8))
        let cipheredData = NSData(bytes: cipheredPass, length: cipheredPass.count)
        
        UserDefaults.standard.set(cipheredData, forKey: "databasePassword")
    }
    
    func getAndDecryptDatabasePassword(completion: @escaping (_ password: String?, _ error: Error?) -> ()) {
        let decipheredData = UserDefaults.standard.data(forKey: "databasePassword")
        
        if decipheredData == nil || aes == nil {
            executedFunction = completion
            
            return
        }
        
        let decipheredArray = [UInt8](decipheredData!)
        let originalData = try! aes?.decrypt(decipheredArray)
        let decipheredString = String(bytes: originalData!, encoding: .utf8)!
        
        completion(decipheredString, nil)
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
        let cipheredData = NSData(bytes: cipheredPass, length: cipheredPass.count)
        
        UserDefaults.standard.set(cipheredData, forKey: "pinMode")
    }
    
    func getAndDecryptCipheredMode(completion: @escaping (_ password: String?, _ error: Error?) -> ()) {
        let decipheredData = UserDefaults.standard.data(forKey: "pinMode")
        
        if decipheredData == nil {
//            executedFunction = completion
            writeCipheredPinMode(mode: 1)
            completion("1", nil)
            
            return
        }
        
        let decipheredArray = [UInt8](decipheredData!)
        let originalData = try! aes?.decrypt(decipheredArray)
        let decipheredString = String(bytes: originalData!, encoding: .utf8)!
        
        completion(decipheredString, nil)
    }
}
