//
//  SendPresenter.swift
//  Multy
//
//  Created by Artyom Alekseev on 15.05.2018.
//  Copyright © 2018 Idealnaya rabota. All rights reserved.
//

import UIKit
import RealmSwift

class SendPresenter: NSObject {
    var sendVC : SendViewController?
    
    var walletsArr = Array<UserWalletRLM>() {
        didSet {
            filterArray()
        }
    }
    
    var filteredWalletArray = Array<UserWalletRLM>() {
        didSet {
            if filteredWalletArray.count == 0 {
                selectedWalletIndex = nil
            } else {
                selectedWalletIndex = 0
            }
            
            sendVC?.updateUI()
        }
    }
    
    var selectedWalletIndex : Int? {
        didSet {
            if selectedWalletIndex != oldValue {
                self.createTransactionDTO()
                
                self.sendVC?.updateUI()
            }
        }
    }
    
    var activeRequestsArr = [PaymentRequest]() {
        didSet {
            if activeRequestsArr.count == 0 {
                selectedActiveRequestIndex = nil
            }
        }
    }
    
    var selectedActiveRequestIndex : Int? {
        didSet {
            filterArray()
            
            if selectedActiveRequestIndex != oldValue {
                self.createTransactionDTO()
                
                self.sendVC?.updateUI()
            }
        }
    }
    
    var isSendingAvailable : Bool {
        get {
            var result = false
            if selectedActiveRequestIndex != nil && selectedWalletIndex != nil {
//                let activeRequest = activeRequestsArr[selectedActiveRequestIndex!]
//                let wallet = walletsArr[selectedWalletIndex!]
                //FIXME:
                result = true
//                if wallet.sumInCrypto >= activeRequest.sendAmount.doubleValue {
//                    result = true
//                }
            }
            return result
        }
    }
    
    
    var newUserCodes = [String]()
    
    var transaction : TransactionDTO?
    
    var receiveActiveRequestTimer = Timer()
    
    var blockActivityUpdating = false
    
    func filterArray() {
        if selectedActiveRequestIndex != nil  {
            let request = activeRequestsArr[selectedActiveRequestIndex!]
            //FIXEME: add all blockchains
            let sendAmount = request.sendAmount.stringWithDot.convertCryptoAmountStringToMinimalUnits(in: BLOCKCHAIN_BITCOIN)
            let address = request.sendAddress
            
            if request.satisfied {
                filteredWalletArray = Array<UserWalletRLM>()
            } else {
                filteredWalletArray = walletsArr.filter{ DataManager.shared.isAddressValid(address: address, for: $0).isValid && $0.availableAmount > sendAmount }
            }
        } else {
            filteredWalletArray = walletsArr
        }
    }
    
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
        getWallets()
        
