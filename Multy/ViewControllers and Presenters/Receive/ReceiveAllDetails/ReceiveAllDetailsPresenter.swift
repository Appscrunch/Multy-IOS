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
    
    var blockWirelessActivityUpdating = false
    
    func viewControllerViewDidLoad() {
        let _ = BLEManager.shared
    }
    
    func viewControllerViewWillAppear() {
        viewWillAppear()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillResignActive(notification:)), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillTerminate(notification:)), name: Notification.Name.UIApplicationWillTerminate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationDidBecomeActive(notification:)), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    func viewWillAppear() {
        receiveAllDetailsVC?.updateSearchingAnimation()
        blockWirelessActivityUpdating = false
        startWirelessReceiverActivity()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didChangedBluetoothReachability(notification:)), name: Notification.Name(bluetoothReachabilityChangedNotificationName), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didUpdateTransaction(notification:)), name: Notification.Name("transactionUpdated"), object: nil)
    }
    
    func viewControllerViewWillDisappear() {
        viewWillDisappear()
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIApplicationWillTerminate, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    func viewWillDisappear() {
        stopWirelessReceiverActivity()
        blockWirelessActivityUpdating = true
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name(bluetoothReachabilityChangedNotificationName), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("transactionUpdated"), object: nil)
    }
    
    func cancelViewController() {
        if self.receiveAllDetailsVC!.option == .wireless {
            stopWirelessReceiverActivity()
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
            startWirelessReceiverActivity()
        }
    }
    
    func sendWallet(wallet: UserWalletRLM) {
        self.wallet = wallet
        self.receiveAllDetailsVC?.updateUIWithWallet()
        
        if self.receiveAllDetailsVC!.option == .wireless {
            startWirelessReceiverActivity()
        }
    }
    
    func didChangeReceivingOption() {
        switch self.receiveAllDetailsVC!.option {
        case .qrCode:
            stopWirelessReceiverActivity()
            break
            
        case .wireless:
            if wirelessRequestImageName == nil {
                generateWirelessRequestImage()
            }
            
            startWirelessReceiverActivity()
            break
        }
    }
    
    private func handleBluetoothReachability() {
        if self.receiveAllDetailsVC?.option == .wireless {
            let reachability = BLEManager.shared.reachability
            
            if reachability == .notReachable {
                self.receiveAllDetailsVC?.presentBluetoothErrorAlert()
            } else if reachability == .reachable {
                if !blockWirelessActivityUpdating {
                    startWirelessReceiverActivity()
                }
            }
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
    
    private func startWirelessReceiverActivity() {
        if self.receiveAllDetailsVC!.option == .wireless {
            let reachability = BLEManager.shared.reachability
            if reachability == .reachable {
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
    
    private func stopWirelessReceiverActivity() {
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
    
    @objc private func applicationWillResignActive(notification: Notification) {
        viewWillDisappear()
    }
    
    @objc private func applicationWillTerminate(notification: Notification) {
        viewWillDisappear()
    }
    
    @objc private func applicationDidBecomeActive(notification: Notification) {
        viewWillAppear()
    }
}
