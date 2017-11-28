//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class WalletViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    
    var presenter = WalletPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
        
        presenter.mainVC = self
        
        presenter.fixConstraints()
        presenter.registerCells()
    }
    
    @IBAction func closeAction() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension WalletViewController : UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        
        if let headerCell = scrollView.superview?.superview as? MainWalletHeaderCell {
            headerCell.pageControl.currentPage = page
        }
    }
}

extension WalletViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath == [0, 0] {         // Main Wallet Header Cell
            let headerCell = self.tableView.dequeueReusableCell(withIdentifier: "MainWalletHeaderCellID") as! MainWalletHeaderCell
            headerCell.selectionStyle = .none
            headerCell.delegate = self
            
            return headerCell
        } else {                           //  Wallet Cell
            let walletCell = self.tableView.dequeueReusableCell(withIdentifier: "MainWalletCellID") as! MainWalletCell
            walletCell.selectionStyle = .none
            
            return walletCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == [0, 0] {
            
        } else {
            self.performSegue(withIdentifier: "transactionVC", sender: Any.self)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath == [0,0] ? 300 * (screenWidth / 375.0) : 80
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath == [0, 1] {
            (cell as! MainWalletCell).setCorners()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "transactionVC" {
            let vc = segue.destination as! TransactionViewController
            vc.isForReceive = false
        }
    }
}

extension WalletViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth, height: 210.0 * (screenWidth / 375.0))
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
