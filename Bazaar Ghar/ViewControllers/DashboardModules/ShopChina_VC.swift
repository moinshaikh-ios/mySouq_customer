//
//  ShopChina_VC.swift
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


class ShopChina_VC: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var bestsellerview: NSLayoutConstraint!
    
    @IBOutlet weak var trendingproductlbl: UILabel!
    @IBOutlet weak var imageslidercollectionview: UICollectionView!
    @IBOutlet weak var homeTblView: UITableView!
    @IBOutlet weak var topcell_1: UICollectionView!
    @IBOutlet weak var homeLastProductCollectionView: UICollectionView!
    
    @IBOutlet weak var pageController: UIPageControl!
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    
    @IBOutlet weak var hotdealslbl: UILabel!
    @IBOutlet weak var shoplabel: UILabel!
    // outlets
    @IBOutlet weak var topcategorieslbl: UILabel!
    @IBOutlet weak var LiveGif: UIImageView!
    @IBOutlet weak var hotDealCollectionV: UICollectionView!

    @IBOutlet weak var hotDealViewHeight: NSLayoutConstraint!
    @IBOutlet weak var hotDealView: UIView!
    @IBOutlet weak var chatBotGif: UIImageView!
    @IBOutlet weak var recommendationLbl: UILabel!

    @IBOutlet weak var shopByCatLbl: UILabel!
    @IBOutlet weak var viewalllbl: UIButton!
    @IBOutlet weak var pagerView: FSPagerView!
     @IBOutlet weak var pageControl: FSPageControl!
    @IBOutlet weak var headerBackgroudView: UIView!

    @IBOutlet weak var shopbeyound_tblview: UITableView!
    @IBOutlet weak var lastRandomProductsCollectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var shopLbl: UILabel!

    @IBOutlet weak var topshoplbl: UILabel!
    @IBOutlet weak var shopLblBackgoundView: UIView!
    @IBOutlet weak var shopImage: UIImageView!
    @IBOutlet weak var videoCollection: UICollectionView!
    @IBOutlet weak var shopingReelsLbl: UILabel!
    @IBOutlet weak var shoesCollectionView: UICollectionView!
    @IBOutlet weak var catView: UIView!

    @IBOutlet weak var reletedVideoViewHieght: NSLayoutConstraint!
    
    @IBOutlet weak var relatedVideoView: UIView!
    @IBOutlet weak var cartCount: UILabel!
    @IBOutlet weak var cartCountView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var bestSellerArrowBtn: UIButton!

    
    var cartCountShow: String? {
        didSet {
            if Int(cartCountShow ?? "0") ?? 0 > 0 {
                self.cartCountView.isHidden = false
            }
            self.cartCount.text = cartCountShow
        }
    }
    
    var KSA : [KSAcat] = []
    var China : [KSAcat] = []
    var Pak : [KSAcat] = []
    
    var catSequence = [
        "66fa5e0856711740c06380d2",
        "66fa5e0756711740c0637b48",
        "66fa5e0756711740c0637c96",
        "66fa5e0756711740c0637a82",
        "66fa5e0756711740c0637a5a",
        "66fa5e0956711740c063810e"
    ]

    
    var bannerapidata: [Banner]? = nil{
        didSet{
            self.setupPageControl()
           self.imageslidercollectionview.reloadData()
        }
    }
    var CategoriesResponsedata: [CategoriesResponse] = []
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
     
    let centerTransitioningDelegate = CenterTransitioningDelegate()
    var load:Bool?
    
    var shop:String?
    var color:String?
    var shopImg: String?
    var shoptxtColor:String?
    var catBGColor : String?
    var LiveStreamingResultsdata: [LiveStreamingResults] = [] {
        didSet {
            videoCollection.reloadData()
        }
    }
    var kk = 0
    var subCatData: [DatumSubCategory] = [] {
        didSet {
            subCatData = []
            if subCatData.count > 0 {
                kk += 150
                if ProductCategoriesResponsedata.count > 0 {
                    self.tableViewHeight.constant = CGFloat(770 * (self.ProductCategoriesResponsedata.count)) + CGFloat(kk)
                }else {
                    self.tableViewHeight.constant = 0
                }
                let hh = 800
                let ll = ((self.getrandomproductapiModel.count) / 2) * 285
                let final = hh + ll
                self.scrollHeight.constant = CGFloat(final) + (self.hotDealViewHeight.constant) + (self.tableViewHeight.constant)    
            }
        }
    }
    var origin : String?
    var pakBestSellerProductsData :  [Product] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        KSA = [
            KSAcat(name: "Fragrances",id: "66fa5e0956711740c063810e",img: "https://bazaarghar-stage.s3.me-south-1.amazonaws.com/17278500288301640595114605fragrances.png", arName: "العطور"),
            
            KSAcat(name: "Abaya, Hijabs & Shrugs",id: "66fa5e0756711740c0637a5c",img: "https://cdn.bazaarghar.com/1670841873220abbaya.png", arName: "العباية والحجابات والشالات"),
         
            KSAcat(name: "Gaming And Consoles",id: "66fa5e0756711740c0637b48",img: "https://bazaarghar-stage.s3.me-south-1.amazonaws.com/17279334150881714134544530game-and-accesories.png", arName: "الألعاب وأجهزة التحكم"),
           
            KSAcat(name: "Home Appliances",id: "66fa5e0756711740c0637b08",img: "https://bazaarghar-stage.s3.me-south-1.amazonaws.com/17278499243161707723343428consumer-electronics.png", arName: "الأجهزة المنزلية"),
            
            KSAcat(name: "Watches",id: "66fa5e0756711740c0637c6e",img:"https://bazaarghar-stage.s3.me-south-1.amazonaws.com/17278545523501640604011524watches.png", arName: "الساعات"),
            
            KSAcat(name: "Audio & Video",id: "66fa5e0756711740c0637adc",img:"https://bazaarghar-stage.s3.me-south-1.amazonaws.com/17278559370301640605173236audio-video.png", arName: "الصوت والفيديو"),
                   
        ]
        
        China = [
            
        KSAcat(name: "Lights and Lighting",id: "66fa5e0756711740c0637c1e",img:  "https://cdn.bazaarghar.com/1743053603300pngwing.com-34-.png",arName: "الأضواء والإضاءة"),
        
        KSAcat(name: "Women",id: "66fa5e0756711740c0637a5a",img: "https://bazaarghar-stage.s3.me-south-1.amazonaws.com/17279324640241714392382431women-clothing.png",arName: "نحيف"),
        
        KSAcat(name: "Home and Lifestyle",id: "66fa5e0756711740c0637b7e",img:  "https://bazaarghar-stage.s3.me-south-1.amazonaws.com/17278499911991707723393718home-life-style.png",arName: "المنزل ونمط الحياة"),
            
        KSAcat(name: "Car Care",id: "66fa5e0956711740c0638126",img:  "https://cdn.bazaarghar.com/1729579178229car-care.png",arName: "العناية بالسيارات"),
        
        KSAcat(name: "Accessories",id: "66fa5e0956711740c06380f4",img: "https://bazaarghar-stage.s3.me-south-1.amazonaws.com/17279317081721640605905715chargers-data-cables.png", arName: "مُكَمِّلات"),
        
       
        ]
        
        Pak = [
            KSAcat(name: "Hand Bags",id:"66fa5e0756711740c0637dd4" ,img: "https://cdn.bazaarghar.com/1640607310826ladies-handbags.png", arName: "حقائب اليد"),
            
            KSAcat(name: "Eastern Wear",id:"66fa5e0756711740c0637a62" ,img:"https://cdn.bazaarghar.com/1640677218387women-stitched.png",arName: "الملابس الشرقية"),
            
            KSAcat(name: "Truck Art",id:"66fa5e0856711740c0637ee2" ,img:"https://bazaarghar-stage.s3.me-south-1.amazonaws.com/17279387194441717658331032truck-art.png",arName: "فن الشاحنة"),
            
            KSAcat(name: "Eastern Footwear",id:"66fa5e0756711740c0637c48" ,img:"https://cdn.bazaarghar.com/1729508323337eastern-wear-mens.png",arName: "الأحذية الشرقية"),
         
         ]

        scrollView.delegate = self
        topshoplbl.text = shop
        shopLbl.text =  LanguageManager.language == "ar" ?  " مرحبا بكم" + "\(shop ?? "")": "Welcome to " + "\(shop ?? "")"
        shopLblBackgoundView.backgroundColor = UIColor(hex: color ?? "")
        shopImage.image = UIImage(named: shopImg ?? "")

        
