//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class MainWalletHeaderCell: UITableViewCell, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var pageControll: UIPageControl!
    
    var mainVC: UIViewController?
    
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
//    @IBOutlet weak var pageControll: SMPageControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        let headerCollectionCell = UINib.init(nibName: "MainWalletCollectionViewCell", bundle: nil)
        self.collectionView.register(headerCollectionCell, forCellWithReuseIdentifier: "MainWalletCollectionViewCellID")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupPageControl() {
//        self.pageControll.numberOfPages = 2
        
    }
    
    func setupUI() {
        if wallet != nil {
//            self.pageControll.numberOfPages = (self.wallet?.addresses.count)!
        }
    }
}

extension MainWalletHeaderCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return (self.wallet?.addresses.count)!
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "MainWalletCollectionViewCellID", for: indexPath) as! MainWalletCollectionViewCell
        cell.mainVC = self.mainVC
        cell.wallet = self.wallet
        cell.fillInCell()
        
        return cell
    }
}
