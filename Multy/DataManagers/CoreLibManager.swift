//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import RealmSwift

class CoreLibManager: NSObject {
    static let shared = CoreLibManager()
    
    func mnemonicAllWords() -> Array<String> {
        let mnemonicArrayPointer = UnsafeMutablePointer<UnsafePointer<Int8>?>.allocate(capacity: 1)
        
        defer { mnemonicArrayPointer.deallocate(capacity: 1) }
        
        mnemonic_get_dictionary(mnemonicArrayPointer)
        
        let mnemonicArrayString = String(cString: mnemonicArrayPointer.pointee!).trimmingCharacters(in: .whitespacesAndNewlines)
        
        return mnemonicArrayString.components(separatedBy: " ")
    }
    
    func createMnemonicPhraseArray() -> Array<String> {
        let mnemo = UnsafeMutablePointer<UnsafePointer<Int8>?>.allocate(capacity: 1)
        
        defer { mnemo.deallocate(capacity: 1) }
        
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
    
    func createSeedBinaryData(from phrase: String) -> BinaryData? {
        print("seed phrase: \(phrase)")
        let stringPointer = phrase.UTF8CStringPointer
        let binaryDataPointer = UnsafeMutablePointer<UnsafeMutablePointer<BinaryData>?>.allocate(capacity: 1)
        
        defer {
            binaryDataPointer.deallocate(capacity: 1)
//            stringPointer.deallocate(capacity: 1)
        }
        
        let ms = make_seed(stringPointer, nil, binaryDataPointer)
        
        if ms != nil {
            print("ms: \(String(describing: ms))")
            let _ = returnErrorString(opaquePointer: ms!, mask: "make_seed")
            
            return nil
        }

        if binaryDataPointer.pointee != nil {
            return binaryDataPointer.pointee!.pointee
        } else {
            return nil
        }
    }
    
    func createExtendedKey(from binaryData: inout BinaryData) -> String {
        let binaryDataPointer = UnsafeMutablePointer(mutating: &binaryData)
        
        let masterKeyPointer = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        let extendedKeyPointer = UnsafeMutablePointer<UnsafePointer<Int8>?>.allocate(capacity: 1)
        
        defer {
            masterKeyPointer.deallocate(capacity: 1)
            extendedKeyPointer.deallocate(capacity: 1)
        }
        
        var mmk = make_master_key(binaryDataPointer, masterKeyPointer)
        print("mmk: \(String(describing: mmk))")
        
        var mki = make_key_id(masterKeyPointer.pointee, extendedKeyPointer)
        print("mki: \(String(describing: mki))")
        
        let extendedKey = String(cString: extendedKeyPointer.pointee!)
        print("extended key: \(extendedKey)")
        
        mmk = nil
        mki = nil
        
        return extendedKey
    }
    
    func createWallet(from binaryData: inout BinaryData, currencyID: UInt32, walletID: UInt32) -> Dictionary<String, Any>? {
        let binaryDataPointer = UnsafeMutablePointer(mutating: &binaryData)
        let masterKeyPointer = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        
        let mmk = make_master_key(binaryDataPointer, masterKeyPointer)
        print("mmk: \(String(describing: mmk))")
        
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
        
        //placed here since we have multiple return
        defer {
//            binaryDataPointer.deallocate(capacity: 1)
            masterKeyPointer.deallocate(capacity: 1)
            newAccountPointer.deallocate(capacity: 1)
            newAddressPointer.deallocate(capacity: 1)
            newAddressStringPointer.deallocate(capacity: 1)
            
            addressPrivateKeyPointer.deallocate(capacity: 1)
            privateKeyStringPointer.deallocate(capacity: 1)
            
            addressPublicKeyPointer.deallocate(capacity: 1)
            publicKeyStringPointer.deallocate(capacity: 1)
        }

        let blockchain = createBlockchainType(currencyID: currencyID, netType: BLOCKCHAIN_NET_TYPE_TESTNET.rawValue)
        let mHDa = make_hd_account(masterKeyPointer.pointee, blockchain, walletID, newAccountPointer)
        if mHDa != nil {
            let _ = returnErrorString(opaquePointer: mHDa!, mask: "make_hd_account")
            
            return nil
        }
        
        let mHDla = make_hd_leaf_account(newAccountPointer.pointee, ADDRESS_INTERNAL, 0, newAddressPointer)
        if mHDla != nil {
            let _ = returnErrorString(opaquePointer: mHDla!, mask: "make_hd_leaf_account")
            
            return nil
        }
        
        //Create wallet
        var walletDict = Dictionary<String, Any>()
        walletDict["currency"] = currencyID
        walletDict["walletID"] = walletID
        walletDict["addressID"] = UInt32(0)
        
        let gaas = account_get_address_string(newAddressPointer.pointee, newAddressStringPointer)
        var addressString : String? = nil
        if gaas != nil {
            print("Cannot get address string: \(String(describing: gaas))")
        } else {
            addressString = String(cString: newAddressStringPointer.pointee!)
            print("addressString: \(addressString)")
            
            walletDict["address"] = addressString!
        }
        
        let gakPRIV = account_get_key(newAddressPointer.pointee, KEY_TYPE_PRIVATE, addressPrivateKeyPointer)
        let gakPUBL = account_get_key(newAddressPointer.pointee, KEY_TYPE_PUBLIC, addressPublicKeyPointer)
        
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
    
    func createPrivateKey(currencyID: UInt32, walletID: UInt32, addressID: UInt32, binaryData: inout BinaryData) -> OpaquePointer? {
        let binaryDataPointer = UnsafeMutablePointer(mutating: &binaryData)
        let masterKeyPointer = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        
        let mmk = make_master_key(binaryDataPointer, masterKeyPointer)
        print("mmk: \(String(describing: mmk))")
        
        //HD Account
        let newAccountPointer = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        
        //New address
        let newAddressPointer = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        
        //Private
        let addressPrivateKeyPointer = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)

        //placed here since we have multiple return
        defer {
//            binaryDataPointer.deallocate(capacity: 1)
            masterKeyPointer.deallocate(capacity: 1)
            newAccountPointer.deallocate(capacity: 1)
            newAddressPointer.deallocate(capacity: 1)
            addressPrivateKeyPointer.deallocate(capacity: 1)
        }
        
        let blockchain = createBlockchainType(currencyID: currencyID, netType: BLOCKCHAIN_NET_TYPE_TESTNET.rawValue)
        let mHDa = make_hd_account(masterKeyPointer.pointee, blockchain, walletID, newAccountPointer)
        if mHDa != nil {
            let _ = returnErrorString(opaquePointer: mHDa!, mask: "mHDa")
            
            return nil
        }
        
        let mHDla = make_hd_leaf_account(newAccountPointer.pointee, ADDRESS_INTERNAL, addressID, newAddressPointer)
        if mHDla != nil {
            let _ = returnErrorString(opaquePointer: mHDla!, mask: "mHDla")
            
            return nil
        }
        
        let gakPRIV = account_get_key(newAddressPointer.pointee, KEY_TYPE_PRIVATE, addressPrivateKeyPointer)
        if gakPRIV != nil {
            let _ = returnErrorString(opaquePointer: gakPRIV!, mask: "gakPRIV")
            
            return nil
        } else {
//            let privateKeyStringPointer = UnsafeMutablePointer<UnsafePointer<Int8>?>.allocate(capacity: 1)
//            let ktsPRIV = key_to_string(addressPrivateKeyPointer.pointee!, privateKeyStringPointer)
//            let privateKeyString = String(cString: privateKeyStringPointer.pointee!)
//            print(privateKeyString)
            
            return addressPrivateKeyPointer.pointee
        }
    }
    
    func createAddress(currencyID: UInt32, walletID: UInt32, addressID: UInt32, binaryData: inout BinaryData) -> Dictionary<String, Any>? {
        let binaryDataPointer = UnsafeMutablePointer(mutating: &binaryData)
        let masterKeyPointer = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        
        let mmk = make_master_key(binaryDataPointer, masterKeyPointer)
        print("mmk: \(String(describing: mmk))")
        
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
        
        //placed here since we have multiple return
        defer {
//            binaryDataPointer.deallocate(capacity: 1)
            masterKeyPointer.deallocate(capacity: 1)
            newAccountPointer.deallocate(capacity: 1)
            newAddressPointer.deallocate(capacity: 1)
            newAddressStringPointer.deallocate(capacity: 1)
            addressPrivateKeyPointer.deallocate(capacity: 1)
            privateKeyStringPointer.deallocate(capacity: 1)
            addressPublicKeyPointer.deallocate(capacity: 1)
            publicKeyStringPointer.deallocate(capacity: 1)
        }
        
        let blockchain = createBlockchainType(currencyID: currencyID, netType: BLOCKCHAIN_NET_TYPE_TESTNET.rawValue)
        let mHDa = make_hd_account(masterKeyPointer.pointee, blockchain, walletID, newAccountPointer)
        if mHDa != nil {
            let _ = returnErrorString(opaquePointer: mHDa!, mask: "make_hd_account")
            
            return nil
        }
        
        let mHDla = make_hd_leaf_account(newAccountPointer.pointee, ADDRESS_INTERNAL, addressID, newAddressPointer)
        if mHDla != nil {
            let _ = returnErrorString(opaquePointer: mHDa!, mask: "make_hd_leaf_account")
            
            return nil
        }
        
        //Create wallet
        var addressDict = Dictionary<String, Any>()
        addressDict["currencyID"] = currencyID
        addressDict["walletIndex"] = walletID
        addressDict["addressIndex"] = addressID
        addressDict["addressPointer"] = newAddressPointer.pointee
        
        let gaas = account_get_address_string(newAddressPointer.pointee, newAddressStringPointer)
        var addressString : String? = nil
        if gaas != nil {
            print("Cannot get address string: \(String(describing: gaas))")
        } else {
            addressString = String(cString: newAddressStringPointer.pointee!)
            print("addressString: \(addressString)")
            
            addressDict["address"] = addressString!
        }
        
        let gakPRIV = account_get_key(newAddressPointer.pointee, KEY_TYPE_PRIVATE, addressPrivateKeyPointer)
        let gakPUBL = account_get_key(newAddressPointer.pointee, KEY_TYPE_PUBLIC, addressPublicKeyPointer)
        
        let ktsPRIV = key_to_string(addressPrivateKeyPointer.pointee, privateKeyStringPointer)
        let ktsPUBL = key_to_string(addressPublicKeyPointer.pointee, publicKeyStringPointer)
        
        print("\(gakPRIV) - \(gakPUBL) - \(ktsPRIV) - \(ktsPUBL)")
        
        var privateKeyString : String? = nil
        var publicKeyString : String? = nil
        
        if ktsPRIV != nil {
            print("Cannot get private string: \(String(describing: gaas))")
        } else {
            privateKeyString = String(cString: privateKeyStringPointer.pointee!)
            addressDict["privateKey"] = privateKeyString
            
            addressDict["addressPrivateKeyPointer"] = addressPublicKeyPointer.pointee
        }
        
        if ktsPUBL != nil {
            print("Cannot get public string: \(String(describing: gaas))")
        } else {
            publicKeyString = String(cString: publicKeyStringPointer.pointee!)
            addressDict["publicKey"] = publicKeyString
        }
        
        defer {  }
        
        return addressDict
    }
    
    func createTransaction(addressPointer: OpaquePointer,
                           sendAddress: String,
                           sendAmountString: String,
                           feePerByteAmount: String,
                           isDonationExists: Bool,
                           donationAmount: String,
                           isPayCommission: Bool,
                           wallet: UserWalletRLM,
                           binaryData: inout BinaryData,
                           inputs: List<AddressRLM>) -> (String, Double) {
        let inputs = DataManager.shared.realmManager.spendableOutput(addresses: inputs)
        let inputSum = DataManager.shared.spendableOutputSum(outputs: inputs)
        
        //create transaction
        let transactionPointer = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        
        let mt = make_transaction(addressPointer, transactionPointer)
        if mt != nil {
            let _ = returnErrorString(opaquePointer: mt!, mask: "make_transaction")
        }
        
        //fee
        let fee = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        let tgf = transaction_get_fee(transactionPointer.pointee, fee)
        if tgf != nil {
            let _ = returnErrorString(opaquePointer: tgf!, mask: "transaction_get_fee")
        }
        
        
        let maxFee = UInt64(feePerByteAmount)!
//        let maxFeeString = String(maxFee + (maxFee / 5) + 1)// 20% error
        //Amount
        setAmountValue(key: "amount_per_byte", value: feePerByteAmount, pointer: fee.pointee!)
//        setAmountValue(key: "max_amount_per_byte", value: maxFeeString, pointer: fee.pointee!) // optional

        //spendable info
        
        for input in inputs {
            let transactionSource = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
            let tas = transaction_add_source(transactionPointer.pointee, transactionSource)
            
            setAmountValue(key: "amount",
                           value: String(describing: input.transactionOutAmount),
                           pointer: transactionSource.pointee!)
            setBinaryDataValue(key: "prev_tx_hash",
                               value: input.transactionID,
                               pointer: transactionSource.pointee!)
            setIntValue(key: "prev_tx_out_index",
                        value: input.transactionOutID.uint32Value,
                        pointer: transactionSource.pointee!)
            setBinaryDataValue(key: "prev_tx_out_script_pubkey",
                               value: input.transactionOutScript,
                               pointer: transactionSource.pointee!)
            
            let privateKey = createPrivateKey(currencyID: wallet.chain.uint32Value,
                                              walletID: wallet.walletID.uint32Value,
                                              addressID: input.addressID.uint32Value,
                                              binaryData: &binaryData)
            setPrivateKeyValue(key: "private_key", value: privateKey!, pointer: transactionSource.pointee!)
            
            defer { transactionSource.deallocate(capacity: 1) }
        }
        
        var sendSum = UInt64(0)
        var changeSum = UInt64(0)
        let sendSumInSatoshi = convertBTCStringToSatoshi(sum: sendAmountString)
        let donationSumInSatoshi = convertBTCStringToSatoshi(sum: donationAmount)
        
        defer {
            transactionPointer.deallocate(capacity: 1)
            fee.deallocate(capacity: 1)
        }
        
        if sendSumInSatoshi < donationSumInSatoshi {
            return ("Sending amount (\(sendAmountString) BTC) must be greater then donation amount (\(donationAmount) BTC)", -2)
        }
        
        sendSum = sendSumInSatoshi
        
        //address
        let transactionDestination = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        transaction_add_destination(transactionPointer.pointee, transactionDestination)
        
        setStringValue(key: "address", value: sendAddress, pointer: transactionDestination.pointee!)

        //donation
        if isDonationExists {
            let donationDestination = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
            transaction_add_destination(transactionPointer.pointee, donationDestination)
            
            let currentChainDonationAddress = DataManager.shared.getBTCDonationAddress(netType: wallet.chainType.uint32Value)
            
            setStringValue(key: "address", value: currentChainDonationAddress, pointer: donationDestination.pointee!)
            setAmountValue(key: "amount", value: String(convertBTCStringToSatoshi(sum: donationAmount)), pointer: donationDestination.pointee!)
            
            defer { donationDestination.deallocate(capacity: 1) }
        }
        
        //change
        //MARK: UInt32(wallet.addresses.count)
        let dict = createAddress(currencyID: wallet.chain.uint32Value,
                                 walletID: wallet.walletID.uint32Value,
                                 addressID: UInt32(wallet.addresses.count),
                                 binaryData: &binaryData)
        
        //if we send MAX than we mark "is_change" for destination
        if sendSumInSatoshi == inputSum {
            setIntValue(key: "is_change", value: UInt32(1), pointer: transactionDestination.pointee!)
        } else {
            if !isPayCommission {
                sendSum -= donationSumInSatoshi
            }
            
            setAmountValue(key: "amount", value: String(sendSum), pointer: transactionDestination.pointee!)
            
            let changeDestination = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
            transaction_add_destination(transactionPointer.pointee, changeDestination)
            
            setIntValue(key: "is_change", value: UInt32(1), pointer: changeDestination.pointee!)
            setStringValue(key: "address", value: dict!["address"] as! String, pointer: changeDestination.pointee!)
            //        setAmountValue(key: "amount", value: String(changeSum), pointer: changeDestination.pointee!)
            
            defer { changeDestination.deallocate(capacity: 1) }
        }
        
        //final
        let serializedTransaction = UnsafeMutablePointer<UnsafeMutablePointer<BinaryData>?>.allocate(capacity: 1)
        
        let tu = transaction_update(transactionPointer.pointee)
        
        if tu != nil {
            let errrString = returnErrorString(opaquePointer: tu!, mask: "transaction_get_fee")
            
//            defer { pointer?.deallocate(capacity: 1) }
            
            return (errrString, -1)
        }
        
        
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        //modify sums after transaction update
        
        let totalSumPointer = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        let tgtf = transaction_get_total_fee(transactionPointer.pointee, totalSumPointer)
        let amountStringPointer = UnsafeMutablePointer<UnsafePointer<Int8>?>.allocate(capacity: 1)
        
        defer {
            transactionDestination.deallocate(capacity: 1)
            serializedTransaction.deallocate(capacity: 1)
            totalSumPointer.deallocate(capacity: 1)
            amountStringPointer.deallocate(capacity: 1)
        }
        
        let ats = big_int_to_string(totalSumPointer.pointee, amountStringPointer)
        if ats != nil {
            let errrString = returnErrorString(opaquePointer: ats!, mask: "amount_to_string")
            
            return (errrString, -1)
        }
        
        let amountString = String(cString: amountStringPointer.pointee!)
        let feeInSatoshiAmount = UInt64(amountString)!
        let feeInBTCAmount = convertSatoshiToBTC(sum: feeInSatoshiAmount)
        
        //checking sums
        
        if isPayCommission {
            sendSum = sendSumInSatoshi
            if inputSum < sendSum + donationSumInSatoshi + feeInSatoshiAmount {
                return ("Wallet amount (\(convertSatoshiToBTCString(sum: inputSum))) must be greater the send amount (\(convertSatoshiToBTCString(sum: sendSum))) plus fee amount (\(convertSatoshiToBTCString(sum: feeInSatoshiAmount))) plus donation amount (\(donationAmount) BTC)", -2)
            } else {
                //reamins just for checking all sums - automatically calculated in core library
                changeSum = inputSum - (sendSum + donationSumInSatoshi + feeInSatoshiAmount)
            }
        } else {
            if sendSumInSatoshi < donationSumInSatoshi + feeInSatoshiAmount {
                return ("Sending amount (\(sendAmountString) BTC) must be greater then fee amount (\(convertSatoshiToBTCString(sum: feeInSatoshiAmount))) plus donation (\(donationAmount) BTC)", -2)
            } else {
                if sendSumInSatoshi != inputSum {
                    sendSum = sendSumInSatoshi - (donationSumInSatoshi + feeInSatoshiAmount)
                    //update value for sending sum
                    setAmountValue(key: "amount", value: String(sendSum), pointer: transactionDestination.pointee!)
                    
                    //reamins just for checking all sums - automatically calculated in core library
                    changeSum = inputSum - sendSumInSatoshi
                }
            }
        }
        
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        let tSer = transaction_serialize(transactionPointer.pointee, serializedTransaction)
        
        if tSer != nil {
            let errrString = returnErrorString(opaquePointer: tSer!, mask: "transaction_serialize")
            return (errrString, -1)
        }
        
        let data = serializedTransaction.pointee!.pointee.convertToData()
        let str = data.hexEncodedString()
        
        print("end transaction: \(str)")
        
        
        return (str, feeInBTCAmount)
    }
    
    func setAmountValue(key: String, value: String, pointer: OpaquePointer) {
        let amountKey = key.UTF8CStringPointer
        let amountValue = value.UTF8CStringPointer
        
        let amountPointer = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        let _ = make_big_int(amountValue, amountPointer)
        
        let psav = properties_set_big_int_value(pointer, amountKey, amountPointer.pointee)
        
        if psav != nil {
            let pointer = UnsafeMutablePointer<CustomError>(psav)
            let errrString = String(cString: pointer!.pointee.message)
            
            defer { pointer?.deallocate(capacity: 1) }
            
            print("setAmountValue: \(errrString))")
        }
        
        defer {
//            amountKey.deallocate(capacity: 1)
//            amountValue.deallocate(capacity: 1)
            amountPointer.deallocate(capacity: 1)
        }
    }
    
    func setBinaryDataValue(key: String, value: String, pointer: OpaquePointer) {
        let binaryKey = key.UTF8CStringPointer
        let dataValue = value.UTF8CStringPointer
        
        let binData = UnsafeMutablePointer<UnsafeMutablePointer<BinaryData>?>.allocate(capacity: 1)
        make_binary_data_from_hex(dataValue, binData)
        
        let psbdv = properties_set_binary_data_value(pointer, binaryKey, binData.pointee)
        if psbdv != nil {
            let pointer = UnsafeMutablePointer<CustomError>(psbdv)
            let errrString = String(cString: pointer!.pointee.message)
            
            defer { pointer?.deallocate(capacity: 1) }
            
            print("setBinaryDataValue: \(errrString))")
        }
        
        defer {
//            binaryKey.deallocate(capacity: 1)
//            dataValue.deallocate(capacity: 1)
            binData.deallocate(capacity: 1)
        }
    }
    
    func setIntValue(key: String, value: UInt32, pointer: OpaquePointer) {
        let intKey = key.UTF8CStringPointer
        let intValue = Int32(value)

        let psi = properties_set_int32_value(pointer, intKey, intValue)
        
        if psi != nil {
            let pointer = UnsafeMutablePointer<CustomError>(psi)
            let errrString = String(cString: pointer!.pointee.message)
            
            defer { pointer?.deallocate(capacity: 1) }
            
            print("setIntValue: \(errrString))")
        }
        
        defer {
//            intKey.deallocate(capacity: 1)
        }
    }
    
    func setStringValue(key: String, value: String, pointer: OpaquePointer) {
        let stringKey = key.UTF8CStringPointer
        let stringValue = value.UTF8CStringPointer
        
        let pstv = properties_set_string_value(pointer, stringKey, stringValue)
        
        if pstv != nil {
            let pointer = UnsafeMutablePointer<CustomError>(pstv)
            let errrString = String(cString: pointer!.pointee.message)
            
            defer { pointer?.deallocate(capacity: 1) }
            
            print("setStringValue: \(errrString))")
        }
        
        defer {
//            stringKey.deallocate(capacity: 1)
//            stringValue.deallocate(capacity: 1)
        }
    }
    
    func setPrivateKeyValue(key: String, value: OpaquePointer, pointer: OpaquePointer) {
        let stringKey = key.UTF8CStringPointer
        
        let pspkv = properties_set_private_key_value(pointer, stringKey, value)
        
        if pspkv != nil {
            let pointer = UnsafeMutablePointer<CustomError>(pspkv)
            let errorString = String(cString: pointer!.pointee.message)
            
            defer { pointer?.deallocate(capacity: 1) }
            
            print("setPrivateKeyValue: \(errorString))")
        }
        
        defer {
//            stringKey.deallocate(capacity: 1)
        }
    }
    
    func returnErrorString(opaquePointer: OpaquePointer, mask: String) -> String {
        let pointer = UnsafeMutablePointer<CustomError>(opaquePointer)
        let errorString = String(cString: pointer.pointee.message)
        
        print("\(mask): \(errorString))")
        
        defer {
            pointer.deallocate(capacity: 1)
        }
        
        return errorString
    }
    
    func isAddressValid(address: String, for wallet: UserWalletRLM) -> (Bool, String?) {
        let addressUTF8 = address.UTF8CStringPointer
        //FIXME: Blockchain values
        let blockchainType = createBlockchainType(currencyID: wallet.chain.uint32Value, netType: BLOCKCHAIN_NET_TYPE_TESTNET.rawValue)
        let error = validate_address(blockchainType, addressUTF8)
        
        defer {
//            addressUTF8.deallocate(capacity: 1)
        }
        
        if error != nil {
            let pointer = UnsafeMutablePointer<CustomError>(error)
            let errorString = String(cString: pointer!.pointee.message)

            defer { pointer?.deallocate(capacity: 1) }
            
//            defer { pointer?.deallocate(capacity: 1) }
            
            return (false, errorString)
        } else {
            return (true, nil)
        }
    }
    
    func createBlockchainType(currencyID: UInt32, netType: UInt32) -> BlockchainType {
        return BlockchainType.init(blockchain: Blockchain.init(currencyID), net_type: Int(netType))
    }
}

////////////////////////////////////
private typealias TestCoreLibManager = CoreLibManager
extension TestCoreLibManager {
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
        
