//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class PortfolioTableViewCell: UITableViewCell, UIScrollViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var mainVC: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        let portfolioCollectionCell = UINib.init(nibName: "PortfolioCollectionViewCell", bundle: nil)
        self.collectionView.register(portfolioCollectionCell, forCellWithReuseIdentifier: "portfolioCollectionCell")
        
        let donationCell = UINib.init(nibName: "DonationCollectionViewCell", bundle: nil)
        self.collectionView.register(donationCell, forCellWithReuseIdentifier: "donatCell")
        pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControlEvents.valueChanged)

    }
    
    @objc func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * collectionView.frame.size.width
        collectionView.setContentOffset(CGPoint(x: x,y :0), animated: true)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupPageControl() {
        
    }
    
}


extension PortfolioTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let colCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "portfolioCollectionCell", for: indexPath) as! PortfolioCollectionViewCell
//        colCell.makeCornerRadius()
//        return colCell
        let donatCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "donatCell", for: indexPath) as! DonationCollectionViewCell
        donatCell.makeCellBy(index: indexPath.row)
        return donatCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
//        case 0: break
//        case 1: break
        default:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let donatAlert = storyboard.instantiateViewController(withIdentifier: "donationAlert") as! DonationAlertViewController
            donatAlert.modalPresentationStyle = .overCurrentContext
            donatAlert.cancelDelegate = self.mainVC as! AssetsViewController
            self.mainVC?.present(donatAlert, animated: true, completion: nil)
            (self.mainVC?.tabBarController as! CustomTabBarViewController).changeViewVisibility(isHidden: true)
        }
    }
    
    
}

