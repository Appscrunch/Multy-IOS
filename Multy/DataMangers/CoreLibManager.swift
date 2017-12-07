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
    
    func createSeedBinaryData(from phrase: String) -> BinaryData {
        //MAKE: free data
        //use defer function!!!
        
        print("seed phrase: \(phrase)")
        let stringPointer = phrase.UTF8CStringPointer
        let binaryDataPointer = UnsafeMutablePointer<UnsafeMutablePointer<BinaryData>?>.allocate(capacity: 1)
        
        let ms = make_seed(stringPointer, nil, binaryDataPointer)
        
        if ms != nil {
            print("ms: \(String(describing: ms))")
//            return nil
        }

        return binaryDataPointer.pointee!.pointee
    }
    
    func createExtendedKey(from binaryData: inout BinaryData) -> String {
        let binaryDataPointer = UnsafeMutablePointer(mutating: &binaryData)
        
        let masterKeyPointer = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        let extendedKeyPointer = UnsafeMutablePointer<UnsafePointer<Int8>?>.allocate(capacity: 1)
        
        var mmk = make_master_key(binaryDataPointer, masterKeyPointer)
        print("mmk: \(String(describing: mmk))")
        
        var mki = make_key_id(masterKeyPointer.pointee, extendedKeyPointer)
        print("mki: \(String(describing: mki))")
        
        let extendedKey = String(cString: extendedKeyPointer.pointee!)
        print("extended key: \(extendedKey)")
        
        //free data
//        binaryDataPointer.deallocate(capacity: 1)
//        masterKeyPointer.deallocate(capacity: 1)
//        extendedKeyPointer.deallocate(capacity: 1)
        mmk = nil
        mki = nil
//        binaryData = nil
        
        return extendedKey
    }
    
    func createWallet(from binaryData: inout BinaryData, currencyID: UInt32, walletID: UInt32) -> Dictionary<String, Any>? {
        let binaryDataPointer = UnsafeMutablePointer(mutating: &binaryData)
        let masterKeyPointer = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        
        let mmk = make_master_key(binaryDataPointer, masterKeyPointer)
        print("mmk: \(String(describing: mmk))")
        
        //HD Account
        createHDAccount(from: masterKeyPointer.pointee!)
        
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

        let mHDa = make_hd_account(masterKeyPointer.pointee, Currency.init(currencyID), walletID, newAccountPointer)
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
    
    func createHDAccount(from masterKey: OpaquePointer)  {
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
        
        let mHDa = make_hd_account(masterKey, Currency.init(0), 0, newAccountPointer)
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
        transactionActions(account: newAccountPointer.pointee!, sendAddress: "", sendAmountString: "100000000", feeAmount: "20000", donationAddress: "", donationAmount: "10000000")
    }
    
    func transactionActions(account: OpaquePointer, sendAddress: String, sendAmountString: String, feeAmount: String, donationAddress: String, donationAmount: String) {
        //create transaction
        let transactionPointer = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        let transactionSource = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        
        let mt = make_transaction(account, transactionPointer)
        if mt != nil {
            let pointer = UnsafeMutablePointer<CustomError>(mt)
            let errrString = String(cString: pointer!.pointee.message)
            
            print("\(errrString) -- \(UINT64_MAX)")
        }
        
        let tas = transaction_add_source(transactionPointer.pointee, transactionSource)
        
        //amount sum
        let amountPointer = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        let amountKey = "amount".UTF8CStringPointer
        let amountValue = "20".UTF8CStringPointer
        let ma = make_amount(amountValue, amountPointer)
        properties_set_amount_value(transactionSource.pointee, amountKey, amountPointer.pointee)
        
        //prev transaction hash
        //prev_tx_hash
        //prev_tx_out_index
        //prev_tx_out_script_pubkey
        
        
        
        //address
        let transactionDestination = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        transaction_add_destination(transactionPointer.pointee, transactionDestination)
        
        let addressKey = "address".UTF8CStringPointer
        let addressValue = sendAddress.UTF8CStringPointer
        properties_set_string_value(transactionDestination.pointee, addressKey, addressValue)

        let sendAmountPointer = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        let sendAmountValue = sendAmountString.UTF8CStringPointer
        let ma2 = make_amount(sendAmountValue, amountPointer)
        properties_set_amount_value(transactionDestination.pointee, amountKey, sendAmountPointer.pointee)
        
        //change
        
//        let transactionDestination = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
//        transaction_add_destination(transactionPointer.pointee, transactionDestination)
//
//        let addressKey = "address".UTF8CStringPointer
//        let addressValue = sendAddress.UTF8CStringPointer
//        properties_set_string_value(transactionDestination.pointee, addressKey, addressValue)
//
//        let sendAmountPointer = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
//        let sendAmountValue = sendAmountString.UTF8CStringPointer
//        let ma2 = make_amount(sendAmountValue, amountPointer)
//        properties_set_amount_value(transactionDestination.pointee, amountKey, sendAmountPointer.pointee)
        
        //final
        let serializedTransaction = UnsafeMutablePointer<UnsafePointer<BinaryData>?>.allocate(capacity: 1)
        transaction_update(transactionPointer.pointee)
        transaction_sign(transactionPointer.pointee)
        transaction_serialize(transactionPointer.pointee, serializedTransaction)
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
