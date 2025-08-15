//
//  ProductDetail_VC.swift
//  Bazaar Ghar
//
//  Created by Umair ALi on 25/08/2023.
//

import UIKit
import Cosmos
import SocketIO
import SwiftyJSON
import AudioToolbox

class ProductDetail_VC: UIViewController {
    
    @IBOutlet weak var OrderWhatsapp_btn: UIButton!
    @IBOutlet weak var addtocart_btn: UIButton!
    @IBOutlet weak var chat_btn: UIButton!
    @IBOutlet weak var cart_btn: UIButton!
    @IBOutlet weak var store_btn: UIButton!
    @IBOutlet weak var DescriptionProduct: UILabel!
    @IBOutlet weak var productcount: UILabel!
    @IBOutlet weak var Sharebtn: UIButton!
    @IBOutlet weak var returnpolicybtn: UIButton!
    @IBOutlet weak var plusbtn: UIButton!
    @IBOutlet weak var Likebtn: UIButton!
    @IBOutlet weak var Minusbtn: UIButton!
    @IBOutlet weak var OnSaleimage: UIImageView!
    @IBOutlet weak var producttitle: UILabel!
    @IBOutlet weak var Salesprice: UILabel!
    @IBOutlet weak var Regularprice: UILabel!
    @IBOutlet weak var favouritebutton: UIButton!
    @IBOutlet weak var switchbutton: UISwitch!
    @IBOutlet weak var searchproductvc: UITextField!
    @IBOutlet weak var backbutton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ProductImgCollectionview: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var productPriceLine: UIView!
    @IBOutlet weak var varientsTblV: UITableView!
    @IBOutlet weak var percentLbl: UILabel!

    var SubCategorycollectionviewIndex = 0
    @IBOutlet weak var ratingView: CosmosView!
    
    @IBOutlet weak var scrollheight: NSLayoutConstraint!
    @IBOutlet weak var livelbl: UILabel!
    @IBOutlet weak var likeLbl: UILabel!
    @IBOutlet weak var shareLbl: UILabel!
    @IBOutlet weak var returnPolicyLbl: UILabel!
    @IBOutlet weak var chatLbl: UILabel!
    @IBOutlet weak var cartLbl: UILabel!
    @IBOutlet weak var storeLbl: UILabel!
    @IBOutlet weak var buyNowBtn: UIButton!
    @IBOutlet weak var addToCartLbl: UILabel!
    @IBOutlet weak var viaWhatsappLbl: UILabel!
    
    @IBOutlet weak var attributeView: UIView!
    @IBOutlet weak var relatedProductView: UIView!
    @IBOutlet weak var relatedVideoView: UIView!
    @IBOutlet weak var progressView: UIView!
    
    @IBOutlet weak var remaingDateLbl: UILabel!
    @IBOutlet weak var remainingProductLbl: UILabel!
    @IBOutlet weak var dealSoldLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    
    @IBOutlet weak var days: UILabel!
    @IBOutlet weak var hours: UILabel!
    @IBOutlet weak var minutes: UILabel!



    @IBOutlet weak var categoryproduct_collectionview: UICollectionView!
    @IBOutlet weak var videoCollection: UICollectionView!

    @IBOutlet weak var attributeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var stackHeight: NSLayoutConstraint!
    
    @IBOutlet weak var progressViews: UIProgressView!

    @IBOutlet weak var remainingdateview: UIView!
    @IBOutlet weak var dayslbl: UILabel!
    @IBOutlet weak var minslbl: UILabel!
    @IBOutlet weak var hrslbl: UILabel!
    @IBOutlet weak var timeleftlbl: UILabel!
    @IBOutlet weak var groupbuyremainingtimelbl: UILabel!
    @IBOutlet weak var dealssoldlbll: UILabel!
    @IBOutlet weak var remaininglbll: UILabel!
    @IBOutlet weak var releatedvideoslbl: UILabel!
    @IBOutlet weak var releatedproductslbl: UILabel!

    @IBOutlet weak var quantityView: UIView!
    @IBOutlet weak var outOfStockLbl: UILabel!
    
    

    
    var timer = Timer()
    var counter = 0 {
        didSet {
            let offsetX = CGFloat(self.counter) * self.ProductImgCollectionview.bounds.size.width
           self.ProductImgCollectionview.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
            self.pageControl.currentPage = self.counter
        }
    }
    var productCount = 1
    var incrementproductCount = 1
    var slugid: String?
    var isImageFav = false
    var productcategoriesdetailsdata : ProductCategoriesDetailsResponse?
    var orderDetails: CartItemsResponse?
    var getAllProductsByCategoriesData: [Product] = []
    var LiveStreamingResultsdata: [LiveStreamingResults] = []
    var groupbydealsdata: GroupByResult?


