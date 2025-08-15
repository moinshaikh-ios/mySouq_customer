//
//  New_StoreVC.swift
//  Bazaar Ghar
//
//  Created by Zany on 02/07/2024.
//

import UIKit
import FSPagerView
import SocketIO
import SwiftyJSON

class New_StoreVC: UIViewController {
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var headerBackgroudView: UIView!
    @IBOutlet weak var videosLabel: UILabel!
    @IBOutlet weak var pagerView: FSPagerView!
     @IBOutlet weak var pageControl: FSPageControl!
    @IBOutlet weak var videoCollection: UICollectionView!
    @IBOutlet weak var HeaderbrandNameLbl: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var brandNameLbl: UILabel!
    var productcategoriesdetailsdata : getSellerDetailDataModel?
    @IBOutlet weak var categoryproduct_collectionview: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var storeproductquantity: UILabel!
    @IBOutlet weak var shopbycategorieslbl: UILabel!
    @IBOutlet weak var shopbycat_collectionview: UICollectionView!
    @IBOutlet weak var latestproductlbl: UILabel!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var shopByCatView: UIView!
    @IBOutlet weak var productEmptyLbl: UILabel!
    @IBOutlet weak var latestProductHeight: NSLayoutConstraint!
    @IBOutlet weak var cartCount: UILabel!
    @IBOutlet weak var cartCountView: UIView!

    
    var cartCountShow: String? {
        didSet {
            if Int(cartCountShow ?? "0") ?? 0 > 0 {
                self.cartCountView.isHidden = false
            }
            self.cartCount.text = cartCountShow
        }
    }

    var messages: [PMsg]? = nil{
        didSet{
           
     
        }
    }
    var counter =  0

    var LiveStreamingResultsdata: [LiveStreamingResults] = []
    var latestProductModel: [PChat] = []
    let centerTransitioningDelegate = CenterTransitioningDelegate()
    var prductid:String?
    var brandName:String?
    var gallaryImages:[String]?
    var isFollow = false
    var storeId = String()
    var productCount:String?
    var getAllProductsByCategoriesData: [Product] = []
    var categoryPage = 1
    var isLoadingNextPage = false
    var isEndReached = false
    var manager:SocketManager?
    var socket: SocketIOClient?
    var sellerID:String? {
        didSet {
            getSellerDetail(id: sellerID ?? "")
        }
    }
    var CategoriesResponsedata: [CategoriesResponse] = []
    var catId:String? {
        didSet {
           categoriesApi(isbackground: false, id: catId ?? "")
        }
    }
    var catIds:[String]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        headerBackgroudView.backgroundColor = UIColor(named: "headercolor")
       
        HeaderbrandNameLbl.text = brandName ?? ""
       
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        pagerView.automaticSlidingInterval = 2.0
        pagerView.clipsToBounds = true
        followcheck(storeId: self.storeId)
        update(count: 1)
        let attributedText =  Utility().attributedStringWithColoredLastWord("Shop By Categories", lastWordColor: UIColor(named: "headercolor")!, otherWordsColor: UIColor(hexString: blackColor))
                shopbycategorieslbl.attributedText = attributedText
        shopbycategorieslbl.text = "shopbycategories".pLocalized(lang: LanguageManager.language)

        
        let attributedText1 =  Utility().attributedStringWithColoredLastWord("Latest Products", lastWordColor: UIColor(named: "headercolor")!, otherWordsColor: UIColor(hexString: blackColor))
        latestproductlbl.attributedText = attributedText1
        
            latestproductlbl.text = "latestproducts".pLocalized(lang: LanguageManager.language)

      
        
