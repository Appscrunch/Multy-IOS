//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

extension DataManager {
//    func isDeviceJailbroken() -> Bool {
//        return coreLibManager.isDeviceJailbroken()
//    }
    
    func getMnenonicArray() -> Array<String> {
        return coreLibManager.createMnemonicPhraseArray()
    }
    
    func startCoreTest() {
        coreLibManager.startTests()
    }
    
    func getRootID(from seedPhase: String) -> String {
        return coreLibManager.createRootID(from: seedPhase)
    }
    
    func createWallet(from rootID: String, currencyID : UInt32, walletID : UInt32) -> Dictionary<String, Any>? {
        return coreLibManager.createWallet(from: rootID, currencyID: currencyID, walletID: walletID)
    }
    
    func createNewWallet(_ currencyID: UInt32, walletID: UInt32, completion: @escaping (_ wallet: Dictionary<String, Any>?) -> ()) {
        let seedPharse = getMnenonicArray()
        let seedPhraseString = seedPharse.joined(separator: " ")
        let rootKey = getRootID(from: seedPhraseString)
        
        var wallet = createWallet(from: rootKey, currencyID: currencyID, walletID: walletID)
        
        if wallet == nil {
            completion(nil)
        }
        
        wallet!["rootKey"] = rootKey
        wallet!["seedPharse"] = seedPhraseString
        
        completion(wallet!)
    }
}
