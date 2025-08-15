//
//  ShopChinaViewController.swift
//  Bazaar Ghar
//
//  Created by Developer on 23/04/2024.
//

import UIKit
import SocketIO
import SwiftyJSON
import AudioToolbox

class ShopChinaViewController: UIViewController {
    @IBOutlet weak var homeswitchbtn: UISwitch!
    @IBOutlet weak var imageslidercollectionview: UICollectionView!
    @IBOutlet weak var homeTblView: UITableView!
    
    @IBOutlet weak var pageController: UIPageControl!
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    
    @IBOutlet weak var hotdealslbl: UILabel!
    // outlets
    @IBOutlet weak var searchProductslbs: UITextField!
    @IBOutlet weak var livelbl: UILabel!
    @IBOutlet weak var hederView: UIView!
    @IBOutlet weak var LiveGif: UIImageView!
    @IBOutlet weak var hotDealCollectionV: UICollectionView!

    @IBOutlet weak var hotDealViewHeight: NSLayoutConstraint!
    @IBOutlet weak var hotDealView: UIView!
    @IBOutlet weak var chatBotGif: UIImageView!

    
    
    @IBOutlet weak var viewalllbl: UIButton!
    
    
    var bannerapidata: [Banner]? = nil{
        didSet{
            DispatchQueue.main.async {
                self.setupPageControl()
                self.imageslidercollectionview.reloadData()
            }
        }
    }
    var ProductCategoriesResponsedata: [PChat] = []
    var groupbydealsdata: [GroupByResult] = []