//        headerBackgroudView.backgroundColor = UIColor(named: "headercolor") headerBackgroudView, colors: [primaryColor, primaryColor, headerSecondaryColor])

        pagerView.dataSource = self
               pagerView.delegate = self
               pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        pagerView.automaticSlidingInterval = 2.0
        

        shopByCatLbl.attributedText = Utility().attributedStringWithColoredLastWordBold("shopbycategories".pLocalized(lang: LanguageManager.language), lastWordColor: UIColor(named: "headercolor")!, otherWordsColor: .black)
        
        trendingproductlbl.attributedText = Utility().attributedStringWithColoredLastWordBold("Trendingproducts".pLocalized(lang: AppDefault.languages), lastWordColor: UIColor(named: "headercolor")!, otherWordsColor: .black)
  
        shopingReelsLbl.attributedText =  Utility().attributedStringWithColoredLastWord("shoppingreels".pLocalized(lang: LanguageManager.language), lastWordColor: UIColor(named: "headercolor")!, otherWordsColor: UIColor(hexString: blackColor))
        
        shopchinaflag = ["flag_china","flag_pakistan","flag_saudi"]


        shopchinaimg = ["Image 120","Image 121","saudi_product_image"]
        nameshopchina = ["Shop China","Shop Pakistan","Shop Saudi"]
        self.becomeFirstResponder()
 
        hotDealViewHeight.constant = 0
        hotDealView.isHidden = true
        homeTblView.delegate = self
        homeTblView.dataSource = self
        homeLastProductCollectionView.delegate = self
        homeLastProductCollectionView.dataSource  = self

        setupCollectionView()
        setupproductsCollectionView()

     
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.videocallmethod(notification:)), name: Notification.Name("videocallid"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("Productid"), object: nil)
        

        
        if shop == "shopchina".pLocalized(lang: LanguageManager.language) {
            recommendationLbl.attributedText = Utility().attributedStringWithColoredLastWord("bestseller".pLocalized(lang: LanguageManager.language), lastWordColor: UIColor(named: "headercolor")!, otherWordsColor: UIColor(hexString: blackColor))
            let imageDataDict:[String: String] = ["img": "china"]
            NotificationCenter.default.post(name: Notification.Name("globe"), object: nil,userInfo: imageDataDict)
            CategoriesResponsedata.removeAll()
            for i in China {
                categoriesApi(isbackground: true, id: i.id ?? "")
            }
            self.catSequence = [
                China[0].id ?? "",
                China[1].id ?? "",
                China[2].id ?? "",
                China[3].id ?? "",
                China[4].id ?? ""
//                China[5].id ?? ""
            ]
            
            self.productcategoriesApi(cat: China[0].id ?? "", cat2: China[1].id ?? "", cat3: China[2].id ?? "", cat4: China[3].id ?? "", cat5: China[4].id ?? "", cat6:  "", origin: "china",isbackground: true)
            randomproduct(cat: "66fa5e0756711740c0637c1e", cat2: "", cat3: "", cat4: "", cat5: "", cat6: "",  isbackground: true, origin: "china")
            getStreamingVideos(origin: "china")
            getrandomproduct(origin: "china")
            self.origin = "china"
        }else if shop == "shopsaudia".pLocalized(lang: LanguageManager.language) {
            recommendationLbl.attributedText = Utility().attributedStringWithColoredLastWord("bestseller".pLocalized(lang: LanguageManager.language), lastWordColor: UIColor(named: "headercolor")!, otherWordsColor: UIColor(hexString: blackColor))
            let imageDataDict:[String: String] = ["img": "saudi"]
            NotificationCenter.default.post(name: Notification.Name("globe"), object: nil,userInfo: imageDataDict)
            CategoriesResponsedata.removeAll()
            for i in KSA {
                categoriesApi(isbackground: false, id: i.id ?? "")
            }
            self.catSequence = [
                KSA[0].id ?? "",
                KSA[1].id ?? "",
                KSA[2].id ?? "",
                KSA[3].id ?? "",
                KSA[4].id ?? "",
                KSA[5].id ?? ""
            ]
            self.productcategoriesApi(cat: KSA[0].id ?? "", cat2: KSA[1].id ?? "", cat3: KSA[2].id ?? "", cat4: KSA[3].id ?? "", cat5: KSA[4].id ?? "", cat6: KSA[5].id ?? "", origin: "ksa",isbackground: false)
            randomproduct(cat: "66fa5e0956711740c063810e", cat2: "", cat3: "", cat4: "", cat5: "", cat6: "",  isbackground: false, origin: "ksa")
            getStreamingVideos(origin: "ksa")
            getrandomproduct(origin: "ksa")
            self.origin = "ksa"

        }else {
            recommendationLbl.attributedText = Utility().attributedStringWithColoredLastWord("bestseller".pLocalized(lang: LanguageManager.language), lastWordColor: UIColor(named: "headercolor")!, otherWordsColor: UIColor(hexString: blackColor))
            let imageDataDict:[String: String] = ["img": "pakistan-image"]
            NotificationCenter.default.post(name: Notification.Name("globe"), object: nil,userInfo: imageDataDict)
            CategoriesResponsedata.removeAll()
            for i in Pak {
                categoriesApi(isbackground: false, id: i.id ?? "")
            }
            self.catSequence = [
                Pak[0].id ?? "",
                Pak[1].id ?? "",
                Pak[2].id ?? "",
                Pak[3].id ?? "",
//                Pak[4].id ?? "",
//                Pak[5].id ?? ""
            ]
            self.productcategoriesApi(cat: Pak[0].id ?? "", cat2: Pak[1].id ?? "", cat3: Pak[2].id ?? "", cat4: Pak[3].id ?? "", cat5: "", cat6: "", origin: "pak",isbackground: false)

            randomproduct(cat: "66fa5e0756711740c0637d2e", cat2: "", cat3: "", cat4: "", cat5: "", cat6: "",  isbackground: false,origin: "pak")
//            getAllProductsByCategoriesbyid(limit: 20, page: 1, sortBy:"-createdAt", category: "66fa5e0756711740c0637c98", active: false)
            getStreamingVideos(origin: "pak")
            getrandomproduct(origin: "pak")
            self.origin = "pak"
        }
        
        LanguageRender()
        
    }
    

    
    private func categoriesApi(isbackground:Bool,id:String) {
        APIServices.categories2(isbackground:isbackground, id: id, limit: 0,completion: {[weak self] data in
            switch data {
            case .success(let res):
                for i in (0 ..< (self?.CategoriesResponsedata.count ?? 0)).reversed() {
              
                    self?.CategoriesResponsedata[i].subCategories?.removeAll(where: {$0.categorySpecs?.productsCount == 0})
                }
                self?.CategoriesResponsedata.append(res)
                self?.topcell_1.reloadData()
            case .failure(let error):
                print(error)
                if error != "OK" {
                    self?.view.makeToast(error)
                }
            }
        })
    }
    
    func setupproductsCollectionView() {
        let nib = UINib(nibName: "HomeLastProductCollectionViewCell", bundle: nil)
        homeLastProductCollectionView.register(nib, forCellWithReuseIdentifier: "HomeLastProductCollectionViewCell")
        homeLastProductCollectionView.delegate = self
        homeLastProductCollectionView.dataSource  = self
        
    
        
        shoesCollectionView.register(nib, forCellWithReuseIdentifier: "HomeLastProductCollectionViewCell")
        shoesCollectionView.delegate = self
        shoesCollectionView.dataSource  = self
        
        lastRandomProductsCollectionView.register(nib, forCellWithReuseIdentifier: "HomeLastProductCollectionViewCell")
        lastRandomProductsCollectionView.delegate = self
        lastRandomProductsCollectionView.dataSource  = self
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        // Check if the scroll view has reached the bottom
        if offsetY > contentHeight - frameHeight {
            // Call your API
            if load == true {
                
                if shop == "shopchina".pLocalized(lang: LanguageManager.language) {
                    getrandomproduct(origin: "china")
                }else if shop == "shopsaudia".pLocalized(lang: LanguageManager.language) {
                    getrandomproduct(origin: "ksa")
                }else {
                    getrandomproduct(origin: "pak")
                }
            }
        }
    }
    
        func loadMoreData() {
            // Your API call
            print("Reached the end of the scroll view, loading more data...")

            
        }
    
    @objc func touchTapped(_ sender: UITapGestureRecognizer) {
            let vc = LIVE_videoNew.getVC(.videoStoryBoard)
            self.navigationController?.pushViewController(vc, animated: false)
        }
    @objc func touchTapped2(_ sender: UITapGestureRecognizer) {
        let phoneNumber = "+923075265787"
//                  /" // Your phone number with country code
              let urlString = "https://wa.me/\(phoneNumber)"
              
              if let url = URL(string: urlString) {
                  if UIApplication.shared.canOpenURL(url) {
                      UIApplication.shared.open(url, options: [:], completionHandler: nil)
                  } else {
                      // WhatsApp is not installed
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
        cartCountShow = AppDefault.cartCount
        
        if shop == "shopchina".pLocalized(lang: LanguageManager.language) {
            let imageDataDict:[String: String] = ["img": "china"]
            NotificationCenter.default.post(name: Notification.Name("globe"), object: nil,userInfo: imageDataDict)
        }else if shop == "shopsaudia".pLocalized(lang: LanguageManager.language) {
            let imageDataDict:[String: String] = ["img": "saudi"]
            NotificationCenter.default.post(name: Notification.Name("globe"), object: nil,userInfo: imageDataDict)
        }else {
            let imageDataDict:[String: String] = ["img": "pakistan-image"]
            NotificationCenter.default.post(name: Notification.Name("globe"), object: nil,userInfo: imageDataDict)
        }

        catView.backgroundColor = UIColor(hex: catBGColor ?? "")
        shopLbl.textColor =  UIColor(hex: shoptxtColor ?? "")
        
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = true


        self.bannerApi(isbackground: false)

        
//        self.LanguageRender()
        SocketConeect()
        
    }
    func wishList(isbackground:Bool){
        APIServices.wishlist(isbackground: isbackground){[weak self] data in
          switch data{
          case .success(let res):
          //
            AppDefault.wishlistproduct = res.products
   
            self?.homeLastProductCollectionView.reloadData()
              self?.lastRandomProductsCollectionView.reloadData()
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
    private func getStreamingVideos(origin:String){
        APIServices.shopchinaStreamingVideo(isBackground: false, origin: origin,completion: {[weak self] data in
            switch data{
            case .success(let res):
                
                if res.results?.count ?? 0 > 0 {
                        self?.reletedVideoViewHieght.constant = 300
                        
                        self?.scrollHeight.constant = self?.scrollHeight.constant ?? 0 + (self?.reletedVideoViewHieght.constant ?? 0)
                        self?.relatedVideoView.isHidden = false
                }else {
                    self?.reletedVideoViewHieght.constant = 0
                    self?.scrollHeight.constant =  self?.scrollHeight.constant ?? 0 + (self?.reletedVideoViewHieght.constant ?? 0)
                    self?.relatedVideoView.isHidden = true
                }
                self?.LiveStreamingResultsdata = res.results ?? []
                self?.videoCollection.reloadData()
                
            case .failure(let error):
                print(error)
                if error != "OK" {
                    self?.view.makeToast(error)
                }
            }
        })
    }


    func LanguageRender() {

        hotdealslbl.text = "hotdeals".pLocalized(lang: LanguageManager.language)
        viewalllbl.setTitle("viewall".pLocalized(lang: LanguageManager.language), for: .normal)
   

        topcategorieslbl.text = "topcategories".pLocalized(lang: LanguageManager.language)
        
                if LanguageManager.language == "ar"{
                    backBtn.setImage(UIImage(systemName: "chevron.backward.circle.fill"), for: .normal)
                    bestSellerArrowBtn.setImage(UIImage(systemName: "arrow.left"), for: .normal)
                   }else{
                       backBtn.setImage(UIImage(systemName: "chevron.backward.circle.fill"), for: .normal)
                       bestSellerArrowBtn.setImage(UIImage(systemName: "arrow.right"), for: .normal)
                   }
                
                UIView.appearance().semanticContentAttribute = LanguageManager.language == "ar" ? .forceRightToLeft : .forceLeftToRight
                UITextField.appearance().textAlignment = LanguageManager.language == "ar" ? .right : .left
        
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
    
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
           if sender.isOn {
               AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))

               let vc = LIVE_videoNew.getVC(.videoStoryBoard)
               self.navigationController?.pushViewController(vc, animated: false)
           }
       }
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func shopByCatArrowBtnTapped(_ sender: Any) {
        let vc = CategoriesVC.getVC(.main)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func gamerSaleArrowBtnTapped(_ sender: Any) {
        let vc = Category_ProductsVC.getVC(.productStoryBoard)
        if shop == "shopchina".pLocalized(lang: LanguageManager.language) {
            vc.prductid = "66fa5e0756711740c0637c1e"
            vc.catNameTitle = "Best Seller"
            vc.origin = "china"
        }else if shop == "shopsaudia".pLocalized(lang: LanguageManager.language) {
            vc.prductid = "66fa5e0956711740c063810e"
            vc.catNameTitle = "Best Seller"
            vc.origin = "ksa"
        }else {
            vc.prductid = "66fa5e0756711740c0637d2e"
            vc.catNameTitle = "Best Seller"
            vc.origin = "pak"
        }
           vc.video_section = false
           vc.storeFlag = false
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func shoppingReelsArrowBtnTapped(_ sender: Any) {
        let vc = LIVE_videoNew.getVC(.videoStoryBoard)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func languageBtnTapped(_ sender: Any) {
        
        
        appDelegate.showCustomerLanguageAlertControllerHeight(title: "selectlanguage".pLocalized(lang: LanguageManager.language), heading: "", btn1Title: "cancel".pLocalized(lang: LanguageManager.language), btn1Callback: {
            
        }, btn2Title: "apply".pLocalized(lang: LanguageManager.language)) {
            UIView.appearance().semanticContentAttribute = LanguageManager.language == "ar" ? .forceRightToLeft : .forceLeftToRight
//            UITabBar.appearance().semanticContentAttribute = LanguageManager.language == "ar" ? .forceRightToLeft : .forceLeftToRight
            UITextField.appearance().textAlignment = LanguageManager.language == "ar" ? .right : .left
            NotificationCenter.default.post(name: Notification.Name("RefreshAllTabs"), object: nil)
            self.navigationController?.popToRootViewController(animated: true)
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

                    if self?.shop == "shopchina".pLocalized(lang: LanguageManager.language) {
                        let banners =  res
                        
                        if LanguageManager.language == "ar" {
                            for item in res{
                                let objext = item.id
                                if objext?.bannerName == "Country China App Arabic" {
                                    self?.bannerapidata = (objext?.banners)!
                                }
                            }
                        }else {
                            for item in res{
                                let objext = item.id
                                if objext?.bannerName == "Country China App" {
                                    self?.bannerapidata = (objext?.banners)!
                                }
                            }
                    }
                        
                    }else if self?.shop == "shopsaudia".pLocalized(lang: LanguageManager.language)  {
                        if LanguageManager.language == "ar" {
                            for item in res{
                                let objext = item.id
                                if objext?.bannerName == "Country KSA App Arabic" {
                                    self?.bannerapidata = (objext?.banners)!
                                }
                            }
                        }else {
                            for item in res{
                                let objext = item.id
                                if objext?.bannerName == "Country KSA App" {
                                    self?.bannerapidata = (objext?.banners)!
                                }
                              }
                            }
                    } else {
                    let banners =  res
                    
                        if LanguageManager.language == "ar" {
                            for item in res{
                                let objext = item.id
                                if objext?.bannerName == "Country Pakistan App Arabic" {
                                    self?.bannerapidata = (objext?.banners)!
                                }
                            }
                        }else {
                            for item in res{
                                let objext = item.id
                                if objext?.bannerName == "Country Pakistan App" {
                                    self?.bannerapidata = (objext?.banners)!
                                }
                              }
                            }
                }
                    self?.pageControl.numberOfPages = self?.bannerapidata?.count ?? 0
                    self?.pageControl.currentPage = 0
            }

                self?.pagerView.reloadData()
            case .failure(let error):
                print(error)
                if error != "OK" {
                    self?.view.makeToast(error)
                }            }
        }
        )
    }
//    private func categoriesApi(isbackground:Bool) {
//        APIServices.getAllCategories(isbackground:isbackground,completion: {[weak self] data in
//            switch data{
//            case .success(let res):
//                self?.CategoriesResponsedata = res
//                AppDefault.getAllCategoriesResponsedata = res
//                
//                self?.topcell_1.reloadData()
//            case .failure(let error):
//                print(error)
//                self?.view.makeToast(error)
//            }
//        })
//    }
    
    private func productcategoriesApi(cat:String,cat2:String,cat3:String,cat4:String,cat5:String,cat6:String,origin:String,isbackground:Bool){
        APIServices.shopchinaproductcategories(cat: cat, cat2: cat2, cat3: cat3, cat4: cat4, cat5: cat5,cat6:cat6,origin: origin,isbackground:isbackground,completion: {[weak self] data in
            switch data{
            case .success(let res):
                self?.kk = 0
                AppDefault.productcategoriesApi = res
                if(res.count > 0){
                    
                    // Create a dictionary to map id to its index in the desired order
                    let orderMap = Dictionary(uniqueKeysWithValues: ((self?.catSequence.enumerated().map { ($1, $0) })!))

                    // Sort the data array based on the index in desired order
                    let sortedData = AppDefault.productcategoriesApi?.sorted {
                        (orderMap[$0.id ?? ""] ?? Int.max) < (orderMap[$1.id ?? ""] ?? Int.max)
                    }
                    
                    self?.ProductCategoriesResponsedata = sortedData!
                   
                    self?.tableViewHeight.constant = CGFloat(770 * (self?.ProductCategoriesResponsedata.count ?? 0))
                    let hh = 800
                    let ll = ((self?.getrandomproductapiModel.count ?? 0) / 2) * 285
                    let final = hh + ll
                    self?.scrollHeight.constant = CGFloat(final) + (self?.hotDealViewHeight.constant ?? 0) + (self?.tableViewHeight.constant ?? 0)
                }else {
                    self?.tableViewHeight.constant = 0
                }
                self?.lastRandomProductsCollectionView.reloadData()
                self?.homeTblView.reloadData()
            case .failure(let error):
                print(error)
                if error != "OK" {
                    self?.view.makeToast(error)
                }
            }
        })
    }
    private func getAllProductsByCategoriesbyid(limit:Int,page:Int,sortBy:String,category:String,active:Bool){
        APIServices.getAllProductsByCategoriesbyid(limit:limit,page:page,sortBy:sortBy,category:category,active:active, origin: "pak"){[weak self] data in
            switch data{
            case .success(let res):
                if(res.Categoriesdata?.count ?? 0 > 0){
                    self?.pakBestSellerProductsData = res.Categoriesdata ?? []
//                    AppDefault.randonproduct = res
                }
               //
               
                self?.homeLastProductCollectionView.reloadData()
                self?.shoesCollectionView.reloadData()

                
            case .failure(let error):
                print(error)
                if(error == "Please authenticate" && AppDefault.islogin){
                    appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                }else{
                    if error == "Not found"{
                        
                    }else{
                        if error != "OK" {
                            self?.view.makeToast(error)
                        }
                    }
                }

            }
        }
    }

    private func randomproduct(cat:String,cat2:String,cat3:String,cat4:String,cat5:String,cat6:String,isbackground : Bool,origin:String){
        APIServices.shopchinaproductcategories(cat: cat, cat2: cat2, cat3: cat3, cat4: cat4, cat5: cat5, cat6: cat6, origin: origin,isbackground:isbackground,completion: {[weak self] data in
            switch data{
            case .success(let res):
            
             
                if(res.count > 0){
                    self?.randomproductapiModel = res
                    self?.bestsellerview.constant = 0 // 620
//                    AppDefault.randonproduct = res
                }else{
                    self?.bestsellerview.constant = 0
                }
               //
               
                self?.homeLastProductCollectionView.reloadData()
                self?.shoesCollectionView.reloadData()

            case .failure(let error):
                print(error)
                self?.bestsellerview.constant = 0
                if error != "OK" {
                    self?.view.makeToast(error)
                }
            }
        })
    }
    
    private func getrandomproduct(origin:String){
        load = false
        APIServices.getrandomproduct(isbackground: false, origin: origin,completion: {[weak self] data in
            switch data{
            case .success(let res):
            
             
                if(res.count > 0){
                    self?.getrandomproductapiModel.append(contentsOf: res)
                }
               
//                self?.tableViewHeight.constant = CGFloat(920 * (self?.ProductCategoriesResponsedata.count ?? 0))
               
                let hh = 800
                let ll = ((self?.getrandomproductapiModel.count ?? 0) / 2) * 285
                let final = hh + ll

                self?.scrollHeight.constant = CGFloat(final) + (self?.hotDealViewHeight.constant ?? 0) + (self?.tableViewHeight.constant ?? 0)
               
                self?.lastRandomProductsCollectionView.reloadData()
                self?.load = true
            case .failure(let error):
                print(error)
                if error != "OK" {
                    self?.view.makeToast(error)
                }
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
//                self?.view.makeToast(error)
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
//                   vc.isGroupBuy = false
                  vc.slugid = appDelegate.slugid
                self.navigationController?.pushViewController(vc, animated: false)
    }
    @objc func videocallmethod(notification: Notification) {
            
        let vc = VideoViewController.getVC(.videoStoryBoard)
        vc.accessToken = appDelegate.videotoken
        vc.videoCallId = appDelegate.videoid
     
        self.navigationController?.pushViewController(vc, animated: false)
    }

    func setupCollectionView() {
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        imageslidercollectionview.register(nib, forCellWithReuseIdentifier: "cell")
        imageslidercollectionview.delegate = self
        imageslidercollectionview.dataSource = self
    
    }
    
    
    func setupPageControl() {
        pageController.numberOfPages = bannerapidata?.count ?? 0
        pageController.pageIndicatorTintColor = UIColor.gray
        pageController.currentPageIndicatorTintColor = UIColor.red

        pageController.currentPage = 0
        
        if LanguageManager.language == "ar" {
//            imageslidercollectionview.semanticContentAttribute = .forceLeftToRight
//            headerBackgroudView.semanticContentAttribute = .forceLeftToRight
        }else {
//            imageslidercollectionview.semanticContentAttribute = .forceLeftToRight
//            headerBackgroudView.semanticContentAttribute = .forceLeftToRight
        }
        
    
    }
    
//    @objc func reloadcollection() {
//      
//        timer.invalidate()
//        
//        self.setupPageControl()
//    }
    
    @objc func autoSlideer() {
        if counter < bannerapidata?.count ?? 0 {
            let index = IndexPath.init(item: counter, section: 0)
            if bannerapidata?.count == 0 {
                
            }else {
                self.imageslidercollectionview.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            }
            pageController.currentPage = counter
            counter += 1
        } else {
            counter = 0
//            let index = IndexPath.init(item: counter, section: 0)
//            self.imageslidercollectionview.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
//            pageController.currentPage = counter
        }
    }
    
    // MARK: - Button Action

}

extension ShopChina_VC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == imageslidercollectionview {
            return  bannerapidata?.count ?? 0
        }else if collectionView == homeLastProductCollectionView {
                return self.randomproductapiModel.first?.product?.count ?? 0
        }else if collectionView == shoesCollectionView {
            if shop == "shoppakistan".pLocalized(lang: LanguageManager.language) {
                return self.pakBestSellerProductsData.count ?? 0
            }else {
                return self.randomproductapiModel.first?.product?.count ?? 0
            }
        }else if collectionView == hotDealCollectionV {
            return groupbydealsdata.count
        } else if collectionView == lastRandomProductsCollectionView {
            return self.getrandomproductapiModel.count

        } else if collectionView == videoCollection{
            return self.LiveStreamingResultsdata.count
        }else {
            if shop == "shopchina".pLocalized(lang: LanguageManager.language) {
                return China.count
            }else if shop == "shopsaudia".pLocalized(lang: LanguageManager.language) {
                return KSA.count
            }else {
                return Pak.count
            }
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

                let data = self.randomproductapiModel.first?.product?[indexPath.row]
                cell.product = data
            cell.percentBGView.backgroundColor = UIColor(named: "greenColor")
                cell.product = data
                cell.productimage.pLoadImage(url: data?.mainImage ?? "")
               

                if data?.onSale == true {
                    cell.discountPrice.isHidden = false
                    cell.productPrice.isHidden = false
                    cell.discountPrice.attributedText = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(data?.salePrice ?? 0, label: cell.discountPrice))
                    cell.productPrice.attributedText = "\(appDelegate.currencylabel) \(Utility().formatNumberWithCommas(data?.regularPrice ?? 0, label:  cell.productPrice).trimmingCharacters(in: .whitespaces))".strikeThrough()
                    cell.productPriceLine.isHidden = true
                    cell.productPrice.textColor = UIColor.red
                    cell.productPriceLine.backgroundColor = UIColor.red
                    cell.percentBGView.isHidden = false
                }else {
                    cell.productPriceLine.isHidden = true
                    cell.productPrice.isHidden = true
                    cell.discountPrice.attributedText = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(data?.regularPrice ?? 0, label:  cell.discountPrice))
                    cell.percentBGView.isHidden = true
                 }
                cell.heartBtn.tag = indexPath.row
                cell.cartButton.tag = indexPath.row
                cell.cartButton.addTarget(self, action: #selector(gamessalescartButtonTap(_:)), for: .touchUpInside)
                cell.heartBtn.addTarget(self, action: #selector(gamesalesHeartBtnTapped(_:)), for: .touchUpInside)

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
        } else if collectionView == shoesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeLastProductCollectionViewCell", for: indexPath) as! HomeLastProductCollectionViewCell
            if shop == "shoppakistan".pLocalized(lang: LanguageManager.language){
                let data = pakBestSellerProductsData[indexPath.row]
                cell.percentBGView.backgroundColor = UIColor(named: "greenColor")
                cell.product = data
                cell.productimage.pLoadImage(url: data.mainImage ?? "")
                if LanguageManager.language == "ar"{
                    cell.productname.text = data.lang?.ar?.productName
                }else{
                    cell.productname.text =  data.productName
                }

                if data.onSale == true {
                    cell.discountPrice.isHidden = false
                    cell.productPrice.isHidden = false
                    cell.discountPrice.attributedText = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(data.salePrice ?? 0, label:  cell.discountPrice))
                    cell.productPrice.attributedText = "\(appDelegate.currencylabel) \(Utility().formatNumberWithCommas(data.regularPrice ?? 0, label: cell.productPrice).trimmingCharacters(in: .whitespaces))".strikeThrough()
                    cell.productPriceLine.isHidden = true
                    cell.productPrice.textColor = UIColor.red
                    cell.productPriceLine.backgroundColor = UIColor.red
                    cell.percentBGView.isHidden = false
                }else {
                    
                    cell.productPriceLine.isHidden = true
                    cell.productPrice.isHidden = true
                    cell.discountPrice.attributedText = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(data.regularPrice ?? 0, label: cell.discountPrice))
                    cell.percentBGView.isHidden = true
                 }
                cell.heartBtn.tag = indexPath.row
                cell.cartButton.tag = indexPath.row
            }else {
                let data = self.randomproductapiModel.first?.product?[indexPath.row]
                cell.percentBGView.backgroundColor = UIColor(named: "greenColor")
                cell.product = data
                cell.productimage.pLoadImage(url: data?.mainImage ?? "")
                if LanguageManager.language == "ar" && data?.lang?.ar != nil{
                    cell.productname.text = data?.lang?.ar?.productName
                }else{
                    cell.productname.text =  data?.productName
                }

                if data?.onSale == true {
                    cell.discountPrice.isHidden = false
                    cell.productPrice.isHidden = false
                    cell.discountPrice.attributedText = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(data?.salePrice ?? 0, label:     cell.discountPrice))
                    cell.productPrice.attributedText = "\(appDelegate.currencylabel) \(Utility().formatNumberWithCommas(data?.regularPrice ?? 0, label:   cell.productPrice).trimmingCharacters(in: .whitespaces))".strikeThrough()
                    cell.productPriceLine.isHidden = true
                    cell.productPrice.textColor = UIColor.red
                    cell.productPriceLine.backgroundColor = UIColor.red
                    cell.percentBGView.isHidden = false
                }else {
                    cell.productPriceLine.isHidden = true
                    cell.productPrice.isHidden = true
                    cell.discountPrice.attributedText = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(data?.regularPrice ?? 0, label: cell.discountPrice))
                    cell.percentBGView.isHidden = true
                 }
                cell.heartBtn.tag = indexPath.row
                cell.cartButton.tag = indexPath.row
            }
            
            
           
            
            
            
            return cell
        }else if collectionView == hotDealCollectionV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotDealCollectionViewCell", for: indexPath) as! HotDealCollectionViewCell
            let data = groupbydealsdata[indexPath.row]
            
            cell.mainImage.pLoadImage(url: data.productID?.mainImage ?? "")
            cell.brandName.text =  data.productID?.productName
            cell.regularPrice.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(data.productID?.regularPrice ?? 0, label:   cell.regularPrice)
            cell.days.text = "\(data.remainingTime?.days ?? 0)"
            cell.hours.text = "\(data.remainingTime?.hours ?? 0)"
            cell.minutes.text = "\(data.remainingTime?.minutes ?? 0)"
            cell.dayslbl.text = "days".pLocalized(lang: LanguageManager.language)
            cell.hrslbl.text = "hrs".pLocalized(lang: LanguageManager.language)
            cell.minslbl.text = "mins".pLocalized(lang: LanguageManager.language)
            if data.productID?.onSale == true {
                cell.salePrice.isHidden = false
                cell.salePrice.text =   appDelegate.currencylabel + Utility().formatNumberWithCommas(data.productID?.salePrice ?? 0, label:    cell.salePrice)
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
            cell.percentBGView.backgroundColor = UIColor(named: "greenColor")
            cell.product = data
            cell.productimage.pLoadImage(url: data.mainImage ?? "")
            if LanguageManager.language == "ar" && data.lang?.ar != nil{
                cell.productname.text = data.lang?.ar?.productName
            }else{
                cell.productname.text =  data.productName
            }

            if data.onSale == true {
                cell.discountPrice.isHidden = false
                cell.productPrice.isHidden = false
                cell.discountPrice.attributedText = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(data.salePrice ?? 0, label:  cell.discountPrice))
                cell.productPrice.attributedText = "\(appDelegate.currencylabel) \(Utility().formatNumberWithCommas(data.regularPrice ?? 0, label:     cell.productPrice).trimmingCharacters(in: .whitespaces))".strikeThrough()
                cell.productPriceLine.isHidden = true
                cell.productPrice.textColor = UIColor.red
                cell.productPriceLine.backgroundColor = UIColor.red
                cell.percentBGView.isHidden = false
            }else {
                cell.productPriceLine.isHidden = true
                cell.productPrice.isHidden = true
                cell.discountPrice.attributedText = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(data.regularPrice ?? 0, label:  cell.discountPrice))
                cell.percentBGView.isHidden = true
             }
            cell.heartBtn.tag = indexPath.row
            cell.cartButton.tag = indexPath.row
            cell.cartButton.addTarget(self, action: #selector(randomcartBtnTapped(_:)), for: .touchUpInside)

            cell.heartBtn.addTarget(self, action: #selector(randomHeartBtnTapped(_:)), for: .touchUpInside)

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
        } else if collectionView == videoCollection{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Videoscategorycell1", for: indexPath) as! Videoscategorycell
            let data = LiveStreamingResultsdata[indexPath.row]
            cell.productimage.pLoadImage(url: data.thumbnail ?? "")
            cell.viewslbl.text = "\(data.totalViews ?? 0)  "
            cell.Productname.text = data.brandName
            cell.likeslbl.text = "\(data.like ?? 0)"
                return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topcategoriescell", for: indexPath) as! topcategoriescell
//            let data = CategoriesResponsedata[indexPath.row]
          
            if shop == "shopchina".pLocalized(lang: LanguageManager.language) {
                let  data = China[indexPath.row]
                  cell.imageView.pLoadImage(url: data.img ?? "")
                if LanguageManager.language == "ar"{
                      cell.topCatLbl.text = data.arName
                  }else{
                      cell.topCatLbl.text = data.name
                  }
  
            }else if shop == "shopsaudia".pLocalized(lang: LanguageManager.language) {
                let  data = KSA[indexPath.row]
                  cell.imageView.pLoadImage(url: data.img ?? "")
                  if LanguageManager.language == "ar"{
                      cell.topCatLbl.text = data.arName
                  }else{
                      cell.topCatLbl.text = data.name
                  }
            }else {
                let  data = Pak[indexPath.row]
                  cell.imageView.pLoadImage(url: data.img ?? "")
                  if LanguageManager.language == "ar"{
                      cell.topCatLbl.text = data.arName
                  }else{
                      cell.topCatLbl.text = data.name
                  }
            }
        
            if LanguageManager.language == "ar" {
                 cell.contentView.transform = CGAffineTransform(scaleX: -1, y: 1)
             } else {
                 cell.contentView.transform = .identity
             }
            
            return cell
        }
    }
    @objc func gamessalescartButtonTap(_ sender: UIButton) {
        let data = self.randomproductapiModel.first?.product?[sender.tag]
        
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
            vc.onDismiss = {
                self.cartCountShow = AppDefault.cartCount
            }
            self.present(vc, animated: true)
        }
    }
    @objc func gamesalesHeartBtnTapped(_ sender: UIButton) {

        if(AppDefault.islogin){
              let index = sender.tag
              let item = self.randomproductapiModel.first?.product?[index]
            if item?.id == nil {
                self.wishListApi(productId: (item?._id ?? ""))
            }else {
                self.wishListApi(productId: (item?.id ?? ""))
            }
            }else{
                let vc = PopupLoginVc.getVC(.popups)
              vc.modalPresentationStyle = .overFullScreen
              self.present(vc, animated: true, completion: nil)
            }
    }
    @objc func randomcartBtnTapped(_ sender: UIButton) {
        let data = getrandomproductapiModel[sender.tag]
        
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
    @objc func randomHeartBtnTapped(_ sender: UIButton) {
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
            return 10
        } else if collectionView == shoesCollectionView {
            return 10
        }
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == homeLastProductCollectionView {
            return 5
        }else if collectionView == shoesCollectionView {
            return 5
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == imageslidercollectionview {
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        }else if collectionView == homeLastProductCollectionView {
            return CGSize(width: homeLastProductCollectionView.frame.width/2-5, height: 280)
        } else if collectionView == shoesCollectionView {
            return CGSize(width: shoesCollectionView.frame.width/2-5, height: 280)
        }else if collectionView == hotDealCollectionV {
            return CGSize(width: self.hotDealCollectionV.frame.width/1.2, height: self.hotDealCollectionV.frame.height)

        } else if collectionView == lastRandomProductsCollectionView {
            return CGSize(width: self.lastRandomProductsCollectionView.frame.width/2.12-2, height: 280)

        }else if collectionView == videoCollection {
            return CGSize(width: collectionView.frame.size.width/2, height: collectionView.frame.size.height)
        } else {
            return CGSize(width: self.topcell_1.frame.width/5-10, height: self.topcell_1.frame.height)

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == lastRandomProductsCollectionView {
           return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        }else {
            return  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        }
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        
//        
//        if pageController.currentPage == (bannerapidata?.count ?? 0) - 1 {
////            self.reloadcollection()
//            let scrollPos = scrollView.contentOffset.x / view.frame.width
//            pageController.currentPage = Int(scrollPos)
//        }else {
//            let scrollPos = scrollView.contentOffset.x / view.frame.width
//            pageController.currentPage = Int(scrollPos)
//            counter = pageController.currentPage
//        }
//        
//        loadMoreData()
//    }
    
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
                        if shop == "shopchina".pLocalized(lang: LanguageManager.language) {
                            vc.origin = "china"
                        }else if shop == "shopsaudia".pLocalized(lang: LanguageManager.language) {
                            vc.origin = "ksa"
                        }else {
                            vc.origin = "pak"
                        }
                        self.navigationController?.pushViewController(vc, animated: false)
                    }
                    
                  case "Product":
                    if data?.linkId == "" || data?.linkId == nil {
                        
                    }else {
                        let vc = NewProductPageViewController.getVC(.productStoryBoard)
//                        vc.isGroupBuy = false
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
            let data = self.randomproductapiModel.first?.product?[indexPath.row]
            let vc = NewProductPageViewController.getVC(.productStoryBoard)
//                vc.isGroupBuy = false
            vc.slugid = data?.slug
            self.navigationController?.pushViewController(vc, animated: false)
        }else if collectionView == shoesCollectionView {
            let data = self.randomproductapiModel.first?.product?[indexPath.row]
            let vc = NewProductPageViewController.getVC(.productStoryBoard)
//                vc.isGroupBuy = false
            vc.slugid = data?.slug
            self.navigationController?.pushViewController(vc, animated: false)
        }else if collectionView == hotDealCollectionV {
            let data = groupbydealsdata[indexPath.row]
            let vc = NewProductPageViewController.getVC(.productStoryBoard)
//            vc.isGroupBuy = true
//            vc.groupbydealsdata = data
            vc.slugid = data.productID?.slug
            self.navigationController?.pushViewController(vc, animated: false)
        } else if collectionView == lastRandomProductsCollectionView {
            let data = getrandomproductapiModel[indexPath.row]

            let vc = NewProductPageViewController.getVC(.productStoryBoard)
//            vc.isGroupBuy = false
            vc.slugid = data.slug
            self.navigationController?.pushViewController(vc, animated: false)
        } else if collectionView == videoCollection {
            let data = LiveStreamingResultsdata[indexPath.row]
            let vc = New_SingleVideoview.getVC(.videoStoryBoard)
            vc.LiveStreamingResultsdata = self.LiveStreamingResultsdata
            vc.indexValue = indexPath.row
            vc.page = 2
            self.navigationController?.pushViewController(vc, animated: false)
            appDelegate.videoCountAPI(isbackground: false, slug: LiveStreamingResultsdata[indexPath.row].slug ?? "")
        } else {
             
            
            if shop == "shopchina".pLocalized(lang: LanguageManager.language) {
                let  data = China[indexPath.row]
                let vc = Category_ProductsVC.getVC(.productStoryBoard)
                vc.prductid = data.id ?? ""
                vc.video_section = false
                vc.storeFlag = false
                vc.catNameTitle = data.name ?? ""
                vc.origin = "china"
                self.navigationController?.pushViewController(vc, animated: false)
            }else if shop == "shopsaudia".pLocalized(lang: LanguageManager.language) {
                let  data = KSA[indexPath.row]
                let vc = Category_ProductsVC.getVC(.productStoryBoard)
                vc.prductid = data.id ?? ""
                vc.video_section = false
                vc.storeFlag = false
                vc.catNameTitle = data.name ?? ""
                vc.origin = "ksa"
                self.navigationController?.pushViewController(vc, animated: false)
            }else {
                let  data = Pak[indexPath.row]
                let vc = Category_ProductsVC.getVC(.productStoryBoard)
                vc.prductid = data.id ?? ""
                vc.video_section = false
                vc.storeFlag = false
                vc.catNameTitle = data.name ?? ""
                vc.origin = "pak"
                self.navigationController?.pushViewController(vc, animated: false)
            }
            
          }
        
    }
    
}

