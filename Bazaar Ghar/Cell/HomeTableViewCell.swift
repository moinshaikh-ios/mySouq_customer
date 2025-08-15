//
//  HomeTableViewCell.swift
//  Bazaar Ghar
//
//  Created by Developer on 21/08/2023.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    @IBOutlet weak var Homecollectionview: UICollectionView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var cateogorylbl: UILabel!
    @IBOutlet weak var catBannerBtn: UIButton!
    @IBOutlet weak var arrowBtn: UIButton!
    @IBOutlet weak var subCatCollectionView: UICollectionView!
    @IBOutlet weak var subCatViewHeight: NSLayoutConstraint!
    @IBOutlet weak var arrowImg: UIImageView!

    
    var productvariantsapi: [Variants]? = nil{
        didSet{
            
            
        }
        
    }
    let centerTransitioningDelegate = CenterTransitioningDelegate()

    
    
     var productapi: [Product]? = nil{
         didSet{
             if(AppDefault.islogin){
                 wishList(isbackground: true)
             }
             if productapi?.count ?? 0 > 0 {
                 Homecollectionview.backgroundView = nil
             }else {
                 let messageLabel = UILabel()
                             messageLabel.text = "Product not found"
                             messageLabel.textAlignment = .center
                             messageLabel.font = UIFont.systemFont(ofSize: 18)
                             messageLabel.textColor = .gray
                             
                 Homecollectionview.backgroundView = messageLabel
             }
             self.Homecollectionview.reloadData()
         }
     }
    var subCatData: [DatumSubCategory] = [] {
        didSet {
            subCatData = []
            if subCatData.count > 0 {
                subCatViewHeight.constant = 150
            }else {
                subCatViewHeight.constant = 0
            }
            subCatCollectionView.reloadData()
        }
    }
    var nav:UINavigationController?
    
    
    var index:Int?
    var selectedIndex = 0
    var origin:String?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupCollectionView()
    }
    func setupCollectionView() {
        let nib = UINib(nibName: "HomeLastProductCollectionViewCell", bundle: nil)
        Homecollectionview.register(nib, forCellWithReuseIdentifier: "HomeLastProductCollectionViewCell")
        Homecollectionview.delegate = self
        Homecollectionview.dataSource  = self
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func wishList(isbackground: Bool){
        APIServices.wishlist(isbackground: isbackground){[weak self] data in
          switch data{
          case .success(let res):
            AppDefault.wishlistproduct = res.products
            self?.Homecollectionview.reloadData()
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
    //        self?.view.makeToast(error)
          }
        })
      }
    
    private func productcategoriesApi(cat:String,cat2:String,cat3:String,cat4:String,cat5:String,cat6:String,isbackground:Bool,origin:String){
        APIServices.shopchinaproductcategories(cat: cat, cat2: cat2, cat3: cat3, cat4: cat4, cat5: cat5, cat6: cat6, origin: origin,isbackground:isbackground,completion: {[weak self] data in
            switch data{
            case .success(let res):
                if(res.count > 0){
                    if res.first?.product?.first?.regularPrice == nil {
                        self?.productapi = res.first?.product
//                        UIApplication.pTopViewController().view.makeToast("product not found")
                    }else {
                        self?.productapi = res.first?.product
                    }
                }
            
            case .failure(let error):
                print(error)
            }
        })
    }
    

}