    var timer = Timer()
    var counter = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeFirstResponder()
//        SocketConeect()
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = true
//        let jeremyGif = UIImage.gifImageWithName("live_icon_gif")
//           LiveGif.image = UIImage.gifImageWithName("live_icon_gif")
//        LiveGif.isUserInteractionEnabled = true
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.touchTapped(_:)))
//          LiveGif.addGestureRecognizer(tap)
//        
//        chatBotGif.image = UIImage(named: "chatbot_icon")
//        chatBotGif.isUserInteractionEnabled = true
//     let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.touchTapped2(_:)))
//        chatBotGif.addGestureRecognizer(tap2)
//  
        hotDealViewHeight.constant = 0
        hotDealView.isHidden = true

        homeTblView.delegate = self
        homeTblView.dataSource = self

        setupCollectionView()
        
        DispatchQueue.main.async {
              self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.autoSlideer), userInfo: nil, repeats: true)
           }
       
     
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.videocallmethod(notification:)), name: Notification.Name("videocallid"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("Productid"), object: nil)
        
        homeswitchbtn.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        
    }
    @objc func touchTapped(_ sender: UITapGestureRecognizer) {
        let vc = LIVE_videoNew.getVC(.videoStoryBoard)
            self.navigationController?.pushViewController(vc, animated: false)
        }
    @objc func touchTapped2(_ sender: UITapGestureRecognizer) {
        let vc = webView_ViewController.getVC(.main)
        vc.modalPresentationStyle  = .fullScreen
        self.present(vc, animated: false)
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
        
    
        homeswitchbtn.isOn = false
        
        DispatchQueue.main.async {
            self.bannerApi(isbackground: false)

            self.groupByDeals(limit: 20, page: 1, isbackground: false)

            self.productcategoriesApi(cat: "66fa5e0756711740c0637ada", cat2: "66fa5e0756711740c0637b34", cat3: "66fa5e0756711740c0637c1c", cat4: "65e82aa5067e0d3f4c5f76c2", cat5: "65e82aa5067e0d3f4c5f77b3",isbackground: false)

        }

        self.LanguageRender()
        
    }
    

    func LanguageRender() {
        searchProductslbs.placeholder = "searchproducts".pLocalized(lang: LanguageManager.language)
        livelbl.text = "live".pLocalized(lang: LanguageManager.language)
        hotdealslbl.text = "hotdeals".pLocalized(lang: LanguageManager.language)
        viewalllbl.setTitle("viewall".pLocalized(lang: LanguageManager.language), for: .normal)

        
        //        if LanguageManager.language == "ar"{
        //            backBtn.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        //           }else{
        //               backBtn.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        //           }
                
                UIView.appearance().semanticContentAttribute = LanguageManager.language == "ar" ? .forceRightToLeft : .forceLeftToRight
                UITextField.appearance().textAlignment = LanguageManager.language == "ar" ? .right : .left
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
 
                    
                   
                }
    
            case .failure(let error):
                print(error)
                self?.view.makeToast(error)
            }
        }
        )
    }
    private func productcategoriesApi(cat:String,cat2:String,cat3:String,cat4:String,cat5:String,isbackground:Bool){
        APIServices.productcategories(cat: cat, cat2: cat2, cat3: cat3, cat4: cat4, cat5: cat5, cat6: "",isbackground:isbackground,completion: {[weak self] data in
            switch data{
            case .success(let res):
                
                if(res.count > 0){
                    self?.ProductCategoriesResponsedata = res
                    self?.tableViewHeight.constant = CGFloat(731 * (self?.ProductCategoriesResponsedata.count ?? 0))
                    
                    
                    self?.scrollHeight.constant = 300 + (self?.hotDealViewHeight.constant ?? 0) + (self?.tableViewHeight.constant ?? 0)
                }
  
                self?.homeTblView.reloadData()
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
                self?.view.makeToast(error)
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
    func setupCollectionViewproducts() {
        let nib = UINib(nibName: "HomeLastProductCollectionViewCell", bundle: nil)
        hotDealCollectionV.register(nib, forCellWithReuseIdentifier: "HomeLastProductCollectionViewCell")
        hotDealCollectionV.delegate = self
        hotDealCollectionV.dataSource  = self
     
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
    
//    @objc func reloadcollection() {
//
//        timer.invalidate()
//
//        self.setupPageControl()
//    }
    
    @objc func autoSlideer() {
        if counter < bannerapidata?.count ?? 0 {
            let index = IndexPath.init(item: counter, section: 0)
            self.imageslidercollectionview.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
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

extension ShopChinaViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == imageslidercollectionview {
            return  bannerapidata?.count ?? 0
        }else if collectionView == hotDealCollectionV {
            return groupbydealsdata.count
        }else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == imageslidercollectionview {
            let data = bannerapidata?[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
            cell.imageView.pLoadImage(url: data?.image ?? "")

            return cell
        }else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotDealCollectionViewCell", for: indexPath) as! HotDealCollectionViewCell
            let data = groupbydealsdata[indexPath.row]
            
            cell.mainImage.pLoadImage(url: data.productID?.mainImage ?? "")
            cell.brandName.text =  data.productID?.productName
            cell.regularPrice.text =    appDelegate.currencylabel + Utility().formatNumberWithCommas(data.productID?.regularPrice ?? 0, label:    cell.regularPrice)
            cell.days.text = "\(data.remainingTime?.days ?? 0)"
            cell.hours.text = "\(data.remainingTime?.hours ?? 0)"
            cell.minutes.text = "\(data.remainingTime?.minutes ?? 0)"
            cell.dayslbl.text = "days".pLocalized(lang: LanguageManager.language)
            cell.hrslbl.text = "hrs".pLocalized(lang: LanguageManager.language)
            cell.minslbl.text = "mins".pLocalized(lang: LanguageManager.language)
            if data.productID?.onSale == true {
                cell.salePrice.isHidden = false
                cell.salePrice.text =   appDelegate.currencylabel + Utility().formatNumberWithCommas(data.productID?.salePrice ?? 0, label:  cell.salePrice)
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
 
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == imageslidercollectionview {
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        }else if collectionView == hotDealCollectionV {
            return CGSize(width: self.hotDealCollectionV.frame.width/1.2, height: self.hotDealCollectionV.frame.height)

        }else {
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
          return  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        if pageController.currentPage == (bannerapidata?.count ?? 0) - 1 {
//            self.reloadcollection()
        }else {
            let scrollPos = scrollView.contentOffset.x / view.frame.width
            pageController.currentPage = Int(scrollPos)
            counter = pageController.currentPage
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

            
        }else if collectionView == hotDealCollectionV {
            let data = groupbydealsdata[indexPath.row]
            let vc = NewProductPageViewController.getVC(.productStoryBoard)
//            vc.isGroupBuy = true
//            vc.groupbydealsdata = data
            vc.slugid = data.productID?.slug
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
    }
    
}

extension ShopChinaViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ProductCategoriesResponsedata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        let data = ProductCategoriesResponsedata[indexPath.row]

        
        if LanguageManager.language == "ar" && data.lang?.ar != nil{
            cell.cateogorylbl.text = data.lang?.ar?.name?.uppercased()
            cell.img.pLoadImage(url: data.lang?.ar?.wideBannerImage ?? "")
        }else{
            cell.cateogorylbl.text = data.name?.uppercased()
            cell.img.pLoadImage(url: data.wideBannerImage ?? "")
        }
//        cell.cateogorylbl.text = data.name ?? ""
        cell.productapi = data.product ?? []
    
        cell.catBannerBtn.tag = indexPath.row
        
        cell.catBannerBtn.addTarget(self, action: #selector(catBannerBtnTapped(_:)), for: .touchUpInside)
        
        return cell
        
    }
    @objc func catBannerBtnTapped(_ sender: UIButton) {
        let data = ProductCategoriesResponsedata[sender.tag]
        
        let vc = Category_ProductsVC.getVC(.productStoryBoard)
        vc.prductid = data.id ?? ""
        vc.video_section = false
        vc.storeFlag = false
        vc.catNameTitle = data.name ?? ""
        self.navigationController?.pushViewController(vc, animated: false)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 731
        
    }
    
    
    
}


//extension ShopChinaViewController {
//    
//    func SocketConeect() {
//       
//        manager = SocketManager(socketURL: AppConstants.API.chinesBellUrl, config: [.log(true),
//                                                                                  .compress,
//                                                                                  .forceWebsockets(true),.connectParams( ["token":AppDefault.accessToken])])
//        socket = manager?.socket(forNamespace: "/chat/v1/notification")
//
//        socket?.on(clientEvent: .connect) { (data, ack) in
////            self.socket?.emit("allNotifications", ["userId":AppDefault.currentUser?.id ?? "","page":1,"limit":200])
////            self.socket?.emit("unreadNotifications", ["userId":AppDefault.currentUser?.id ?? ""])
//         
//           }
//        self.socket?.on("notifyChineseBell") { data, ack in
//            print("chinise bell",data)
//        
//        }
//        
////        self.socket?.on("allNotifications") { data, ack in
////
////            if let rooms = data[0] as? [String: Any]{
////                if let item = rooms["results"] as? [[String: Any]]{
////
////                    self.messageItem.removeAll()
////                    var messageItem:[notificationmodel] = []
////                    let Datamodel = JSON(item)
////                    let message = Datamodel.array
////
////                    for items in message ?? []{
////                        messageItem.append(notificationmodel(jsonData: items))
////                    }
////
////                    print(messageItem)
////
////
////                    self.messageItem = messageItem
////
////
////                }
////
////            }
////        }
//        
// 
//    
////        self.socket?.on("unreadNotifications") { data, ack in
////            print("chinise bell",data)
//// //
////        }
//       
////        self.socket?.on("chineseBell") { data, ack in
////            print("chinise bell",data)
//// //
////        }
//        
//        socket?.connect()
//        
//        socket?.on(clientEvent: .disconnect) { data, ack in
//           // Handle the disconnection event
//           print("Socket disconnected")
//       }
//      
//    }
//
//    
//}
