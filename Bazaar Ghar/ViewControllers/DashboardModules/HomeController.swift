//
//  HomeController.swift
//  Bazaar Ghar
//
//  Created by Developer on 21/08/2023.
//

import UIKit
import SocketIO
import SwiftyJSON
import AudioToolbox
import FSPagerView
import Presentr
import Lottie
import SideMenu
import Frames


class HomeController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var latestmobilesectionview: UIView!
    @IBOutlet weak var homelastproductsview: NSLayoutConstraint!
    @IBOutlet weak var homeswitchbtn: UISwitch!
    @IBOutlet weak var imageslidercollectionview: UICollectionView!
    @IBOutlet weak var homeTblView: UITableView!
    @IBOutlet weak var topcell_1: UICollectionView!
    @IBOutlet weak var homeLastProductCollectionView: UICollectionView!
    
    @IBOutlet weak var pageController: UIPageControl!
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    
    @IBOutlet weak var hotdealslbl: UILabel!
    @IBOutlet weak var shoplabel: UILabel!

    @IBOutlet weak var searchProductslbs: UITextField!
    @IBOutlet weak var livelbl: UILabel!
    @IBOutlet weak var topcategorieslbl: UILabel!
    @IBOutlet weak var trendingproductlbl: UILabel!

    @IBOutlet weak var hederView: UIView!
    @IBOutlet weak var LiveGif: UIImageView!
    @IBOutlet weak var hotDealCollectionV: UICollectionView!

    @IBOutlet weak var hotDealViewHeight: NSLayoutConstraint!
    @IBOutlet weak var hotDealView: UIView!
    @IBOutlet weak var chatBotGif: UIImageView!
    @IBOutlet weak var recommendationLbl: UILabel!

    @IBOutlet weak var shopByCatLbl: UILabel!

    @IBOutlet weak var searchFeild: UITextField!
    
    @IBOutlet weak var viewalllbl: UIButton!
    @IBOutlet weak var pagerView: FSPagerView!
     @IBOutlet weak var pageControl: FSPageControl!
    @IBOutlet weak var headerBackgroudView: UIView!

    @IBOutlet weak var shopbeyoundview: UIView!
    @IBOutlet weak var shopbeyound_tblview: UITableView!
    @IBOutlet weak var lastRandomProductsCollectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var langLbl: UILabel!
    @IBOutlet weak var cartCount: UILabel!
    @IBOutlet weak var cartCountView: UIView!
    @IBOutlet weak var topCatBackBtn: UIButton!
    @IBOutlet weak var latestBackBtn: UIButton!

    @IBOutlet weak var liveImage: UIImageView!
    var bannerapidata: [Banner]? = nil{
        didSet{
            self.setupPageControl()
           self.pagerView.reloadData()
        }
    }
    var CategoriesResponsedata: [getAllCategoryResponse] = []
    var UpdatedCategoriesResponsedata: [getAllCategoryResponse] = []
    var ProductCategoriesResponsedata: [PChat] = []
    var randomproductapiModel: [PChat] = []
    var getrandomproductapiModel: [Product] = []

    var groupbydealsdata: [GroupByResult] = []

    var timer = Timer()
    var counter = 0
   var shopchinaflag = [String]()
    var shopchinaimg = [String]()
    var nameshopchina = [String]()
    var isLogin = UserDefaults.standard.bool(forKey: "isLogin")
    
    var manager:SocketManager?
    var socket: SocketIOClient?
    var messageItem:[notificationmodel] = []

