//
//  Category_ProductsVC.swift
//  Bazaar Ghar
//
//  Created by Umair ALi on 29/08/2023.
//

import UIKit
import AudioToolbox
import Presentr
import DropDown

class Category_ProductsVC: UIViewController {
    @IBOutlet weak var filterPullDownButtom: UIButton!
    @IBOutlet weak var filterLbl: UILabel!
    @IBOutlet weak var categoryproduct_collectionview: UICollectionView!
    @IBOutlet weak var categoryNameTitle: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
   
    @IBOutlet weak var cartbtn: UIButton!
    @IBOutlet weak var pagecontrol: UIPageControl!
    var LiveStreamingResultsdata: [LiveStreamingResults] = []
        
    @IBOutlet weak var scrollheight: NSLayoutConstraint!

    @IBOutlet weak var searchProductslbs: UITextField!
    @IBOutlet weak var livelbl: UILabel!
    @IBOutlet weak var productSortByLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var homeswitchbtn: UISwitch!
    @IBOutlet weak var productEmptyLbl: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headerBackgroudView: UIView!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var cartCount: UILabel!
    @IBOutlet weak var cartCountView: UIView!
    @IBOutlet weak var dropDownLbl: UILabel!

    
    var cartCountShow: String? {
        didSet {
            if Int(cartCountShow ?? "0") ?? 0 > 0 {
                self.cartCountView.isHidden = false
            }
            self.cartCount.text = cartCountShow
        }
    }

    var contentPages: [UIViewController] = []

    var prductid = String()
    var catNameTitle = String()
     var sort = "-createdAt"
    var sellerDescription = String()
    var storeId = String()
    var sellerId = ""
    var getAllProductsByCategoriesData: [Product] = []
    
    var storeFlag = Bool()
    var video_section = Bool()
    var isEndReached = false
    var isLoadingNextPage = false
    var categoryPage = 1
    var isFollow = false
    let centerTransitioningDelegate = CenterTransitioningDelegate()
    var origin:String? {
        didSet {
            update(count: 1)
        }
    }

    let dropDown = DropDown()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.productEmptyLbl.isHidden = true
        dropDownLbl.text = "default".pLocalized(lang: LanguageManager.language)
        var config = UIButton.Configuration.filled()
        config.title = ""
        config.image = UIImage(systemName: "chevron.down")
        config.imagePlacement = .trailing
        config.imagePadding = 0
        config.baseBackgroundColor = .systemGray4
        config.baseForegroundColor = .black
        config.cornerStyle = .large

