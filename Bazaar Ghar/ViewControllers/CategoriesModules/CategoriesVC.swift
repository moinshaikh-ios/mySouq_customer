//
//  CategoriesVC.swift
//  BAZAAR GHAR
//
//  Created by Umair ALi on 24/08/2023.
//

import UIKit
import AudioToolbox
import SocketIO


class CategoriesVC: UIViewController {
    @IBOutlet weak var Maincollectionview:UICollectionView!
    @IBOutlet weak var SubCategorycollectionview:UICollectionView!
    @IBOutlet weak var Varientscollectionview:UICollectionView!
    @IBOutlet weak var homeswitchbtn: UISwitch!

    @IBOutlet weak var searchProductslbs: UITextField!
    @IBOutlet weak var livelbl: UILabel!
    @IBOutlet weak var hederView: UIView!
    @IBOutlet weak var emptyLbl:UILabel!
    @IBOutlet weak var cartCount: UILabel!
    @IBOutlet weak var cartCountView: UIView!
    @IBOutlet weak var logoImg: UIImageView!

    
    var cartCountShow: String? {
        didSet {
            if Int(cartCountShow ?? "0") ?? 0 > 0 {
                self.cartCountView.isHidden = false
            }
            self.cartCount.text = cartCountShow
        }
    }
    
