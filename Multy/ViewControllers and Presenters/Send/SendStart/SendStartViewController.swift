//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import ZFRippleButton

class SendStartViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextBtn: ZFRippleButton!
    
    let presenter = SendStartPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.sendStartVC = self
        self.registerCells()
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        self.nextBtn.backgroundColor = UIColor(red: 209/255, green: 209/255, blue: 214/255, alpha: 1.0)
    }
    
    func registerCells() {
        let searchAddressCell = UINib(nibName: "SearchAddressTableViewCell", bundle: nil)
        self.tableView.register(searchAddressCell, forCellReuseIdentifier: "searchAddressCell")
        
        let oneLabelCell = UINib(nibName: "NewWalletTableViewCell", bundle: nil)
        self.tableView.register(oneLabelCell, forCellReuseIdentifier: "oneLabelCell")
        
        let recentCell = UINib(nibName: "RecentAddressTableViewCell", bundle: nil)
        self.tableView.register(recentCell, forCellReuseIdentifier: "recentCell")
    }
    
    @IBAction func nextAction(_ sender: Any) {
        self.performSegue(withIdentifier: "chooseWalletVC", sender: sender)
    }
    
    func makeAvailableNextBtn() {
        self.nextBtn.isEnabled = true
        self.nextBtn.applyGradient(withColours: [UIColor(ciColor: CIColor(red: 0/255, green: 178/255, blue: 255/255)),
                                                 UIColor(ciColor: CIColor(red: 0/255, green: 122/255, blue: 255/255))],
                                   gradientOrientation: .horizontal)
    }
    
}

extension SendStartViewController:  UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath == [0, 0] {
            let searchAddressCell = self.tableView.dequeueReusableCell(withIdentifier: "searchAddressCell") as! SearchAddressTableViewCell
            searchAddressCell.cancelDelegate = self.presenter
            searchAddressCell.sendAddressDelegate = self.presenter
            return searchAddressCell
        } else if indexPath == [0, 1] {
            let oneLabelCell = self.tableView.dequeueReusableCell(withIdentifier: "oneLabelCell") as! NewWalletTableViewCell
            oneLabelCell.setupForSendStartVC()
            return oneLabelCell
        } else {
            let recentCell = self.tableView.dequeueReusableCell(withIdentifier: "recentCell") as! RecentAddressTableViewCell
            return recentCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == [0, 0] {
            return 305
        } else { //if indexPath == [0, 1] {
            return 60
        }
    }
}
