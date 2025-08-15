import UIKit
import CoreImage

class HomeLastProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var discountPrice: UILabel!
    @IBOutlet weak var productimage: UIImageView!
    @IBOutlet weak var productname: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var Offbanner: UILabel!
    @IBOutlet weak var productPriceLine: UIView!
    @IBOutlet weak var percentBGView: UIView!
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var heartBtn: UIButton!
    
     var imageDownloadTask: URLSessionDataTask?
    
    var product: Product! {
        didSet {
            // Reset image views before loading new data
            backgroundImage.image = nil
            productimage.image = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Delay for 1 second
                self.productimage.pLoadImage(url: self.product.mainImage ?? "")
                // Optionally apply a blur effect or other changes here
                self.blurEffect() // Uncomment if you want to blur the image
            }
            // Load background image (you can replace this with SDWebImage if available)
            
            
            // Product name localization
            if LanguageManager.language == "ar", let arName = product?.lang?.ar?.productName {
                self.productname.text = arName
            } else {
                self.productname.text = product?.productName
            }

            // Discount calculation
            if let regular = product.regularPrice, let sale = product.price {
                let percentValue = ((regular - sale) * 100) / regular
                let formatted = LanguageManager.language == "ar"
                    ? "خصم % \(Utility().convertToArabicNumerals(percentValue))"
                    : String(format: "%.0f%% Off", percentValue)
                self.Offbanner.text = formatted
            } else {
                self.Offbanner.text = nil
            }
        }
    }

    var idarray: [Product]? {
        didSet {
            heartBtn.isSelected = (idarray?.first?.id == product?.id)
        }
    }
    deinit {
        print("Cell deallocated: \(self)")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        percentBGView.backgroundColor = UIColor(named: "greenColor")
        Offbanner.textColor = .black
        cartButton.tintColor = UIColor(named: "greenColor")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        

        
    
        productimage.image = nil
        productname.text = nil
        productPrice.text = nil
        discountPrice.text = nil
        Offbanner.text = nil
        heartBtn.isSelected = false
    }

    // Optional blur effect (avoid reprocessing the same image each scroll)
    func blurEffect() {
        guard let image = backgroundImage.image,
              let beginImage = CIImage(image: image) else { return }

        let context = CIContext(options: nil)
        guard let blurFilter = CIFilter(name: "CIGaussianBlur") else { return }

        blurFilter.setValue(beginImage, forKey: kCIInputImageKey)
        blurFilter.setValue(10, forKey: kCIInputRadiusKey)

        guard let blurredImage = blurFilter.outputImage else { return }

        let cropped = blurredImage.cropped(to: beginImage.extent)
        guard let cgimg = context.createCGImage(cropped, from: cropped.extent) else { return }

        let processedImage = UIImage(cgImage: cgimg, scale: image.scale, orientation: image.imageOrientation)
        backgroundImage.image = processedImage
    }
}

