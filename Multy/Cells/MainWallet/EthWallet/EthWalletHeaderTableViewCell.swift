//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class EthWalletHeaderTableViewCell: UITableViewCell, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var pageControll: UIPageControl!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    var mainVC: UIViewController?
    
    var blockedAmount = UInt64()
    
    var wallet: UserWalletRLM? {
        didSet {
            self.setupUI()
        }
    }
    
    weak var delegate : UICollectionViewDelegate? {
        didSet {
            self.collectionView.delegate = delegate
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        let collectionHeaderCell = UINib.init(nibName: "EthWalletHeaderCollectionViewCell", bundle: nil)
        self.collectionView.register(collectionHeaderCell, forCellWithReuseIdentifier: "ethCollectionWalletCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI() {
        self.bottomView.roundCorners(corners: [.topLeft, .topRight], radius: 20)
        if screenHeight == heightOfX {
            self.topConstraint.constant = 40
        }
    }
    
    @IBAction func closeAction(_ sender: Any) {
        (self.mainVC as! WalletViewController).closeAction()
    }
    
    @IBAction func settingsAction(_ sender: Any) {
        (self.mainVC as! WalletViewController).settingssAction(Any.self)
    }
    
}


extension EthWalletHeaderTableViewCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        return (self.wallet?.addresses.count)!
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "ethCollectionWalletCell", for: indexPath) as! EthWalletHeaderCollectionViewCell
//        cell.mainVC = self.mainVC
//        cell.wallet = self.wallet
//        cell.blockedAmount = self.blockedAmount
//        cell.fillInCell()
        
        return cell
    }
    
    
    
    func updateUI() {
        self.collectionView.reloadData()
    }
}
