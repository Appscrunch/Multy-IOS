//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class ReceiveAllDetailsViewController: UIViewController {

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
    
    
    let presenter = ReceiveAllDetailsPresenter()
    
//    var testWallet = "3DA28WCp4Cu5LQiddJnDJJmKWvmmZAKP5K"
//    var testWallet = "bitcoin:3DA28WCp4Cu5LQiddJnDJJmKWvmmZAKP5K?amount=0.005"
    var qrcodeImage: CIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.receiveAllDetailsVC = self
        self.makeQRCode()
        self.tabBarController?.tabBar.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.checkValuesAndSetupUI()
        self.updateUIWithWallet()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func requestSumAction(_ sender: Any) {
        self.performSegue(withIdentifier: "receiveAmount", sender: UIButton.self)
    }
    
    @IBAction func wirelessScanAction(_ sender: Any) {
    }
    
    @IBAction func addressBookAction(_ sender: Any) {
    }
    
    @IBAction func moreOptionsAction(_ sender: Any) {
        let message = "MULTY \n\nYour Address: \n\(self.presenter.walletAddress) \n\nReqsted Amount: \(self.presenter.cryptoSum ?? 0.0) \(self.presenter.cryptoName ?? "")"
        let objectsToShare = [message] as [String]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func chooseAnotherWalletAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Receive", bundle: nil)
        let walletsVC = storyboard.instantiateViewController(withIdentifier: "ReceiveStart") as! ReceiveStartViewController
        walletsVC.presenter.isNeedToPop = true
        walletsVC.sendWalletDelegate = self.presenter
        self.navigationController?.pushViewController(walletsVC, animated: true)
    }
    
    
    func updateUIWithWallet() {
        self.walletNameLbl.text = self.presenter.wallet?.name
        self.walletCryptoSumBtn.setTitle("\(self.presenter.wallet?.sumInCrypto ?? 0.0) \(self.presenter.wallet?.cryptoName ?? "")", for: .normal)
        self.walletFiatSumLbl.text = "\(self.presenter.wallet?.sumInFiat ?? 0.0) \(self.presenter.wallet?.fiatSymbol ?? "")"
        self.presenter.walletAddress = (self.presenter.wallet?.address)!
        self.addressLbl.text = self.presenter.walletAddress
    }
    
    
    func makeStringForQRWithSumAndAdress(cryptoName: String) -> String { // cryptoName = bitcoin
        return "\(cryptoName):\(self.presenter.walletAddress)?amount=\(self.presenter.cryptoSum ?? 0.0)"
    }
    
// MARK: QRCode Activity
    func makeQRCode() {
        let data = self.presenter.walletAddress.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
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
        
        self.sumValueLbl.text = "\(self.presenter.cryptoSum ?? 0.0)"
        self.cryptoNameLbl.text = self.presenter.cryptoName
        self.fiatSumLbl.text = "\(self.presenter.fiatSum ?? 0.0)"
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
}
