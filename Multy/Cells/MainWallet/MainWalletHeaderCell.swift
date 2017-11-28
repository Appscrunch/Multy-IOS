//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class MainWalletHeaderCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate : UICollectionViewDelegate?
//    @IBOutlet weak var pageControll: SMPageControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        let headerCollectionCell = UINib.init(nibName: "MainWalletCollectionViewCell", bundle: nil)
        self.collectionView.register(headerCollectionCell, forCellWithReuseIdentifier: "MainWalletCollectionViewCellID")
        
        self.collectionView.delegate = delegate
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupPageControl() {
//        self.pageControll.numberOfPages = 2
        
    }
}

extension MainWalletHeaderCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "MainWalletCollectionViewCellID", for: indexPath) as! MainWalletCollectionViewCell

        return cell
    }
}