    var isGroupBuy = Bool()
    var isCome = Bool()
    var endDate = String()
    var remainingProduct = String()
    var minSubscription = String()
    var buyAbleProduct = String()
    var progressValue = Float()
    var mainImage = String()
    var manager:SocketManager?
    var socket: SocketIOClient?
    var messages: [PMsg]? = nil{
        didSet{
           
     
        }
    }
    var currentIndex = 0
    var varientSlug : String?
    var isnav = false
    var nav : UINavigationController? {
        didSet {
            isnav = true
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
//      self.connectSocket()

        ProductImgCollectionview.isScrollEnabled = false

        
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
             swipeLeft.direction = .left
                        self.ProductImgCollectionview.addGestureRecognizer(swipeLeft)
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
                swipeRight.direction = .right
                        self.ProductImgCollectionview.addGestureRecognizer(swipeRight)
        
        
        
        ratingView.settings.updateOnTouch = false
     
        favouritebutton.isSelected = false
        setupCollectionView()
        productcount.text = "\(productCount)"
        
        setupPageControl()
        scrollheight.constant = 700
        switchbutton.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        
//        DispatchQueue.main.async {
//              self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.autoSlideer), userInfo: nil, repeats: true)
//           }
//        
//        if let layout = ProductImgCollectionview.collectionViewLayout as? UICollectionViewFlowLayout {
//                   layout.scrollDirection = .horizontal
//                   layout.minimumLineSpacing = 0 // Set this to 0 if you want no space between cells
//               }
        
        
      
        
        
    
        
    }
    
//    @objc func autoSlideer() {
//        if counter < productcategoriesdetailsdata?.gallery?.count ?? 0 {
//            let index = IndexPath.init(item: counter, section: 0)
//            self.ProductImgCollectionview.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
//            pageControl.currentPage = counter
//            counter += 1
//        } else {
//            counter = 0
////            let index = IndexPath.init(item: counter, section: 0)
////            self.imageslidercollectionview.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
////            pageController.currentPage = counter
//        }
//    }
    
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        guard let galleryCount = productcategoriesdetailsdata?.gallery?.count else {
            return
        }
        
        switch gesture.direction {
        case .left:
            
            if counter < galleryCount - 1 {
                counter += 1
            }
            
        case .right:
            
            if counter == 0 {
                
            }else {
                counter -= 1
            }
        default:
            break
        }
 
    }
    //    @objc func Swipeleft(){
//
//      
////        let cout = productcategoriesdetailsdata?.gallery?.count ?? 0
////        if(self.SubCategorycollectionviewIndex == cout - 1){
////            
////        }else{
////            
////            SubCategorycollectionviewIndex += 1
////            self.ProductImgCollectionview.reloadData()
////            }
//    }
//           
//           @objc
//           func Swiperight(){
//              
////               if( SubCategorycollectionviewIndex == 0){
////                   
////                   
////               }else{
////                   SubCategorycollectionviewIndex -= 1
////                   self.ProductImgCollectionview.reloadData()
////                 
////               }
//           }
    
