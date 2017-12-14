//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class CoreLibManager: NSObject {
    static let shared = CoreLibManager()
    
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
//        run_tests(1, UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>.allocate(capacity: 1))
    }
        
    func startSwiftTest() {
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
        print("make_mnemonic: \(mm)")
        
        let phrase = String(cString: mnemo.pointee!)
        
        print("seed phrase: \(phrase)")
        
        let stringPointer = phrase.UTF8CStringPointer
        let binaryDataPointer = UnsafeMutablePointer<UnsafeMutablePointer<BinaryData>?>.allocate(capacity: 1)
        
        let ms = make_seed(stringPointer, nil, binaryDataPointer)
        
        print("make_seed: \(ms)")
        
        let masterKeyPointer = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        let extendedKeyPointer = UnsafeMutablePointer<UnsafePointer<Int8>?>.allocate(capacity: 1)
        
        var mmk = make_master_key(binaryDataPointer.pointee, masterKeyPointer)
        print("make_master_key: \(String(describing: mmk))")
        
        var mki = make_key_id(masterKeyPointer.pointee, extendedKeyPointer)
        print("make_key_id: \(String(describing: mki))")
        
        let extendedKey = String(cString: extendedKeyPointer.pointee!)
        print("extended key: \(extendedKey)")
        
        //HD Account
        
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
        
        let mHDa = make_hd_account(masterKeyPointer.pointee, Currency.init(0), 0, newAccountPointer)
        print("make_hd_account: \(mHDa)")
        
        let mHDla = make_hd_leaf_account(newAccountPointer.pointee, ADDRESS_INTERNAL, 0, newAddressPointer)
        print("make_hd_leaf_account: \(mHDla)")
        
        //Create wallet
        
        let gaas = get_account_address_string(newAddressPointer.pointee, newAddressStringPointer)
        var addressString : String? = nil
        if gaas != nil {
            print("Cannot get address string: \(String(describing: gaas))")
        } else {
            addressString = String(cString: newAddressStringPointer.pointee!)
            print("addressString: \(addressString!)")
        }
        
        let gakPRIV = get_account_key(newAddressPointer.pointee, KEY_TYPE_PRIVATE, addressPrivateKeyPointer)
        let gakPUBL = get_account_key(newAddressPointer.pointee, KEY_TYPE_PUBLIC, addressPublicKeyPointer)
        
        let ktsPRIV = key_to_string(addressPrivateKeyPointer.pointee, privateKeyStringPointer)
        let ktsPUBL = key_to_string(addressPublicKeyPointer.pointee, publicKeyStringPointer)
        
        print("\(gakPRIV) - \(gakPUBL) - \(ktsPRIV) - \(ktsPUBL)")
        
        
        let currencyPointer = UnsafeMutablePointer<Currency>.allocate(capacity: 1)
        let gac = get_account_currency(newAddressPointer.pointee, currencyPointer)
        print("gac: \(gac)")
        
        let currency : Currency = currencyPointer.pointee
        print("another currency: \(currency)")
        
        //create transaction
        let transactionPointer = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        let transactionSource = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        
        
        let mt = make_transaction(newAddressPointer.pointee, transactionPointer)
        if mt != nil {
            let pointer = UnsafeMutablePointer<CustomError>(mt)
            let errrString = String(cString: pointer!.pointee.message)
            
            print("\(errrString) -- \(UINT64_MAX)")
        }
        
        print("END")
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
        walletDict["addressID"] = UInt32(0)
        
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
        createTransaction(addressPointer: newAddressPointer.pointee!, sendAddress: "", sendAmountString: "100000000", feeAmountString: "20000", donationAddress: "", donationAmount: "10000000", txid: "createTransaction", txoutid: 1, txoutamount: 804, txoutscript: "a914bddce1db77593a7ac8d67f0d488c4311d5103ffa87")
    }
    
    func createTransaction(addressPointer: OpaquePointer, sendAddress: String, sendAmountString: String, feeAmountString: String, donationAddress: String, donationAmount: String, txid: String, txoutid: UInt32, txoutamount: UInt32, txoutscript: String) {
        let currencyPointer = UnsafeMutablePointer<Currency>.allocate(capacity: 1)
        let gac = get_account_currency(addressPointer, currencyPointer)
        print("gac: \(gac)")
        
        let currency : Currency = currencyPointer.pointee
        print("another currency: \(currency)")
        
        //create transaction
        let transactionPointer = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        let transactionSource = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        
        
        let mt = make_transaction(addressPointer, transactionPointer)
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
        print("test")
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