extension ShopChina_VC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return ProductCategoriesResponsedata.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell

            let data = ProductCategoriesResponsedata[indexPath.row]
             cell.origin = self.origin
        
        if LanguageManager.language == "ar" {
            cell.img.pLoadImage(url: data.lang?.ar?.wideBannerImage ?? data.wideBannerImage ?? "")
            cell.arrowBtn.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        }else {
            cell.img.pLoadImage(url: data.wideBannerImage ?? "")
            cell.arrowBtn.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        }
            
            if LanguageManager.language == "ar" && data.lang?.ar != nil{
//                cell.cateogorylbl.text = data.lang?.ar?.name?.lowercased().capitalized
                cell.cateogorylbl.attributedText = Utility().attributedStringWithColoredLastWord((data.lang?.ar?.name ?? data.name) ?? "", lastWordColor: UIColor(named: "headercolor")!, otherWordsColor: UIColor(hexString: blackColor))
                cell.img.pLoadImage(url: data.wideBannerImage ?? "")
//                cell.img.pLoadImage(url: data.lang?.ar?.wideBannerImage ?? "")
//                cell.arrowBtn.setImage(UIImage(systemName: "arrow.left"), for: .normal)
            }else{
                cell.cateogorylbl.attributedText = Utility().attributedStringWithColoredLastWord(data.name?.lowercased().capitalized ?? "", lastWordColor: UIColor(named: "headercolor")!, otherWordsColor: UIColor(hexString: blackColor))
//                cell.img.pLoadImage(url: data.wideBannerImage ?? "")
//                cell.arrowBtn.setImage(UIImage(systemName: "arrow.right"), for: .normal)
            }
            //        cell.cateogorylbl.text = data.name ?? ""
            cell.productapi = data.product ?? []
        cell.index = indexPath.row
        for i in AppDefault.getAllCategoriesResponsedata ?? [] {
            if i.id == data.id {
                cell.subCatData = i.subCategories ?? []
                self.subCatData = i.subCategories ?? []
                break
            }else {
                for j in i.subCategories ?? [] {
                    if j.id == data.id {
                        cell.subCatData = j.subCategories ?? []
                        self.subCatData = j.subCategories ?? []
                        break
                    } else {
                        for h in j.subCategories ?? [] {
                            if h.id == data.id {
                                cell.subCatData = h.subCategories ?? []
                                self.subCatData = h.subCategories ?? []
                                break
                            }
                        }
                    }
                }
            }
        }
        
        
        
            cell.catBannerBtn.tag = indexPath.row
            cell.arrowBtn.tag = indexPath.row
            cell.catBannerBtn.addTarget(self, action: #selector(catBannerBtnTapped(_:)), for: .touchUpInside)
        cell.nav = self.navigationController
        cell.arrowBtn.addTarget(self, action: #selector(arrowBtnTapped(_:)), for: .touchUpInside)

            return cell
    }
    @objc func exploreBtnTapped(_ sender: UIButton) {
        
    }
    @objc func arrowBtnTapped(_ sender: UIButton) {
        let data = ProductCategoriesResponsedata[sender.tag]
        
        let vc = Category_ProductsVC.getVC(.productStoryBoard)
        vc.prductid = data.id ?? ""
        vc.video_section = false
        vc.storeFlag = false
        vc.catNameTitle = data.name ?? ""
        if shop == "shopchina".pLocalized(lang: LanguageManager.language) {
            vc.origin = "china"
        }else if shop == "shopsaudia".pLocalized(lang: LanguageManager.language) {
            vc.origin = "ksa"
        }else {
            vc.origin = "pak"
        }
        self.navigationController?.pushViewController(vc, animated: false)

    }
    @objc func catBannerBtnTapped(_ sender: UIButton) {
        let data = ProductCategoriesResponsedata[sender.tag]
        
        let vc = Category_ProductsVC.getVC(.productStoryBoard)
        vc.prductid = data.id ?? ""
        vc.video_section = false
        vc.storeFlag = false
        vc.catNameTitle = data.name ?? ""
        if shop == "shopchina".pLocalized(lang: LanguageManager.language) {
            vc.origin = "china"
        }else if shop == "shopsaudia".pLocalized(lang: LanguageManager.language) {
            vc.origin = "ksa"
        }else {
            vc.origin = "pak"
        }
        self.navigationController?.pushViewController(vc, animated: false)

    }
    @objc func cartButtonTap(_ sender: UIButton) {
        let data = self.randomproductapiModel.first?.product?[sender.tag]
        
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
            vc.onDismiss = {
                self.cartCountShow = AppDefault.cartCount
            }
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if subCatData.count > 0 {
            return  920
        }else {
            return 770
        }
    }
}


