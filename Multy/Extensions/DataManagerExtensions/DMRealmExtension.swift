//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import Foundation

extension DataManager {
    func writeSeedPhrase(_ seedPhrase : String, completion: @escaping (_ error: NSError?) -> ()) {
        realmManager.writeSeedPhrase(seedPhrase) { (error) in
            completion(error)
        }
    }
    
    func deleteSeedPhrase(completion: @escaping (_ error: NSError?) -> ()) {
        realmManager.deleteSeedPhrase { (error) in
            completion(error)
        }
    }
}
