//
//  Shopbeyound_TableViewCell.swift
//  Bazaar Ghar
//
//  Created by Developer on 14/06/2024.
//

import UIKit

class Shopbeyound_TableViewCell: UITableViewCell {
    @IBOutlet weak var shopbeyound_CollectionView: UICollectionView!
    @IBOutlet weak var shop_img: UIImageView!

    @IBOutlet weak var explore_btn: UIButton!
    @IBOutlet weak var shopname_lbl: UILabel!
    @IBOutlet weak var exploreNowLbl: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var exploreNowArrow: UIButton!
    
    
    var CategoriesResponsedata: [getAllCategoryResponse] = []
    var count = 0
    var nav : UINavigationController?
    
    var KSA : [KSAcat] = []
    var China : [KSAcat] = []
    var Pak : [KSAcat] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        shopbeyound_CollectionView.dataSource = self
        shopbeyound_CollectionView.delegate = self
        // Initialization code
        KSA = [
            KSAcat(name: "Home Appliances",id: "66fa5e0756711740c0637b08",img: "https://bazaarghar-stage.s3.me-south-1.amazonaws.com/17278499243161707723343428consumer-electronics.png", arName: "الأجهزة المنزلية"),
            
            KSAcat(name: "Abaya, Hijabs & Shrugs",id: "66fa5e0756711740c0637a5c",img: "https://cdn.bazaarghar.com/1670841873220abbaya.png", arName: "العباية والحجابات والشالات"),
            
            KSAcat(name: "Audio & Video",id: "66fa5e0756711740c0637adc",img:"https://bazaarghar-stage.s3.me-south-1.amazonaws.com/17278559370301640605173236audio-video.png", arName: "الصوت والفيديو"),
            
            KSAcat(name: "Watches",id: "66fa5e0756711740c0637c6e",img:"https://bazaarghar-stage.s3.me-south-1.amazonaws.com/17278545523501640604011524watches.png", arName: "الساعات"),
       
        ]
        
        China = [
        KSAcat(name: "Home and Lifestyle",id: "66fa5e0756711740c0637b7e",img:  "https://bazaarghar-stage.s3.me-south-1.amazonaws.com/17278499911991707723393718home-life-style.png",arName: "المنزل ونمط الحياة"),
            
        KSAcat(name: "Women",id: "66fa5e0756711740c0637a5a",img: "https://bazaarghar-stage.s3.me-south-1.amazonaws.com/17279324640241714392382431women-clothing.png",arName: "نحيف"),
        
        KSAcat(name: "Accessories",id: "66fa5e0956711740c06380f4",img: "https://bazaarghar-stage.s3.me-south-1.amazonaws.com/17279317081721640605905715chargers-data-cables.png", arName: "مُكَمِّلات"),
        
        KSAcat(name: "Footwear",id: "66fa5e0756711740c0637c3c",img:  "https://bazaarghar-stage.s3.me-south-1.amazonaws.com/17278544971851724831211715joggers-sneakers.png",arName: "الأحذية"),
       
        ]
        
        Pak = [
            KSAcat(name: "Hand Bags",id:"66fa5e0756711740c0637dd4" ,img: "https://cdn.bazaarghar.com/1640607310826ladies-handbags.png", arName: "حقائب اليد"),
            
            KSAcat(name: "Eastern Wear",id:"66fa5e0756711740c0637a62" ,img:"https://cdn.bazaarghar.com/1640677218387women-stitched.png",arName: "الملابس الشرقية"),
            
            KSAcat(name: "Truck Art",id:"66fa5e0856711740c0637ee2" ,img:"https://bazaarghar-stage.s3.me-south-1.amazonaws.com/17279387194441717658331032truck-art.png",arName: "فن الشاحنة"),
            
            KSAcat(name: "Eastern Footwear",id:"66fa5e0756711740c0637c48" ,img:"https://cdn.bazaarghar.com/1729508323337eastern-wear-mens.png",arName: "الأحذية الشرقية"),
         
         ]
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
extension Shopbeyound_TableViewCell: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Shopbeyound_CollectionViewCell", for: indexPath) as! Shopbeyound_CollectionViewCell
        if count == 1 {
                let data = Pak[indexPath.row]
                if LanguageManager.language == "ar"{
                    cell.lbl.text = " \(data.arName ?? "")  "
                }else{
                    cell.lbl.text = " \(data.name ?? "")  "

                }
                cell.shop_img.pLoadImage(url: data.img ?? "")
            
        }else if count == 2 {
                
                let data = China[indexPath.row]
                cell.shop_img.pLoadImage(url: data.img ?? "")
                if LanguageManager.language == "ar"{
                    cell.lbl.text = " \(data.arName ?? "")  "
                }else{
                    cell.lbl.text = " \(data.name ?? "")  "
                }
        }else {
                
                let data = KSA[indexPath.row]
                cell.shop_img.pLoadImage(url: data.img ?? "")
                if LanguageManager.language == "ar"{
                    cell.lbl.text = " \(data.arName ?? "")  "
                }else{
                    cell.lbl.text = " \(data.name ?? "")  "

                }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if count == 1 {
            let data = Pak[indexPath.row]

            let vc = Category_ProductsVC.getVC(.productStoryBoard)
            vc.prductid = data.id ?? ""
            vc.video_section = false
            vc.storeFlag = false
            vc.catNameTitle = LanguageManager.language == "ar" ? data.arName ?? "" : data.name ?? ""
            vc.origin = "pak"
            self.nav?.pushViewController(vc, animated: false)
        }else if count == 2 {
            let data = China[indexPath.row]

            let vc = Category_ProductsVC.getVC(.productStoryBoard)
            vc.prductid = data.id ?? ""
            vc.video_section = false
            vc.storeFlag = false
            vc.catNameTitle = LanguageManager.language == "ar" ? data.arName ?? "" : data.name ?? ""
            vc.origin = "china"
            self.nav?.pushViewController(vc, animated: false)
        }else {
            let data = KSA[indexPath.row]

            let vc = Category_ProductsVC.getVC(.productStoryBoard)
            vc.prductid = data.id ?? ""
            vc.video_section = false
            vc.storeFlag = false
            vc.catNameTitle = LanguageManager.language == "ar" ? data.arName ?? "" : data.name ?? ""
            vc.origin = "ksa"
            self.nav?.pushViewController(vc, animated: false)
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
   
      
        return CGSize(width: self.shopbeyound_CollectionView.frame.width/2.04, height: self.shopbeyound_CollectionView.frame.height/2.04)
        
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
         return UIEdgeInsets.zero // No insets
     }
     
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         return 5 // No spacing between lines
     }
     
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
         return 1 // No spacing between items
     }
}