var count = 0


    var shopBeyondBGColorArray = [UIColor(hex: "#F7FFF2"),UIColor(hex: "#FFF4F6"),UIColor(hex: "#F0FFEF")]
    var shopBeyonimagesArray = [UIImage(named: "pakistan-image"),UIImage(named: "china"),UIImage(named: "saudi")]
    var shopBeyonLblArray = ["Shop Pakistan","Shop China","Shop Saudi"]
    var shopBeyonLblArrayar = ["تسوق باكستان","تسوق الصين","تسوق سعودي"]

    let centerTransitioningDelegate = CenterTransitioningDelegate()
    var load:Bool?
    var addwislistResponseMessage: String?
    var idsArray = [String]()
    var wishlistDataResponse : WishlistResponse?
    
    // Desired order
    let catSequence = [
        "66fa5e0856711740c06380d2",
        "66fa5e0756711740c0637b48",
        "66fa5e0756711740c0637c96",
        "66fa5e0756711740c0637a82",
        "66fa5e0756711740c0637a5a",
        "66fa5e0956711740c063810e"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        liveImage.image = UIImage.gifImageWithName("new_shake")
        liveImage.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
              liveImage.addGestureRecognizer(tapGesture)
        SetupView()
        self.tabBarController?.delegate = self
        setupSideMenu()
        searchFeild.returnKeyType = .search
        searchFeild.translatesAutoresizingMaskIntoConstraints = false
        searchFeild.delegate = self
//        getStreamingVideos(limit:200,page:1,categories: [], city: "")
    }
    
    
    @objc func imageTapped() {
           print("GIF Tapped!")
        let vc = LIVE_videoNew.getVC(.videoStoryBoard)
        self.navigationController?.pushViewController(vc, animated: false)

       }
    private func setupSideMenu() {
    
        let vc = MenuVCList.getVC(.sidemenu)
        let sideMenu = SideMenuNavigationController(rootViewController: vc)
        sideMenu.presentationStyle = .menuSlideIn
   
        sideMenu.leftSide = false
        
        sideMenu.menuWidth = UIScreen.main.bounds.width * 0.7
        sideMenu.presentationStyle.backgroundColor = .clear
        sideMenu.presentationStyle.onTopShadowOpacity = 0.0
        sideMenu.presentationStyle.onTopShadowColor = .clear
        sideMenu.presentationStyle.onTopShadowColor = UIColor.black.withAlphaComponent(0.5)
        sideMenu.presentationStyle.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        sideMenu.presentationStyle.presentingEndAlpha = 0.5
        
        sideMenu.statusBarEndAlpha  = 0.0
        sideMenu.view.backgroundColor = .white
        sideMenu.presentationStyle.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        sideMenu.tabBarController?.tabBar.isHidden = false
        
        SideMenuManager.default.rightMenuNavigationController = sideMenu
        
    }
    func SetupView(){
        if AppDefault.islogin{
            SocketConeect()
        }

        
        scrollView.delegate = self
        let attributedText11 =  Utility().attributedStringWithColoredLastWordBold("Shop beyond boundaries", lastWordColor:   UIColor(named: "headercolor")!, otherWordsColor: .black)

        shoplabel.attributedText = attributedText11

        trendingproductlbl.attributedText =  Utility().attributedStringWithColoredLastWordBold("Trendingproducts".pLocalized(lang: AppDefault.languages), lastWordColor: UIColor(named: "headercolor")!, otherWordsColor: .black)

        headerBackgroudView.backgroundColor = UIColor(named: "headercolor")

        pagerView.dataSource = self
               pagerView.delegate = self
               pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        pagerView.automaticSlidingInterval = 2.0
        shopbeyound_tblview.dataSource = self
        shopbeyound_tblview.delegate = self
        shopchinaflag = ["flag_china","flag_pakistan","flag_saudi"]
        shopchinaimg = ["Image 120","Image 121","saudi_product_image"]
        nameshopchina = ["Shop China","Shop Pakistan","Shop Saudi"]
        self.becomeFirstResponder()

        chatBotGif.isUserInteractionEnabled = true
     let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.touchTapped2(_:)))
        chatBotGif.addGestureRecognizer(tap2)


        hotDealViewHeight.constant = 0
        hotDealView.isHidden = true
        homeTblView.delegate = self
        homeTblView.dataSource = self


        setupCollectionView()
       
     
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.videocallmethod(notification:)), name: Notification.Name("videocallid"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("Productid"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.cartCountReceivedNotification(notification:)), name: Notification.Name("cartCount"), object: nil)
        

        
        homeswitchbtn.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        
        if(AppDefault.randonproduct?.count ?? 0 > 0){
            randomproduct(cat: "66fa5e0856711740c06380d2", cat2: "", cat3: "", cat4: "", cat5: "",  isbackground: true)
            self.randomproductapiModel = AppDefault.randonproduct ?? []
            if(randomproductapiModel.first?.product?.count == 0){
                self.latestmobilesectionview.isHidden = true
                self.homelastproductsview.constant = 0
            }else{
                self.latestmobilesectionview.isHidden = false
                self.homelastproductsview.constant = 0 // 617
            }
        }else{
            randomproduct(cat: "66fa5e0856711740c06380d2", cat2: "", cat3: "", cat4: "", cat5: "",  isbackground: false)
        }
        if(AppDefault.getrandomproductapiModel?.count ?? 0 > 0){
            let res = AppDefault.getrandomproductapiModel!
            if(res.count > 0){
                self.getrandomproductapiModel.append(contentsOf: res)
            }
     
            self.tableViewHeight.constant = CGFloat(770 * (self.ProductCategoriesResponsedata.count))
            
            let hh = (300 * 3) + 1440
            let ll = ((self.getrandomproductapiModel.count) / 2) * 288
            let final = hh + ll

            self.scrollHeight.constant = CGFloat(final) + (self.hotDealViewHeight.constant) + (self.tableViewHeight.constant)
           
            self.lastRandomProductsCollectionView.reloadData()
            self.load = true
           
            getrandomproduct(isbackground: true)
        }else{
            getrandomproduct(isbackground: false)
        }

        if(AppDefault.productcategoriesApi?.count ?? 0 > 0){
            productcategoriesApi(cat: "66fa5e0756711740c0637b48", cat2: "66fa5e0756711740c0637c96", cat3: "66fa5e0756711740c0637a82", cat4: "66fa5e0756711740c0637a5a", cat5: "66fa5e0956711740c063810e", cat6: "66fa5e0856711740c06380d2",isbackground: true)

            self.ProductCategoriesResponsedata = AppDefault.productcategoriesApi ?? []
            
            // Create a dictionary to map id to its index in the desired order
            let orderMap = Dictionary(uniqueKeysWithValues: (self.catSequence.enumerated().map { ($1, $0) }))

            // Sort the data array based on the index in desired order
            let sortedData = AppDefault.productcategoriesApi?.sorted {
                (orderMap[$0.id ?? ""] ?? Int.max) < (orderMap[$1.id ?? ""] ?? Int.max)
            }
            
            
            self.ProductCategoriesResponsedata = sortedData ?? []

            self.tableViewHeight.constant = CGFloat(770 * (self.ProductCategoriesResponsedata.count ))
            let hh = (300 * 3) + 1440 + ((getrandomproductapiModel.count) / 2) * 288

            self.scrollHeight.constant = CGFloat(hh) + (self.hotDealViewHeight.constant) + (self.tableViewHeight.constant)

            self.homeTblView.reloadData()

        }else{
            productcategoriesApi(cat: "66fa5e0756711740c0637b48", cat2: "66fa5e0756711740c0637c96", cat3: "66fa5e0756711740c0637a82", cat4: "66fa5e0756711740c0637a5a", cat5: "66fa5e0956711740c063810e", cat6: "66fa5e0856711740c06380d2",isbackground: false)
        }

        
        
        if(AppDefault.getAllCategoriesResponsedata?.count ?? 0 > 0){
          
            self.UpdatedCategoriesResponsedata = AppDefault.getAllCategoriesResponsedata ?? []

            self.topcell_1.reloadData()
            self.categoriesApi(isbackground: true)

        }
        else
        {
            self.categoriesApi(isbackground: true)
        }
                

        if(AppDefault.Bannerdata?.count ?? 0 > 0){
            let res = AppDefault.Bannerdata!
            if(res.count > 0){
                if LanguageManager.language == "ar" {
                    for item in res{
                        let objext = item.id
                        if objext?.bannerName == "Customer App Home Arabic" {
                            self.bannerapidata = (objext?.banners)!
                        }
                    }
                }else {
                    for item in res{
                        let objext = item.id
                        if objext?.bannerName == "Mob Banner Home" {
                            self.bannerapidata = (objext?.banners)!
                        }
                    }
                }

            }
           
            self.bannerApi(isbackground: true)
        }else{
            self.bannerApi(isbackground: false)
        }
    }
    
    func setupCollectionView() {
        let nib = UINib(nibName: "HomeLastProductCollectionViewCell", bundle: nil)
        homeLastProductCollectionView.register(nib, forCellWithReuseIdentifier: "HomeLastProductCollectionViewCell")
        homeLastProductCollectionView.delegate = self
        homeLastProductCollectionView.dataSource  = self
        lastRandomProductsCollectionView.register(nib, forCellWithReuseIdentifier: "HomeLastProductCollectionViewCell")
        lastRandomProductsCollectionView.delegate = self
        lastRandomProductsCollectionView.dataSource  = self
    }
    

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
 
        if offsetY > contentHeight - frameHeight {
         
            if load == true {
                getrandomproduct(isbackground: false)
            }
        }
    }
        func loadMoreData() {
          
            print("Reached the end of the scroll view, loading more data...")
           
            
        }
    
    @objc func touchTapped(_ sender: UITapGestureRecognizer) {
            let vc = LIVE_videoNew.getVC(.videoStoryBoard)
            self.navigationController?.pushViewController(vc, animated: false)
        }
    @objc func touchTapped2(_ sender: UITapGestureRecognizer) {
        let phoneNumber = "+923075265787"

              let urlString = "https://wa.me/\(phoneNumber)"
              
              if let url = URL(string: urlString) {
                  if UIApplication.shared.canOpenURL(url) {
                      UIApplication.shared.open(url, options: [:], completionHandler: nil)
                  } else {
                   
                      let alert = UIAlertController(title: "Error", message: "WhatsApp is not installed on your device.", preferredStyle: .alert)
                      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                      self.present(alert, animated: true, completion: nil)
                  }
              }
    }
    override var canBecomeFirstResponder: Bool {
        get {
            return true
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
         super.viewWillAppear(animated)
        
       
        self.getDeliveryDate()
        let imageDataDict:[String: String] = ["img": "World_Button"]
        NotificationCenter.default.post(name: Notification.Name("globe"), object: nil,userInfo: imageDataDict)
        self.navigationController?.isNavigationBarHidden = true
        self.cartCountView.isHidden = true
        getCartProducts()
        if(AppDefault.islogin ){
            
            if AppDefault.wishlistproduct != nil{
                wishList(isbackground: true)
            }else{
                wishList(isbackground: false)
            }
            
            
            }
       
        
        homeswitchbtn.isOn = false
        self.LanguageRender()
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        view.endEditing(true)
    }
    func LanguageRender() {
        searchFeild.placeholder = "whatareyoulookingfor".pLocalized(lang: LanguageManager.language)
        livelbl.text = "live".pLocalized(lang: LanguageManager.language)
        hotdealslbl.text = "hotdeals".pLocalized(lang: LanguageManager.language)
        viewalllbl.setTitle("viewall".pLocalized(lang: LanguageManager.language), for: .normal)
        
        recommendationLbl.attributedText = Utility().attributedStringWithColoredLastWordBold("latestmobiles".pLocalized(lang: LanguageManager.language), lastWordColor: UIColor(named: "headercolor")!, otherWordsColor: .black)
        shopByCatLbl.attributedText = Utility().attributedStringWithColoredLastWordBold("shopbycategories".pLocalized(lang: LanguageManager.language), lastWordColor: UIColor(named: "headercolor")!, otherWordsColor: .black)
        shoplabel.text = "shopbeyoundboundaries".pLocalized(lang: LanguageManager.language)
//        topcategorieslbl.attributedText = Utility().attributedStringWithColoredLastWordBold("topcategories".pLocalized(lang: LanguageManager.language), lastWordColor: UIColor(named: "headercolor")!, otherWordsColor: .black)
        langLbl.text = "language".pLocalized(lang: LanguageManager.language)

                if LanguageManager.language == "ar"{
                    topCatBackBtn.setImage(UIImage(systemName: "arrow.left"), for: .normal)
                    latestBackBtn.setImage(UIImage(systemName: "arrow.left"), for: .normal)
                   }else{
                    topCatBackBtn.setImage(UIImage(systemName: "arrow.right"), for: .normal)
                    latestBackBtn.setImage(UIImage(systemName: "arrow.right"), for: .normal)
                   }
                
                UIView.appearance().semanticContentAttribute = LanguageManager.language == "ar" ? .forceRightToLeft : .forceLeftToRight
                UITextField.appearance().textAlignment = LanguageManager.language == "ar" ? .right : .left
        UICollectionView.appearance().semanticContentAttribute = LanguageManager.language == "ar" ? .forceRightToLeft : .forceLeftToRight
        UICollectionViewCell.appearance().semanticContentAttribute = LanguageManager.language == "ar" ? .forceRightToLeft : .forceLeftToRight
        

        if LanguageManager.language == "ar" {
            topcell_1.transform = CGAffineTransform(scaleX: -1, y: 1)
            pagerView.transform = CGAffineTransform(scaleX: -1, y: 1)
            pageControl.transform = CGAffineTransform(scaleX: -1, y: 1)
        } else {
            topcell_1.transform = .identity
            pagerView.transform = .identity
            pageControl.transform = .identity
        }

    }
    
    func wishList(isbackground:Bool){
        APIServices.wishlist(isbackground: isbackground){[weak self] data in
          switch data{
          case .success(let res):
     
            AppDefault.wishlistproduct = res.products
   
            self?.homeLastProductCollectionView.reloadData()
              self?.lastRandomProductsCollectionView.reloadData()
          case .failure(let error):
            print(error)
          }
        }
      }
    func getDeliveryDate(){
        APIServices.getDeliveryDate(){[weak self] data in
          switch data{
          case .success(let res):
      
              AppDefault.getDeliveryDate = res
           
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
                      self?.present(vc, animated: true, completion: nil)
                  }
              }
          }
        })
      }

    
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
           if sender.isOn {
               AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))

               let vc = LIVE_videoNew.getVC(.videoStoryBoard)
               self.navigationController?.pushViewController(vc, animated: false)
           }
       }
    
    @IBAction func searchTapped(_ sender: Any) {
        let vc = Search_ViewController.getVC(.searchStoryBoard)
        if(searchFeild.text?.count == 0){
            self.navigationController?.pushViewController(vc, animated: false)
           
        }else{
        
            vc.searchText = searchFeild.text
            self.navigationController?.pushViewController(vc, animated: false)
        }
       
    }
    
    @IBAction func languageBtnTapped(_ sender: Any) {
        
        
        appDelegate.showCustomerLanguageAlertControllerHeight(title: "selectlanguage".pLocalized(lang: LanguageManager.language), heading: "", btn1Title: "cancel".pLocalized(lang: LanguageManager.language), btn1Callback: {
            AppDefault.languages = LanguageManager.language
        }, btn2Title: "apply".pLocalized(lang: LanguageManager.language)) {
            LanguageManager.language =  AppDefault.languages
            UIView.appearance().semanticContentAttribute = LanguageManager.language == "ar" ? .forceRightToLeft : .forceLeftToRight

            UITextField.appearance().textAlignment = LanguageManager.language == "ar" ? .right : .left
            NotificationCenter.default.post(name: Notification.Name("RefreshAllTabs"), object: nil)
            UICollectionView.appearance().semanticContentAttribute = .forceLeftToRight
        
            appDelegate.GotoDashBoard(ischecklogin: false)
          
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
    @IBAction func gotoCategoriesBtnTapped(_ sender: Any) {
        let vc = CategoriesVC
            .getVC(.main)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    private func bannerApi(isbackground:Bool){
        APIServices.banner(isbackground: isbackground, completion: {[weak self] data in
            switch data{
            case .success(let res):
                print(data)
                AppDefault.Bannerdata = res
                if(res.count > 0){
                    let banners =  res
                    
                    if LanguageManager.language == "ar" {
                        for item in res{
                            let objext = item.id
                            if objext?.bannerName == "Customer App Home Arabic" {
                                self?.bannerapidata = (objext?.banners)!
                            }
                        }
                    }else {
                        for item in res{
                            let objext = item.id
                            if objext?.bannerName == "Mob Banner Home" {
                                self?.bannerapidata = (objext?.banners)!
                            }
                        }
                    }

                    
                    self?.pageControl.numberOfPages = self?.bannerapidata?.count ?? 0
                    self?.pageControl.currentPage = 0
                }
    
            case .failure(let error):
                print(error)
                self?.view.makeToast(error)
            }
        }
        )
    }
    private func categoriesApi(isbackground:Bool) {
        APIServices.getAllCategories(isbackground:isbackground,completion: {[weak self] data in
            switch data{
            case .success(let res):
                for i in (0 ..< (self?.CategoriesResponsedata.count ?? 0)).reversed() {
              
                    self?.CategoriesResponsedata[i].subCategories?.removeAll(where: {$0.categorySpecs?.productsCount == 0})
                }
                for i in (0 ..< (self?.UpdatedCategoriesResponsedata.count ?? 0)).reversed() {
              
                    self?.UpdatedCategoriesResponsedata[i].subCategories?.removeAll(where: {$0.categorySpecs?.productsCount == 0})
                }
                self?.CategoriesResponsedata = res
                self?.UpdatedCategoriesResponsedata = res
                
                let hotDealsCategory = getAllCategoryResponse(
                              type: "",
                              platform: "",
                              name: "Hot Deals",
                              mainImage: "Brandsimg",
                              slug: "",
                              categorySpecs: nil,
                              lang: DatumLang(ar: PurpleAr(
                                  name: "العروض الساخنة",
                                  description: "",
                                  bannerImage: "",
                                  wideBannerImage: "",
                                  wideBannerImageAr: ""
                              )),
                              subCategories: [],
                              id: ""
                          )
                self?.UpdatedCategoriesResponsedata.insert(hotDealsCategory, at: 0)
                
                AppDefault.getAllCategoriesResponsedata = res
                
                self?.topcell_1.reloadData()
            case .failure(let error):
                print(error)
                self?.view.makeToast(error)
            }
        })
    }
    
    private func productcategoriesApi(cat:String,cat2:String,cat3:String,cat4:String,cat5:String,cat6:String,isbackground:Bool){
        APIServices.productcategories(cat: cat, cat2: cat2, cat3: cat3, cat4: cat4, cat5: cat5, cat6: cat6,isbackground:isbackground ) {[weak self] data in
            switch data{
            case .success(let res):
                AppDefault.productcategoriesApi = res
                if(res.count > 0){
                    self?.ProductCategoriesResponsedata = res
                    
                    // Create a dictionary to map id to its index in the desired order
                    let orderMap = Dictionary(uniqueKeysWithValues: (self?.catSequence.enumerated().map { ($1, $0) })!)

                    // Sort the data array based on the index in desired order
                    let sortedData = res.sorted {
                        (orderMap[$0.id ?? ""] ?? Int.max) < (orderMap[$1.id ?? ""] ?? Int.max)
                    }
                    
                    
                    self?.ProductCategoriesResponsedata = sortedData
                    
                    self?.tableViewHeight.constant = CGFloat(770 * (self?.ProductCategoriesResponsedata.count ?? 0))
                    
                    let hh = (300 * 3) + 1440
                    let ll = ((self?.getrandomproductapiModel.count ?? 0) / 2) * 288
                    let final = hh + ll

                    self?.scrollHeight.constant = CGFloat(final) + (self?.hotDealViewHeight.constant ?? 0) + (self?.tableViewHeight.constant ?? 0)
                }
                self?.lastRandomProductsCollectionView.reloadData()
                self?.homeTblView.reloadData()
            case .failure(let error):
                print(error)
                self?.view.makeToast(error)
            }
        }
    }

    private func randomproduct(cat:String,cat2:String,cat3:String,cat4:String,cat5:String,isbackground : Bool){
        APIServices.productcategories(cat: cat, cat2: cat2, cat3: cat3, cat4: cat4, cat5: cat5, cat6: "",isbackground:isbackground,completion: {[weak self] data in
            switch data{
            case .success(let res):
            
             
                if(res.first?.product?.count  == 0){
                    self?.homelastproductsview.constant = 0
                    self?.latestmobilesectionview.isHidden = true
                    
                }else{
                    self?.latestmobilesectionview.isHidden = false
                    AppDefault.randonproduct = res
                    self?.randomproductapiModel = res
                    self?.homelastproductsview.constant =  0 //617
                    self?.homeLastProductCollectionView.reloadData()
                    
                }
           
               
                
            case .failure(let error):
                self?.homelastproductsview.constant = 0

                self?.latestmobilesectionview.isHidden = true
                
                print(error)
                self?.view.makeToast(error)
            }
        })
    }
    
    private func getrandomproduct(isbackground:Bool){
        load = false
        APIServices.getrandomproduct(isbackground:isbackground,completion: {[weak self] data in
            switch data{
            case .success(let res):
            
                if(res.count > 0){
                    AppDefault.getrandomproductapiModel = res
                    self?.getrandomproductapiModel.append(contentsOf: res)
                }
              
                self?.tableViewHeight.constant = CGFloat(770 * (self?.ProductCategoriesResponsedata.count ?? 0))
                
                let hh = (300 * 3) + 1440
                let ll = ((self?.getrandomproductapiModel.count ?? 0) / 2) * 288
                let final = hh + ll

                self?.scrollHeight.constant = CGFloat(final) + (self?.hotDealViewHeight.constant ?? 0) + (self?.tableViewHeight.constant ?? 0)
               
                self?.lastRandomProductsCollectionView.reloadData()
                self?.load = true
            case .failure(let error):
                print(error)
                self?.view.makeToast(error)
            }
        })
    }
    
    private func groupByDeals(limit:Int,page:Int,isbackground : Bool){
        APIServices.groupByDeals(limit: limit, page: page, isbackground: isbackground,completion: {[weak self] data in
            switch data{
            case .success(let res):
                AppDefault.groupbydealdata = res.result
                if(res.result?.count ?? 0 > 0){
                    AppDefault.groupbydealdata = res.result
                    self?.groupbydealsdata = res.result ?? []
                    self?.hotDealViewHeight.constant = 300
                    self?.hotDealView.isHidden = false
                    self?.hotDealCollectionV.reloadData()
                }
               
            case .failure(let error):
                print(error)

            }
        })
    }
    
    @IBAction func hotDealViewAllBtnTapped(_ sender: Any) {
        let vc = HotDealProductsViewController.getVC(.oldStoryboard)
        vc.groupbydealsdata = self.groupbydealsdata
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
                let vc = NewProductPageViewController.getVC(.productStoryBoard)
                
                  vc.slugid = appDelegate.slugid
                self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc func cartCountReceivedNotification(notification: Notification) {
        if let count = notification.userInfo?["count"] as? Int {
            print("countttt \(count)")
            self.cartCount.text = "\(count)"
            if count > 0 {
                cartCountView.isHidden = false
            }
          }
    }

    @objc func videocallmethod(notification: Notification) {
            
        let vc = VideoViewController.getVC(.videoStoryBoard)
        vc.accessToken = appDelegate.videotoken
        vc.videoCallId = appDelegate.videoid
     
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func setupPageControl() {
        pageController.numberOfPages = bannerapidata?.count ?? 0
        pageController.pageIndicatorTintColor = UIColor.gray
        pageController.currentPageIndicatorTintColor = UIColor.red

        pageController.currentPage = 0
        
        if LanguageManager.language == "ar" {
            imageslidercollectionview.semanticContentAttribute = .forceLeftToRight
            hederView.semanticContentAttribute = .forceLeftToRight
        }else {
            imageslidercollectionview.semanticContentAttribute = .forceLeftToRight
            hederView.semanticContentAttribute = .forceLeftToRight
        }
        
    
    }

    @IBAction func shopByCatArrowBtnTapped(_ sender: Any) {

        tabBarController?.selectedIndex = 1

    }
    @IBAction func latestMobileArrowBtnTapped(_ sender: Any) {
        let vc = Category_ProductsVC.getVC(.productStoryBoard)
            vc.prductid = "66fa5e0856711740c06380d2"
           vc.video_section = false
           vc.storeFlag = false
           vc.catNameTitle = "latestmobiles".pLocalized(lang: LanguageManager.language)
        self.navigationController?.pushViewController(vc, animated: false)
    }
}

extension HomeController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == imageslidercollectionview {
            return  bannerapidata?.count ?? 0
        }else if collectionView == homeLastProductCollectionView {
            return self.randomproductapiModel.first?.product?.count ?? 0
        }else if collectionView == hotDealCollectionV {
            return groupbydealsdata.count
        } else if collectionView == lastRandomProductsCollectionView {
            return self.getrandomproductapiModel.count

        } else {
            return self.UpdatedCategoriesResponsedata.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == imageslidercollectionview {
            let data = bannerapidata?[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
            cell.imageView.pLoadImage(url: data?.image ?? "")

            return cell
        } else if collectionView == homeLastProductCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeLastProductCollectionViewCell", for: indexPath) as! HomeLastProductCollectionViewCell
            let data = randomproductapiModel.first?.product?[indexPath.row]

            cell.product = data
            cell.productimage.pLoadImage(url: data?.mainImage ?? "")
            if LanguageManager.language == "ar"{
                cell.productname.text = data?.lang?.ar?.productName ?? data?.productName
            }else{
                cell.productname.text =  data?.productName
            }

            if data?.onSale == true {
                cell.discountPrice.isHidden = false
                cell.productPrice.isHidden = false
                cell.discountPrice.attributedText = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(data?.salePrice ?? 0, label:  cell.discountPrice))
                cell.productPrice.attributedText = "\(appDelegate.currencylabel) \(Utility().formatNumberWithCommas(data?.regularPrice ?? 0, label:   cell.productPrice).trimmingCharacters(in: .whitespaces))".strikeThrough()
                cell.productPriceLine.isHidden = true
                cell.productPrice.textColor = UIColor.red
                cell.productPriceLine.backgroundColor = UIColor.red
                cell.percentBGView.isHidden = false

            }else {
                cell.productPriceLine.isHidden = true
                cell.productPrice.isHidden = true
                cell.discountPrice.attributedText =
                Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(data?.regularPrice ?? 0, label:   cell.discountPrice))
                cell.percentBGView.isHidden = true
             }
            
            cell.heartBtn.tag = indexPath.row
            cell.cartButton.tag = indexPath.row
            cell.cartButton.addTarget(self, action: #selector(cartButtonTap(_:)), for: .touchUpInside)
            cell.heartBtn.addTarget(self, action: #selector(homeLatestMobileheartButtonTap(_:)), for: .touchUpInside)
            
            if let wishlistProducts = AppDefault.wishlistproduct {
                    if wishlistProducts.contains(where: { $0.id == data?.id }) {
                      cell.heartBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                      cell.heartBtn.tintColor = .red
                    } else {
                      cell.backgroundColor = .white
                      cell.heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
                      cell.heartBtn.tintColor = .white
                    }
                  }
            
            return cell
        } else if collectionView == hotDealCollectionV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotDealCollectionViewCell", for: indexPath) as! HotDealCollectionViewCell
            let data = groupbydealsdata[indexPath.row]
            
            cell.mainImage.pLoadImage(url: data.productID?.mainImage ?? "")
            cell.brandName.text =  data.productID?.productName
            cell.regularPrice.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(data.productID?.regularPrice ?? 0, label: cell.regularPrice)
            cell.regularPrice.attributedText = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(data.productID?.salePrice ?? 0, label:   cell.regularPrice))
            cell.days.text = "\(data.remainingTime?.days ?? 0)"
            cell.hours.text = "\(data.remainingTime?.hours ?? 0)"
            cell.minutes.text = "\(data.remainingTime?.minutes ?? 0)"
            cell.dayslbl.text = "days".pLocalized(lang: LanguageManager.language)
            cell.hrslbl.text = "hrs".pLocalized(lang: LanguageManager.language)
            cell.minslbl.text = "mins".pLocalized(lang: LanguageManager.language)
            if data.productID?.onSale == true {
                cell.salePrice.isHidden = false
                cell.salePrice.text =   appDelegate.currencylabel + Utility().formatNumberWithCommas(data.productID?.salePrice ?? 0, label:  cell.salePrice)
                cell.salePrice.attributedText = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(data.productID?.salePrice ?? 0, label:  cell.salePrice))
                cell.productPriceLine.isHidden = false
                cell.regularPrice.textColor = UIColor.red
                cell.salePrice.textColor = primaryColor!
                cell.productPriceLine.backgroundColor = UIColor.red
            }else {
                cell.salePrice.isHidden = true
                cell.productPriceLine.isHidden = true
                cell.regularPrice.textColor = primaryColor!

             }
           
            return cell
        }else if collectionView == lastRandomProductsCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeLastProductCollectionViewCell", for: indexPath) as! HomeLastProductCollectionViewCell
            let data = getrandomproductapiModel[indexPath.row]

            cell.product = data
            cell.productimage.pLoadImage(url: data.mainImage ?? "")

            if LanguageManager.language == "ar"{
                cell.productname.text = data.lang?.ar?.productName ?? data.productName
            }else{
                cell.productname.text =  data.productName
            }
            
            if data.onSale == true {
                cell.discountPrice.isHidden = false
                cell.productPrice.isHidden = false
                cell.discountPrice.attributedText = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(data.salePrice ?? 0, label: cell.discountPrice))
                cell.productPrice.attributedText = "\(appDelegate.currencylabel) \(Utility().formatNumberWithCommas(data.regularPrice ?? 0, label:     cell.productPrice).trimmingCharacters(in: .whitespaces))".strikeThrough()
                cell.productPriceLine.isHidden = true
                cell.productPrice.textColor = UIColor.red
                cell.productPriceLine.backgroundColor = UIColor.red
                cell.percentBGView.isHidden = false
            }else {
                cell.productPriceLine.isHidden = true
                cell.productPrice.isHidden = true
                cell.discountPrice.attributedText = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(data.regularPrice ?? 0, label:    cell.discountPrice))
                cell.percentBGView.isHidden = true
             }
            
            cell.heartBtn.tag = indexPath.row
            cell.cartButton.tag = indexPath.row
            cell.cartButton.addTarget(self, action: #selector(lastRandomProductcartButtonTap(_:)), for: .touchUpInside)
            cell.heartBtn.addTarget(self, action: #selector(trendingProductHeartBtnTapped(_:)), for: .touchUpInside)
            
            if let wishlistProducts = AppDefault.wishlistproduct {
                    if wishlistProducts.contains(where: { $0.id == data._id }) {
                      cell.heartBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                      cell.heartBtn.tintColor = .red
                    } else {
                      cell.backgroundColor = .white
                      cell.heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
                      cell.heartBtn.tintColor = .white
                    }
                  }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topcategoriescell", for: indexPath) as! topcategoriescell
            let data = UpdatedCategoriesResponsedata[indexPath.row]
            if(indexPath.row == 0){
                cell.imageView.image  = UIImage(named: data.mainImage ?? "")
            }else{
                cell.imageView.pLoadImage(url: data.mainImage ?? "")
            }
          
            
            
            if LanguageManager.language == "ar" && data.lang?.ar != nil{
                cell.topCatLbl.text = data.lang?.ar?.name ?? data.name
            }else{
                cell.topCatLbl.text = data.name
            }
            if LanguageManager.language == "ar" {
                 cell.contentView.transform = CGAffineTransform(scaleX: -1, y: 1)
             } else {
                 cell.contentView.transform = .identity
             }
            
            return cell
        }
    }
    
    @objc func homeLatestMobileheartButtonTap(_ sender: UIButton) {
        if(AppDefault.islogin){
              let index = sender.tag
              let item = randomproductapiModel.first?.product?[index]
            if item?.id == nil {
                self.wishListApi(productId: (item?._id ?? ""))
            }else {
                self.wishListApi(productId: (item?.id ?? ""))
            }            }else{
                let vc = PopupLoginVc.getVC(.popups)
              vc.modalPresentationStyle = .overFullScreen
              self.present(vc, animated: true, completion: nil)
            }
    }
    @objc func trendingProductHeartBtnTapped(_ sender: UIButton) {
        if(AppDefault.islogin){
              let index = sender.tag
              let item = getrandomproductapiModel[index]
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
    
    func applyGradientBackground(to view: UIView, topColor: UIColor, bottomColor: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == homeLastProductCollectionView {
            return 8
        }else if collectionView == lastRandomProductsCollectionView {
            return 8
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == homeLastProductCollectionView  {
            return 5
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == imageslidercollectionview {
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        }else if collectionView == homeLastProductCollectionView {
            return CGSize(width: homeLastProductCollectionView.frame.width/2, height: 280)
        } else if collectionView == hotDealCollectionV {
            return CGSize(width: self.hotDealCollectionV.frame.width/1.2, height: self.hotDealCollectionV.frame.height)

        } else if collectionView == lastRandomProductsCollectionView {
            return CGSize(width: self.lastRandomProductsCollectionView.frame.width/2.1-5, height: 280)

        } else {
            let data = UpdatedCategoriesResponsedata[indexPath.row]

                return CGSize(width: self.topcell_1.frame.width/3.9-10, height: self.topcell_1.frame.height/2-5)

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == lastRandomProductsCollectionView {
           return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        }else {
            return  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == imageslidercollectionview {
            let data = self.bannerapidata?[indexPath.row]
            if data?.type == "" || data?.type == nil {
                
            }else {
                switch data?.type {
                    
                  case "Market":
                    let vc = StoreSearchVC.getVC(.searchStoryBoard)
                    vc.isMarket = true
                    vc.marketID = data?.linkId
                    vc.isNavBar = false
                    self.navigationController?.pushViewController(vc, animated: false)

                  case "Store":
                    if data?.linkId == "" || data?.linkId == nil {
                        
                    }else {
                        let vc = New_StoreVC.getVC(.productStoryBoard)
                        vc.prductid = data?.linkId ?? ""
//                        vc.brandName = data?.name
                        vc.storeId = data?.linkId ?? ""
                        vc.sellerID = data?.linkId ?? ""
                        self.navigationController?.pushViewController(vc, animated: false)
                    }

                  case "Category":
                    if data?.linkId == "" || data?.linkId == nil {
                        
                    }else {
                        let vc = Category_ProductsVC.getVC(.productStoryBoard)
                        vc.prductid = data?.linkId ?? ""
                        vc.video_section = false
                        vc.storeFlag = false
                        vc.catNameTitle = data?.name ?? ""
                        self.navigationController?.pushViewController(vc, animated: false)
                    }
                    
                  case "Product":
                    if data?.linkId == "" || data?.linkId == nil {
                        
                    }else {
                        let vc = NewProductPageViewController.getVC(.productStoryBoard)

                        vc.slugid = data?.linkId
                        self.navigationController?.pushViewController(vc, animated: false)
                    }
                    
                  case "Video":
                    let vc = LIVE_videoNew.getVC(.videoStoryBoard)
                    self.navigationController?.pushViewController(vc, animated: false)
                    
                  case "Page":
                    print("page")
                      let vc = Page_Vc.getVC(.main)
                    vc.collectionId = data?.linkId ?? ""
                      self.navigationController?.pushViewController(vc, animated: false)

                  default:
                        print("Invalid data")
                }
            }

            
        }else if collectionView == homeLastProductCollectionView {
            let data = randomproductapiModel.first?.product?[indexPath.row]
            let vc = NewProductPageViewController.getVC(.productStoryBoard)

                       vc.slugid = data?.slug
            self.navigationController?.pushViewController(vc, animated: false)
        }else if collectionView == hotDealCollectionV {
            let data = groupbydealsdata[indexPath.row]
            let vc = NewProductPageViewController.getVC(.productStoryBoard)

            vc.slugid = data.productID?.slug
            self.navigationController?.pushViewController(vc, animated: false)
        } else if collectionView == lastRandomProductsCollectionView {
            let data = getrandomproductapiModel[indexPath.row]

            let vc = NewProductPageViewController.getVC(.productStoryBoard)

            vc.slugid = data.slug
            self.navigationController?.pushViewController(vc, animated: false)
        }else {
              let data = UpdatedCategoriesResponsedata[indexPath.row]
            if(indexPath.row == 0){
                let vc = HotDealView.getVC(.sidemenu)
                

                self.navigationController?.pushViewController(vc, animated: false)
            }else{
                let vc = Category_ProductsVC.getVC(.productStoryBoard)
                vc.prductid = data.id ?? ""
                vc.video_section = false
                vc.storeFlag = false
              vc.catNameTitle = (LanguageManager.language == "ar" ? data.lang?.ar?.name ?? data.name : data.name ?? "")!
                self.navigationController?.pushViewController(vc, animated: false)
            }
            
          }
        
    }
    
    private func getStreamingVideos(limit:Int,page:Int,categories: [String],city:String){
        APIServices.getStreamingVideos(limit:limit,page:page,categories:categories,userId:"", city: city,completion: {[weak self] data in
            switch data{
            case .success(let res):
                AppDefault.LiveStreamingResultsdata = res.results ?? []
            case .failure(let error):
                print(error)

            }
        })
    }
    
    
    
}

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == shopbeyound_tblview{
            return 3
        }else{
            return ProductCategoriesResponsedata.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  tableView == shopbeyound_tblview{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Shopbeyound_TableViewCell", for: indexPath) as! Shopbeyound_TableViewCell
            
            if indexPath.row == 1 {
                if LanguageManager.language == "ar" {
                    let attributedText1 =  Utility().attributedStringWithColoredLastWord(shopBeyonLblArrayar[indexPath.row], lastWordColor: .red, otherWordsColor: .black)
                    cell.shopname_lbl.attributedText = attributedText1

                }else{
                    let attributedText1 =  Utility().attributedStringWithColoredLastWord(shopBeyonLblArray[indexPath.row], lastWordColor: .red, otherWordsColor: .black)
                    cell.shopname_lbl.attributedText = attributedText1

                }
            }else {
                if LanguageManager.language == "ar"{
                    let attributedText1 =  Utility().attributedStringWithColoredLastWord(shopBeyonLblArrayar[indexPath.row], lastWordColor: .green, otherWordsColor: .black)
                    cell.shopname_lbl.attributedText = attributedText1

                }else{
                    let attributedText1 =  Utility().attributedStringWithColoredLastWord(shopBeyonLblArray[indexPath.row], lastWordColor: .green, otherWordsColor: .black)
                    cell.shopname_lbl.attributedText = attributedText1

                }
  
            }
            cell.exploreNowLbl.text = "explorenow".pLocalized(lang: LanguageManager.language)
                    if LanguageManager.language == "ar"{
                        cell.exploreNowArrow.setImage(UIImage(systemName: "chevron.left"), for: .normal)
                       }else{
                           cell.exploreNowArrow.setImage(UIImage(systemName: "chevron.right"), for: .normal)
                       }
            cell.shop_img.image = shopBeyonimagesArray[indexPath.row]
            cell.explore_btn.tag = indexPath.row
            cell.explore_btn.addTarget(self, action: #selector(exploreBtnTapped(_:)), for: .touchUpInside)
            cell.bgView.backgroundColor = shopBeyondBGColorArray[indexPath.row]
            
            cell.CategoriesResponsedata = self.CategoriesResponsedata
            self.count += 1
            cell.count = self.count
            cell.nav = navigationController
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell

            let data = ProductCategoriesResponsedata[indexPath.row]
            
            
            if LanguageManager.language == "ar"{
                cell.cateogorylbl.attributedText =  Utility().attributedStringWithColoredLastWordBold(data.lang?.ar?.name?.capitalized ?? "", lastWordColor: UIColor(named: "headercolor")!, otherWordsColor: .black)
                cell.img.pLoadImage(url: data.lang?.ar?.wideBannerImage ?? "")
                cell.arrowBtn.setImage(UIImage(systemName: "arrow.left"), for: .normal)
            }else{
        cell.cateogorylbl.attributedText = Utility().attributedStringWithColoredLastWordBold(data.name?.capitalized ?? "", lastWordColor: UIColor(named: "headercolor")!, otherWordsColor: .black)
                cell.img.pLoadImage(url: data.wideBannerImage ?? "")
                cell.arrowBtn.setImage(UIImage(systemName: "arrow.right"), for: .normal)
            }

            cell.productapi = data.product ?? []
            
            cell.catBannerBtn.tag = indexPath.row
            cell.arrowBtn.tag = indexPath.row
            cell.nav = self.navigationController
            cell.catBannerBtn.addTarget(self, action: #selector(catBannerBtnTapped(_:)), for: .touchUpInside)
            cell.arrowBtn.addTarget(self, action: #selector(arrowBtnTapped(_:)), for: .touchUpInside)

            return cell
        }
    }
    @objc func exploreBtnTapped(_ sender: UIButton) {
        if sender.tag == 0 {
            let vc = ShopChina_VC.getVC(.main)
            vc.shop = "shoppakistan".pLocalized(lang: LanguageManager.language)
            vc.color = "#F7FFF2"
            vc.shopImg = "shop_pak"
            UIApplication.pTopViewController().navigationController?.pushViewController(vc, animated: false)
            
           
        }else if sender.tag == 1 {
            let vc = ShopChina_VC.getVC(.main)
            vc.shop = "shopchina".pLocalized(lang: LanguageManager.language)
            vc.color = "#FFCDC9"
            vc.shopImg = "shop_china"
            vc.shoptxtColor = "#DC2A1B"
            UIApplication.pTopViewController().navigationController?.pushViewController(vc, animated: false)
            
        } else {
            let vc = ShopChina_VC.getVC(.main)
            vc.shop = "shopsaudia".pLocalized(lang: LanguageManager.language)
            vc.color = "#DEFFF1"
            vc.shopImg = "shop_saudi"
            vc.shoptxtColor = "#028E53"
            UIApplication.pTopViewController().navigationController?.pushViewController(vc, animated: false)
        }
    }
    @objc func catBannerBtnTapped(_ sender: UIButton) {
        let data = ProductCategoriesResponsedata[sender.tag]
        
        let vc = Category_ProductsVC.getVC(.productStoryBoard)
        vc.prductid = data.id ?? ""
        vc.video_section = false
        vc.storeFlag = false
        vc.catNameTitle = LanguageManager.language == "ar" ? data.lang?.ar?.name ?? "" : data.name ?? ""
        self.navigationController?.pushViewController(vc, animated: false)

    }
    @objc func arrowBtnTapped(_ sender: UIButton) {
        let data = ProductCategoriesResponsedata[sender.tag]
        
        let vc = Category_ProductsVC.getVC(.productStoryBoard)
        vc.prductid = data.id ?? ""
        vc.video_section = false
        vc.storeFlag = false
        vc.catNameTitle = LanguageManager.language == "ar" ? data.lang?.ar?.name ?? "" : data.name ?? ""
        self.navigationController?.pushViewController(vc, animated: false)

    }
    @objc func cartButtonTap(_ sender: UIButton) {
        
        if AppDefault.islogin == true {
            let data = randomproductapiModel.first?.product?[sender.tag]
            
            if (data?.variants?.countVariants() ?? 0 > 0) {
                let vc = NewProductPageViewController.getVC(.productStoryBoard)
                vc.slugid = data?.slug
                navigationController?.pushViewController(vc, animated: false)
            }else {
                let vc = CartPopupViewController.getVC(.popups)
               
                vc.modalPresentationStyle = .custom
                vc.transitioningDelegate = centerTransitioningDelegate
                vc.products = data
                vc.nav = self.navigationController
                self.present(vc, animated: true, completion: nil)
                
            }
        }else {
            let vc = PopupLoginVc.getVC(.popups)
           vc.modalPresentationStyle = .overFullScreen
           self.present(vc, animated: true, completion: nil)
        }


    }
    @objc func lastRandomProductcartButtonTap(_ sender: UIButton) {
        let data = getrandomproductapiModel[sender.tag]
        
        if AppDefault.islogin == true {
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
                self.present(vc, animated: true, completion: nil)
                
            }
        }else {
            let vc = PopupLoginVc.getVC(.popups)
           vc.modalPresentationStyle = .overFullScreen
           self.present(vc, animated: true, completion: nil)
        }
        

    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == shopbeyound_tblview{
            return 343
            
        }else {
            return 770
        }
    }
}


extension HomeController {
    
    func SocketConeect() {
       
        manager = SocketManager(socketURL: AppConstants.API.chinesBellUrl, config: [.log(true),
                                                                                  .compress,
                                                                                  .forceWebsockets(true),.connectParams( ["token":AppDefault.accessToken])])
        socket = manager?.socket(forNamespace: "/chat/v1/notification")

        socket?.on(clientEvent: .connect) { (data, ack) in

         
           }
        self.socket?.on("notifyChineseBell") { data, ack in
            print("chinise bell",data)
        
        }
     
        
        socket?.connect()
        
        socket?.on(clientEvent: .disconnect) { data, ack in

           print("Socket disconnected")
       }
      
    }

    
}

extension HomeController: FSPagerViewDataSource, FSPagerViewDelegate {
func numberOfItems(in pagerView: FSPagerView) -> Int {
       return  bannerapidata?.count ?? 0
   }

   func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
       let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
       let data = bannerapidata?[index]
       cell.imageView?.pLoadImage(url: data?.image ?? "")
       if LanguageManager.language == "ar" {
              cell.imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
          } else {
              cell.imageView?.transform = .identity
          }
       cell.imageView?.contentMode = .scaleAspectFill
       return cell
   }


   func pagerViewDidScroll(_ pagerView: FSPagerView) {
       let currentIndex = pagerView.currentIndex
       pageControl.currentPage = currentIndex
   }
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        let data = self.bannerapidata?[index]
        if data?.type == "" || data?.type == nil {
            
        }else {
            switch data?.type {
                
              case "Market":
                let vc = StoreSearchVC.getVC(.searchStoryBoard)
                vc.isMarket = true
                vc.marketID = data?.linkId
                vc.isNavBar = false
                self.navigationController?.pushViewController(vc, animated: false)

              case "Store":
                if data?.linkId == "" || data?.linkId == nil {
                    
                }else {
                    let vc = New_StoreVC.getVC(.productStoryBoard)
                    vc.prductid = data?.linkId ?? ""
//                    vc.brandName = data?.name
                    vc.storeId = data?.linkId ?? ""
                    vc.sellerID = data?.linkId ?? ""
                    self.navigationController?.pushViewController(vc, animated: false)
                }

              case "Category":
                if data?.linkId == "" || data?.linkId == nil {
                    
                }else {
                    let vc = Category_ProductsVC.getVC(.productStoryBoard)
                    vc.prductid = data?.linkId ?? ""
                    vc.video_section = false
                    vc.storeFlag = false
                    vc.catNameTitle = data?.name ?? ""
                    self.navigationController?.pushViewController(vc, animated: false)
                }
                
              case "Product":
                if data?.linkId == "" || data?.linkId == nil {
                    
                }else {
                    let vc = NewProductPageViewController.getVC(.productStoryBoard)

                    vc.slugid = data?.linkId
                    self.navigationController?.pushViewController(vc, animated: false)
                }
                
              case "Video":
                let vc = LIVE_videoNew.getVC(.videoStoryBoard)
                self.navigationController?.pushViewController(vc, animated: false)
                
              case "Page":
                print("page")
                let vc = HotDealProducts.getVC(.sidemenu)
                vc.headerName = data?.name ?? ""
                vc.id = data?.linkId ?? ""
                self.navigationController?.pushViewController(vc, animated: false)
              default:
                    print("Invalid data")
            }
        }

    }
}


class CenterPresentationController: UIPresentationController {

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else {
            return CGRect()
        }
        
  
        let width: CGFloat = containerView.frame.width - 30
        let height: CGFloat = 500
        
       
        let x = (containerView.bounds.width - width) / 2
        let y = (containerView.bounds.height - height) / 2
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
   
        guard let containerView = containerView else { return }
        let dimmingView = UIView(frame: containerView.bounds)
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        containerView.addSubview(dimmingView)
        
    
        containerView.addSubview(presentedViewController.view)
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()

    }
}


class CenterTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CenterPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension HomeController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
   
        textField.resignFirstResponder()
        
        let vc = Search_ViewController.getVC(.searchStoryBoard)
        if(textField.text?.count == 0){
            self.navigationController?.pushViewController(vc, animated: false)
           
        }else{
        
            vc.searchText = textField.text
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
        return true
    }
}


extension HomeController {
    private func getCartProducts(){
        APIServices.getCartItems(background: true){[weak self] data in
            switch data{
            case .success(let res):
                print("")
            case .failure(let error):
                print(error)
            }
        }
    }
}



extension HomeController: UITabBarControllerDelegate {
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        // Handle Menu tab
               if viewController is MenuVc {
                   present(SideMenuManager.default.rightMenuNavigationController!, animated: true, completion: nil)
                   return false
               }
               
               // Handle Profile tab
               if let nav = viewController as? UINavigationController,
                  let rootVC = nav.viewControllers.first,
                  rootVC is ProfileViewController {

                   if AppDefault.islogin {
                       return true
                   } else {
                       let vc = PopupLoginVc.getVC(.popups)
                       vc.modalPresentationStyle = .overFullScreen
                       self.present(vc, animated: true, completion: nil)
                       return false
                   }
               }
               
               return true
           }

}
extension HomeController: ThreedsWebViewControllerDelegate {

    func threeDSWebViewControllerAuthenticationDidSucceed(_ threeDSWebViewController: ThreedsWebViewController, token: String?) {
        print(token)
    }

    func threeDSWebViewControllerAuthenticationDidFail(_ threeDSWebViewController: ThreedsWebViewController) {
        // Handle failed 3DS.
    }

}