    var Mainview = [String]()
    var subview = [String]()
    var Varientsview = [String]()
    var MaincollectionIndex = 0
    var SubCategorycollectionviewIndex = 0
    var CategoriesResponsedata: [CategoriesResponse] = []
    var manager:SocketManager?
    var socket: SocketIOClient?
    override func viewDidLoad() {
        super.viewDidLoad()

        
        hederView.backgroundColor = UIColor(named: "headercolor")
        
        self.Maincollectionview.delegate = self
        self.Maincollectionview.dataSource = self
        self.SubCategorycollectionview.delegate = self
        self.SubCategorycollectionview.dataSource = self
        self.Varientscollectionview.delegate = self
        self.Varientscollectionview.dataSource = self
        
        let left = UISwipeGestureRecognizer(target : self, action : #selector(Swipeleft))
                        left.direction = .left
                        self.Varientscollectionview.addGestureRecognizer(left)
                        
                let right = UISwipeGestureRecognizer(target : self, action : #selector(Swiperight))
                        right.direction = .right
                        self.Varientscollectionview.addGestureRecognizer(right)
        
        homeswitchbtn.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)

    }
    @IBAction func switchChanged(_ sender: UISwitch) {
           if sender.isOn {
               AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
               let vc = LIVE_videoNew.getVC(.videoStoryBoard)
               self.navigationController?.pushViewController(vc, animated: false)
           }
       }
    
    override func viewWillAppear(_ animated: Bool) {
        let imageDataDict:[String: String] = ["img": "World_Button"]
        NotificationCenter.default.post(name: Notification.Name("globe"), object: nil,userInfo: imageDataDict)
        homeswitchbtn.isOn = false
        cartCountShow = AppDefault.cartCount
        if( AppDefault.CategoriesResponsedata?.count ?? 0 > 0 ){
            self.categoriesApi(isbackground: true, id: "")
            self.CategoriesResponsedata = AppDefault.CategoriesResponsedata ?? []
            self.Maincollectionview.reloadData()
            self.SubCategorycollectionview.reloadData()
            self.Varientscollectionview.reloadData()
        }else{
            self.categoriesApi(isbackground: false, id: "")
        }
        
        self.LanguageRender()

//        if LanguageManager.language == "ar" {
//            hederView.semanticContentAttribute = .forceLeftToRight
//        }else {
//            hederView.semanticContentAttribute = .forceLeftToRight
//        }
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = true
        

     }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            let vc = LIVE_videoNew.getVC(.videoStoryBoard)
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    func LanguageRender(){
        searchProductslbs.placeholder = "searchproducts".pLocalized(lang: LanguageManager.language)
        livelbl.text = "live".pLocalized(lang: LanguageManager.language)
        
        if(LanguageManager.language == "ar"){
            logoImg.image = UIImage(named: "MySouqLogoArwhite")
        }else{
            logoImg.image = UIImage(named: "mysouq")
        }
        
        UIView.appearance().semanticContentAttribute = LanguageManager.language == "ar" ?
            .forceRightToLeft : .forceLeftToRight
        UITextField.appearance().textAlignment = LanguageManager.language == "ar" ? .right : .left
        UICollectionView.appearance().semanticContentAttribute = LanguageManager.language == "ar" ? .forceRightToLeft : .forceLeftToRight
        UICollectionViewCell.appearance().semanticContentAttribute = LanguageManager.language == "ar" ? .forceRightToLeft : .forceLeftToRight
        
        if LanguageManager.language == "ar" {
            Maincollectionview.transform = CGAffineTransform(scaleX: -1, y: 1)
            SubCategorycollectionview.transform = CGAffineTransform(scaleX: -1, y: 1)
            Varientscollectionview.transform = CGAffineTransform(scaleX: -1, y: 1)
        } else {
            Maincollectionview.transform = .identity
            SubCategorycollectionview.transform = .identity
            Varientscollectionview.transform = .identity
        }
        
        
    }
    
    func scrollToIndex(index:Int) {
         let rect = self.SubCategorycollectionview.layoutAttributesForItem(at:IndexPath(row: index, section: 0))?.frame
         self.SubCategorycollectionview.scrollRectToVisible(rect!, animated: true)
       
     }
    @objc func Swipeleft(){
        let cout = CategoriesResponsedata[MaincollectionIndex].subCategories?.count ?? 0
        if(self.SubCategorycollectionviewIndex == cout - 1){
       
           
        }else{
            SubCategorycollectionviewIndex += 1
            self.Maincollectionview.reloadData()
            self.SubCategorycollectionview.reloadData()
            self.Varientscollectionview.reloadData()
           
        }
           }
           
           @objc
           func Swiperight(){
               if( SubCategorycollectionviewIndex == 0){
             
                   
               }else{
                   SubCategorycollectionviewIndex -= 1 
                   self.Maincollectionview.reloadData()
                   self.SubCategorycollectionview.reloadData()
                   self.Varientscollectionview.reloadData()
               }
           }
    
 
    private func categoriesApi(isbackground:Bool,id:String) {
        APIServices.categories(isbackground:isbackground, id: id, limit: 28,completion: {[weak self] data in
            switch data {
            case .success(let res):
                
                
                
                
                
                self?.CategoriesResponsedata = res.Categoriesdata ?? []
                for i in (0 ..< (self?.CategoriesResponsedata.count ?? 0)).reversed() {
              
                    self?.CategoriesResponsedata[i].subCategories?.removeAll(where: {$0.categorySpecs?.productsCount == 0})
                }
                
                
                
                
                
                AppDefault.CategoriesResponsedata = res.Categoriesdata
                
                self?.Maincollectionview.reloadData()
                self?.SubCategorycollectionview.reloadData()
                self?.Varientscollectionview.reloadData()
            case .failure(let error):
                print(error)
                self?.view.makeToast(error)
            }
        })
    }
    
    @IBAction func searchTapped(_ sender: Any) {
        
        let vc = Search_ViewController.getVC(.searchStoryBoard)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    @IBAction func bazaarGharImgBtnTapped(_ sender: Any) {
        
        self.tabBarController?.selectedIndex = 0
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
    
}
extension CategoriesVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
   

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == Maincollectionview {
            return CategoriesResponsedata.count
        }else if collectionView == SubCategorycollectionview {
            if(CategoriesResponsedata.count > 0)
            {
                return CategoriesResponsedata[MaincollectionIndex].subCategories?.count ?? 0
            } else {
                return 0
            }
           
        }else {
            if(CategoriesResponsedata.count > 0){
                if(CategoriesResponsedata[MaincollectionIndex].subCategories?.count ?? 0 > 0){
                    return CategoriesResponsedata[MaincollectionIndex].subCategories?[SubCategorycollectionviewIndex].subCategories?.count ?? 0
                }else{
                    return 0
                }
            }else {
                return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == Maincollectionview {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topcategoriescell", for: indexPath) as! topcategoriescell
            let data = CategoriesResponsedata[indexPath.row]
            cell.imageView.pLoadImage(url: data.mainImage ?? "")
            if LanguageManager.language == "ar" && data.lang?.ar != nil{
                cell.topCatLbl.text = data.lang?.ar?.name ?? ""
            }else{
                cell.topCatLbl.text = data.name ?? ""
            }
            if(self.MaincollectionIndex == indexPath.row){
                cell.bgView.backgroundColor = .white
            }else{
                cell.bgView.backgroundColor = .systemGray6
            }
            
            if LanguageManager.language == "ar" {
                 cell.contentView.transform = CGAffineTransform(scaleX: -1, y: 1)
             } else {
                 cell.contentView.transform = .identity
             }
            
            return cell
        }else if collectionView == SubCategorycollectionview {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubCategoriesCollectionView", for: indexPath) as! SubCategoriesCollectionView
            let data = CategoriesResponsedata[MaincollectionIndex].subCategories?[indexPath.row]
            if LanguageManager.language == "ar" && data?.lang?.ar != nil{
                cell.subcollectionlabel.text = data?.lang?.ar?.name
            }else{
                cell.subcollectionlabel.text = data?.name
            }
            if(self.SubCategorycollectionviewIndex == indexPath.row){
                cell.subcollectionVie.backgroundColor = UIColor(named: "headercolor")
                cell.subcollectionlabel.textColor = .white
                cell.subcollectionVie.borderColor = UIColor.gray
                cell.subcollectionVie.borderWidth = 0
             
            }else{
                cell.subcollectionVie.backgroundColor? = .white
                cell.subcollectionVie.borderColor = UIColor.gray
                cell.subcollectionVie.borderWidth = 1

//                cell.subcollectionlabel.borderColor = UIColor.gray
                cell.subcollectionlabel.textColor = .black
            }
            self.scrollToIndex(index: self.SubCategorycollectionviewIndex)
            // Configure cell with data from array2
            
            if LanguageManager.language == "ar" {
                 cell.contentView.transform = CGAffineTransform(scaleX: -1, y: 1)
             } else {
                 cell.contentView.transform = .identity
             }
            
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VarientsCollectionView", for: indexPath) as! VarientsCollectionView
            let data = CategoriesResponsedata[MaincollectionIndex].subCategories?[SubCategorycollectionviewIndex].subCategories?[indexPath.row]
            cell.Varientscollectionimg.pLoadImage(url: data?.mainImage ?? "")
            if LanguageManager.language == "ar" && data?.lang?.ar != nil{
                cell.Varientscollectionlabel.text = data?.lang?.ar?.name
            }else{
                cell.Varientscollectionlabel.text = data?.name
            }
            if CategoriesResponsedata[MaincollectionIndex].subCategories?[SubCategorycollectionviewIndex].subCategories?.count ?? 0 > 0 {
                emptyLbl.isHidden = true
            }else {
                emptyLbl.isHidden = false
            }
            
            if LanguageManager.language == "ar" {
                 cell.contentView.transform = CGAffineTransform(scaleX: -1, y: 1)
             } else {
                 cell.contentView.transform = .identity
             }
       
            return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == Maincollectionview {
            return CGSize(width: self.Maincollectionview.frame.width, height: self.Maincollectionview.frame.height/8)
            return CGSize(width: self.Maincollectionview.frame.width, height: self.Maincollectionview.frame.height/8)
        }else if collectionView == SubCategorycollectionview {
            let label = UILabel(frame: CGRect.zero)
                  if indexPath.row <= self.CategoriesResponsedata[MaincollectionIndex].subCategories?.count ?? 0 - 1 {
                      if LanguageManager.language == "ar" && CategoriesResponsedata[MaincollectionIndex].subCategories?[indexPath.item].lang?.ar != nil{                          label.text =  self.CategoriesResponsedata[MaincollectionIndex].subCategories?[indexPath.item].lang?.ar?.name
                      }else {
                          label.text =  self.CategoriesResponsedata[MaincollectionIndex].subCategories?[indexPath.item].name
                      }
                  }
                  
                  label.sizeToFit()
            if(CategoriesResponsedata[MaincollectionIndex].subCategories?[indexPath.row].categorySpecs?.productsCount == 0 ||
               CategoriesResponsedata[MaincollectionIndex].subCategories?[indexPath.row].categorySpecs?.productsCount ?? 0 < 1){
                return CGSize(width: 0, height: 0)
            }else{
                return CGSize(width: label.frame.width + 15, height: 45)
            }
            
        }else {
            if(CategoriesResponsedata[MaincollectionIndex].subCategories?[SubCategorycollectionviewIndex].subCategories?[indexPath.row].categorySpecs?.productsCount == 0 ||
               CategoriesResponsedata[MaincollectionIndex].subCategories?[SubCategorycollectionviewIndex].subCategories?[indexPath.row].categorySpecs?.productsCount ?? 0 < 1){
                return CGSize(width: 0, height: 0)
            }else{
                return CGSize(width: self.Varientscollectionview.frame.width/3-10, height: 135)
            }
            
           
        }
        
       
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == Maincollectionview {
            self.MaincollectionIndex = indexPath.item
            
            for (index, i) in (CategoriesResponsedata[indexPath.row].subCategories ?? []).enumerated() {
                if i.categorySpecs?.productsCount ?? 0 > 0 {  // Checking where productsCount > 0
                    SubCategorycollectionviewIndex = index  // Store the index where the loop breaks
                    break
                }
            }
                           
        }else if collectionView == SubCategorycollectionview {
            self.SubCategorycollectionviewIndex = indexPath.item
        }else {
  
            let data = CategoriesResponsedata[MaincollectionIndex].subCategories?[SubCategorycollectionviewIndex].subCategories?[indexPath.row]
            let vc = Category_ProductsVC.getVC(.productStoryBoard)
            vc.prductid = data?.id ?? ""
        
            vc.video_section = false
            vc.storeFlag = false
            vc.catNameTitle = data?.name ?? ""
            
            self.navigationController?.pushViewController(vc, animated: false)
        }
        self.Maincollectionview.reloadData()
        self.SubCategorycollectionview.reloadData()
        self.Varientscollectionview.reloadData()
    }
   

}

