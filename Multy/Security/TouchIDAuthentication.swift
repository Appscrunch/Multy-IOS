//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import Foundation
import LocalAuthentication

class TouchIDAuth {
    let context = LAContext()
    
    func canEvaluatePolicy() -> Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    func authenticateUser(completion: @escaping (String?) -> Void) { // 1
        context.touchIDAuthenticationAllowableReuseDuration = 5
        guard canEvaluatePolicy() else {
            completion("You have not attemps to TouchId or PIN")
            return
        }
//        context.touchIDAuthenticationAllowableReuseDuration = 3
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                               localizedReason: "Logging in with Touch ID") { (success, evaluateError) in
                                if success {
                                    DispatchQueue.main.async {
                                        completion(nil)
                                    }
                                } else {
                                    let message: String
                                    switch evaluateError {
                                    case LAError.authenticationFailed?:
                                        message = "There was a problem verifying your identity."
                                    case LAError.userCancel?:
                                        message = ""
                                    case LAError.userFallback?:
                                        message = "You pressed password."
                                    default:
                                        message = "Touch ID may not be configured"
                                    }
                                    completion(message)
                                }
        }
    }
}