        if let image = config.image {
            let size = CGSize(width: 10, height: 7)
            let renderer = UIGraphicsImageRenderer(size: size)
            let resizedImage = renderer.image { _ in
                image.draw(in: CGRect(origin: .zero, size: size))
            }
            config.image = resizedImage
        }
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 12)

        filterPullDownButtom.configuration = config
        filterPullDownButtom.translatesAutoresizingMaskIntoConstraints = false
        filterPullDownButtom.contentHorizontalAlignment = .trailing
        //        filterPullDownButtom.setTitle("default".pLocalized(lang: LanguageManager.language), for: .normal)
        filterPullDownButtom.setTitleColor(.black, for: .normal)
        
        scrollView.delegate = self
        headerBackgroudView.backgroundColor = UIColor(named: "headercolor")
        setupCollectionView()
        categoryNameTitle.text = catNameTitle
        if(self.origin == nil || self.origin == ""){
            update(count: 1)
        }
       
        if storeFlag == false {
            categoryNameTitle.isHidden = false
        } else {
            categoryNameTitle.isHidden = true
        }
        homeswitchbtn.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        filterPullDownButtom.addTarget(self, action: #selector(dropDownButtonTapped), for: .touchUpInside)

    }
    
    @objc func dropDownButtonTapped() {
        dropDown.show()
    }
    func setupDropDown() {
        dropDown.dataSource = [
            "default".pLocalized(lang: LanguageManager.language),
            "pricelowtohigh".pLocalized(lang: LanguageManager.language),
            "pricehightolow".pLocalized(lang: LanguageManager.language)
        ]
        
        // Set the anchor view to the button
        dropDown.anchorView = filterPullDownButtom
        dropDown.direction = .any
        
        // Ensure the dropdown aligns properly based on language direction
        let isArabic = LanguageManager.language == "ar"
        dropDown.semanticContentAttribute = isArabic ? .forceLeftToRight : .forceRightToLeft
        filterPullDownButtom.semanticContentAttribute = isArabic ? .forceLeftToRight : .forceRightToLeft
        
        // Dynamically adjust the bottom offset
        DispatchQueue.main.async {
            let buttonWidth = self.filterPullDownButtom.bounds.width
            let xOffset: CGFloat = isArabic ? buttonWidth - (self.dropDown.width ?? 0) : 0
            self.dropDown.bottomOffset = CGPoint(x: xOffset, y: self.filterPullDownButtom.bounds.height)
        }
        
        // Handle selection action
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            print("Selected: \(item)")
//            self?.filterPullDownButtom.setTitle(item, for: .normal)
            self?.dropDownLbl.text = item
            if item == "default".pLocalized(lang: LanguageManager.language) {
                self?.sort = "-createdAt"
            } else if item == "pricelowtohigh".pLocalized(lang: LanguageManager.language) {
                self?.sort = "price"
            } else {
                self?.sort = "-price"
            }
            
            self?.getAllProductsByCategoriesData.removeAll()
            self?.update(count: 1)
        }
    }

    
    func setupCollectionView() {
        let nib = UINib(nibName: "HomeLastProductCollectionViewCell", bundle: nil)
        categoryproduct_collectionview.register(nib, forCellWithReuseIdentifier: "HomeLastProductCollectionViewCell")
        categoryproduct_collectionview.delegate = self
        categoryproduct_collectionview.dataSource = self
    }
    
    
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.LanguageRender()
        homeswitchbtn.isOn = false
        cartCountShow = AppDefault.cartCount
        if(AppDefault.islogin ){
            
            if AppDefault.wishlistproduct != nil{
                wishList(isbackground: true)
            }else{
                wishList(isbackground: false)
            }
        }
    }
    
    func LanguageRender(){
       
        setupDropDown()

        productSortByLbl.text = "productsortby".pLocalized(lang: LanguageManager.language)
        searchProductslbs.placeholder = "searchproducts".pLocalized(lang: LanguageManager.language)
        livelbl.text = "live".pLocalized(lang: LanguageManager.language)
        
        if LanguageManager.language == "ar"{
            backBtn.setImage(UIImage(systemName: "arrow.right"), for: .normal)
           }else{
               backBtn.setImage(UIImage(systemName: "arrow.left"), for: .normal)
           }
        
        filterPullDownButtom.semanticContentAttribute = LanguageManager.language == "ar" ? .forceRightToLeft : .forceLeftToRight
        UIView.appearance().semanticContentAttribute = LanguageManager.language == "ar" ? .forceRightToLeft : .forceLeftToRight
        UITextField.appearance().textAlignment = LanguageManager.language == "ar" ? .right : .left
        dropDown.semanticContentAttribute = LanguageManager.language == "ar" ? .forceRightToLeft : .forceLeftToRight
        dropDown.anchorView?.plainView.semanticContentAttribute = LanguageManager.language == "ar" ? .forceRightToLeft : .forceLeftToRight
    }
    

    func update(count:Int) {
        if origin == nil {
            if storeFlag == false {
                getAllProductsByCategories(limit: 20, page: count, sortBy:sort, category:prductid, active: false, user: sellerId)
            }else{
                getAllProductsByCategoriesbyid(limit: 20, page: count, sortBy:sort, category:prductid, active: false)
            }
        }else {
            shopchinagetAllProductsByCategories(limit: 20, page: count, sortBy:sort, category:prductid, active: false, origin: origin ?? "")
        }
    
    }
    
    private func getAllProductsByCategories(limit:Int,page:Int,sortBy:String,category:String,active:Bool,user:String){
        APIServices.getAllProductsByCategories(limit:limit,page:page,sortBy:sortBy,category:category,active:active,user:user){[weak self] data in
            switch data {
            case .success(let res):
                if res.Categoriesdata?.count ?? 0 > 0 {
                    
                    self?.getAllProductsByCategoriesData += res.Categoriesdata ?? []
                    self?.categoryPage += 1
                    
                    self?.isLoadingNextPage = false
                    
                    if self?.getAllProductsByCategoriesData.count ?? 0 > 1 {
                        let ll = ((Utility().convertOddToEven(self?.getAllProductsByCategoriesData.count ?? 0)) / 2) * 284
                    self?.scrollheight.constant = CGFloat(ll + 105)
                       
                    }else {
//                        let ll = ((self?.getAllProductsByCategoriesData.count ?? 0) / 2) * 284
                    self?.scrollheight.constant = CGFloat(284 + 105)
                       
                       
                    }
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        let startIndex = (self.getAllProductsByCategoriesData.count) - (res.Categoriesdata?.count ?? 0)
                        if(startIndex == 0){
                            self.categoryproduct_collectionview.reloadData()
                        }else{
                            let endIndex = startIndex + (res.Categoriesdata?.count ?? 0)
                            let indexPaths = (startIndex..<endIndex).map { IndexPath(item: $0, section: 0) }
                            
                            self.categoryproduct_collectionview.performBatchUpdates({
                                self.categoryproduct_collectionview.insertItems(at: indexPaths)
                            }, completion: nil)
                            
                            self.isLoadingNextPage = false
                        }
                    }
       
                    
                }else {
                }
                if self?.getAllProductsByCategoriesData.count ?? 0 > 0 {
                    self?.productEmptyLbl.isHidden = true
                }else {
                    self?.productEmptyLbl.isHidden = false

                }


            case .failure(let error):
                print(error)
                self?.isLoadingNextPage = false
            }
        }
    }
    private func shopchinagetAllProductsByCategories(limit:Int,page:Int,sortBy:String,category:String,active:Bool,origin:String){
        APIServices.shopChinagetAllProductsByCategories(limit:limit,page:page,sortBy:sortBy,category:category,active:active,origin:origin){[weak self] data in
            switch data{
            case .success(let res):
                if res.Categoriesdata?.count ?? 0 > 0 {
                    
                    self?.getAllProductsByCategoriesData += res.Categoriesdata ?? []
                    self?.categoryPage += 1
                    
                    self?.isLoadingNextPage = false
                    

                    let ll = ((Utility().convertOddToEven(self?.getAllProductsByCategoriesData.count ?? 0)) / 2) * 284
                    self?.scrollheight.constant = CGFloat(ll + 105)
                       
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        
                        let startIndex = (self.getAllProductsByCategoriesData.count) - (res.Categoriesdata?.count ?? 0)
                        if(startIndex == 0){
                            self.categoryproduct_collectionview.reloadData()
                        }else{
                            let endIndex = startIndex + (res.Categoriesdata?.count ?? 0)
                            let indexPaths = (startIndex..<endIndex).map { IndexPath(item: $0, section: 0) }
                            
                            self.categoryproduct_collectionview.performBatchUpdates({
                                self.categoryproduct_collectionview.insertItems(at: indexPaths)
                            }, completion: nil)
                            
                            self.isLoadingNextPage = false
                        }
                    }
          
                }else {
                }
                if self?.getAllProductsByCategoriesData.count ?? 0 > 0 {
                    self?.productEmptyLbl.isHidden = true
                }else {
                    self?.productEmptyLbl.isHidden = false

                }


            case .failure(let error):
                print(error)
                self?.isLoadingNextPage = false
            }
        }
    }
    
    private func getAllProductsByCategoriesbyid(limit:Int,page:Int,sortBy:String,category:String,active:Bool){
        APIServices.getAllProductsByCategoriesbyid(limit:limit,page:page,sortBy:sortBy,category:category,active:active, origin: ""){[weak self] data in
            switch data{
            case .success(let res):
                if res.Categoriesdata?.count ?? 0 > 0 {
                    self?.getAllProductsByCategoriesData += res.Categoriesdata ?? []
                    
                    // Increment the page numbe
                    self?.categoryPage += 1
                    
                    // Update flag after loading
                    self?.isLoadingNextPage = false
                    
                    let ll = ((Utility().convertOddToEven(self?.getAllProductsByCategoriesData.count ?? 0)) / 2) * 284
                    self?.scrollheight.constant = CGFloat(ll + 105)
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        let startIndex = (self.getAllProductsByCategoriesData.count) - (res.Categoriesdata?.count ?? 0)
                        if(startIndex == 0){
                            self.categoryproduct_collectionview.reloadData()
                        }else{
                            let endIndex = startIndex + (res.Categoriesdata?.count ?? 0)
                            let indexPaths = (startIndex..<endIndex).map { IndexPath(item: $0, section: 0) }
                            
                            self.categoryproduct_collectionview.performBatchUpdates({
                                self.categoryproduct_collectionview.insertItems(at: indexPaths)
                            }, completion: nil)
                            
                            self.isLoadingNextPage = false
                        }
                    }
                }else {

                }
                if self?.getAllProductsByCategoriesData.count ?? 0 > 0 {
                    self?.productEmptyLbl.isHidden = true
                }else {
                    self?.productEmptyLbl.isHidden = false

                }


                
            case .failure(let error):
                print(error)
                if(error == "Please authenticate" && AppDefault.islogin){
                    appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                }else{
                    if error == "Not found"{
                        
                    }else{
                        self?.view.makeToast(error)
                    }
                }
                self?.isLoadingNextPage = false

            }
        }
    }
    
    
