//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class AddressViewController: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var qrImg: UIImageView!
    @IBOutlet weak var addressLbl: UILabel!
    
    var wallet: UserWalletRLM?
    
    var qrcodeImage: CIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.makeQRCode()
        self.addressLbl.text = self.wallet?.address
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func copyToClipboardAction(_ sender: Any) {
        UIPasteboard.general.string = self.wallet?.address
    }
    
    @IBAction func shareAction(_ sender: Any) {
        let message = "MULTY \n\nMy \(self.wallet?.cryptoName ?? "") Address: \n\(self.wallet?.address ?? "")"
        let objectsToShare = [message] as [String]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func makeStringForQRWithSumAndAdress(cryptoName: String) -> String { // cryptoName = bitcoin
        return "\(cryptoName):\(self.wallet?.address ?? "")"
    }
    
    func makeQRCode() {
        let data = self.wallet?.address.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
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
        let scaleX = qrImg.frame.size.width / qrcodeImage.extent.size.width
        let scaleY = qrImg.frame.size.height / qrcodeImage.extent.size.height
        let transformedImage = qrcodeImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        qrImg.image = self.convert(cmage: transformedImage)
    }
    
    func convert(cmage:CIImage) -> UIImage {
        let context:CIContext = CIContext.init(options: nil)
        let cgImage:CGImage = context.createCGImage(cmage, from: cmage.extent)!
        let image:UIImage = UIImage.init(cgImage: cgImage)
        return image
    }
}
