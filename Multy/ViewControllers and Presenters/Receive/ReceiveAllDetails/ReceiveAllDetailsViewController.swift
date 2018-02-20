//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import Branch

class ReceiveAllDetailsViewController: UIViewController, AnalyticsProtocol {

    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var qrImage: UIImageView!
    @IBOutlet weak var addressLbl: UILabel!
    
    @IBOutlet weak var requestSumBtn: UIButton! // hide title when sum was requested
    @IBOutlet weak var sumValueLbl: UILabel!
    @IBOutlet weak var cryptoNameLbl: UILabel!
    @IBOutlet weak var fiatSumLbl: UILabel!
    @IBOutlet weak var fiatNameLbl: UILabel!
    
    @IBOutlet weak var walletNameLbl: UILabel!
    @IBOutlet weak var walletCryptoSumBtn: UIButton! //set title with sum here
    @IBOutlet weak var walletFiatSumLbl: UILabel!
    @IBOutlet weak var constraintForSum: NSLayoutConstraint!
    
    let presenter = ReceiveAllDetailsPresenter()
    
//    var testWallet = "3DA28WCp4Cu5LQiddJnDJJmKWvmmZAKP5K"
//    var testWallet = "bitcoin:3DA28WCp4Cu5LQiddJnDJJmKWvmmZAKP5K?amount=0.005"
    var qrcodeImage: CIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.receiveAllDetailsVC = self
        self.tabBarController?.tabBar.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        sendAnalyticsEvent(screenName: "\(screenReceiveSummaryWithChain)\(presenter.wallet!.chain)", eventName: "\(screenReceiveSummaryWithChain)\(presenter.wallet!.chain)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.checkValuesAndSetupUI()
        self.updateUIWithWallet()
        self.makeQRCode()
        self.ipadFix()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
        self.navigationController?.popToRootViewController(animated: false)
        sendAnalyticsEvent(screenName: "\(screenReceiveSummaryWithChain)\(presenter.wallet!.chain)", eventName: closeTap)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        sendAnalyticsEvent(screenName: "\(screenReceiveSummaryWithChain)\(presenter.wallet!.chain)", eventName: closeTap)
    }
    
    @IBAction func qrTapAction(_ sender: Any) {
        sendAnalyticsEvent(screenName: "\(screenReceiveSummaryWithChain)\(presenter.wallet!.chain)", eventName: qrTap)
    }
    
    @IBAction func requestSumAction(_ sender: Any) {
        self.performSegue(withIdentifier: "receiveAmount", sender: UIButton.self)
        sendAnalyticsEvent(screenName: "\(screenReceiveSummaryWithChain)\(presenter.wallet!.chain)", eventName: requestSumTap)
    }
    
    @IBAction func addressAction(_ sender: Any) {
        sendAnalyticsEvent(screenName: "\(screenReceiveSummaryWithChain)\(presenter.wallet!.chain)", eventName: addressTap)
    }
    
    @IBAction func wirelessScanAction(_ sender: Any) {
        sendAnalyticsEvent(screenName: "\(screenReceiveSummaryWithChain)\(presenter.wallet!.chain)", eventName: wirelessScanTap)
    }
    
    @IBAction func addressBookAction(_ sender: Any) {
        sendAnalyticsEvent(screenName: "\(screenReceiveSummaryWithChain)\(presenter.wallet!.chain)", eventName: addressBookTap)
    }
    
