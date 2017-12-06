//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class CoreLibManager: NSObject {
    static let shared = CoreLibManager()
    
    func isDeviceJailbroken() -> Bool {
        if TARGET_IPHONE_SIMULATOR != 1 {
            // Check 1 : existence of files that are common for jailbroken devices
            
            if FileManager.default.fileExists(atPath: "/Applications/Cydia.app")
                || FileManager.default.fileExists(atPath: "/Applications/RockApp.app")
                || FileManager.default.fileExists(atPath: "/Applications/Icy.app")
                || FileManager.default.fileExists(atPath: "/Applications/WinterBoard.app")
                || FileManager.default.fileExists(atPath: "/Applications/SBSettings.app")
                || FileManager.default.fileExists(atPath: "/Applications/MxTube.app")
                || FileManager.default.fileExists(atPath: "/Applications/IntelliScreen.app")
                || FileManager.default.fileExists(atPath: "/Applications/FakeCarrier.app")
                || FileManager.default.fileExists(atPath: "/Applications/blackra1n.app")
                
                || FileManager.default.fileExists(atPath: "/Library/MobileSubstrate/MobileSubstrate.dylib")
                
                || FileManager.default.fileExists(atPath: "/Library/MobileSubstrate/DynamicLibraries/Veency.plist")
                || FileManager.default.fileExists(atPath: "/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist")
                
                || FileManager.default.fileExists(atPath: "/System/Library/LaunchDaemons/com.ikey.bbot.plist")
                || FileManager.default.fileExists(atPath: "/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist")
                
                
                
                || FileManager.default.fileExists(atPath: "/bin/bash")
                || FileManager.default.fileExists(atPath: "/bin/sh")
                
                
                || FileManager.default.fileExists(atPath: "/etc/ssh/sshd_config")
                || FileManager.default.fileExists(atPath: "/etc/apt")
                
                || FileManager.default.fileExists(atPath: "/private/var/lib/apt/")
                || FileManager.default.fileExists(atPath: "/private/var/mobile/Library/SBSettings/Themes")
                || FileManager.default.fileExists(atPath: "/private/var/lib/cydia")
                || FileManager.default.fileExists(atPath: "/private/var/tmp/cydia.log")
                || FileManager.default.fileExists(atPath: "/private/var/stash")
                
                || FileManager.default.fileExists(atPath: "/usr/sbin/sshd")
                || FileManager.default.fileExists(atPath: "/usr/libexec/sftp-server")
                || FileManager.default.fileExists(atPath: "/usr/libexec/ssh-keysign")
                
                || FileManager.default.fileExists(atPath: "/var/tmp/cydia.log")
                || FileManager.default.fileExists(atPath: "/var/log/syslog")
                || FileManager.default.fileExists(atPath: "/var/lib/cydia")
                || FileManager.default.fileExists(atPath: "/var/lib/apt")
                || FileManager.default.fileExists(atPath: "/var/cache/apt")
                
                || UIApplication.shared.canOpenURL(URL(string:"cydia://package/com.example.package")!) {
                
                return true
            }
            
            // Check 2 : Reading and writing in system directories (sandbox violation)
            let stringToWrite = "Jailbreak Test"
            
            do {
                try stringToWrite.write(toFile:"/private/JailbreakTest.txt", atomically:true, encoding:String.Encoding.utf8)
                
                //Device is jailbroken
                
                return true
            } catch {
                return false
            }
        } else {
            return false
        }
    }
    
    func createMnemonicPhraseArray() -> Array<String> {
        let mnemo = UnsafeMutablePointer<UnsafePointer<Int8>?>.allocate(capacity: 1)
        let entropySource = EntropySource.init(data: nil, fill_entropy: { (data, length, entropy) in
            guard entropy != nil else {
                return 0
            }
            
            let errorInt = SecRandomCopyBytes(kSecRandomDefault, length / 2, entropy!)
            
            if errorInt == errSecSuccess {
                return length / 2
            } else {
                return 0
            }
        })
        
        let mm = make_mnemonic(entropySource, mnemo)
        
        //MAKE: check nil
        print(mm ?? "-11")

        let phrase = String(cString: mnemo.pointee!)
        
        return phrase.components(separatedBy: " ")
    }
    
    func startTests() {
        run_tests(1, UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>.allocate(capacity: 1))
    }
    
    func createRootID(from phrase: String) -> String {
        
        //MAKE: free data
        //use defer function!!!
        
        print("seed phrase: \(phrase)")
        
        let binaryDataPointer = UnsafeMutablePointer<UnsafeMutablePointer<BinaryData>?>.allocate(capacity: 1)
        let masterKeyPointer = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        let extendedKeyPointer = UnsafeMutablePointer<UnsafePointer<Int8>?>.allocate(capacity: 1)
        
        let stringPointer = phrase.UTF8CStringPointer
        
        let ms = make_seed(stringPointer, nil, binaryDataPointer)
        print("ms: \(String(describing: ms))")
        
        let binaryData = binaryDataPointer.pointee
        let mmk = make_master_key(binaryData, masterKeyPointer)
        print("mmk: \(String(describing: mmk))")
        
        let mki = make_key_id(masterKeyPointer.pointee, extendedKeyPointer)
        print("mki: \(String(describing: mki))")
        print("extended key: \(String(cString: extendedKeyPointer.pointee!))")
        
        let rootID = String(cString: extendedKeyPointer.pointee!)
        
        print("rootID: \(rootID)")
        
        //HD Account
        createHDAccount(from: rootID)
        
        return rootID
    }
    
    func createWallet(from rootID : String, currencyID : UInt32, walletID : UInt32) -> Dictionary<String, Any>? {
        let rootIDPointer = OpaquePointer(rootID)
        let newAccountPointer = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        
        //New address
        let newAddressPointer = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        let newAddressStringPointer = UnsafeMutablePointer<UnsafePointer<Int8>?>.allocate(capacity: 1)
        
        //Private
        let addressPrivateKeyPointer = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        let privateKeyStringPointer = UnsafeMutablePointer<UnsafePointer<Int8>?>.allocate(capacity: 1)
        
        //Public
        let addressPublicKeyPointer = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        let publicKeyStringPointer = UnsafeMutablePointer<UnsafePointer<Int8>?>.allocate(capacity: 1)

        let mHDa = make_hd_account(rootIDPointer, Currency.init(currencyID), walletID, newAccountPointer)
        if mHDa != nil {
            print("mHDa: \(String(describing: mHDa))")
            
            return nil
        }
        
        let mHDla = make_hd_leaf_account(newAccountPointer.pointee, ADDRESS_INTERNAL, 0, newAddressPointer)
        if mHDa != nil {
            print("mHDla: \(String(describing: mHDla))")
            
            return nil
        }
        
        //Create wallet
        var walletDict = Dictionary<String, Any>()
        walletDict["currency"] = currencyID
        walletDict["walletID"] = walletID
        walletDict["addressID"] = 0 as UInt32
        
        let gaas = get_account_address_string(newAddressPointer.pointee, newAddressStringPointer)
        var addressString : String? = nil
        if gaas != nil {
            print("Cannot get address string: \(String(describing: gaas))")
        } else {
            addressString = String(cString: newAddressStringPointer.pointee!)
            print("addressString: \(addressString)")
            
            walletDict["address"] = addressString
        }
        
        let gakPRIV = get_account_key(newAddressPointer.pointee, KEY_TYPE_PRIVATE, addressPrivateKeyPointer)
        let gakPUBL = get_account_key(newAddressPointer.pointee, KEY_TYPE_PUBLIC, addressPublicKeyPointer)
        
        let ktsPRIV = key_to_string(addressPrivateKeyPointer.pointee, privateKeyStringPointer)
        let ktsPUBL = key_to_string(addressPublicKeyPointer.pointee, publicKeyStringPointer)
        
        print("\(gakPRIV) - \(gakPUBL) - \(ktsPRIV) - \(ktsPUBL)")
        
        var privateKeyString : String? = nil
        var publicKeyString : String? = nil
        
        if ktsPRIV != nil {
            print("Cannot get private string: \(String(describing: gaas))")
        } else {
            privateKeyString = String(cString: privateKeyStringPointer.pointee!)
            walletDict["privateKey"] = privateKeyString
        }
        
        if ktsPUBL != nil {
            print("Cannot get public string: \(String(describing: gaas))")
        } else {
            publicKeyString = String(cString: publicKeyStringPointer.pointee!)
            walletDict["publicKey"] = publicKeyString
        }
        
        return walletDict
    }
    
    func createHDAccount(from rootID : String)  {
        let rootIDPointer = OpaquePointer(rootID)
        let newAccountPointer = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        
        //New address
        let newAddressPointer = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        let newAddressStringPointer = UnsafeMutablePointer<UnsafePointer<Int8>?>.allocate(capacity: 1)
        
        //Private
        let addressPrivateKeyPointer = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        let privateKeyStringPointer = UnsafeMutablePointer<UnsafePointer<Int8>?>.allocate(capacity: 1)
        
        //Public
        let addressPublicKeyPointer = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        let publicKeyStringPointer = UnsafeMutablePointer<UnsafePointer<Int8>?>.allocate(capacity: 1)
        
        let mHDa = make_hd_account(rootIDPointer, Currency.init(0), 0, newAccountPointer)
        print("mHDa: \(String(describing: mHDa))")
        
        let mHDla = make_hd_leaf_account(newAccountPointer.pointee, ADDRESS_EXTERNAL, 0, newAddressPointer)
        print("mHDla: \(String(describing: mHDla))")
        
        let gaas = get_account_address_string(newAddressPointer.pointee, newAddressStringPointer)
        print("gaas: \(String(describing: gaas))")
        let addressString = String(cString: newAddressStringPointer.pointee!)
        
        print("addressString: \(addressString)")
        
        let gakPRIV = get_account_key(newAddressPointer.pointee, KEY_TYPE_PRIVATE, addressPrivateKeyPointer)
        let gakPUBL = get_account_key(newAddressPointer.pointee, KEY_TYPE_PUBLIC, addressPublicKeyPointer)
        
        let ktsPRIV = key_to_string(addressPrivateKeyPointer.pointee, privateKeyStringPointer)
        let ktsPUBL = key_to_string(addressPublicKeyPointer.pointee, publicKeyStringPointer)
        
        print("\(gakPRIV) - \(gakPUBL) - \(ktsPRIV) - \(ktsPUBL)")
        
        let privateKeyString = String(cString: privateKeyStringPointer.pointee!)
        let publicKeyString = String(cString: publicKeyStringPointer.pointee!)
        
        print("privateKeyString: \(privateKeyString)")
        print("publicKeyString: \(publicKeyString)")
        
        let currencyPointer = UnsafeMutablePointer<Currency>.allocate(capacity: 1)
        let gac = get_account_currency(newAddressPointer.pointee, currencyPointer)
        print("gac: \(gac)")
        
        let currency : Currency = currencyPointer.pointee
        print("currency: \(currency)")
        
        amountActivity()
        transactionActions(account: newAddressPointer.pointee!)
    }
    
    func transactionActions(account: OpaquePointer) {
        //create transaction
        let transactionPointer = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        let sourcePointer = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        
        let mt = make_transaction(account, transactionPointer)
        print("\(mt)")
        
        if mt != nil {
            let pointer = UnsafeMutablePointer<CustomError>(mt)
            let errr = String(cString: (pointer?.pointee.message)!)
        }
        
        
//        let properties =
        
    }
    
    func amountActivity() {
        let amount = "20".UTF8CStringPointer
        let anotherAmount = "30".UTF8CStringPointer

        let newAmount = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        let amountStringPointer = UnsafeMutablePointer<UnsafePointer<Int8>?>.allocate(capacity: 1)
        
        let ma = make_amount(amount, newAmount)
        let ats = amount_to_string(newAmount.pointee, amountStringPointer)
        let asv = amount_set_value(newAmount.pointee, anotherAmount)
//        free_amount(newAmount.pointee)
        print("amountActivity: \(ma) -- \(ats) -- \(asv)")
    }
}