extension ShopChina_VC {
    
    func SocketConeect() {
       
        manager = SocketManager(socketURL: AppConstants.API.chinesBellUrl, config: [.log(true),
                                                                                  .compress,
                                                                                  .forceWebsockets(true),.connectParams( ["token":AppDefault.accessToken])])
        socket = manager?.socket(forNamespace: "/chat/v1/notification")

        socket?.on(clientEvent: .connect) { (data, ack) in
//            self.socket?.emit("allNotifications", ["userId":AppDefault.currentUser?.id ?? "","page":1,"limit":200])
//            self.socket?.emit("unreadNotifications", ["userId":AppDefault.currentUser?.id ?? ""])
         
           }
        self.socket?.on("notifyChineseBell") { data, ack in
            print("chinise bell",data)
        
        }
        
//        self.socket?.on("allNotifications") { data, ack in
//            
//            if let rooms = data[0] as? [String: Any]{
//                if let item = rooms["results"] as? [[String: Any]]{
//                    
//                    self.messageItem.removeAll()
//                    var messageItem:[notificationmodel] = []
//                    let Datamodel = JSON(item)
//                    let message = Datamodel.array
//                    
//                    for items in message ?? []{
//                        messageItem.append(notificationmodel(jsonData: items))
//                    }
//                    
//                    print(messageItem)
//                    
//                    
//                    self.messageItem = messageItem
//                
//                    
//                }
// 
//            }
//        }
        
 
    
//        self.socket?.on("unreadNotifications") { data, ack in
//            print("chinise bell",data)
// //
//        }
       
//        self.socket?.on("chineseBell") { data, ack in
//            print("chinise bell",data)
// //
//        }
        
        socket?.connect()
        
        socket?.on(clientEvent: .disconnect) { data, ack in
           // Handle the disconnection event
           print("Socket disconnected")
       }
      
    }

    
}