    func branchDict() -> NSDictionary {
        //check for blockchain
        //if bitcoin - address: "\(chainName):\(presenter.walletAddress)"
        let chainName = "bitcoin"
        let dict: NSDictionary = ["$og_title" : "Multy",
                                  "address"   : "\(chainName):\(presenter.walletAddress)",
                                  "amount"    : presenter.cryptoSum?.fixedFraction(digits: 8) ?? "0.0"]
        
        return dict
    }
    
    
    @IBAction func moreOptionsAction(_ sender: Any) {
        let branch = Branch.getInstance()
        branch?.getShortURL(withParams: branchDict() as! [String : Any], andChannel: "Create option \"Multy\"", andFeature: "sharing", andCallback: { (url, err) in
            let objectsToShare = [url] as! [String]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            activityVC.completionWithItemsHandler = {(activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
                if !completed {
                    // User canceled
                    return
                } else {
                    if let appName = activityType?.rawValue {
                        self.sendAnalyticsEvent(screenName: "\(screenReceiveSummaryWithChain)\(self.presenter.wallet!.chain)", eventName: "\(shareToAppWithChainTap)\(self.presenter.wallet!.chain)_\(appName)")
                    }
                }
            }
            self.present(activityVC, animated: true, completion: nil)
        })
        sendAnalyticsEvent(screenName: "\(screenReceiveSummaryWithChain)\(presenter.wallet!.chain)", eventName: moreOptionsTap)
        
//        let linkProperties: BranchLinkProperties = BranchLinkProperties()
//        linkProperties.feature = "sharing"
////        linkProperties.addControlParam("$desktop_url", withValue: "http://onliner.by/")
////        linkProperties.addControlParam("$ios_url", withValue: "multy://")
//        linkProperties.addControlParam("address", withValue: self.presenter.walletAddress)
//
//
//        let branchUniversalObject: BranchUniversalObject = BranchUniversalObject(canonicalIdentifier: "item/12345")
//        branchUniversalObject.title = "My Content Title"
//        branchUniversalObject.getShortUrl(with: linkProperties) { (url, error) in
//            let objectsToShare = [url] as! [String]
//            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
//            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
//            self.present(activityVC, animated: true, completion: nil)
//        }
        
//        let message = "MULTY \n\nYour Address: \n\(self.presenter.walletAddress) \n\nRequested Amount: \(self.presenter.cryptoSum ?? 0.0) \(self.presenter.cryptoName ?? "")"
//        let objectsToShare = [message] as [String]
//        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
//        activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
//        self.present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func chooseAnotherWalletAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Receive", bundle: nil)
        let walletsVC = storyboard.instantiateViewController(withIdentifier: "ReceiveStart") as! ReceiveStartViewController
        walletsVC.presenter.isNeedToPop = true
        walletsVC.sendWalletDelegate = self.presenter
        self.navigationController?.pushViewController(walletsVC, animated: true)
        sendAnalyticsEvent(screenName: "\(screenReceiveSummaryWithChain)\(presenter.wallet!.chain)", eventName: changeWalletTap)
    }
    
    
    func updateUIWithWallet() {
        self.walletNameLbl.text = self.presenter.wallet?.name
        self.walletCryptoSumBtn.setTitle("\((self.presenter.wallet?.sumInCrypto ?? 0.0).fixedFraction(digits: 8)) \(self.presenter.wallet?.cryptoName ?? "")", for: .normal)
        let sum = (presenter.wallet!.sumInCrypto * exchangeCourse).fixedFraction(digits: 2)
        self.walletFiatSumLbl.text = "\(sum) \(self.presenter.wallet?.fiatSymbol ?? "")"
        self.presenter.walletAddress = (self.presenter.wallet?.address)!
        self.addressLbl.text = self.presenter.walletAddress
    }
    
    
    func makeStringForQRWithSumAndAdress(cryptoName: String) -> String { // cryptoName = bitcoin
        return "\(cryptoName):\(self.presenter.walletAddress)?amount=\((self.presenter.cryptoSum ?? 0.0).fixedFraction(digits: 8))"
    }
    
// MARK: QRCode Activity
    func makeQRCode() {
        let data = self.makeStringForQRWithSumAndAdress(cryptoName: "bitcoin").data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue("Q", forKey: "inputCorrectionLevel")
        
        qrcodeImage = filter?.outputImage
        displayQRCodeImage()
    }
    
    func makeQrWithSum() {
        let walletData = self.makeStringForQRWithSumAndAdress(cryptoName: "bitcoin").data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(walletData, forKey: "inputMessage")
        filter?.setValue("Q", forKey: "inputCorrectionLevel")
        
        qrcodeImage = filter?.outputImage
        displayQRCodeImage()
    }
    
    func displayQRCodeImage() {
        let scaleX = qrImage.frame.size.width / qrcodeImage.extent.size.width
        let scaleY = qrImage.frame.size.height / qrcodeImage.extent.size.height
        let transformedImage = qrcodeImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        qrImage.image = self.convert(cmage: transformedImage)
    }
    
    func convert(cmage:CIImage) -> UIImage {
        let context:CIContext = CIContext.init(options: nil)
        let cgImage:CGImage = context.createCGImage(cmage, from: cmage.extent)!
        let image:UIImage = UIImage.init(cgImage: cgImage)
        return image
    }
    //
    
    func setupUIWithAmounts() {
        self.requestSumBtn.titleLabel?.isHidden = true
        self.sumValueLbl.isHidden = false
        self.cryptoNameLbl.isHidden = false
        self.fiatSumLbl.isHidden = false
        self.fiatNameLbl.isHidden = false
        
        self.sumValueLbl.text = "\((self.presenter.cryptoSum ?? 0.0).fixedFraction(digits: 8))"
        self.cryptoNameLbl.text = self.presenter.cryptoName
        self.fiatSumLbl.text = "\((self.presenter.fiatSum ?? 0.0).fixedFraction(digits: 2))"
        self.fiatNameLbl.text = self.presenter.fiatName
        
        self.makeQrWithSum()
    }
    
    func checkValuesAndSetupUI() {
        if self.presenter.cryptoSum != nil {
            self.requestSumBtn.titleLabel?.isHidden = true
            self.requestSumBtn.setTitleColor(.white, for: .selected)
            self.requestSumBtn.setTitleColor(.white, for: .normal)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "receiveAmount" {
            let destVC = segue.destination as! ReceiveAmountViewController
            destVC.delegate = self.presenter
            if self.presenter.cryptoSum != nil {
                destVC.sumInCrypto = self.presenter.cryptoSum!
                destVC.cryptoName = self.presenter.cryptoName!
                destVC.fiatName = self.presenter.fiatName!
                destVC.sumInFiat = self.presenter.fiatSum!
            }
        }
    }
    
    func ipadFix() {
        if screenHeight == heightOfiPad {
            self.sumValueLbl.font = sumValueLbl.font.withSize(30)
            self.cryptoNameLbl.font = cryptoNameLbl.font.withSize(30)
        }
    }
}