        let blockchain = createBlockchainType(currencyID: BLOCKCHAIN_BITCOIN.rawValue, netType: BLOCKCHAIN_NET_TYPE_MAINNET.rawValue)
        let mHDa = make_hd_account(masterKeyPointer.pointee, blockchain, UInt32(0), newAccountPointer)
        print("make_hd_account: \(mHDa)")
        
        if mHDa != nil {
            let _ = returnErrorString(opaquePointer: mHDa!, mask: "make_hd_account")
        }
        
        let mHDla = make_hd_leaf_account(newAccountPointer.pointee!, ADDRESS_INTERNAL, UInt32(0), newAddressPointer)
        //        make_hd_leaf_account(OpaquePointer!, AddressType, UInt32, UnsafeMutablePointer<OpaquePointer?>!)
        if mHDla != nil {
            let _ = returnErrorString(opaquePointer: mHDla!, mask: "make_hd_leaf_account")
        }
        
        //Create wallet
        
        let gaas = account_get_address_string(newAddressPointer.pointee, newAddressStringPointer)
        var addressString : String? = nil
        if gaas != nil {
            let _ = returnErrorString(opaquePointer: gaas!, mask: "account_get_address_string")
        } else {
            addressString = String(cString: newAddressStringPointer.pointee!)
            print("addressString: \(addressString!)")
        }
        
