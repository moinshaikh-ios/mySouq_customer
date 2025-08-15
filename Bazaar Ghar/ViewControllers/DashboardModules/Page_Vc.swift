//
//  Page_Vc.swift
//  Bazaar Ghar
//
//  Created by Developer on 07/11/2023.
//

import UIKit

class Page_Vc: UIViewController {

    
    
    @IBOutlet weak var pageCollectionView: UICollectionView!
    @IBOutlet weak var bannerImage: UIImageView!
    
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!

    
    var collectionId: String?
    var offersPageData: [CollectionData] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        offersPage(limit:50,page:1,id:collectionId ?? "")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func offersPage(limit:Int,page:Int,id:String){
        APIServices.collectionDataApi(limit:limit,page:page,collectionId:id){[weak self] data in
            switch data{
            case .success(let res):
                
                self?.bannerImage.pLoadImage(url: res.first?.image ?? "")
                self?.offersPageData = res
                
                self?.scrollHeight.constant = CGFloat((250) + (125 * (res.first?.products?.count ?? 0)))
                
                self?.pageCollectionView.reloadData()
             //
               
            case .failure(let error):
                print(error)
            }
        }
    }
    

}

extension Page_Vc: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  offersPageData.first?.products?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HOMECollectionViewCell", for: indexPath) as! HOMECollectionViewCell
        let data = offersPageData.first?.products?[indexPath.row]
        cell.productimage.pLoadImage(url:  data?.mainImage ?? "")
        cell.productname.text =  data?.productName
        cell.productPrice.text =  data?.regularPrice?.prettyNumberFormat(appDelegate.currencylabel)
        if data?.onSale == true {
            cell.discountPrice.isHidden = false
            cell.discountPrice.text = data?.salePrice?.prettyNumberFormat(appDelegate.currencylabel)
            cell.productPriceLine.isHidden = false
            cell.productPrice.textColor = UIColor.systemGray3

        }else {
            cell.discountPrice.isHidden = true
            cell.productPriceLine.isHidden = true
            cell.productPrice.textColor = UIColor.black

         }
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2-5, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = offersPageData.first?.products?[indexPath.row]
        let vc = NewProductPageViewController.getVC(.productStoryBoard)
//            vc.isGroupBuy = false
           vc.slugid = data?.slug
        self.navigationController?.pushViewController(vc, animated: false)

    }
    
}

