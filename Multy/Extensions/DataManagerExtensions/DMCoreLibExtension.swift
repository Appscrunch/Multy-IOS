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
}
