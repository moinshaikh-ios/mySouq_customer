//
//  wishlist_vc.swift
//  Bazaar Ghar
//
//  Created by Zany on 21/09/2023.
//

import UIKit

class wishlist_vc: UIViewController {
    
    var wishListItems: [Product] = []
    @IBOutlet weak var wishlistcollection: UICollectionView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var wishlistLbl: UILabel!
    @IBOutlet weak var emptyview: UIView!
    @IBOutlet weak var emptylbl: UILabel!

    let centerTransitioningDelegate = CenterTransitioningDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
     
//        if((self.tabBarController?.tabBar.isHidden) != nil){
//            appDelegate.isbutton = true
//        }else{
//            appDelegate.isbutton = false
//        }
//        NotificationCenter.default.post(name: Notification.Name("ishideen"), object: nil)
        
        self.emptyview.isHidden = true

        setupCollectionView()
        // Do any additional setup after loading the view.
    }
    
    func setupCollectionView() {
        let nib = UINib(nibName: "HomeLastProductCollectionViewCell", bundle: nil)
        wishlistcollection.register(nib, forCellWithReuseIdentifier: "HomeLastProductCollectionViewCell")
        wishlistcollection.delegate = self
        wishlistcollection.dataSource  = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        wishList()
        LanguageRender()
    }
    
    func LanguageRender() {
        
        if LanguageManager.language == "ar"{
            backBtn.setImage(UIImage(systemName: "arrow.right"), for: .normal)
           }else{
               backBtn.setImage(UIImage(systemName: "arrow.left"), for: .normal)
           }
        wishlistLbl.text = "wishlist".pLocalized(lang: LanguageManager.language)

        
    }
    
     func wishList(){
         APIServices.wishlist(isbackground: false){[weak self] data in
            switch data{
            case .success(let res):
             //
                self?.wishListItems = res.products ?? []
                self?.wishListItems.reverse()
                self?.wishlistcollection.reloadData()
                if(self?.wishListItems.count ?? 0 > 0){
                    self?.emptyview.isHidden = true
                    self?.emptylbl.isHidden = true

                }else{
                    self?.emptyview.isHidden = false
                    self?.emptylbl.isHidden = false
                }
            case .failure(let error):
                self?.emptyview.isHidden = false
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
              self?.wishList()
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

    
    
    @IBAction func backBtnTapped(_ sender: Any) {
//        appDelegate.isbutton = false
//    NotificationCenter.default.post(name: Notification.Name("ishideen"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
   

}
extension wishlist_vc:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.wishListItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeLastProductCollectionViewCell", for: indexPath) as! HomeLastProductCollectionViewCell
        let data = wishListItems[indexPath.row]
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
            cell.discountPrice.attributedText = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(data.salePrice ?? 0, label: cell.discountPrice))
            cell.productPrice.attributedText = "\(appDelegate.currencylabel) \(Utility().formatNumberWithCommas(data.regularPrice ?? 0, label:  cell.productPrice).trimmingCharacters(in: .whitespaces))".strikeThrough()
            cell.productPriceLine.isHidden = true
            cell.productPrice.textColor = UIColor.red
            cell.productPriceLine.backgroundColor = UIColor.red
            cell.percentBGView.isHidden = false

        }else {
            cell.productPriceLine.isHidden = true
            cell.productPrice.isHidden = true
            cell.discountPrice.attributedText = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(data.regularPrice ?? 0, label:   cell.discountPrice))
            cell.percentBGView.isHidden = true
         }
        
        cell.heartBtn.tag = indexPath.row
        cell.cartButton.tag = indexPath.row
        cell.cartButton.addTarget(self, action: #selector(cartButtonTap(_:)), for: .touchUpInside)
        cell.heartBtn.addTarget(self, action: #selector(homeLatestMobileheartButtonTap(_:)), for: .touchUpInside)
        
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
        let data = wishListItems[sender.tag]
        
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


    }
    
    @objc func homeLatestMobileheartButtonTap(_ sender: UIButton) {
        if(AppDefault.islogin){
              let index = sender.tag
              let item = wishListItems[index]
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
        let data =  self.wishListItems[indexPath.row]
        let vc = NewProductPageViewController.getVC(.productStoryBoard)
//            vc.isGroupBuy = false
            vc.slugid = data.slug
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.wishlistcollection.frame.width/2.1-2,
                      height: 280)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 5, bottom: 10, right: 5)
    }
    
    }



//
//extension wishlist_vc: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return wishListItems.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let data = wishListItems[indexPath.row]
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
//            cell.imageView.pLoadImage(url: data.mainImage ?? "")
//
//            return cell
//
//    }
//}
