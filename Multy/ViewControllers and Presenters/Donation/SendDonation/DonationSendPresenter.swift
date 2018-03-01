//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class DonationSendPresenter: NSObject, CustomFeeRateProtocol, SendWalletProtocol {

    var mainVC: DonationSendViewController?
    
    var selectedIndexOfSpeed: Int?
    
    var customFee = UInt64(20)
    
    var walletPayFrom: UserWalletRLM?
    
    var maxAvailable = 0.0
    
    var donationAddress = ""
    
    var feeRate: NSDictionary? {
        didSet {
            mainVC?.tableView.reloadData()
        }
    }
    
    func customFeeData(firstValue: Double, secValue: Double) {
        print(firstValue)
        if selectedIndexOfSpeed != 5 {
            selectedIndexOfSpeed = 2
        }
        let cell = self.mainVC?.tableView.cellForRow(at: [0, selectedIndexOfSpeed!]) as! CustomTrasanctionFeeTableViewCell
        cell.value = firstValue
        cell.setupUIForBtc()
        self.customFee = UInt64(firstValue)
        self.mainVC?.tableView.reloadData()
        self.mainVC?.makeSendAvailable(isAvailable: true)
//        sendDetailsVC?.sendAnalyticsEvent(screenName: "\(screenTransactionFeeWithChain)\(transactionDTO.choosenWallet!.chain)", eventName: customFeeSetuped)
    }
    
    func getWallets() {
        self.mainVC?.view.isUserInteractionEnabled = false
        DataManager.shared.realmManager.fetchAllWallets { (wallets) in
            self.mainVC?.view.isUserInteractionEnabled = true
            let walletsArr = Array(wallets!.sorted(by: {$0.sumInCrypto > $1.sumInCrypto}))
            self.walletPayFrom = walletsArr.first
            self.maxAvailable = (self.walletPayFrom?.sumInCrypto)!
            self.mainVC?.updateUIWithWallet()
        }
    }
    
    func sendWallet(wallet: UserWalletRLM) {
        self.walletPayFrom = wallet
        self.mainVC?.updateUIWithWallet()
    }
    
    func makeFiatDonat() {
        let cryptoDonat = self.mainVC?.donationTF.text //string
        let cryptoDonatWithDot = cryptoDonat?.replacingOccurrences(of: ",", with: ".") as NSString?
        let fiatDonat = (cryptoDonatWithDot!.doubleValue) * exchangeCourse
        
        self.mainVC?.fiatDonationLbl.text = "\(fiatDonat.fixedFraction(digits: 2)) USD"
    }
    
    func makeTransaction() {
        let transaction = TransactionDTO()
        transaction.choosenWallet = self.walletPayFrom
        transaction.sendAddress = donationAddress
        transaction.sendAmount = self.mainVC?.donationTF.text?.convertStringWithCommaToDouble()
        transaction.transaction?.customFee = self.customFee
        
        DataManager.shared.createDonationTransaction(transactionDTO: transaction) { (answer, err) in
            self.mainVC?.progressHud.hide()
            self.mainVC?.view.isUserInteractionEnabled = true
            if err != nil {
                let alert = UIAlertController(title: "Error", message: err.debugDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.mainVC?.present(alert, animated: true, completion: nil)
                return
            }
            
            let storyboard = UIStoryboard(name: "Send", bundle: nil)
            let sendSuccessVC = storyboard.instantiateViewController(withIdentifier: "SuccessSendVC") as! SendingAnimationViewController
            sendSuccessVC.chainId = transaction.choosenWallet?.chain as? Int
            self.mainVC?.navigationController?.pushViewController(sendSuccessVC, animated: true)
        }
    }
}
