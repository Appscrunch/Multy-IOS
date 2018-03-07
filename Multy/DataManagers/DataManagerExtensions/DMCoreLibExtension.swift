//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

extension DataManager {
//    func isDeviceJailbroken() -> Bool {
//        return coreLibManager.isDeviceJailbroken()
//    }
    
    func getMnenonicAllWords() -> Array<String> {
        return coreLibManager.mnemonicAllWords()
    }
    
    func getMnenonicArray() -> Array<String> {
        return coreLibManager.createMnemonicPhraseArray()
    }
    
    func startCoreTest() {
        coreLibManager.startTests()
    }
    
    func getRootString(from seedPhase: String) -> (String?, String?)  {
        var binaryData = coreLibManager.createSeedBinaryData(from: seedPhase)
        if binaryData != nil {
            return (coreLibManager.createExtendedKey(from: &binaryData!), nil)
        } else {
            return (nil, "Seed phrase is too short")
        }
        
    }
    
    
    
//    func createWallet(from seedPhrase: String, currencyID : UInt32, walletID : UInt32, addressID: UInt32) -> Dictionary<String, Any>? {
//        var binaryData = coreLibManager.createSeedBinaryData(from: seedPhrase)
//        
//        
//    }
    
    func createNewWallet(for binaryData: inout BinaryData, _ currencyID: UInt32, walletID: UInt32) -> Dictionary<String, Any>? {
        return coreLibManager.createWallet(from: &binaryData, currencyID: currencyID, walletID: walletID)
    }
    
    func isAddressValid(address: String, for wallet: UserWalletRLM) -> (Bool, String?) {
        return coreLibManager.isAddressValid(address: address, for: wallet)
    }
    
    func createAndSendDonationTransaction(transactionDTO: TransactionDTO, completion: @escaping(_ answer: String?,_ error: Error?) -> ()) {
        let core = DataManager.shared.coreLibManager
        let wallet = transactionDTO.choosenWallet!
        var binaryData = DataManager.shared.realmManager.account!.binaryDataString.createBinaryData()!
        
        
        let addressData = core.createAddress(currencyID: transactionDTO.choosenWallet!.chain.uint32Value,
                                             walletID: transactionDTO.choosenWallet!.walletID.uint32Value,
                                             addressID: UInt32(transactionDTO.choosenWallet!.addresses.count),
                                             binaryData: &binaryData)
        
        let trData = DataManager.shared.coreLibManager.createTransaction(addressPointer: addressData!["addressPointer"] as! OpaquePointer,
                                                                         sendAddress: transactionDTO.sendAddress!,
                                                                         sendAmountString: transactionDTO.sendAmount!.fixedFraction(digits: 8),
                                                                         feePerByteAmount: "\(transactionDTO.transaction!.customFee!)",
                                                                         isDonationExists: false,
                                                                         donationAmount: "0",
                                                                         isPayCommission: true,
                                                                         wallet: transactionDTO.choosenWallet!,
                                                                         binaryData: &binaryData,
                                                                         inputs: transactionDTO.choosenWallet!.addresses)
        
        let newAddressParams = [
            "walletindex"   : wallet.walletID.intValue,
            "address"       : addressData!["address"] as! String,
            "addressindex"  : wallet.addresses.count,
            "transaction"   : trData.0,
            "ishd"          : NSNumber(booleanLiteral: true)
            ] as [String : Any]
        
        let params = [
            "currencyid": wallet.chain,
            "payload"   : newAddressParams
            ] as [String : Any]
        
        DataManager.shared.sendHDTransaction(transactionParameters: params) { (dict, error) in
            print("---------\(dict)")
            //FIXME: create messages in bad cases
            
            if error != nil {
//                self.presentAlert()
                
                print("sendHDTransaction Error: \(error)")
//                self.sendAnalyticsEvent(screenName: "\(screenSendAmountWithChain)\(self.presenter.transactionDTO.choosenWallet!.chain)", eventName: transactionErrorFromServer)
                completion(nil, nil)
                
                return
            }
            
            if dict!["code"] as! Int == 200 {
//                self.performSegue(withIdentifier: "sendingAnimationVC", sender: sender)
                completion("good", nil)
            } else {
                completion(nil, nil)
//                self.sendAnalyticsEvent(screenName: "\(screenSendAmountWithChain)\(self.presenter.transactionDTO.choosenWallet!.chain)", eventName: transactionErrorFromServer)
//                self.presentAlert()
            }
        }
    }
    
}