        blockActivityUpdating = false
        startSenderActivity()
        handleBluetoothReachability()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didDiscoverNewAd(notification:)), name: Notification.Name(didDiscoverNewAdvertisementNotificationName), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didChangedBluetoothReachability(notification:)), name: Notification.Name(bluetoothReachabilityChangedNotificationName), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveNewRequests(notification:)), name: Notification.Name("newReceiver"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveSendResponse(notification:)), name: Notification.Name("sendResponse"), object: nil)
        
    }
    
    func viewControllerViewWillDisappear() {
        viewWillDisappear()
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIApplicationWillTerminate, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    func viewWillDisappear() {
        stopSenderActivity()
        blockActivityUpdating = true
        
        self.selectedWalletIndex = nil
        NotificationCenter.default.removeObserver(self, name: Notification.Name(didDiscoverNewAdvertisementNotificationName), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(bluetoothReachabilityChangedNotificationName), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("newReceiver"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("sendResponse"), object: nil)
    }
    
    func numberOfWallets() -> Int {
        return filteredWalletArray.count
    }
    
    func numberOfActiveRequests() -> Int {
        return activeRequestsArr.count
    }
    
    func getWallets() {
        DataManager.shared.getAccount { [unowned self] (acc, err) in
            if err == nil {
                // MARK: check this
                if acc != nil && acc!.wallets.count > 0 {
                    
                    self.walletsArr = acc!.wallets.sorted(by: { $0.availableSumInCrypto > $1.availableSumInCrypto })
                }
            }
        }
    }
    
    func getWalletsVerbose(completion: @escaping (_ flag: Bool) -> ()) {
        DataManager.shared.getWalletsVerbose() { (walletsArrayFromApi, err) in
            if err != nil {
                return
            } else {
                let walletsArr = UserWalletRLM.initWithArray(walletsInfo: walletsArrayFromApi!)
                print("afterVerbose:rawdata: \(walletsArrayFromApi)")
                DataManager.shared.realmManager.updateWalletsInAcc(arrOfWallets: walletsArr, completion: { (acc, err) in
                    self.account = acc
                    
                    if acc != nil && acc!.wallets.count > 0 {
                        self.selectedWalletIndex = 0
                        
                        self.walletsArr = acc!.wallets.sorted(by: { $0.availableSumInCrypto > $1.availableSumInCrypto })
                    }
                    
                    print("wallets: \(acc?.wallets)")
                    completion(true)
                })
            }
        }
    }
    
    
    private func createTransactionDTO() {
        if isSendingAvailable && selectedWalletIndex != nil && filteredWalletArray.count > selectedWalletIndex!  {
            transaction = TransactionDTO()
            let request = activeRequestsArr[selectedActiveRequestIndex!]
            //FIXME:
            transaction!.sendAmount = request.sendAmount.doubleValue
            transaction!.sendAddress = request.sendAddress
            transaction!.choosenWallet = filteredWalletArray[selectedWalletIndex!]
            sendVC?.fillTransaction()
        }
    }
    
    
    @objc private func didDiscoverNewAd(notification: Notification) {
        DispatchQueue.main.async {
            let newAdOriginID = notification.userInfo!["originID"] as! UUID
            if BLEManager.shared.receivedAds != nil {
                var newAd : Advertisement?
                for ad in BLEManager.shared.receivedAds! {
                    if ad.originID == newAdOriginID {
                        newAd = ad
                        print("Discovered new usercode \(ad.userCode)")
                        break
                    }
                }
                
                if newAd != nil {
                    self.newUserCodes.append(newAd!.userCode)
                }
            }
        }
    }
    
    func becomeSenderForUsersWithCodes(_ userCodes : [String]) {
        let uniqueUserCodes = Array(Set(userCodes))
        DataManager.shared.socketManager.becomeSender(nearIDs: uniqueUserCodes)
    }
    
    func startSenderActivity() {
        startSearchingActiveRequests()
    }
    
    func stopSenderActivity() {
        DataManager.shared.socketManager.stopSend()
        self.stopSearching()
        cleanRequests()
    }
        
    func handleBluetoothReachability() {
        switch BLEManager.shared.reachability {
        case .reachable, .unknown:
            if BLEManager.shared.reachability == .reachable {
                self.sendVC?.updateUIForBluetoothState(true)
                if !blockActivityUpdating {
                    startSenderActivity()
                }
            }
            
            break
            
        case .notReachable:
            self.sendVC?.updateUIForBluetoothState(false)
            if !blockActivityUpdating {
                stopSenderActivity()
            }
            break
        }
    }
    
    func addActivePaymentRequests(requests: [PaymentRequest]) {
        activeRequestsArr.append(contentsOf: requests)
        if numberOfActiveRequests() > 0 && selectedActiveRequestIndex == nil {
            selectedActiveRequestIndex = 0
        }
    }
    
    var addressData : Dictionary<String, Any>?
    var binaryData : BinaryData?
    var account = DataManager.shared.realmManager.account
    
    func createPreliminaryData() {
        let account = DataManager.shared.realmManager.account
        let core = DataManager.shared.coreLibManager
        let wallet = filteredWalletArray[selectedWalletIndex!]
        binaryData = account!.binaryDataString.createBinaryData()!
        
        
        
        addressData = core.createAddress(blockchain:    wallet.blockchainType,
                                         walletID:      wallet.walletID.uint32Value,
                                         addressID:     wallet.changeAddressIndex,
                                         binaryData:    &binaryData!)
    }
    
    func send() {
//        self.getWalletsVerbose(completion: { (success) in
//            self.activeRequestsArr[self.selectedActiveRequestIndex!].satisfied = true
//            self.sendVC?.updateUIWithSendResponse(success: true)
//        })
        
        createPreliminaryData()
        let request = activeRequestsArr[selectedActiveRequestIndex!]
        let wallet = filteredWalletArray[selectedWalletIndex!]
        let trData = DataManager.shared.coreLibManager.createTransaction(addressPointer: addressData!["addressPointer"] as! UnsafeMutablePointer<OpaquePointer?>,
                                                                         sendAddress: request.sendAddress,
                                                                         sendAmountString: request.sendAmount,
                                                                         feePerByteAmount: "10",
            isDonationExists: false,
            donationAmount: "0",
            isPayCommission: true,
            wallet: wallet,
            binaryData: &binaryData!,
            inputs: wallet.addresses)

        let newAddressParams = [
            "walletindex"   : wallet.walletID.intValue,
            "address"       : addressData!["address"] as! String,
            "addressindex"  : wallet.addresses.count,
            "transaction"   : trData.0,
            "ishd"          : NSNumber(booleanLiteral: wallet.shouldCreateNewAddressAfterTransaction)
            ] as [String : Any]

        let params = [
            "currencyid": wallet.chain,
            "networkid" : wallet.chainType,
            "payload"   : newAddressParams
            ] as [String : Any]

        DataManager.shared.sendHDTransaction(transactionParameters: params, completion: { (dict, error) in
            print("\(dict), \(error)")
            
            if error != nil {
                self.sendVC?.updateUIWithSendResponse(success: false)
            } else {
                self.getWalletsVerbose(completion: { (success) in
                    self.activeRequestsArr[self.selectedActiveRequestIndex!].satisfied = true
                    self.sendVC?.updateUIWithSendResponse(success: true)
                })
            }
        })
    }
    
    func cleanRequests() {
        self.activeRequestsArr.removeAll()
        self.selectedActiveRequestIndex = nil
    }
    
    func sendAnimationComplete() {
        filterArray()
        sendVC?.updateUI()
    }
    
    @objc private func didChangedBluetoothReachability(notification: Notification) {
        DispatchQueue.main.async {
            self.handleBluetoothReachability()
        }
    }
    
    @objc private func didReceiveNewRequests(notification: Notification) {
        DispatchQueue.main.async {
            let requests = notification.userInfo!["paymentRequests"] as! [PaymentRequest]
            
            var filteredRequestArray = requests.filter{BigInt($0.sendAmount.convertCryptoAmountStringToMinimalUnits(in: BLOCKCHAIN_BITCOIN).stringValue) > Int64(0)}
            
            var newRequests = [PaymentRequest]()
            while filteredRequestArray.count > 0 {
                let request = filteredRequestArray.first!
                
                var isRequestOld = false
                for oldRequest in self.activeRequestsArr {
                    if oldRequest.userCode == request.userCode {
                        let index = self.activeRequestsArr.index(of: oldRequest)
                        if self.activeRequestsArr[index!].sendAmount != request.sendAmount {
                            self.activeRequestsArr[index!] = request
                        }
                        
                        isRequestOld = true
                        break
                    }
                }
                
                if !isRequestOld {
                    newRequests.append(request)
                }
                
                filteredRequestArray.removeFirst()
            }
            
            if newRequests.count > 0 {
                self.addActivePaymentRequests(requests: newRequests)
            }
            
            self.sendVC?.updateUI()
        }
    }
    
    @objc private func didReceiveSendResponse(notification: Notification) {
        DispatchQueue.main.async {
            let success = notification.userInfo!["data"] as! Bool
            
            if success {
                self.activeRequestsArr[self.selectedActiveRequestIndex!].satisfied = true
            }
            
            self.sendVC?.updateUIWithSendResponse(success: success)
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
    
    func indexForActiveRequst(_ request : PaymentRequest) -> Int? {
        for req in activeRequestsArr {
            if req.userCode == request.userCode {
                return activeRequestsArr.index(of: req)!
            }
        }
        return nil
    }
    
    func startSearchingActiveRequests() {
        BLEManager.shared.startScan()
        receiveActiveRequestTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkNewUserCodes), userInfo: nil, repeats: true)
    }
    
    func stopSearching() {
        BLEManager.shared.stopScan()
        receiveActiveRequestTimer.invalidate()
    }
    
    @objc func checkNewUserCodes() {
//        let request = PaymentRequest.init(sendAddress: "mrQ5gJvzeGZ7bjtXycfJGdAo9BUNtgQVL9", userCode: "41234123", currencyID: 0, sendAmount: "0,001", networkID : 1, userID : "ffwqefqewfdsf")
//
//        activeRequestsArr.append(request)
//        if numberOfActiveRequests() == 1 {
//            selectedActiveRequestIndex = 0
//        }
//
//        sendVC?.updateUI()
        
        if newUserCodes.count > 0 {
            becomeSenderForUsersWithCodes(newUserCodes)
            newUserCodes.removeAll()
        }
    }
    
    func randomRequestAddress() -> String {
        var result = "0x"
        result.append(randomString(length: 34))
        return result
    }
    
    func randomString(length:Int) -> String {
        let charSet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var c = charSet.characters.map { String($0) }
        var s:String = ""
        for _ in (1...length) {
            s.append(c[Int(arc4random()) % c.count])
        }
        return s
    }
    
    func randomAmount() -> Double {
        return Double(arc4random())/Double(UInt32.max)
    }
    
    func randomCurrencyID() -> NSNumber {
        return NSNumber.init(value: 0)
    }
    
    func randomColor() -> UIColor {
        return UIColor(red:   CGFloat(arc4random()) / CGFloat(UInt32.max),
                       green: CGFloat(arc4random()) / CGFloat(UInt32.max),
                       blue:  CGFloat(arc4random()) / CGFloat(UInt32.max),
                       alpha: 1.0)
    }
}

extension SendPresenter: QrDataProtocol {
    func qrData(string: String) {
        let storyboard = UIStoryboard(name: "Send", bundle: nil)
        let sendStartVC = storyboard.instantiateViewController(withIdentifier: "sendStart") as! SendStartViewController
        sendStartVC.presenter.transactionDTO.update(from: string)
        
        sendVC!.navigationController?.pushViewController(sendStartVC, animated: true)
    }
}