//    private func chinesebell(sellerId:String,brandName:String,description:String){
//        APIServices.chinesebell(sellerId: sellerId, brandName: brandName, description: description){[weak self] data in
//            switch data{
//            case .success(_): break
//             //
//            case .failure(let error):
//                print(error)
//                if(error == "Please authenticate" && AppDefault.islogin){
//                    appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
//                }else{
//                    self?.view.makeToast(error)
//                }
//            }
//        }
//    }
    
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

              self?.wishList(isbackground: false)
          case .failure(let error):
            print(error)
              if error == "Please authenticate" {
                  if AppDefault.islogin{
                      
                  }else{

                      let vc = PopupLoginVc.getVC(.popups)
                      vc.modalPresentationStyle = .overFullScreen
                      vc.presentationController?.delegate = self
                      self?.present(vc, animated: true, completion: nil)
                  }
              }
          }
        })
      }
    
    
    @IBAction func cartbtn(_ sender: Any) {
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
    @IBAction func searchTapped(_ sender: Any) {
        
        let vc = Search_ViewController.getVC(.searchStoryBoard)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
//            appDelegate.isbutton = false
//        NotificationCenter.default.post(name: Notification.Name("ishideen"), object: nil)
        self.navigationController?.popViewController(animated: false)
    }

    
    @IBAction func viewAllBtnTapped(_ sender: Any) {
        let vc = New_SingleVideoview.getVC(.videoStoryBoard)
        vc.LiveStreamingResultsdata = self.LiveStreamingResultsdata
        vc.indexValue = 0
        vc.page = 2
        self.navigationController?.pushViewController(vc, animated: false)

    }
}