extension HomeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//            return 1
//        }
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if collectionView == subCatCollectionView {
                return subCatData.count
            }else {
                return productapi?.count ?? 0
            }
        }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == subCatCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubCategoryCollectionViewCell", for: indexPath) as! SubCategoryCollectionViewCell
            let data = subCatData[indexPath.row]
            cell.catName.text =  LanguageManager.language == "ar" ? data.lang?.ar?.name : data.name
            cell.catImg.pLoadImage(url: data.mainImage ?? "")
            
            
            if selectedIndex == indexPath.row {
                cell.backgroundVieww.backgroundColor = UIColor(named: "headercolor")
                cell.catName.textColor = .white
                cell.backgroundVieww.borderWidth = 0
            }else {
                cell.backgroundVieww.backgroundColor = .white
                cell.catName.textColor = .black
                cell.backgroundVieww.borderWidth = 1
            }
            
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeLastProductCollectionViewCell", for: indexPath) as! HomeLastProductCollectionViewCell
            let data = productapi?[indexPath.row]
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
                cell.discountPrice.attributedText = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(data?.salePrice ?? 0, label: cell.discountPrice))
                cell.productPrice.attributedText = "\(appDelegate.currencylabel) \(Utility().formatNumberWithCommas(data?.regularPrice ?? 0, label: cell.productPrice).trimmingCharacters(in: .whitespaces))".strikeThrough()
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
            cell.cartButton.tag = indexPath.row
            cell.cartButton.addTarget(self, action: #selector(catBannerBtnTapped(_:)), for: .touchUpInside)
            cell.heartBtn.tag = indexPath.row
            cell.heartBtn.addTarget(self, action: #selector(LatestMobileheartButtonTap(_:)), for: .touchUpInside)

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
        }
        
       
    }
    @objc func LatestMobileheartButtonTap(_ sender: UIButton) {
        if(AppDefault.islogin){
              let index = sender.tag
              let item = productapi?[index]
              self.wishListApi(productId: (item?.id ?? ""))
            }else{
                let vc = PopupLoginVc.getVC(.popups)
              vc.modalPresentationStyle = .overFullScreen
                UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
            }
    }
    
    @objc func catBannerBtnTapped(_ sender: UIButton) {
        let data = productapi?[sender.tag]
        
        if AppDefault.islogin == true {
            if (data?.variants?.countVariants() ?? 0 > 0) {
                let vc = NewProductPageViewController.getVC(.productStoryBoard)
                vc.slugid = data?.slug
                nav?.pushViewController(vc, animated: false)
            }else {
                let vc = CartPopupViewController.getVC(.popups)
               
                vc.modalPresentationStyle = .custom
                vc.transitioningDelegate = centerTransitioningDelegate
                vc.products = data
                vc.nav = self.nav
                UIApplication.pTopViewController().present(vc, animated: true, completion: nil)
            }
        }else {
            let vc = PopupLoginVc.getVC(.popups)
           vc.modalPresentationStyle = .overFullScreen
            UIApplication.pTopViewController().present(vc, animated: true, completion: nil)
        }
        

        
        
//        if (data?.variants?.first?.selectedAttributes?.count ?? 0 > 0) {
//            let vc = CartPopupViewController.getVC(.popups)
//           
//            vc.modalPresentationStyle = .custom
//            vc.transitioningDelegate = centerTransitioningDelegate
//            vc.products = data
//            vc.nav = self.nav
//            UIApplication.pTopViewController().present(vc, animated: true, completion: nil)
//        }else {
//            let vc = NewProductPageViewController.getVC(.productStoryBoard)
//            vc.slugid = data?.slug
//            nav?.pushViewController(vc, animated: false)
//        }
        

    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == subCatCollectionView {
            selectedIndex = indexPath.row
            let data = subCatData[indexPath.row]
//            let imageDataDict:[String: Any] = ["id": data.id ?? "", "index": self.index ?? 0]
//            NotificationCenter.default.post(name: Notification.Name("subcatupdate"), object: nil,userInfo: imageDataDict)
            
            self.productcategoriesApi(cat: data.id ?? "", cat2: "", cat3: "", cat4: "", cat5: "", cat6: "",isbackground: false, origin: self.origin ?? "")

            subCatCollectionView.reloadData()
        }else {
            let data = productapi?[indexPath.row]
            let vc = NewProductPageViewController.getVC(.productStoryBoard)
            vc.slugid = data?.slug
            nav?.pushViewController(vc, animated: false)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == subCatCollectionView {
            let data = subCatData[indexPath.row]
//            if data.categorySpecs?.productsCount == 0 {
//                return CGSize(width: 0, height: 0)
//            }else {
                return CGSize(width: subCatCollectionView.frame.width/1.7, height: subCatCollectionView.frame.height)
//            }
        }else {
            return CGSize(width: Homecollectionview.frame.width/2-5, height: 280)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
   
}
