//
//  HotDealProducts.swift
//  Bazaar Ghar
//
//  Created by Developer on 24/04/2025.
//

import UIKit

class HotDealProducts: UIViewController {
    var id: String?
    @IBOutlet weak var header: UILabel!
    var headerName : String?
    var products: [Product]?
    let centerTransitioningDelegate = CenterTransitioningDelegate()

    @IBOutlet weak var hotdealscollectionview: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "HomeLastProductCollectionViewCell", bundle: nil)
        hotdealscollectionview.register(nib, forCellWithReuseIdentifier: "HomeLastProductCollectionViewCell")
        hotdealscollectionview.delegate = self
        hotdealscollectionview.dataSource = self
        self.header.text = headerName ?? ""
        hotdealsapi(id:id ?? "")
        wishList()
       

        // Do any additional setup after loading the view.
    }
    
    func hotdealsapi(id:String){
        APIServices.hotdealsPorductApi(id:id){[weak self] data in
       switch data{
       case .success(let res):
           
           self?.products = res.first?.products ?? []
           self?.hotdealscollectionview.reloadData()
       case .failure(let error):
  //         UIApplication.pTopViewController().navigationController?.popViewController(animated: true)
           self?.view.makeToast(error)
        }
       }
     }
    private func wishListApi(productId:String) {
        APIServices.newwishlist(product:productId,completion: {[weak self] data in
          switch data{
          case .success(let res):
           //
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
    //        self?.view.makeToast(error)
          }
        })
      }
    func wishList(){
            APIServices.wishlist(isbackground: false){[weak self] data in
              switch data{
              case .success(let res):
              //
                AppDefault.wishlistproduct = res.products
                  self?.hotdealscollectionview.reloadData()

//                  if let wishlistProducts = AppDefault.wishlistproduct {
//                      if wishlistProducts.contains(where: { $0.id == self?.products?.first?.welcomeID ?? "" }) {
////                          self?.heartBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
////                          self?.heartBtn.tintColor = .red
//                          } else {
////                              self?.heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
//    //                          self?.heartBtn.tintColor = UIColor(named: "headercolor")
//                          }
//                        }
                  self?.hotdealscollectionview.reloadData()
              case .failure(let error):
                print(error)
              }
            }
          }
}



extension HotDealProducts:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
   
        return self.products?.count ?? 0
    
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeLastProductCollectionViewCell", for: indexPath) as! HomeLastProductCollectionViewCell
        let data =  self.products?[indexPath.row]
        cell.percentBGView.backgroundColor = UIColor(named: "greenColor")
        cell.product = data
        cell.productimage.pLoadImage(url: data?.mainImage ?? "")
        cell.productname.text =  data?.productName ?? ""
        cell.productPrice.text =  appDelegate.currencylabel + Utility().formatNumberWithCommas(data?.regularPrice ?? 0, label:  cell.productPrice)
        if data?.onSale == true {
                cell.discountPrice.isHidden = false
            cell.discountPrice.attributedText = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(data?.salePrice ?? 0, label:  cell.discountPrice))

                cell.productPriceLine.isHidden = false
                cell.productPrice.textColor = UIColor.red
                cell.productPriceLine.backgroundColor = UIColor.red
                cell.percentBGView.isHidden = false
                
            }else {
                cell.discountPrice.isHidden = true
                cell.productPriceLine.isHidden = true
                cell.productPrice.attributedText = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(data?.regularPrice ?? 0, label:  cell.productPrice))
                cell.percentBGView.isHidden = true
             }
            cell.heartBtn.tag = indexPath.row
            cell.cartButton.tag = indexPath.row
            cell.cartButton.addTarget(self, action: #selector(cartButtonTap(_:)), for: .touchUpInside)
            cell.heartBtn.addTarget(self, action: #selector(heartButtonTap(_:)), for: .touchUpInside)
                     
        if let wishlistProducts = AppDefault.wishlistproduct {
            if wishlistProducts.contains(where: { $0.id == data?._id  ?? ""}) {
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
        let data = products?[sender.tag]

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
//            vc.onDismiss = {
//                self.cartCountShow = AppDefault.cartCount
//            }
            self.present(vc, animated: true, completion: nil)
        }

    }
    
    @objc func heartButtonTap(_ sender: UIButton) {
        if(AppDefault.islogin){
            let index = sender.tag
            let item = products?[index]
            if item?.id == nil {
                self.wishListApi(productId: (item?._id ?? ""))
            }else {
                self.wishListApi(productId: (item?.id ?? ""))
            }
        }
        else{
                let vc = PopupLoginVc.getVC(.popups)
              vc.modalPresentationStyle = .overFullScreen
              self.present(vc, animated: true, completion: nil)
            }


    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        let data =  self.products?[indexPath.row]
            
            let vc = NewProductPageViewController.getVC(.productStoryBoard)
//            vc.isGroupBuy = false
        vc.slugid = data?.slug
            self.navigationController?.pushViewController(vc, animated: false)
         
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        return CGSize(width: self.hotdealscollectionview.frame.width/2.03, height: 280)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 4

    }
    
  
    

    
    }
    
    

//extension Category_ProductsVC: UIScrollViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//       
//            let offsetY = scrollView.contentOffset.y
//            let contentHeight = scrollView.contentSize.height
//            let height = scrollView.frame.size.height
//            
//            // If user scrolls to the bottom
//            if offsetY > contentHeight - height {
//                // Call your function to load more products
//                loadMoreProducts()
//            }
//        
//    }
//    
//    func loadMoreProducts() {
//        guard !isLoadingNextPage && !isEndReached else {
//            return // Return if already loading next page or end is reached
//        }
//        
//        isLoadingNextPage = true
//        
//        // Call your API to fetch more products
//        update(count: categoryPage)
//    }
//}


//extension Category_ProductsVC: UIAdaptivePresentationControllerDelegate {
//    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
//        print("You dismissed the presented controller")
//    }
//}
