//
//  ProMenuList.swift
//  AgorzCustomer
//
//  Created by admin on 2/25/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import SwiftyJSON

import Lottie


class MenuVCList: UIViewController ,UITableViewDataSource , UITableViewDelegate {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var companyname: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var brandsLbl: UILabel!
    @IBOutlet weak var storesLbl: UILabel!
    @IBOutlet weak var liveLbl: UILabel!
    @IBOutlet weak var groupbyLbl: UILabel!

    @IBOutlet weak var mysouqmenulogo: UIImageView!
    @IBOutlet weak var Top_sidemenuCollect: UICollectionView!
    
    var isSelected  =  ""

    @IBOutlet weak var backButton: UIView!
    @IBOutlet var menuview: UIView!
    var isShowingSubcategories = false
    var selectedSubcategories: [DatumSubCategory] = []
  
    var data = [String]()
    var imagedata = [String]()
    var categoryStates: [CategoryState] = []

    @IBOutlet weak var videoAnimationView: LottieAnimationView!

    
    
    
    
    // new
    var currentLevel: Int = 0
    var currentCategories: [Any] = []
   
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        

        isSelected  = "Home"
        let animation = LottieAnimation.named("new_side_animation")
        videoAnimationView.animation = animation
        videoAnimationView.loopMode = .loop

      
        
