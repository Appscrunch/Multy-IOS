//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import ZFRippleButton
import Firebase

class CreateWalletViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constraintContinueBtnBottom: NSLayoutConstraint!
    @IBOutlet weak var createBtn: ZFRippleButton!
    
    var presenter = CreateWalletPresenter()
    var maxNameLength = 30
    let progressHUD = ProgressHUD(text: "Creating Wallet...")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        self.view.addSubview(progressHUD)
        progressHUD.hide()
        
        self.presenter.mainVC = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        Analytics.setUserProperty("open creating wallet", forName: "open_creating_wallet")
        Analytics.logEvent("open_creating_wallet", parameters: ["name": "name" as NSObject])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        (self.tabBarController as! CustomTabBarViewController).menuButton.isHidden = true
        (self.tabBarController as! CustomTabBarViewController).changeViewVisibility(isHidden: true)
    }
    
    @IBAction func cancleAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createAction(_ sender: Any) {
        progressHUD.show()
        presenter.createNewWallet { (dict) in
            print(dict)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.createBtn.applyGradient(withColours: [UIColor(ciColor: CIColor(red: 0/255, green: 178/255, blue: 255/255)),
                                                   UIColor(ciColor: CIColor(red: 0/255, green: 122/255, blue: 255/255))],
                                     gradientOrientation: .horizontal)
    }
}

extension CreateWalletViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath == [0,0] {
            let cell1 = self.tableView.dequeueReusableCell(withIdentifier: "cell1") as! CreateWalletNameTableViewCell
            cell1.walletNameTF.becomeFirstResponder()
            return cell1
        } else if indexPath == [0,1] {
            let cell2 = self.tableView.dequeueReusableCell(withIdentifier: "cell2")
            return cell2!
        } else {//if indexPath == [0,2] {
            let cell4 = self.tableView.dequeueReusableCell(withIdentifier: "cell4")
            return cell4!
            //        } else { //if indexPath == [0,3] {
            //            let cell3 = self.tableView.dequeueReusableCell(withIdentifier: "cell3")
            //            return cell3!

        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
    
    @objc func keyboardWillShow(_ notification : Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let inset : UIEdgeInsets = UIEdgeInsetsMake(64, 0, keyboardSize.height, 0)
            self.constraintContinueBtnBottom.constant = inset.bottom
            if screenHeight == 812 {
                self.constraintContinueBtnBottom.constant = inset.bottom - 35
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y != 0{
//                self.view.frame.origin.y += keyboardSize.height
//            }
            self.constraintContinueBtnBottom.constant = 0
//        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.dismissKeyboard()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField.text?.count)! + string.count < maxNameLength {
            return true
        } else {
            return false
        }
    }
    
}
