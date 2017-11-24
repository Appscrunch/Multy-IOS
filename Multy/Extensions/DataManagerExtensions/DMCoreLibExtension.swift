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
    
    func getRootID(from seedPhase: String) -> String {
        return coreLibManager.restoreSeed(from: seedPhase)
    }
}
