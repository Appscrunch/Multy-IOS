//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class PortfolioTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        let portfolioCollectionCell = UINib.init(nibName: "PortfolioCollectionViewCell", bundle: nil)
        self.collectionView.register(portfolioCollectionCell, forCellWithReuseIdentifier: "portfolioCollectionCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}


extension PortfolioTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let colCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "portfolioCollectionCell", for: indexPath) as! PortfolioCollectionViewCell
        colCell.makeCornerRadius()
        return colCell
    }
    
    
}