        self.menuview.backgroundColor = UIColor.white
               


        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadSSideMenu), name: NSNotification.Name(rawValue: "sidemenuReload"), object: nil)
    }
    
    func langReder(){
        
        if(LanguageManager.language == "ar"){
       
            mysouqmenulogo.image = UIImage(named: "MySouqLogoAr")
        }else{
            mysouqmenulogo.image = UIImage(named: "MySouq-new")
        }
        
    }
    
    
    @IBAction func crossbtn(_ sender: Any) {

        
        self.dismiss(animated: false)


    }
    private lazy var StoreSearchVCs: StoreSearchVC = {
        var vc = StoreSearchVC.getVC(.searchStoryBoard)
        return vc
    }()
    @IBAction func brandstap(_ sender: Any) {
        let vc = HotDealView.getVC(.sidemenu)
        

        self.navigationController?.pushViewController(vc, animated: false)
    }

    @IBAction func groupbuytap(_ sender: Any) {
        

        let vc = Groupby_Controller.getVC(.sidemenu)

        
        self.navigationController?.pushViewController(vc, animated: false)

    }
    @IBAction func storetap(_ sender: Any) {
        let vc = Search_ViewController.getVC(.searchStoryBoard)
        vc.index = 1

        self.navigationController?.pushViewController(vc, animated: false)
    }
    @IBAction func bazaarstap(_ sender: Any) {
        let vc = Search_ViewController.getVC(.searchStoryBoard)
        vc.index = 1

        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func offerstap(_ sender: Any) {
        let vc = offers_page.getVC(.sidemenu)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    @IBAction func livetap(_ sender: Any) {
        let vc = LIVE_videoNew.getVC(.videoStoryBoard)
        self.navigationController?.pushViewController(vc, animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        langReder()
        SetupAppColor()
        self.CreateMenuitemList()
        loadInitialData()
        name.attributedText = Utility().attributedStringWithColoredLastWordBold("topcategories".pLocalized(lang: LanguageManager.language), lastWordColor: UIColor(named: "headercolor")!, otherWordsColor: UIColor(hexString: "#101010"))
        languageRender()
    }
    
    func languageRender() {
        storesLbl.text = "store".pLocalized(lang: LanguageManager.language)
        brandsLbl.text = "hotdeals".pLocalized(lang: LanguageManager.language)
        liveLbl.text = "live".pLocalized(lang: LanguageManager.language)
        groupbyLbl.text = "groupbuy".pLocalized(lang: LanguageManager.language)
    }
    
    func loadInitialData() {
        if let categories = AppDefault.getAllCategoriesResponsedata {
            currentCategories = categories
            currentLevel = 0
            tableview.reloadData()
//            backButton.isHidden = true
           
        }
    }
    
    override func dismissViewController(_ sender: UIButton) {
        if isShowingSubcategories {
               isShowingSubcategories = false
            categoryStates.removeAll()

            tableview.reloadData()
           }
    }
    @objc func reloadSSideMenu(notification: Notification) {


    }
    func SetupAppColor(){
        
    }
//    @IBAction func backButtonPressed(_ sender: Any) {
//        if(currentLevel == 1){
//            backButton.isHidden = true
//        }
//        guard !categoryStates.isEmpty else { return }
//           let previousState = categoryStates.removeLast()
//           currentCategories = previousState.categories
//           currentLevel = previousState.level
//           tableview.reloadData()
//
//    }
//    @IBAction func btnMenu_click(_ sender: Any) {
//        self.sideMenuController?.toggle()
//    }
    func CreateMenuitemList() {

          imagedata = ["home","current trips","next day trips","logout"]
//          data = ["Home","Current Trips","Next Day Trips","Logout"]

        
      
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentCategories.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SideMenuCell
//        cell.selectionStyle = .none
//        let dict  = AppDefault.getAllCategoriesResponsedata?[indexPath.row]
//        cell.lab.text = dict?.name
//        cell.imagelbl.pLoadImage(url: dict?.mainImage ?? "" )
//
//        cell.imagelbl.tintColor = .gray
//        cell.lab.textColor  =  .black
//
//        if cell.lab.text == isSelected{
//
//        }
        cell.selectionStyle = .none
            
            if currentLevel == 0 {
                let category = currentCategories[indexPath.row] as? getAllCategoryResponse
                if LanguageManager.language == "ar" && category?.lang?.ar != nil{
                    cell.lab.text = category?.lang?.ar?.name ?? category?.name
                }else{
                    cell.lab.text = category?.name
                }
                cell.imagelbl.pLoadImage(url: category?.mainImage ?? "")
                
            } else if currentLevel == 1 {
                let subCategory = currentCategories[indexPath.row] as? DatumSubCategory
                if LanguageManager.language == "ar" && subCategory?.lang?.ar != nil{
                    cell.lab.text = subCategory?.lang?.ar?.name ?? subCategory?.name
                }else{
                    cell.lab.text = subCategory?.name
                }
                cell.imagelbl.pLoadImage(url: subCategory?.mainImage ?? "")
            } else if currentLevel == 2 {
                let subSubCategory = currentCategories[indexPath.row] as? DatumSubCategory
                if LanguageManager.language == "ar" && subSubCategory?.lang?.ar != nil{
                    cell.lab.text = subSubCategory?.lang?.ar?.name ?? subSubCategory?.name
                }else{
                    cell.lab.text = subSubCategory?.name
                }
                cell.imagelbl.pLoadImage(url: subSubCategory?.mainImage ?? "")
            } else if currentLevel == 3 {
                let subSubSubCategory = currentCategories[indexPath.row] as! DatumSubCategory
                cell.lab.text = subSubSubCategory.name
                cell.imagelbl.pLoadImage(url: subSubSubCategory.mainImage ?? "")
            }
        
        cell.arrowBtn.setImage(LanguageManager.language == "ar" ? UIImage(systemName: "chevron.left.circle.fill") : UIImage(systemName: "chevron.right.circle.fill") , for: .normal)
            cell.imagelbl.tintColor = .gray
            cell.lab.textColor = .black
            
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if currentLevel == 2 {
            var a  = currentCategories[indexPath.row] as! DatumSubCategory
            if(a.categorySpecs?.productsCount == 0 || a.categorySpecs?.productsCount ?? 0 < 0){
                return 0
            }
            else {
                return 65
            }
        }else {
            return 65
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       

        categoryStates.append(CategoryState(categories: currentCategories, level: currentLevel))
       

        if currentLevel == 0 {
                let selectedCategory = currentCategories[indexPath.row] as? getAllCategoryResponse
            if let subCategories = selectedCategory?.subCategories, !subCategories.isEmpty {
                    currentCategories = subCategories
                    currentLevel = 1
                    tableView.reloadData()
                } else {
                    let vc = Category_ProductsVC.getVC(.productStoryBoard)
                    vc.prductid = selectedCategory?.id ?? ""
                    vc.video_section = false
                    vc.storeFlag = false
                    vc.catNameTitle = selectedCategory?.name ?? ""
                    self.navigationController?.pushViewController(vc, animated: false)
                    categoryStates.removeAll()
                }
            } else if currentLevel == 1 {
                let selectedSubCategory = currentCategories[indexPath.row] as? DatumSubCategory
                if let subSubCategories = selectedSubCategory?.subCategories, !subSubCategories.isEmpty {
                    currentCategories = subSubCategories
                    currentLevel = 2
                    tableView.reloadData()
                } else {
                  
                    let vc = Category_ProductsVC.getVC(.productStoryBoard)
                    vc.prductid = selectedSubCategory?.id ?? ""
                    vc.video_section = false
                    vc.storeFlag = false
                    vc.catNameTitle = selectedSubCategory?.name ?? ""
                    self.navigationController?.pushViewController(vc, animated: false)
                    categoryStates.removeAll()
//                    self.view.makeToast("Subcategories are empty")
                }
            } else if currentLevel == 2 {
                let selectedSubSubCategory = currentCategories[indexPath.row] as? DatumSubCategory
                if let subSubSubCategories = selectedSubSubCategory?.subCategories, !subSubSubCategories.isEmpty {
                    currentCategories = subSubSubCategories
                    currentLevel = 3
                    tableView.reloadData()
                } else {
                    let vc = Category_ProductsVC.getVC(.productStoryBoard)
                    vc.prductid = selectedSubSubCategory?.id ?? ""
                    vc.video_section = false
                    vc.storeFlag = false
                    vc.catNameTitle = selectedSubSubCategory?.name ?? ""
                    self.navigationController?.pushViewController(vc, animated: false)
                    categoryStates.removeAll()
                }
            } else if currentLevel == 3 {
                let selectedSubSubSubCategory = currentCategories[indexPath.row] as? DatumSubCategory
                if let subSubSubSubCategories = selectedSubSubSubCategory?.subCategories, !subSubSubSubCategories.isEmpty {
                    currentCategories = subSubSubSubCategories
                    currentLevel = 4
                    tableView.reloadData()
                } else {
                    let vc = Category_ProductsVC.getVC(.productStoryBoard)
                    vc.prductid = selectedSubSubSubCategory?.id ?? ""
                    vc.video_section = false
                    vc.storeFlag = false
                    vc.catNameTitle = selectedSubSubSubCategory?.name ?? ""
                    self.navigationController?.pushViewController(vc, animated: false)
                    categoryStates.removeAll()
                }
            }
//        if categoryStates.isEmpty {
//            self.backButton.isHidden = true // Hide back button when no more previous states
//        }else{
//            self.backButton.isHidden = false
//        }
    }
 }


struct CategoryState {
    let categories: [Any]
    let level: Int
}