        let gakPRIV = account_get_key(newAddressPointer.pointee, KEY_TYPE_PRIVATE, addressPrivateKeyPointer)
        let gakPUBL = account_get_key(newAddressPointer.pointee, KEY_TYPE_PUBLIC, addressPublicKeyPointer)
        
        let ktsPRIV = key_to_string(addressPrivateKeyPointer.pointee, privateKeyStringPointer)
        let ktsPUBL = key_to_string(addressPublicKeyPointer.pointee, publicKeyStringPointer)
        
        print("\(gakPRIV) - \(gakPUBL) - \(ktsPRIV) - \(ktsPUBL)")
        
        
        let currencyPointer = UnsafeMutablePointer<BlockchainType>.allocate(capacity: 1)
        let gac = account_get_blockchain_type(newAddressPointer.pointee, currencyPointer)
        print("gac: \(gac)")
        
        let currency : BlockchainType = currencyPointer.pointee
        print("another currency: \(currency)")
        
        //create transaction
        let transactionPointer = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        let transactionSource = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        
        
        let mt = make_transaction(newAddressPointer.pointee, transactionPointer)
        if mt != nil {
            let _ = returnErrorString(opaquePointer: mt!, mask: "make_hd_account")
        }
        
        print("END")
        
        defer {
            mnemo.deallocate(capacity: 1)
            //            stringPointer.deallocate(capacity: 1)
            binaryDataPointer.deallocate(capacity: 1)
            masterKeyPointer.deallocate(capacity: 1)
            extendedKeyPointer.deallocate(capacity: 1)
            newAccountPointer.deallocate(capacity: 1)
            newAddressPointer.deallocate(capacity: 1)
            newAddressStringPointer.deallocate(capacity: 1)
            
            //Private
            addressPrivateKeyPointer.deallocate(capacity: 1)
            privateKeyStringPointer.deallocate(capacity: 1)
            
            //Public
            addressPublicKeyPointer.deallocate(capacity: 1)
            publicKeyStringPointer.deallocate(capacity: 1)
            
            currencyPointer.deallocate(capacity: 1)
            
            transactionPointer.deallocate(capacity: 1)
            transactionSource.deallocate(capacity: 1)
        }
        
