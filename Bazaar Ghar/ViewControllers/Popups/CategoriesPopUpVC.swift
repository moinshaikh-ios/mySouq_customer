//
//  CategoriesPopUpVC.swift
//  Bazaar Ghar
//
//  Created by Developer on 24/06/2024.
//

import UIKit

class CategoriesPopUpVC: UIViewController {
    var CategoriesResponsedata: [getAllCategoryResponse] = []
    @IBOutlet weak var topcell_1: UICollectionView!
    @IBOutlet weak var categoriesLbl: UILabel!
    @IBOutlet weak var applyBtnLbl: UILabel!

    var id:String?
    var selectedIndex:Int?
    var catname : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        topcell_1.delegate = self
        topcell_1.dataSource = self
 CategoriesResponsedata =  AppDefault.getAllCategoriesResponsedata ?? []
        topcell_1.reloadData()
        LanguageRender()
    }
    
    func LanguageRender() {
        categoriesLbl.text = "categories".pLocalized(lang: LanguageManager.language)
        applyBtnLbl.text = "apply".pLocalized(lang: LanguageManager.language)
        UIView.appearance().semanticContentAttribute = LanguageManager.language == "ar" ? .forceRightToLeft : .forceLeftToRight
        UITextField.appearance().textAlignment = LanguageManager.language == "ar" ? .right : .left

         if LanguageManager.language == "ar" {
           topcell_1.transform = CGAffineTransform(scaleX: -1, y: 1)
         } else {
            topcell_1.transform = .identity
         }
    }
    
   
    @IBAction func applyBtnTapped(_ sender: Any) {
        if self.id == nil{
            self.view.makeToast("Please Select Category")
        }else{
            self.dismiss(animated: false)
            let imageDataDict:[String: String] = ["id": self.id ?? "", "cat":"cat","catname":catname ?? ""]
            NotificationCenter.default.post(name: Notification.Name("idpass"), object: nil,userInfo: imageDataDict)
        }
    }
 

}
extension CategoriesPopUpVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return CategoriesResponsedata.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
       
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topcategoriescell", for: indexPath) as! topcategoriescell
        let data = CategoriesResponsedata[indexPath.row]
        cell.imageView.pLoadImage(url: data.mainImage ?? "")
            
            
            if LanguageManager.language == "ar" && data.lang?.ar != nil{
                cell.topCatLbl.text = data.lang?.ar?.name
            }else{
                cell.topCatLbl.text = data.name
            }
        
        if self.id == data.id {
            cell.imageView.borderColor = UIColor(named: "greenColor")
            cell.imageView.borderWidth = 2
        }else {
            cell.imageView.borderColor = .gray
        }
        
        if LanguageManager.language == "ar" {
             cell.contentView.transform = CGAffineTransform(scaleX: -1, y: 1)
         } else {
             cell.contentView.transform = .identity
         }
            
            return cell
        
    }
    
   
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
      
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
            return CGSize(width: self.topcell_1.frame.width/3.9-10, height: self.topcell_1.frame.height/2.1-5)

        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
          return  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        let data = CategoriesResponsedata[indexPath.row]
                     self.id = data.id
        self.selectedIndex = indexPath.row
        catname = data.name
        collectionView.reloadData()
//              let vc = Category_ProductsVC.getVC(.productStoryBoard)
//        vc.prductid = data.id ?? ""
//              vc.video_section = false
//              vc.storeFlag = false
//        vc.catNameTitle = data.name ?? ""
//              self.navigationController?.pushViewController(vc, animated: false)
          
        
    }
    
}
