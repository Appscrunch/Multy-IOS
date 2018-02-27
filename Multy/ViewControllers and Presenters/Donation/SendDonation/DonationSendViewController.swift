//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class DonationSendViewController: UIViewController, AnalyticsProtocol {

    @IBOutlet weak var tableView: UITableView!
    
    
    let presenter = DonationSendPresenter()
    var isCustom = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.mainVC = self
        self.registerCells()
        
        tableView.layer.shadowColor = UIColor.gray.cgColor
        tableView.layer.shadowOpacity = 1
        tableView.layer.shadowOffset = .zero
        tableView.layer.shadowRadius = 10
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func registerCells() {
        let transactionCell = UINib(nibName: "TransactionFeeTableViewCell", bundle: nil)
        self.tableView.register(transactionCell, forCellReuseIdentifier: "transactionCell")
        
        let customFeeCell = UINib(nibName: "CustomTrasanctionFeeTableViewCell", bundle: nil)
        self.tableView.register(customFeeCell, forCellReuseIdentifier: "customFeeCell")
    }

}

extension DonationSendViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row != 2 {
            let transactionCell = self.tableView.dequeueReusableCell(withIdentifier: "transactionCell") as! TransactionFeeTableViewCell
            transactionCell.feeRate = self.presenter.feeRate
            if indexPath.row == 0 {
                transactionCell.makeCellBy(indexPath: [0, 3])
            } else { //indexPath.row = 1
                transactionCell.makeCellBy(indexPath: [0, 2])
            }
            
            return transactionCell
        } else {
            let customFeeCell = self.tableView.dequeueReusableCell(withIdentifier: "customFeeCell") as! CustomTrasanctionFeeTableViewCell
            
            return customFeeCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        switch indexPath.row {
//        case 0:
//            sendAnalyticsEvent(screenName: "\(screenTransactionFeeWithChain)\(self.presenter.transactionDTO.choosenWallet!.chain)", eventName: veryFastTap)
//        case 1:
//            sendAnalyticsEvent(screenName: "\(screenTransactionFeeWithChain)\(self.presenter.transactionDTO.choosenWallet!.chain)", eventName: fastTap)
//        case 2:
//            sendAnalyticsEvent(screenName: "\(screenTransactionFeeWithChain)\(self.presenter.transactionDTO.choosenWallet!.chain)", eventName: mediumTap)
//        case 3:
//            sendAnalyticsEvent(screenName: "\(screenTransactionFeeWithChain)\(self.presenter.transactionDTO.choosenWallet!.chain)", eventName: slowTap)
//        case 4:
//            sendAnalyticsEvent(screenName: "\(screenTransactionFeeWithChain)\(self.presenter.transactionDTO.choosenWallet!.chain)", eventName: verySlowTap)
//        case 5:
//            sendAnalyticsEvent(screenName: "\(screenTransactionFeeWithChain)\(self.presenter.transactionDTO.choosenWallet!.chain)", eventName: customTap)
//        default : break
//        }
        
        if indexPath.row != 2 {
            if self.isCustom {
                let customCell = self.tableView.cellForRow(at: [0,2]) as! CustomTrasanctionFeeTableViewCell
                customCell.reloadUI()
            }
            var cells = self.tableView.visibleCells
            cells.removeLast()
            let trueCells = cells as! [TransactionFeeTableViewCell]
            if trueCells[indexPath.row].checkMarkImage.isHidden == false {
                trueCells[indexPath.row].checkMarkImage.isHidden = true
                self.presenter.selectedIndexOfSpeed = nil
                
                return
            }
            for cell in trueCells {
                cell.checkMarkImage.isHidden = true
            }
            trueCells[indexPath.row].checkMarkImage.isHidden = false
            self.presenter.selectedIndexOfSpeed = indexPath.row
        } else {
            self.isCustom = true
            let storyboard = UIStoryboard(name: "Send", bundle: nil)
            let customVC = storyboard.instantiateViewController(withIdentifier: "customVC") as! CustomFeeViewController
//            customVC.presenter.chainId = self.presenter.transactionDTO.choosenWallet!.chain
            customVC.delegate = self.presenter
            customVC.rate = Int(self.presenter.customFee)
            self.presenter.selectedIndexOfSpeed = indexPath.row
            self.navigationController?.pushViewController(customVC, animated: true)
            
            var cells = self.tableView.visibleCells
            cells.removeLast()
            let trueCells = cells as! [TransactionFeeTableViewCell]
            for cell in trueCells {
                cell.checkMarkImage.isHidden = true
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