    @IBAction func switchChanged(_ sender: UISwitch) {
           if sender.isOn {
               AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
              
               let vc = LIVE_videoNew.getVC(.videoStoryBoard)
               self.navigationController?.pushViewController(vc, animated: false)
           }
       }
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            let vc = LIVE_videoNew.getVC(.videoStoryBoard)
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    func setupPageControl() {
        
        pageControl.numberOfPages = self.productcategoriesdetailsdata?.gallery?.count ?? 0

        pageControl.pageIndicatorTintColor = .systemGray4
        pageControl.currentPageIndicatorTintColor = .oceanBlue

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.LanguageRender()
        switchbutton.isOn = false
        setupCollectionViews()
        productcategoriesdetails(slug: slugid ?? "")
        if isGroupBuy == true {
            remainingdateview.isHidden = false // false
            days.text = "\(groupbydealsdata?.remainingTime?.days ?? 0)"
            hours.text = "\(groupbydealsdata?.remainingTime?.hours ?? 0)"
            minutes.text = "\(groupbydealsdata?.remainingTime?.minutes ?? 0)"
            progressView.isHidden = false // false
            stackHeight.constant = 140 // 140
            setProgressData()
        }else {
            remainingdateview.isHidden = true
            progressView.isHidden = true
            stackHeight.constant = 60
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotificationFromCartCell(notification:)), name: Notification.Name("variantSlug"), object: nil)
        
    }
    
    @objc func methodOfReceivedNotificationFromCartCell(notification: Notification) {
    if let slug = notification.userInfo?["variantSlug"] as? String {
            productcategoriesdetails(slug: slug)
                varientSlug = slug
            }
        

    }
    
    func setProgressData() {
        if let convertedDate = Utility().convertDateString(inputDateString: groupbydealsdata?.endDate ?? "") {
            print("Converted date: \(convertedDate)") // Nov/15/2023. 12:00 AM
            remaingDateLbl.text = "(\("groupbuytime".pLocalized(lang: LanguageManager.language))\( convertedDate))"
            
        } else {
            print("Failed to convert the date.")
        }
        remainingProductLbl.text = "\(groupbydealsdata?.remainingProduct ?? 0)"
        dealSoldLbl.text = "\(groupbydealsdata?.buyAbleProduct ?? 0 )"
        totalLbl.text = "\(groupbydealsdata?.minSubscription ?? 0)"
        progressViews.setProgress(Float(groupbydealsdata?.buyAbleProduct ?? 0) / Float(groupbydealsdata?.minSubscription ?? 0), animated: true)
    }
    
    
    func scrollToIndex(index:Int) {
         let rect = self.ProductImgCollectionview.layoutAttributesForItem(at:IndexPath(row: index, section: 0))?.frame
         self.ProductImgCollectionview.scrollRectToVisible(rect!, animated: true)
       
     }
    private func getStreamingVideos(limit:Int,page:Int,categories: [String]){
        APIServices.getStreamingVideos(limit:limit,page:page,categories:categories,userId:"", city: "",completion: {[weak self] data in
            switch data{
            case .success(let res):
               //

                self?.LiveStreamingResultsdata = res.results ?? []
                if res.results?.count ?? 0 > 0 {
                    self?.relatedVideoView.isHidden = false
                    if self?.isGroupBuy == true {
                        self?.scrollheight.constant = (self?.scrollheight.constant ?? 0) + 290
                    }else {
                        self?.scrollheight.constant = (self?.scrollheight.constant ?? 0) + 250
                    }

                }else {
                    self?.relatedVideoView.isHidden = true

                }

                self?.videoCollection.reloadData()
            case .failure(let error):
                print(error)
                self?.view.makeToast(error)
            }
        })
    }
    
    private func getAllProductsByCategories(limit:Int,page:Int,sortBy:String,category:String,active:Bool){
        APIServices.getAllProductsByCategories(limit:limit,page:page,sortBy:sortBy,category:category,active:active, user: ""){[weak self] data in
            switch data{
            case .success(let res):
                self?.getAllProductsByCategoriesData = res.Categoriesdata ?? []
                if res.Categoriesdata?.count ?? 0 > 0 {
                    self?.relatedProductView.isHidden = false
                    if self?.isGroupBuy == true {
                        self?.scrollheight.constant = (self?.scrollheight.constant ?? 0) + 320
                    }else {
                        self?.scrollheight.constant = (self?.scrollheight.constant ?? 0) + 280
                    }
                }else {
                    self?.relatedProductView.isHidden = true

                }
               
                self?.categoryproduct_collectionview.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setupCollectionViews() {
                let nib = UINib(nibName: "PRoductCategory_cell", bundle: nil)
                categoryproduct_collectionview.register(nib, forCellWithReuseIdentifier: "PRoductCategory_cell")
                categoryproduct_collectionview.delegate = self
                categoryproduct_collectionview.dataSource = self

            }
    
    func LanguageRender() {
        searchproductvc.placeholder = "searchproducts".pLocalized(lang: LanguageManager.language)
        livelbl.text = "live".pLocalized(lang: LanguageManager.language)
        likeLbl.text = "like".pLocalized(lang: LanguageManager.language)
        shareLbl.text = "share".pLocalized(lang: LanguageManager.language)
        cartLbl.text = "cart".pLocalized(lang: LanguageManager.language)
        returnPolicyLbl.text = "returnPolicy".pLocalized(lang: LanguageManager.language)
        chatLbl.text = "chat".pLocalized(lang: LanguageManager.language)
        storeLbl.text = "store".pLocalized(lang: LanguageManager.language)
        addToCartLbl.text = "addtocart".pLocalized(lang: LanguageManager.language)
        viaWhatsappLbl.text = "viawhatsapp".pLocalized(lang: LanguageManager.language)
        buyNowBtn.setTitle("buynow".pLocalized(lang: LanguageManager.language), for: .normal)
        dayslbl.text = "days".pLocalized(lang: LanguageManager.language)
        hrslbl.text = "hrs".pLocalized(lang: LanguageManager.language)
        minslbl.text = "mins".pLocalized(lang: LanguageManager.language)
        timeleftlbl.text = "timeleft".pLocalized(lang: LanguageManager.language)
        dealssoldlbll.text = "dealssold".pLocalized(lang: LanguageManager.language)
        remaininglbll.text = "remaining".pLocalized(lang: LanguageManager.language)
        releatedvideoslbl.text = "relatedvideos".pLocalized(lang: LanguageManager.language)
        releatedproductslbl.text = "relatedproducts".pLocalized(lang: LanguageManager.language)
  
     

        if LanguageManager.language == "ar" {
            backbutton.setImage(UIImage(systemName: "arrow.right"), for: .normal)
           }else{
               backbutton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
           }
        
    }
    
    func showShareSheet(id:String) {
        print(id)
        guard let url = URL(string: "\(AppConstants.API.baseURL)product/\(id)") else { return }

        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)

        // On iPad, provide a sourceView and sourceRect to display the share sheet as a popover
        if let popoverPresentationController = activityViewController.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
//            popoverPresentationController.sourceRect = sender.frame
        }

        // Present the share sheet
        present(activityViewController, animated: true, completion: nil)
    }

    
    private func addtowishlist(product: String){
        APIServices.addwishlist(proudct:product,completion: {[weak self] data in
            switch data{
            case .success(let res):
               //
                self?.Likebtn.isSelected = true
                self?.view.makeToast("Product added to wishlist successfully")
            case .failure(let error):
                print(error)
                self?.view.makeToast(error)
            }
        })
    }
    
    private func removeWishList(product: String){
        APIServices.removeWishList(product:product,completion: {[weak self] data in
            switch data{
            case .success(let res):
               //
                self?.Likebtn.isSelected = false
                self?.view.makeToast("Product removed from wishlist successfully")
               
            case .failure(let error):
                print(error)
                self?.view.makeToast(error)
            }
        })
    }
    
    private func productcategoriesdetails(slug:String){
        APIServices.productcategoriesdetails(slug: slug){[weak self] data in
            switch data{
            case .success(let res):
             //
                self?.wishlist()

                if res.quantity ?? 0 > 0 {
                    self?.quantityView.isHidden = false
                    self?.outOfStockLbl.isHidden = true
                    self?.buyNowBtn.isEnabled = true
                }else {
                    self?.quantityView.isHidden = true
                    self?.outOfStockLbl.isHidden = false
                    self?.buyNowBtn.isEnabled = false
                }
                
                if LanguageManager.language == "ar" && res.lang?.ar != nil{
                    self?.producttitle.text = res.lang?.ar?.productName
                }else{
                    self?.producttitle.text = res.productName
                }

//                self?.producttitle.text = res.productName
                
                if res.onSale == true {
                    self?.Salesprice.isHidden = false
                    self?.Salesprice.isHidden = false
                    self?.OnSaleimage.isHidden = false
                    self?.Salesprice.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(res.salePrice ?? 0, label: self?.Salesprice)
                    self?.productPriceLine.isHidden = false
                    self?.Regularprice.textColor = UIColor.red
                    self?.Salesprice.textColor = primaryColor!
                    self?.productPriceLine.backgroundColor = UIColor.red

                }else {
                    self?.Salesprice.isHidden = true
                    self?.OnSaleimage.isHidden = true
                    self?.productPriceLine.isHidden = true
                    self?.Regularprice.textColor = primaryColor!
                 }
                self?.ratingView.rating =    Double(res.ratings?.total ?? 0)
                
                self?.Regularprice.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(res.regularPrice ?? 0, label: self?.Regularprice)
                
                if res.regularPrice == nil || res.salePrice == nil {
                    
                }else {
                    let percentValue = (((res.regularPrice ?? 0) - (res.salePrice ?? 0)) * 100) / (res.regularPrice ?? 0)
                    self?.percentLbl.text = String(format: "%.0f%% OFF", percentValue)
                }

                if LanguageManager.language == "ar" && res.lang?.ar != nil{
                    if res.lang?.ar?.description?.isStringOrHTML() == "HTML"{
                        self?.DescriptionProduct.text = res.description?.htmlToString().withoutHtml
                    //            cell.subTitle.attributedText = product?.itemDescription?.convertHtmlToAttributedStringWithCSS(font: UIFont(name: "Montserrat-Regular", size: cell.subTitle.font.pointSize), csscolor: "2C3D73", lineheight: 0, csstextalign: "left")
                              }else{
                                  self?.DescriptionProduct.text = res.lang?.ar?.description
                              }
                }else{
                    if res.description?.isStringOrHTML() == "HTML"{
                        self?.DescriptionProduct.text = res.description?.htmlToString().withoutHtml
                    //            cell.subTitle.attributedText = product?.itemDescription?.convertHtmlToAttributedStringWithCSS(font: UIFont(name: "Montserrat-Regular", size: cell.subTitle.font.pointSize), csscolor: "2C3D73", lineheight: 0, csstextalign: "left")
                              }else{
                                  self?.DescriptionProduct.text = res.description
                              }
                    
                }

                
//                if res.description?.isStringOrHTML() == "HTML"{
//                    self?.DescriptionProduct.text = res.description?.htmlToString().withoutHtml
//                //            cell.subTitle.attributedText = product?.itemDescription?.convertHtmlToAttributedStringWithCSS(font: UIFont(name: "Montserrat-Regular", size: cell.subTitle.font.pointSize), csscolor: "2C3D73", lineheight: 0, csstextalign: "left")
//                          }else{
//                              self?.DescriptionProduct.text = res.description
//                          }
                
                self?.producttitle.sizeToFit()
                let label = UILabel(frame: CGRect.zero)
                
                
                if LanguageManager.language == "ar" && res.lang?.ar != nil{
                    label.text =  res.lang?.ar?.description ?? ""
                    if res.description?.isStringOrHTML() == "HTML"{
//                        self?.DescriptionProduct.text =  res.lang?.ar?.description     //res.lang?.ar?.description?.htmlToString().withoutHtml
                        let htmlString = res.lang?.ar?.description
                        let plainText = Utility().htmlToString(text: htmlString ?? "")
                        self?.DescriptionProduct.text = Utility().htmlToString(text: plainText)
                    //            cell.subTitle.attributedText = product?.itemDescription?.convertHtmlToAttributedStringWithCSS(font: UIFont(name: "Montserrat-Regular", size: cell.subTitle.font.pointSize), csscolor: "2C3D73", lineheight: 0, csstextalign: "left")
                              }else{
                                  self?.DescriptionProduct.text = res.lang?.ar?.description
                              }
                }else{
                    label.text =  res.description ?? ""
                    if res.description?.isStringOrHTML() == "HTML"{
                        self?.DescriptionProduct.text = res.description?.htmlToString().withoutHtml
                    //            cell.subTitle.attributedText = product?.itemDescription?.convertHtmlToAttributedStringWithCSS(font: UIFont(name: "Montserrat-Regular", size: cell.subTitle.font.pointSize), csscolor: "2C3D73", lineheight: 0, csstextalign: "left")
                              }else{
                                  self?.DescriptionProduct.text = res.description
                              }
                }
                
                
                
//                label.text =  res.description ?? ""
//                if res.description?.isStringOrHTML() == "HTML"{
//                    self?.DescriptionProduct.text = res.description?.htmlToString().withoutHtml
//                //            cell.subTitle.attributedText = product?.itemDescription?.convertHtmlToAttributedStringWithCSS(font: UIFont(name: "Montserrat-Regular", size: cell.subTitle.font.pointSize), csscolor: "2C3D73", lineheight: 0, csstextalign: "left")
//                          }else{
//                              self?.DescriptionProduct.text = res.description
//                          }
                guard let labelText = label.text else { return }
                let height = self?.estimatedHeightOfLabel(text: labelText)
               
                self?.productcategoriesdetailsdata = res
                
                if res.mainAttributes != nil {
                    if res.mainAttributes?.count ?? 0 > 0 {
                        self?.attributeView.isHidden = false
                        if res.mainAttributes?.count ?? 0 > 1 {
                            self?.attributeViewHeight.constant = CGFloat(50 * (res.mainAttributes?.count ?? 0))
                        }
                    }else {
                        self?.attributeView.isHidden = true

                    }
                        let cal = res.mainAttributes?.count ?? 0
                        let val = (cal * 70) + 580
                        
                    self?.scrollheight.constant = CGFloat(val) + ( self?.DescriptionProduct.bounds.height ?? 0.0) + ( self?.producttitle.bounds.height ?? 0.0)
                }else {
                    if res.attributes?.count ?? 0 > 0 {
                        self?.attributeView.isHidden = false
                        if res.attributes?.count ?? 0 > 1 {
                            self?.attributeViewHeight.constant = CGFloat(50 * (res.attributes?.count ?? 0))
                        }
                    }else {
                        self?.attributeView.isHidden = true

                    }
                        let cal = res.attributes?.count ?? 0
                        let val = (cal * 70) + 580
                        
                    self?.scrollheight.constant = CGFloat(val) + ( self?.DescriptionProduct.bounds.height ?? 0.0) + ( self?.producttitle.bounds.height ?? 0.0)
                }
                  

                self?.getAllProductsByCategories(limit: 20, page: 1, sortBy:"ACS", category:res.category ?? "", active: false)
                self?.getStreamingVideos(limit:30,page:1,categories: [res.category ?? ""])


                self?.setupPageControl()
           
                self?.ProductImgCollectionview.reloadData()
                self?.varientsTblV.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func wishlist(){
        APIServices.wishlist(isbackground: false, completion: {[weak self] data in
            switch data{
            case .success(let res):
                for i in res.products ?? []{
                    if(i.id == self?.productcategoriesdetailsdata?.id ?? ""){
                        self?.Likebtn.isSelected = true
                    }
                }
            case .failure(let error):
                print(error)
            }
        })
    }
    
    private func getCartProducts(){
        APIServices.getCartItems(background: true){[weak self] data in
            switch data{
            case .success(let res):
             
                AppDefault.cartId =  res.id
            
                AppDefault.currentUser?.defaultAddress = res.user?.defaultAddress
                self?.orderDetails = res
                
                
                let vc = OrderConfirmation_VC.getVC(.oldStoryboard)
                vc.orderDetails =  self?.orderDetails
                if self?.isnav == true{
                    self?.dismiss(animated: false)
                    self?.nav?.pushViewController(vc, animated: true)
                }
                self?.navigationController?.pushViewController(vc, animated: true)
//                    self?.bannerapidata = res.packages ?? []
//                if(self?.bannerapidata.count ?? 0 > 0){
//                    self?.emptyCart.isHidden = true
//                }else{
//                    self?.emptyCart.isHidden = false
//
//                }

//                self?.subTotal.text = Utility().convertAmountInComma("\(res.subTotal ?? 0)")
//                self?.total.text = Utility().convertAmountInComma("\(res.total ?? 0)")
//
//                self?.cartTableViewCell.reloadData()
            
            
            case .failure(let error):
                print(error)
//                self?.emptyCart.isHidden = false
                if(error == "Please authenticate" && AppDefault.islogin){
                        appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                 }else{
                        self?.view.makeToast(error)
                 }
            }
        }
    }

    func estimatedHeightOfLabel(text: String) -> CGFloat {

        let size = CGSize(width: view.frame.width - 16, height: 1000)

        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)

        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)]

        let rectangleHeight = String(text).boundingRect(with: size, options: options, attributes: attributes, context: nil).height

        return rectangleHeight
    }
    
    @IBAction func searchTapped(_ sender: Any) {
        
        let vc = Search_ViewController.getVC(.searchStoryBoard)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    @IBAction func shareBtn(_ sender: Any) {
        showShareSheet(id:productcategoriesdetailsdata?.slug ?? "")
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        if(isCome == true){
            self.dismiss(animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
       
    }
    
    @IBAction func addToCart(_ sender: Any) {
        
        addToCartApi(product:productcategoriesdetailsdata?.id ?? "",quantity:incrementproductCount,navigation: false)
        
    }
    @IBAction func buyNowBtnTapped(_ sender: Any) {
        
        addToCartApi(product:productcategoriesdetailsdata?.id ?? "",quantity:incrementproductCount,navigation: true)
        
    }
    
    private func addToCartApi(product: String, quantity: Int,navigation:Bool){
        APIServices.additemtocart(product:product,quantity:quantity,completion: {[weak self] data in
            switch data{
            case .success(let res):
                if(navigation){
                    self?.getCartProducts()
                  }
                self?.view.makeToast("Item Added to cart")
                
            case .failure(let error):
                
                if(error == "Please authenticate" && AppDefault.islogin){
                    DispatchQueue.main.async {
                        appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                          let vc = PopupLoginVc.getVC(.popups)
                        vc.modalPresentationStyle = .overFullScreen
                        self?.present(vc, animated: true, completion: nil)
                    }
                }else if(error == "Please authenticate" && AppDefault.islogin == false){
                      let vc = PopupLoginVc.getVC(.popups)
                    vc.modalPresentationStyle = .overFullScreen
                    self?.present(vc, animated: true, completion: nil)
//                    appDelegate.GotoDashBoard(ischecklogin: true)
                }
                else{
                    if self?.varientSlug != nil {
                        print(error)
                        self?.view.makeToast(error)
                    }else {
                        self?.view.makeToast("Please Select Varient")
                    }
                }
                
            }
        })
    }
    @IBAction func Addbtn(_ sender: Any) {
        if( productCount >= productcategoriesdetailsdata?.quantity ?? 0){
            self.view.makeToast("You can buy only \(productcategoriesdetailsdata?.quantity ?? 0) Products")
        }else if(productcategoriesdetailsdata?.quantity == 0){
            self.view.makeToast("Product is Out Of Stock")
        }else{
            productCount += 1
            incrementproductCount = productCount
            print(incrementproductCount)
            productcount.text = "\(productCount)"
        }
}
    @IBAction func wishlistBtn(_ sender: Any) {
        if let button = sender as? UIButton {
            if(AppDefault.islogin){
                if button.isSelected {
                    removeWishList(product:productcategoriesdetailsdata?.id ?? "" )
                   } else {
                       addtowishlist(product: productcategoriesdetailsdata?.id ?? "")
                    
                   }
            }  else {
                  let vc = PopupLoginVc.getVC(.popups)
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true, completion: nil)
//                    appDelegate.GotoDashBoard(ischecklogin: true)
            }
            
           
           }
        
     
        
    }
    @IBAction func SubtractBtn(_ sender: Any) {
        if productCount > 1 {
            productCount -= 1
            productcount.text = "\(productCount)"
        }
        
    }
    
    @IBAction func storeBtn(_ sender: Any) {
                let vc = New_StoreVC.getVC(.productStoryBoard)
                vc.prductid = productcategoriesdetailsdata?.sellerDetail?.seller ?? ""
//                vc.brandName = productcategoriesdetailsdata?.sellerDetail?.brandName ?? ""
                vc.gallaryImages = productcategoriesdetailsdata?.gallery
                vc.storeId = productcategoriesdetailsdata?.sellerDetail?.seller ?? ""

                self.navigationController?.pushViewController(vc, animated: false)


//        let vc = Category_ProductsVC.getVC(.productStoryBoard)
//        vc.prductid = productcategoriesdetailsdata?.sellerDetail?.seller ?? ""
//        vc.video_section = true
//        vc.storeFlag = true
//        vc.storeId = productcategoriesdetailsdata?.sellerDetail?.seller ?? ""
//        vc.catNameTitle = productcategoriesdetailsdata?.sellerDetail?.brandName ?? ""
//        vc.sellerDescription = productcategoriesdetailsdata?.description ?? ""
//        if self.isnav == true{
//            self.dismiss(animated: false)
//            self.nav?.pushViewController(vc, animated: true)
//        }
//        self.navigationController?.pushViewController(vc, animated: false)
        }
    @IBAction func cartBtn(_ sender: Any) {
        let vc = CartViewController.getVC(.main)
        if self.isnav == true{
            self.dismiss(animated: false)
            self.nav?.pushViewController(vc, animated: true)
        }
        self.navigationController?.pushViewController(vc, animated: false)
        }
    @IBAction func wishlistHeaderBtn(_ sender: Any) {
        let vc = wishlist_vc.getVC(.profileSubVIewStoryBoard)
        if self.isnav == true{
            self.dismiss(animated: false)
            self.nav?.pushViewController(vc, animated: true)
        }
        self.navigationController?.pushViewController(vc, animated: false)
        }
   
    @IBAction func chatBtnTappes(_ sender: Any) {
       var ispass = false
////        self.isrelaoddaataa = true
////        let data = messages?[0]
//        
////    customerId: userId,
////           brandName: activeRoom.seller.brandName,
////           storeId: activeRoom.seller.storeId,
////           sellerId: activeRoom.seller.sellerId,
////           isSeller: false,
//        
//        self.socket?.emit("room-join", ["brandName": productcategoriesdetailsdata?.sellerDetail?.brandName ?? "","customerId":AppDefault.currentUser?.id ?? "","isSeller":false,"sellerId": productcategoriesdetailsdata?.sellerDetail?.id ?? "","storeId": productcategoriesdetailsdata?.sellerDetail?.seller ?? ""])
//        self.socket?.on("room-join") { datas, ack in
//            if let rooms = datas[0] as? [String: Any]{
//                
//              
//                let obj = PuserMainModel(jsonData: JSON(rawValue: rooms)!)
//                
//                
//                print(obj)
//                if(ispass == false){
//                    let vc = ChatViewController.getVC(.main)
//                    vc.socket = self.socket
//                    vc.manager = self.manager
////                    vc.messages = data
//                    vc.latestMessages = obj.messages.chat
//                    vc.PuserMainArray = obj
//                    vc.newChat = true
//                    vc.NCroomId = rooms["roomId"] as? String
//                    vc.sellerDetail = self.productcategoriesdetailsdata?.sellerDetail
//                    self.navigationController?.pushViewController(vc, animated: true)
//                    ispass = true
//                }
//            }
//        }
         
    }
    
    @IBAction func whatsappShareText(_ sender: AnyObject) {
        let message = "First Whatsapp Share & https://www.google.co.in"
        var queryCharSet = NSCharacterSet.urlQueryAllowed
        
        queryCharSet.remove(charactersIn: "+&")
        
        if let escapedString = message.addingPercentEncoding(withAllowedCharacters: queryCharSet) {
            if let whatsappURL = URL(string: "whatsapp://send?phone=" + "923011166879" + "&text=") {
                if UIApplication.shared.canOpenURL(whatsappURL) {
                    UIApplication.shared.open(whatsappURL, options: [: ], completionHandler: nil)
                } else {
                    debugPrint("please install WhatsApp")
                    self.view.makeToast("whatsapp not available")
                }
            }
        }
        
    }
    func setupCollectionView() {
        let nib = UINib(nibName: "ProductsCollectionViewCell", bundle: nil)
        ProductImgCollectionview.register(nib, forCellWithReuseIdentifier: "cell2")
        ProductImgCollectionview.delegate = self
        ProductImgCollectionview.dataSource = self
    }

    
}

extension ProductDetail_VC: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryproduct_collectionview{
            return self.getAllProductsByCategoriesData.count

        } else if collectionView == videoCollection {
            return LiveStreamingResultsdata.count
        }else {
            if isGroupBuy == true {
                return productcategoriesdetailsdata?.gallery?.count ?? 0
            }else {
                if productcategoriesdetailsdata?.gallery == [] {
                    return 1
                }else {
                    return productcategoriesdetailsdata?.gallery?.count ?? 0

                }

            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryproduct_collectionview{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PRoductCategory_cell", for: indexPath) as! PRoductCategory_cell
            let data =  self.getAllProductsByCategoriesData[indexPath.row]
            cell.productimage.pLoadImage(url: data.mainImage ?? "")
            cell.productname.text = data.productName
            if data.onSale == true {
                cell.discountPrice.isHidden = false
                cell.discountPrice.text =   appDelegate.currencylabel + Utility().formatNumberWithCommas(data.salePrice ?? 0, label:     cell.discountPrice)
                
                cell.productPriceLine.isHidden = true
                cell.productPrice.textColor = UIColor.gray
                cell.productPriceLine.backgroundColor = UIColor.gray
            }else {
                cell.discountPrice.isHidden = true
                cell.productPriceLine.isHidden = true
                cell.productPrice.textColor = UIColor.black
            }
            cell.productPrice.attributedText = "\(appDelegate.currencylabel) \(Utility().formatNumberWithCommas(data.regularPrice ?? 0, label: cell.productPrice).trimmingCharacters(in: .whitespaces))".strikeThrough()
            
          
            
            return cell
        } else if collectionView == videoCollection {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Videoscategorycell1", for: indexPath) as! Videoscategorycell
            let data = LiveStreamingResultsdata[indexPath.row]
            cell.productimage.pLoadImage(url: data.thumbnail ?? "")
            cell.viewslbl.text = "\(data.totalViews ?? 0)"
            cell.Productname.text = data.brandName
            cell.likeslbl.text = "\(data.like ?? 0)"
                return cell
            
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as! ProductsCollectionViewCell

    //        let prevIndexPath = IndexPath(row: indexPath.row-1, section: indexPath.section)
    //        let previousCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: prevIndexPath)
    
            if isGroupBuy == true {
                let data = self.groupbydealsdata?.productID?.gallery?[indexPath.row]
                cell.imageView.pLoadImage(url: data ?? "")
            }else {
                if productcategoriesdetailsdata?.gallery == [] {
                    let data = productcategoriesdetailsdata?.mainImage
                    cell.imageView.pLoadImage(url: data ?? "")
                }else {
                    let data = productcategoriesdetailsdata?.gallery?[indexPath.row]
                    cell.imageView.pLoadImage(url: data ?? "")
                }

            }
//            counter = indexPath.row
            self.SubCategorycollectionviewIndex = indexPath.row
            self.scrollToIndex(index: self.SubCategorycollectionviewIndex)
            
            return cell
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryproduct_collectionview{
            let data =  self.getAllProductsByCategoriesData[indexPath.row]
           
            let vc = ProductDetail_VC.getVC(.oldStoryboard)
            vc.isGroupBuy = false
            vc.slugid = data.slug
            self.navigationController?.pushViewController(vc, animated: false)
        } else if collectionView == videoCollection {
            let data = LiveStreamingResultsdata[indexPath.row]
            let vc = New_SingleVideoview.getVC(.videoStoryBoard)
            vc.LiveStreamingResultsdata = self.LiveStreamingResultsdata
            vc.indexValue = indexPath.row
            vc.page = 2
            self.navigationController?.pushViewController(vc, animated: false)
            
        } else{
//            let vc = SingleVideoView.getVC(.main)
//            self.navigationController?.pushViewController(vc, animated: false)
            guard let cell = collectionView.cellForItem(at: indexPath) as? ProductsCollectionViewCell else {
                       return
                   }
                   
                   if let image = cell.imageView.image {
                       showImagePreview(image)
                   }
        }
    }
    
    func showImagePreview(_ image: UIImage) {
        // Create the image preview view controller
        let imagePreviewVC = UIViewController()
        
        // Create a semi-transparent background view
        let backgroundView = UIView(frame: imagePreviewVC.view.bounds)
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        imagePreviewVC.view.addSubview(backgroundView)
        
        // Create a container view to hold the image and allow it to be centered
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 400))
        containerView.center = imagePreviewVC.view.center
        containerView.backgroundColor = .clear
        imagePreviewVC.view.addSubview(containerView)
        
        // Create a scroll view to enable zooming
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 400))
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
        containerView.addSubview(scrollView)
        
        // Configure image view
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 400)
        scrollView.addSubview(imageView)
        
        // Set up zooming properties for the scroll view
        scrollView.contentSize = imageView.frame.size
        
        // Add double tap gesture recognizer for zooming
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapGesture(_:)))
            doubleTapGesture.numberOfTapsRequired = 2
            imageView.addGestureRecognizer(doubleTapGesture)
            imageView.isUserInteractionEnabled = true
        
        // Add cross button
        let closeButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(closeImagePreview))
        imagePreviewVC.navigationItem.rightBarButtonItem = closeButton
        imagePreviewVC.navigationItem.rightBarButtonItem?.tintColor = .white
        
        // Present image preview view controller
        let navController = UINavigationController(rootViewController: imagePreviewVC)
        navController.modalPresentationStyle = .overFullScreen
        present(navController, animated: true, completion: nil)
        
    }
    
    @objc func handleDoubleTapGesture(_ sender: UITapGestureRecognizer) {
        guard let scrollView = sender.view?.superview as? UIScrollView else { return }
        
        if scrollView.zoomScale == scrollView.minimumZoomScale {
            // Zoom in if the current zoom scale is minimum
            let center = sender.location(in: scrollView)
            let zoomRect = CGRect(x: center.x, y: center.y, width: 1, height: 1)
            scrollView.zoom(to: zoomRect, animated: true)
        } else {
            // Zoom out if the current zoom scale is not minimum
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        }
    }
    

       @objc func closeImagePreview() {
           dismiss(animated: true, completion: nil)
       }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == categoryproduct_collectionview{
            return  10
        }else {
            return  0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == categoryproduct_collectionview{
          return  0

        }else {
            return  0
        }    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryproduct_collectionview{
            return CGSize(width: self.categoryproduct_collectionview.frame.width/2.1, height: 230)

        } else if collectionView == videoCollection {
            return CGSize(width: collectionView.frame.size.width/2, height: collectionView.frame.size.height)
        }else if collectionView == ProductImgCollectionview {
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        } else {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == categoryproduct_collectionview{
          return  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }else {
            return  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        
//        
//        if pageControl.currentPage == (productcategoriesdetailsdata?.gallery?.count ?? 0) - 1 {
//            
////            self.reloadcollection()
//        }else {
//            let scrollPos = scrollView.contentOffset.x / view.frame.width
//            pageControl.currentPage = Int(scrollPos)
//            counter = pageControl.currentPage
//        }
//    }
    
    
}

extension ProductDetail_VC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if productcategoriesdetailsdata?.mainAttributes != nil {
            return  productcategoriesdetailsdata?.mainAttributes?.count ?? 0
        }else {
            return  productcategoriesdetailsdata?.attributes?.count ?? 0
        }
 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailVarientTableViewCell", for: indexPath) as! ProductDetailVarientTableViewCell
        if productcategoriesdetailsdata?.mainAttributes != nil {
            let data = productcategoriesdetailsdata?.mainAttributes
            let variantdata = productcategoriesdetailsdata?.variants
            cell.attributesLbl.text = (data?[indexPath.row].name ?? "") + " (\(data?[indexPath.row].values?.count ?? 0))"
            cell.index = indexPath.row
            cell.productcategoriesdetailsdata = data
            cell.productcategoriesdetailsvariantdata = variantdata
        }else {
            let data = productcategoriesdetailsdata?.attributes
            let variantdata = productcategoriesdetailsdata?.variants
            cell.attributesLbl.text = (data?[indexPath.row].name ?? "") + " (\(data?[indexPath.row].values?.count ?? 0))"
            cell.index = indexPath.row
            cell.productcategoriesdetailsdata = data
            cell.productcategoriesdetailsvariantdata = variantdata
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

   
}
extension ProductDetail_VC: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollView.subviews.first
    }
}

extension ProductDetail_VC{
    
    
    
     func connectSocket() {
        
         
         
       
         manager = SocketManager(socketURL: AppConstants.API.baseURLChat, config: [.log(true),
                                                                                   .compress,
                                                                                   .forceWebsockets(true),.connectParams( ["token":AppDefault.accessToken])])
         socket = manager?.socket(forNamespace: "/chat/v1/message")
 
        
         if((self.socket?.connect()) != nil){
             
         }else{
          
             socket?.connect()
         }
        
        
         socket?.on(clientEvent: .connect) { (data, ack) in
           
            
            
            
             print(self.socket?.status ?? "")
             print("socketid " + (self.socket?.sid ?? ""))
            print("Socket Connected")
            
        
            
            }
            
        
    
    
         
         socket?.on(clientEvent: .disconnect) { data, ack in
            // Handle the disconnection event
            print("Socket disconnected")
        }
        
        
      
    
       
    }
   
  
    
    
}
