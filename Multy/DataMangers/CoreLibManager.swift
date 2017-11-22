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
        //    print(phrase)
        
        return phrase.components(separatedBy: " ")
    }
}