extension ShopChina_VC: FSPagerViewDataSource, FSPagerViewDelegate {
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

   // MARK: - FSPagerViewDelegate

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
                    if shop == "shopchina".pLocalized(lang: LanguageManager.language) {
                        vc.origin = "china"
                    }else if shop == "shopsaudia".pLocalized(lang: LanguageManager.language) {
                        vc.origin = "ksa"
                    }else {
                        vc.origin = "pak"
                    }
                    self.navigationController?.pushViewController(vc, animated: false)
                }
                
              case "Product":
                if data?.linkId == "" || data?.linkId == nil {
                    
                }else {
                    let vc = NewProductPageViewController.getVC(.productStoryBoard)
//                    vc.isGroupBuy = false
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

    }
}


//class CenterPresentationController: UIPresentationController {
//
//    override var frameOfPresentedViewInContainerView: CGRect {
//        guard let containerView = containerView else {
//            return CGRect()
//        }
//        
//        // Define the size of the presented view controller
//        let width: CGFloat = containerView.frame.width - 30
//        let height: CGFloat = 500
//        
//        // Calculate the center position
//        let x = (containerView.bounds.width - width) / 2
//        let y = (containerView.bounds.height - height) / 2
//        
//        return CGRect(x: x, y: y, width: width, height: height)
//    }
//    
//    override func presentationTransitionWillBegin() {
//        super.presentationTransitionWillBegin()
//        
//        // Optionally add a dimming view or background effect
//        guard let containerView = containerView else { return }
//        let dimmingView = UIView(frame: containerView.bounds)
//        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
//        containerView.addSubview(dimmingView)
//        
//        // Add the presented view
//        containerView.addSubview(presentedViewController.view)
//    }
//    
//    override func dismissalTransitionWillBegin() {
//        super.dismissalTransitionWillBegin()
//        // Optionally handle the dismissal transition
//    }
//}
//
//
//class CenterTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
//    
//    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
//        return CenterPresentationController(presentedViewController: presented, presenting: presenting)
//    }
//}
