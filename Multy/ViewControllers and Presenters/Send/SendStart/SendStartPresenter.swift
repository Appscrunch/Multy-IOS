//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class SendStartPresenter: NSObject, CancelProtocol, SendAddressProtocol, GoToQrProtocol, QrDataProtocol {
    
    var sendStartVC: SendStartViewController?
    var transactionDTO = TransactionDTO()
    var isFromWallet = false
    
    func cancelAction() {
        if self.isFromWallet {
            self.sendStartVC?.navigationController?.popViewController(animated: true)
        } else {
            if let tbc = self.sendStartVC?.tabBarController as? CustomTabBarViewController {
                tbc.setSelectIndex(from: 2, to: tbc.previousSelectedIndex)
            }
            self.sendStartVC?.navigationController?.popToRootViewController(animated: false)
        }
    }
    
    func presentNoInternet() {
        if !(ConnectionCheck.isConnectedToNetwork()) {
            if self.isKind(of: NoInternetConnectionViewController.self) || self.isKind(of: UIAlertController.self) {
                return
            }
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NoConnectionVC") as! NoInternetConnectionViewController
            self.sendStartVC!.present(nextViewController, animated: true, completion: nil)
        }
    }
    
    func sendAddress(address: String) {
        self.transactionDTO.sendAddress = address
        self.sendStartVC?.modifyNextButtonMode()
    }
    
    func goToScanQr() {
        self.sendStartVC?.performSegue(withIdentifier: "qrCamera", sender: Any.self)
    }
  
    func qrData(string: String) {
//        if sting.contains(":") {
//            let separatedString = sting.components(separatedBy: ":")
//            let blockchainName = separatedString[0]
//            print(blockchainName)  // bitcoin
//            if separatedString[1].contains("?") {
//                let separatedAddress = separatedString[1].components(separatedBy: "?")[0]
//                print(separatedAddress)  // wallet address
//                let separatedAmount = separatedString[1].components(separatedBy: "?")[1]
//                if separatedAmount.contains("amount") {
//                    let sumInCrypto = separatedAmount.components(separatedBy: "=")[1]
//                    print(sumInCrypto) // amount sum
//                }
//            } else {
//                let separatedAddress = separatedString[1]
//                print(separatedAddress) // wallet address
//            }
//        }
        let array = string.components(separatedBy: CharacterSet(charactersIn: ":?="))
        switch array.count {
        case 1:                              // shit in qr
            let messageFromQr = array[0]
            self.transactionDTO.sendAddress = messageFromQr
            print(messageFromQr)
        case 2:                              // chain name + address
//            let blockchainName = array[0]
            let addressStr = array[1]
//            print(blockchainName, addressStr)
            self.transactionDTO.sendAddress = addressStr
        case 4:                                // chain name + address + amount
//            let blockchainName = array[0]
            let addressStr = array[1]
            let amount = array[3]
//            print(blockchainName, addressStr, amount)
            self.transactionDTO.sendAddress = addressStr
            self.transactionDTO.sendAmount = (amount as NSString).doubleValue
        default:
            return
        }
        self.sendStartVC?.modifyNextButtonMode()
        self.sendStartVC?.updateUI()
    }
    
    func isValidCryptoAddress() -> Bool {
        if transactionDTO.sendAddress != nil && transactionDTO.choosenWallet != nil {
            let isValidDTO = DataManager.shared.isAddressValid(address: transactionDTO.sendAddress!, for: transactionDTO.choosenWallet!)
            
            if !isValidDTO.0 {
//                presentAlert(message: isValidDTO.1!)
            }
            
            return isValidDTO.0
        } else {
            return transactionDTO.choosenWallet == nil
        }
    }
    
    func presentAlert(message: String) {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        sendStartVC?.present(alert, animated: true, completion: nil)
    }
    
    func isTappedDisabledNextButton(gesture: UITapGestureRecognizer) -> Bool {
        return sendStartVC!.nextBtn.frame.minY < gesture.location(in: gesture.view!).y
    }
    
    func destinationSegueString() -> String {
        switch transactionDTO.blockchainType.blockchain {
        case BLOCKCHAIN_BITCOIN:
            return "sendBTCDetailsVC"
        case BLOCKCHAIN_ETHEREUM:
            return "sendETHDetailsVC"
        default:
            return ""
        }
    }
}
