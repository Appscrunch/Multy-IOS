//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

let wirelessRequestImagesAmount = 10

class ReceiveAllDetailsPresenter: NSObject, ReceiveSumTransferProtocol, SendWalletProtocol {

    var receiveAllDetailsVC: ReceiveAllDetailsViewController?
    
    var cryptoSum: String?
    var cryptoName: String?
    var fiatSum: String?
    var fiatName: String?
    var wirelessRequestImageName: String? {
        didSet {
            if wirelessRequestImageName != nil {
                receiveAllDetailsVC!.hidedImage.image = UIImage(named: wirelessRequestImageName!)
            }
        }
    }
    
    var walletAddress = ""
    
    var wallet: UserWalletRLM? {
        didSet {
            if wallet != nil {
                qrBlockchainString = BlockchainType.create(wallet: wallet!).qrBlockchainString
            }
        }
    }
    
    var qrBlockchainString = String()
    

    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didChangedBluetoothReachability(notification:)), name: Notification.Name(bluetoothReachabilityChangedNotificationName), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didUpdateTransaction(notification:)), name: Notification.Name("transactionUpdated"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(bluetoothReachabilityChangedNotificationName), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("transactionUpdated"), object: nil)
    }
    
    func viewControllerViewDidLoad() {
        let _ = BLEManager.shared
    }
    
    func viewControllerViewWillDisappear() {
        stopReceivingViaWireless()
    }
    
    func cancelViewController() {
        if self.receiveAllDetailsVC!.option == .wireless {
            stopReceivingViaWireless()
        }
        
        self.receiveAllDetailsVC?.tabBarController?.selectedIndex = 0
        self.receiveAllDetailsVC?.navigationController?.popToRootViewController(animated: false)
    }
    
    func transferSum(cryptoAmount: String, cryptoCurrency: String, fiatAmount: String, fiatName: String) {
        self.cryptoSum = cryptoAmount
        self.cryptoName = cryptoCurrency
        self.fiatSum = fiatAmount
        self.fiatName = fiatName
        
        self.receiveAllDetailsVC?.setupUIWithAmounts()
        
        if self.receiveAllDetailsVC!.option == .wireless {
            tryReceiveViaWireless()
        }
    }
    
    func sendWallet(wallet: UserWalletRLM) {
        self.wallet = wallet
        self.receiveAllDetailsVC?.updateUIWithWallet()
        
        if self.receiveAllDetailsVC!.option == .wireless {
            tryReceiveViaWireless()
        }
    }
    
    func didChangeReceivingOption() {
        switch self.receiveAllDetailsVC!.option {
        case .qrCode:
            stopReceivingViaWireless()
            stopSharingUserCode()
            break
            
        case .wireless:
            if wirelessRequestImageName == nil {
                generateWirelessRequestImage()
            }
            
            tryReceiveViaWireless()
            break
        }
    }
    
    private func handleBluetoothReachability() {
        if self.receiveAllDetailsVC?.option == .wireless {
            tryReceiveViaWireless()
        }
    }
    
    private func generateWirelessRequestImage() {
        DataManager.shared.getAccount { (account, error) in
            if account != nil {
                let userID = account!.userID
                let userCode = self.userCodeForUserID(userID: userID)
                if let value = UInt32(userCode, radix: 16) {
                    let imageNumber = Int(value)%wirelessRequestImagesAmount
                    self.wirelessRequestImageName = "wirelessRequestImage_" + String(imageNumber)
//                    self.receiveAllDetailsVC?.updateWirelessTransactionImage()
                }
            }
        }
    }
    
    private func tryReceiveViaWireless() {
        if self.receiveAllDetailsVC!.option == .wireless {
            let reachability = BLEManager.shared.reachability
            if reachability == .notReachable {
                self.receiveAllDetailsVC?.presentBluetoothErrorAlert()
            } else if reachability == .reachable {
                if !BLEManager.shared.isAdvertising {
                    DataManager.shared.getAccount { (account, error) in
                        if account != nil {
                            let userID = account!.userID
                            let userCode = self.userCodeForUserID(userID: userID)
                            self.becomeReceiver(userID: userID, userCode: userCode)
                            self.shareUserCode(code: userCode)
                        }
                    }
                }
            }
        }
    }
    
    private func stopReceivingViaWireless() {
        if BLEManager.shared.isAdvertising {
            stopSharingUserCode()
        }
        cancelBecomeReceiver()
    }
    
    private func shareUserCode(code : String) {
        if !BLEManager.shared.isAdvertising {
            BLEManager.shared.advertise(userId: code)
        }
    }
    
    func userCodeForUserID(userID : String) -> String {
        var result = String()
        result = String(userID[..<userID.index(userID.startIndex, offsetBy: 8)])
        return result.uppercased()
    }
    
    private func stopSharingUserCode() {
        if BLEManager.shared.isAdvertising {
            BLEManager.shared.stopAdvertising()
        }
    }
    
    private func becomeReceiver(userID : String, userCode : String) {
        guard self.wallet != nil else {
            return
        }
        
        let blockchainType = BlockchainType.create(wallet: self.wallet!)
        let currencyID = self.wallet!.chain
        let networkID = blockchainType.net_type
        let address = self.wallet!.address
        let amount = cryptoSum != nil ? cryptoSum!.convertToSatoshiAmountString() : "0"
        
        DataManager.shared.socketManager.becomeReceiver(receiverID: userID, userCode: userCode, currencyID: currencyID.intValue, networkID: networkID, address: address, amount: amount)
    }
    
    private func cancelBecomeReceiver() {
        DataManager.shared.socketManager.stopReceive()
    }
    
    @objc private func didChangedBluetoothReachability(notification: Notification) {
        DispatchQueue.main.async {
            self.handleBluetoothReachability()
        }
    }
    
    @objc private func didUpdateTransaction(notification: Notification) {
        DispatchQueue.main.async {
            self.receiveAllDetailsVC?.presentDidReceivePaymentAlert()
        }
    }
}