        //creating tx
        //Check if exist wallet by walletID
        DataManager.shared.realmManager.getWallet(walletID: 1) { (wallet) in
            let addressData = self.createAddress(currencyID:    wallet!.chain.uint32Value,
                                                 walletID:      wallet!.walletID.uint32Value,
                                                 addressID:     UInt32(wallet!.addresses.count),
                                                 binaryData:    &binaryDataPointer.pointee!.pointee)
            
            let data = self.createTransaction(addressPointer: addressData!["addressPointer"] as! OpaquePointer,
                                              sendAddress: Constants.DataManager.btcTestnetDonationAddress,
                                              sendAmountString: "0,001",
                                              feePerByteAmount: "2",
                                              isDonationExists: false,
                                              donationAmount: "0",
                                              isPayCommission: true,
                                              wallet: wallet!,
                                              binaryData: &binaryDataPointer.pointee!.pointee,
                                              inputs: wallet!.addresses)
            print("tx: \(data.0)")
        }
    }
    
    func testUserPreferences() {
        //user prefs test
        let userPrefs = UserPreferences.shared
        
        userPrefs.getAndDecryptPin { (string, error) in
            print("pin string: \(String(describing: string)) - error: \(String(describing: error))")
        }
        
        userPrefs.getAndDecryptBiometric { (isOn, error) in
            print("biometric: \(String(describing: isOn)) - error: \(String(describing: error))")
        }
        
        userPrefs.getAndDecryptCipheredMode { (isOn, error) in
            print("ciphered mode: \(String(describing: isOn)) - error: \(String(describing: error))")
        }
        
        userPrefs.getAndDecryptDatabasePassword { (dataPass, error) in
            print("ciphered mode: \(String(describing: dataPass)) - error: \(String(describing: error))")
        }
        
        print("\n\n---===The end of the user's prefs test===---\n\n")
    }
}
