//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class PortfolioTableViewCell: UITableViewCell, UIScrollViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var mainVC: UIViewController?
    
    weak var delegate : UICollectionViewDelegate? {
        didSet {
            self.collectionView.delegate = delegate
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        let portfolioCollectionCell = UINib.init(nibName: "PortfolioCollectionViewCell", bundle: nil)
        self.collectionView.register(portfolioCollectionCell, forCellWithReuseIdentifier: "portfolioCollectionCell")
        
        let donationCell = UINib.init(nibName: "DonationCollectionViewCell", bundle: nil)
        self.collectionView.register(donationCell, forCellWithReuseIdentifier: "donatCell")
        pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControlEvents.valueChanged)
    }
    
    @objc fileprivate func changePage(sender: AnyObject) -> () {
        var x = CGFloat(0)
        
        switch pageControl.currentPage {
        case 1:
            x = screenWidth - 30
        default:
            x = 0
        }
        
        collectionView.setContentOffset(CGPoint(x: x,y :0), animated: true)
    }
    
    func changePageControl(currentPage: Int) {
        self.pageControl.currentPage = currentPage
        self.pageControl.updateCurrentPageDisplay()
    }
}

extension PortfolioTableViewCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let donatCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "donatCell", for: indexPath) as! DonationCollectionViewCell
        donatCell.makeCellBy(index: indexPath.row)
        
        return donatCell
    }
}