        shopbycat_collectionview.dataSource = self
        shopbycat_collectionview.delegate = self
        getStreamingVideos(userId: self.prductid ?? "", limit: 30, page: 1, categories:catIds ?? [])
        CategoriesResponsedata.removeAll()
    }
    func setupCollectionView() {
        let nib = UINib(nibName: "HomeLastProductCollectionViewCell", bundle: nil)
        categoryproduct_collectionview.register(nib, forCellWithReuseIdentifier: "HomeLastProductCollectionViewCell")
        categoryproduct_collectionview.delegate = self
        categoryproduct_collectionview.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        cartCountShow = AppDefault.cartCount
        if(AppDefault.islogin){
            self.connectSocket()
            if AppDefault.wishlistproduct != nil{
                wishList(isbackground: true)
            }else{
                wishList(isbackground: false)
            }
        }
    }
    

    override func viewDidAppear(_ animated: Bool) {
     
    }
    func update(count:Int) {
        getAllProductsByCategories(limit: 20, page: count, sortBy:"-price", category:prductid ?? "", active: false)
    }
    
    private func getSellerDetail(id:String){
        APIServices.getSellerDetail(id:id,completion: {[weak self] data in
            switch data{
            case .success(let res):
           //
                self?.brandName = res.brandName ?? ""
                if(LanguageManager.language == "ar"){
                    if(res.lang != nil){
                        self?.brandNameLbl.text  = res.lang?.ar?.brandName ?? ""
                        self?.HeaderbrandNameLbl.text  = res.lang?.ar?.brandName ?? ""
                        self?.brandNameLbl.textAlignment  = .right
                    }else{
                        self?.brandNameLbl.text  = res.brandName ?? ""
                        self?.HeaderbrandNameLbl.text  = res.brandName ?? ""
                        self?.brandNameLbl.textAlignment  = .right
                    }
                   
//                    self?.HeaderbrandNameLbl.textAlignment  = .right
                }else{
                    self?.brandNameLbl.text  = res.brandName ?? ""
                    self?.HeaderbrandNameLbl.text  = res.brandName ?? ""
                    self?.brandNameLbl.textAlignment  = .left
//                    self?.HeaderbrandNameLbl.textAlignment  = .left
                }
                self?.productcategoriesdetailsdata = res
                let gImages = res.images

                let firstFourElements = Array(gImages?.prefix(2) ?? [])

                self?.gallaryImages = firstFourElements
               
                self?.pageControl.numberOfPages = self?.gallaryImages?.count ?? 0
                self?.pageControl.currentPage = 0
                
                self?.pagerView.reloadData()
                
                self?.catIds?.removeAll()
                for i in res.categories ?? [] {
                    self?.catId = i
                    self?.catIds?.append(i)
                }
                
            case .failure(let error):
                print(error)
            }
        })
    }
    
    private func categoriesApi(isbackground:Bool,id:String) {
        APIServices.categories2(isbackground:isbackground, id: id, limit: 10,completion: {[weak self] data in
            switch data {
            case .success(let res):
                self?.shopByCatView.isHidden = false
                for i in (0 ..< (self?.CategoriesResponsedata.count ?? 0)).reversed() {
              
                    self?.CategoriesResponsedata[i].subCategories?.removeAll(where: {$0.categorySpecs?.productsCount == 0})
                }
                self?.CategoriesResponsedata.append(res)
                self?.shopbycat_collectionview.reloadData()
            case .failure(let error):
                print(error)
//                self?.view.makeToast(error)
            }
        })
    }
    

    
    private func getAllProductsByCategories(limit:Int,page:Int,sortBy:String,category:String,active:Bool){
        APIServices.getAllProductsByCategoriesbyid(limit:limit,page:page,sortBy:sortBy,category:category,active:active, origin: ""){[weak self] data in
            switch data{
            case .success(let res):
                self?.storeproductquantity.text = LanguageManager.language == "ar" ? "\(res.totalResult ?? 0) منتجات" : "\(res.totalResult ?? 0) Products"
                if res.Categoriesdata?.count ?? 0 > 0 {
                    self?.getAllProductsByCategoriesData += res.Categoriesdata ?? []
                    // Increment the page numbe
                    self?.categoryPage += 1
                    // Update flag after loading
                    self?.isLoadingNextPage = false
                    self?.latestProductHeight.constant =  CGFloat((Utility().makeOddNumberEven(self?.getAllProductsByCategoriesData.count ?? 0) / 2) * 290)
                    self?.categoryproduct_collectionview.reloadData()
                    self?.productEmptyLbl.isHidden = true
                }else {
                    if page < 2 {
                        self?.productEmptyLbl.isHidden = false
                    }
                }
                
            case .failure(let error):
                print(error)
                if(error == "Please authenticate" && AppDefault.islogin){
                    appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                }else{
                    if error == "Not found"{
                        
                    }else{
//                        self?.view.makeToast(error)
                    }
                }
                self?.isLoadingNextPage = false

            }
        }
    }
        
    private func getStreamingVideos(userId:String,limit:Int,page:Int,categories: [String]){
        APIServices.getStreamingVideos(limit:limit,page:page,categories:categories,userId:userId, city: "",completion: {[weak self] data in
            switch data{
            case .success(let res):
                if res.results?.count ?? 0 > 0 {
                    if(LanguageManager.language == "ar"){
                        self?.videoButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
                        
                    }else{
                        self?.videoButton.setImage(UIImage(systemName: "arrow.right"), for: .normal)
                    }
                    self?.videosLabel.text = "videos".pLocalized(lang: LanguageManager.language)
                    self?.LiveStreamingResultsdata = res.results ?? []
                    self?.videoView.isHidden = false
                    self?.videoCollection.reloadData()
                }else {
                    self?.videoView.isHidden = true
                    self?.videosLabel.isHidden = true
                }
            case .failure(let error):
                print(error)
            }
        })
    }

    
    private func unfollowStore(storeId:String){
        APIServices.unfollowstore(storeId: storeId){[weak self] data in
            switch data{
            case .success(let res):
                if(res == "OK"){
                    self?.followBtn.setTitle("follow".pLocalized(lang: LanguageManager.language), for: .normal)
                    self?.isFollow = false
                }
            case .failure(let error):
                print(error)
                if(error == "Please authenticate" && AppDefault.islogin){
                    DispatchQueue.main.async {
                        appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                    }
                }else if(error == "Please authenticate" && AppDefault.islogin == false){
                      let vc = PopupLoginVc.getVC(.popups)
                    vc.modalPresentationStyle = .overFullScreen
                    self?.present(vc, animated: true, completion: nil)
                }
            }
        }
    } 
    
    private func followStore(storeId:String,web:Bool){
        APIServices.followStore(storeId: storeId, web: web){[weak self] data in
            switch data{
            case .success(let res):
                self?.followBtn.setTitle("followed".pLocalized(lang: LanguageManager.language), for: .normal)
                self?.isFollow = true
             //
            case .failure(let error):
                print(error)
                if(error == "Please authenticate" && AppDefault.islogin){
                    DispatchQueue.main.async {
                        appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                    }
                }else if(error == "Please authenticate" && AppDefault.islogin == false){
                      let vc = PopupLoginVc.getVC(.popups)
                    vc.modalPresentationStyle = .overFullScreen
                    self?.present(vc, animated: true, completion: nil)
                }
            }
        }
    } 
    
    private func followcheck(storeId:String){
        APIServices.followcheck(storeId: storeId){[weak self] data in
            switch data{
            case .success(let res):
                if(res == "OK"){
                    self?.followBtn.setTitle("followed".pLocalized(lang: LanguageManager.language), for: .normal)
                    self?.isFollow = true
                }else{
                    self?.followBtn.setTitle("follow".pLocalized(lang: LanguageManager.language), for: .normal)
                    self?.isFollow = false
                }
            case .failure(let error):
                print(error)
                if error == "NOT_FOUND" {
                    self?.followBtn.setTitle("follow".pLocalized(lang: LanguageManager.language), for: .normal)
                    self?.isFollow = false
                }
                if(error == "Please authenticate" && AppDefault.islogin){
                    DispatchQueue.main.async {
                        appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                    }
                }
            }
        }
    }
    
    func wishList(isbackground:Bool){
        APIServices.wishlist(isbackground: isbackground){[weak self] data in
          switch data{
          case .success(let res):
          //
            AppDefault.wishlistproduct = res.products
   
            self?.categoryproduct_collectionview.reloadData()
          case .failure(let error):
            print(error)
          }
        }
      }
    
    private func wishListApi(productId:String) {
        APIServices.newwishlist(product:productId,completion: {[weak self] data in
          switch data{
          case .success(let res):
           //
    //        if(res == "OK"){
    //          button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
    //          button.tintColor = .red
    //
    //        }else{
    //          button.setImage(UIImage(systemName: "heart"), for: .normal)
    //          button.tintColor = .gray
    //
    //        }
              self?.wishList(isbackground: false)
          case .failure(let error):
            print(error)
              if error == "Please authenticate" {
                  if AppDefault.islogin{
                      
                  }else{
//                       DispatchQueue.main.async {
//                          self.selectedIndex = 0
//                       }
                        let vc = PopupLoginVc.getVC(.popups)
                      vc.modalPresentationStyle = .overFullScreen
                      self?.present(vc, animated: true, completion: nil)
                  }
              }
          }
        })
      }


    @IBAction func followBtnTapped(_ sender: Any) {
        if(isFollow){
            unfollowStore(storeId: self.storeId)
        }else{
            followStore(storeId: self.storeId, web: true)
        }
    }
    @IBAction func backBtnTapped(_ sender: Any) {
//        appDelegate.isbutton = false
//    NotificationCenter.default.post(name: Notification.Name("ishideen"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func callIconBtnTapped(_ sender: Any) {
        
        AppDefault.brandname = brandName ?? ""
        if AppDefault.islogin == true {
            let vc = AddtocartPopup.getVC(.popups)
             vc.modalPresentationStyle = .custom
             vc.transitioningDelegate = self.centerTransitioningDelegate
             vc.img = "video-call"
            vc.titleText = "videocall".pLocalized(lang: LanguageManager.language)
            vc.messageText = "thisvideolikecontinue".pLocalized(lang: LanguageManager.language)
             vc.leftBtnText = "cancel".pLocalized(lang: LanguageManager.language)
             vc.rightBtnText = "yescontinue".pLocalized(lang: LanguageManager.language)
             vc.iscomefor = "video"
             vc.prductid = self.sellerID ?? ""
             self.present(vc, animated: true, completion: nil)
        }else {
            let vc = PopupLoginVc.getVC(.popups)
          vc.modalPresentationStyle = .overFullScreen
          self.present(vc, animated: true, completion: nil)
        }
  
        
        }
    
    
    @IBAction func shareBtn(_ sender: Any) {
        showShareSheet(id:"")
    }
    @IBAction func chatButtonTapped(_ sender: Any) {
                if !AppDefault.islogin {
                        let vc = PopupLoginVc.getVC(.popups)
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: true, completion: nil)
                    } else {
                        guard let sellerId = productcategoriesdetailsdata?.seller else {
                            print("Seller ID not found")
                            return
                        }

                        // Check if there's an existing chat with this seller
                        if let existingMessage = messages?.first(where: { $0.idarray?.sellerId == sellerId }) {
                            // Existing chat found, join the room
                            self.socket?.emit("room-join", [
                                "brandName": existingMessage.idarray?.brandName ?? "",
                                "customerId": AppDefault.currentUser?.id ?? "",
                                "isSeller": false,
                                "sellerId": sellerId,
                                "storeId": existingMessage.idarray?._id ?? "",
                                "options": ["page": 1, "limit": 200]
                            ])

                            self.socket?.on("room-join") { datas, ack in
                                if let rooms = datas[0] as? [String: Any] {
                                    let obj = PuserMainModel(jsonData: JSON(rawValue: rooms)!)
                                    print(obj)

                                    let vc = ChatViewController.getVC(.chatBoard)
                                    vc.socket = self.socket
                                    vc.manager = self.manager
                                    vc.messages = existingMessage
                                    vc.latestMessages = obj.messages.chat
                                    vc.PuserMainArray = obj
                                    vc.newChat = false
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                            }
                        } else {
                            // No existing chat, create a new chat
                            self.socket?.emit("room-join", [
                                "brandName": productcategoriesdetailsdata?.brandName ?? "",
                                "customerId": AppDefault.currentUser?.id ?? "",
                                "isSeller": false,
                                "sellerId": sellerId,
                                "storeId": productcategoriesdetailsdata?.id == nil ? productcategoriesdetailsdata?._id ?? "" : productcategoriesdetailsdata?.id ?? ""
                            ])

                            self.socket?.on("room-join") { datas, ack in
                                if let rooms = datas[0] as? [String: Any] {
                                    let obj = PuserMainModel(jsonData: JSON(rawValue: rooms)!)
                                    print(obj)

                                    let vc = ChatViewController.getVC(.chatBoard)
                                    vc.socket = self.socket
                                    vc.manager = self.manager
                                    vc.messages = nil
                                    vc.latestMessages = nil
                                    vc.PuserMainArray = obj
                                    vc.newChat = true
                                    vc.storeName = self.productcategoriesdetailsdata?.brandName ?? ""
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                            }
                        }
                    }
    }
    
    @IBAction func cartbtnTapped(_ sender: Any) {
        if(AppDefault.accessToken != ""){
            let vc = CartViewController
                .getVC(.main)
            self.navigationController?.pushViewController(vc, animated: false)
        }else{
          
               let vc = PopupLoginVc.getVC(.popups)
               vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func showShareSheet(id:String) {
        print(id)
        guard let url = URL(string: "\(AppConstants.API.storeShareURl)\(productcategoriesdetailsdata?.slug ?? "")") else { return }

        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)

        // On iPad, provide a sourceView and sourceRect to display the share sheet as a popover
        if let popoverPresentationController = activityViewController.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
//            popoverPresentationController.sourceRect = sender.frame
        }

        // Present the share sheet
        present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func videoArrowBtnTapped(_ sender: Any) {
        let vc = LIVE_videoNew.getVC(.videoStoryBoard)
//        vc.LiveStreamingResultsdata = self.LiveStreamingResultsdata
//        vc.indexValue = 0
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
}
extension New_StoreVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == videoCollection{
            return self.LiveStreamingResultsdata.count
        }else if collectionView == shopbycat_collectionview{
            return CategoriesResponsedata.count
        } else {
            return self.getAllProductsByCategoriesData.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == videoCollection{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Videoscategorycell1", for: indexPath) as! Videoscategorycell
            let data = LiveStreamingResultsdata[indexPath.row]
            cell.productimage.pLoadImage(url: data.thumbnail ?? "")
            cell.viewslbl.text = "\(data.totalViews ?? 0)  "
            cell.Productname.text = data.brandName
            cell.likeslbl.text = "\(data.like ?? 0)"
                return cell
            
        }else if collectionView == shopbycat_collectionview{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shopbycat_CollectionViewCell", for: indexPath) as! shopbycat_CollectionViewCell
            
            let data = CategoriesResponsedata[indexPath.row]
            
            cell.shop_img.pLoadImage(url: data.mainImage ?? "")
            if(LanguageManager.language == "ar"){
                if(data.lang != nil){
                    cell.lbl.text = data.lang?.ar?.name ?? ""
                }else{
                    cell.lbl.text = data.name ?? ""
                }
              
            }else{
                cell.lbl.text = data.name ?? ""
            }
           
            cell.BGView.backgroundColor = UIColor(named: "headercolor")
            return cell
        }
        
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeLastProductCollectionViewCell", for: indexPath) as! HomeLastProductCollectionViewCell
            let data =  self.getAllProductsByCategoriesData[indexPath.row]
            cell.percentBGView.backgroundColor = UIColor(named: "greenColor")

            cell.productimage.pLoadImage(url: data.mainImage ?? "")
            if LanguageManager.language == "ar" && data.lang?.ar != nil{
                cell.productname.text = data.lang?.ar?.productName
            }else{
                cell.productname.text =  data.productName
            }
            cell.product = data
            if data.onSale == true {
                cell.discountPrice.isHidden = false
                cell.productPrice.isHidden = false
                cell.discountPrice.attributedText = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(data.salePrice ?? 0, label: cell.discountPrice))
//                cell.productPrice.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(data.regularPrice ?? 0)
                cell.productPrice.attributedText = "\(appDelegate.currencylabel) \(Utility().formatNumberWithCommas(data.regularPrice ?? 0, label:   cell.productPrice).trimmingCharacters(in: .whitespaces))".strikeThrough()
                cell.productPriceLine.isHidden = true
                cell.productPrice.textColor = UIColor.red
                cell.productPriceLine.backgroundColor = UIColor.red
                cell.percentBGView.isHidden = false
            }else {
                cell.productPriceLine.isHidden = true
                cell.productPrice.isHidden = true
                cell.discountPrice.attributedText = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(data.regularPrice ?? 0, label:     cell.discountPrice))
                cell.percentBGView.isHidden = true
             }
            
            cell.cartButton.tag = indexPath.row
            cell.heartBtn.tag = indexPath.row

            cell.cartButton.addTarget(self, action: #selector(cartButtonTap(_:)), for: .touchUpInside)
            cell.heartBtn.addTarget(self, action: #selector(HeartBtnTapped(_:)), for: .touchUpInside)
            
            if let wishlistProducts = AppDefault.wishlistproduct {
                    if wishlistProducts.contains(where: { $0.id == data.id }) {
                      cell.heartBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                      cell.heartBtn.tintColor = .red
                    } else {
                      cell.backgroundColor = .white
                      cell.heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
                      cell.heartBtn.tintColor = .white
                    }
                  }
            
            
            return cell
        }
    }
    
    @objc func HeartBtnTapped(_ sender: UIButton) {
        if(AppDefault.islogin){
              let index = sender.tag
              let item = self.getAllProductsByCategoriesData[index]
            if item.id == nil {
                self.wishListApi(productId: (item._id ?? ""))
            }else {
                self.wishListApi(productId: (item.id ?? ""))
            }
            }else{
                let vc = PopupLoginVc.getVC(.popups)
              vc.modalPresentationStyle = .overFullScreen
              self.present(vc, animated: true, completion: nil)
            }
    }
    
    @objc func cartButtonTap(_ sender: UIButton) {
        let data =  self.getAllProductsByCategoriesData[sender.tag]
        if (data.variants?.countVariants() ?? 0 > 0) {
            let vc = NewProductPageViewController.getVC(.productStoryBoard)
            vc.slugid = data.slug
            navigationController?.pushViewController(vc, animated: false)
        }else {
            let vc = CartPopupViewController.getVC(.popups)
           
            vc.modalPresentationStyle = .custom
            vc.transitioningDelegate = centerTransitioningDelegate
            vc.products = data
            vc.nav = self.navigationController
            vc.onDismiss = {
                self.cartCountShow = AppDefault.cartCount
            }
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
          return  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == videoCollection{
            let data = LiveStreamingResultsdata[indexPath.row]
            let vc = New_SingleVideoview.getVC(.videoStoryBoard)
            vc.LiveStreamingResultsdata = self.LiveStreamingResultsdata
            vc.indexValue = indexPath.row
            vc.page = 2
            self.navigationController?.pushViewController(vc, animated: false)
            appDelegate.videoCountAPI(isbackground: false, slug: LiveStreamingResultsdata[indexPath.row].slug ?? "")
        }else if collectionView == shopbycat_collectionview{
            let data = CategoriesResponsedata[indexPath.row]
            let vc = Category_ProductsVC.getVC(.productStoryBoard)
            vc.prductid = data.id ?? ""
            vc.sellerId = sellerID ?? ""
            vc.video_section = false
            vc.storeFlag = false
            vc.catNameTitle = data.name ?? ""
            self.navigationController?.pushViewController(vc, animated: false)
        }else {
            let data =  self.getAllProductsByCategoriesData[indexPath.row]
            let vc = NewProductPageViewController.getVC(.productStoryBoard)
//            vc.isGroupBuy = false
            vc.slugid = data.slug
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       if collectionView == videoCollection {
           return CGSize(width: collectionView.frame.size.width/2.2, height: collectionView.frame.size.height)
       }else if collectionView == shopbycat_collectionview{
           return CGSize(width: collectionView.frame.width/2.7, height: 160
           )
       }else {
           return CGSize(width: collectionView.frame.width/2.05, height: 280)
        }
    }
}
        
extension New_StoreVC: FSPagerViewDataSource, FSPagerViewDelegate {
func numberOfItems(in pagerView: FSPagerView) -> Int {
            return gallaryImages?.count ?? 0
   }

    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        let data = gallaryImages?[index]
        cell.imageView?.pLoadImage(url: data ?? "")
        cell.imageView?.contentMode = .scaleToFill
        
        return cell
    
   }

   // MARK: - FSPagerViewDelegate

    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        if pagerView == self.pagerView {
            let currentIndex = pagerView.currentIndex
            pageControl.currentPage = currentIndex
        }else {
            let currentIndex = pagerView.currentIndex
            pageControl.currentPage = currentIndex
        }

    }
     
}
extension New_StoreVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        // Prevent triggering when content is too short to scroll
        guard contentHeight > height else { return }

        // Trigger when near bottom (e.g., within 100 pts)
        if offsetY > contentHeight - height - 100 {
            loadMoreProducts()
        }
    }
    
    func loadMoreProducts() {
        guard !isLoadingNextPage && !isEndReached else {
            return // Return if already loading next page or end is reached
        }
        
        isLoadingNextPage = true
        
        // Call your API to fetch more products
        update(count: categoryPage)
    }
}
extension New_StoreVC {
       func connectSocket() {
        manager = SocketManager(socketURL: AppConstants.API.baseURLChat, config: [.log(true),
                                                                                  .compress,
                                                                                  .forceWebsockets(true),.connectParams( ["token":AppDefault.accessToken])])
        socket = manager?.socket(forNamespace: "/chat/v1/message")
           socket?.connect()
        
              socket?.on(clientEvent: .connect) { (data, ack) in
            
        self.socket?.emit("allUnread", ["userId":AppDefault.currentUser?.id ?? ""])
       
            print("socketid " + (self.socket?.sid ?? ""))
            print("Socket Connected")
            
            
            
        }
        
        self.socket?.on("allUnread") { data, ack in
            if let rooms = data[0] as? [[String: Any]]{
                if let rooms = data[0] as? [[String: Any]]{
                    print(rooms)
                    
                     var messageItem:[PMsg] = []
                    let Datamodel = JSON(rooms)
                    let message = Datamodel.array
                    
                    for item in message ?? []{
                        
                        messageItem.append(PMsg(jsonData: item))
                    }
                    
                    print(messageItem)
                    
                    self.messages = messageItem
                    
                    
                }
            }
              self.socket?.on(clientEvent: .disconnect) { data, ack in
                // Handle the disconnection event
                print("Socket disconnected")
            }
            }
        
    }
    
}
