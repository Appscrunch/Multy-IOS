//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

extension DataManager {
    func isDeviceJailbroken() -> Bool {
        return coreLibManager.isDeviceJailbroken()
    }
    
    func getMnenonicArray() -> Array<String> {
        return coreLibManager.createMnemonicPhraseArray()
    }
    
    func startCoreTest() {
        coreLibManager.startTests()
    }
    
    func getRootString(from seedPhase: String) -> String {
        var binaryData = coreLibManager.createSeedBinaryData(from: seedPhase)
        
        return coreLibManager.createExtendedKey(from: &binaryData)
    }
    
    func createWallet(from seedPhrase: String, currencyID : UInt32, walletID : UInt32) -> Dictionary<String, Any>? {
        var binaryData = coreLibManager.createSeedBinaryData(from: seedPhrase)
        
        return coreLibManager.createWallet(from: &binaryData, currencyID: currencyID, walletID: walletID)
    }
    
    func createNewAccountWithWallet(_ currencyID: UInt32, walletID: UInt32, completion: @escaping (_ wallet: Dictionary<String, Any>?) -> ()) {
        let seedPharse = getMnenonicArray()
        let seedPhraseString = seedPharse.joined(separator: " ")
        let rootKey = getRootString(from: seedPhraseString)
        
        var wallet = createWallet(from: rootKey, currencyID: currencyID, walletID: walletID)
        
        if wallet == nil {
            completion(nil)
        }
        
        wallet!["rootKey"] = rootKey
        wallet!["seedPharse"] = seedPhraseString
        
        completion(wallet!)
    }
}