extension Category_ProductsVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
   
            return self.getAllProductsByCategoriesData.count
    
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeLastProductCollectionViewCell", for: indexPath) as! HomeLastProductCollectionViewCell
            let data =  self.getAllProductsByCategoriesData[indexPath.row]
        cell.percentBGView.backgroundColor = UIColor(named: "greenColor")
        cell.product = data
//
            cell.productname.text =  LanguageManager.language == "ar" ? data.lang?.ar?.productName ?? data.productName : data.productName ?? ""
        cell.productPrice.text =  appDelegate.currencylabel + Utility().formatNumberWithCommas(data.regularPrice ?? 0, label:  cell.productPrice)
            if data.onSale == true {
                cell.discountPrice.isHidden = false
                cell.discountPrice.attributedText = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(data.salePrice ?? 0, label:  cell.discountPrice))

                cell.productPriceLine.isHidden = false
                cell.productPrice.textColor = UIColor.red
                cell.productPriceLine.backgroundColor = UIColor.red
                cell.percentBGView.isHidden = false
                
            }else {
                cell.discountPrice.isHidden = true
                cell.productPriceLine.isHidden = true
                cell.productPrice.attributedText = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(data.regularPrice ?? 0, label:  cell.productPrice))
                cell.percentBGView.isHidden = true
             }
            cell.heartBtn.tag = indexPath.row
            cell.cartButton.tag = indexPath.row
            cell.cartButton.addTarget(self, action: #selector(cartButtonTap(_:)), for: .touchUpInside)
            cell.heartBtn.addTarget(self, action: #selector(heartButtonTap(_:)), for: .touchUpInside)
                     
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

    
    @objc func cartButtonTap(_ sender: UIButton) {
        let data = getAllProductsByCategoriesData[sender.tag]
        
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
    
    @objc func heartButtonTap(_ sender: UIButton) {
        if(AppDefault.islogin){
              let index = sender.tag
            let item = getAllProductsByCategoriesData[index]
            if item.id == nil {
                self.wishListApi(productId: (item._id ?? ""))
            }else {
                self.wishListApi(productId: (item.id ?? ""))
            }            }else{
                let vc = PopupLoginVc.getVC(.popups)
              vc.modalPresentationStyle = .overFullScreen
              self.present(vc, animated: true, completion: nil)
            }


    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryproduct_collectionview{
            let data =  self.getAllProductsByCategoriesData[indexPath.row]
            
            let vc = NewProductPageViewController.getVC(.productStoryBoard)
//            vc.isGroupBuy = false
            vc.slugid = data.slug
            self.navigationController?.pushViewController(vc, animated: false)
        } else{
            let vc = New_SingleVideoview.getVC(.videoStoryBoard)
            vc.LiveStreamingResultsdata = self.LiveStreamingResultsdata
            vc.indexValue = indexPath.row
            vc.page = 2
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        return CGSize(width: self.categoryproduct_collectionview.frame.width/2.03, height: 280)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 4

    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? HomeLastProductCollectionViewCell {
            cell.backgroundImage.image = nil
            cell.productimage.image = nil
            cell.imageDownloadTask?.cancel()
        }
    }
    
  
    

    
    }
    
    

extension Category_ProductsVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height - 100 {
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


extension Category_ProductsVC: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        print("You dismissed the presented controller")
    }
}
