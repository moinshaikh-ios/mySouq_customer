//
//  ProductSearch_VC.swift
//  Bazaar Ghar
//
//  Created by Umair ALi on 06/09/2023.
//

import UIKit

class ProductSearch_VC: UIViewController {
    @IBOutlet weak var productsearchcollection: UICollectionView!

    @IBOutlet weak var notFound: UILabel!

    var searchproductdata: [Product] = []

    var searchText: String? {
        didSet{
            searchproduct(name: "productName" , limit: 40, page: 1, value: searchText ?? "")

        }
    }
    var isEndReached = false
    var isLoadingNextPage = false
    var categoryPage = 0
    let centerTransitioningDelegate = CenterTransitioningDelegate()
                                            
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()

    }
    override func viewWillAppear(_ animated: Bool) {
        notFound.isHidden = true
        self.searchproductdata = []
        searchproduct(name: "productName" , limit: 40, page: 1, value: searchText ?? "")
    }
    
    func setupCollectionView() {
        let nib = UINib(nibName: "HomeLastProductCollectionViewCell", bundle: nil)
        productsearchcollection.register(nib, forCellWithReuseIdentifier: "HomeLastProductCollectionViewCell")
        productsearchcollection.delegate = self
        productsearchcollection.dataSource = self
    }

    
    
    private func searchproduct(name:String,limit:Int,page:Int,value:String){
        APIServices.searchproduct(name:name,limit:limit,page:page,value:value){[weak self] data in
            switch data{
            case .success(let res):

               
                self?.searchproductdata.append(contentsOf: res)
                self?.categoryPage += 1
                self?.isLoadingNextPage = false
             //
                self?.productsearchcollection.reloadData()
            case .failure(let error):
                print(error)
                self?.isLoadingNextPage = false

            }
        }
    }
    
    

}
extension ProductSearch_VC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.searchproductdata.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeLastProductCollectionViewCell", for: indexPath) as! HomeLastProductCollectionViewCell
        let data = searchproductdata[indexPath.row]
        cell.percentBGView.backgroundColor = UIColor(named: "greenColor")
        cell.product = data
        cell.productimage.pLoadImage(url: data.mainImage ?? "")
        if LanguageManager.language == "ar"{
            cell.productname.text = data.productName
        }else{
            cell.productname.text =  data.productName
        }

        if data.onSale == true {
            cell.discountPrice.isHidden = false
            cell.productPrice.isHidden = false
            cell.discountPrice.attributedText = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(data.salePrice ?? 0, label: cell.discountPrice))
            cell.productPrice.attributedText = "\(appDelegate.currencylabel) \(Utility().formatNumberWithCommas(data.regularPrice ?? 0, label:   cell.productPrice).trimmingCharacters(in: .whitespaces))".strikeThrough()
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
        cell.cartButton.addTarget(self, action: #selector(cartButtonTap(_:)), for: .touchUpInside)
//        cell.heartBtn.addTarget(self, action: #selector(LatestMobileheartButtonTap(_:)), for: .touchUpInside)
            
            
            
            return cell
        }
    
    @objc func cartButtonTap(_ sender: UIButton) {
        let data = searchproductdata[sender.tag]
        
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
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeLastProductCollectionViewCell", for: indexPath) as! HomeLastProductCollectionViewCell
//        let data = searchproductdata[indexPath.row]
//
//        cell.productimage.pLoadImage(url: data.mainImage ?? "")
//        cell.productname.text = data.productName
//        if data.onSale == true {
//            cell.discountPrice.isHidden = false
//            cell.discountPrice.text =  appDelegate.currencylabel + Utility().formatNumberWithCommas(data.salePrice ?? 0)
//            cell.productPriceLine.isHidden = false
//            cell.productPrice.textColor = UIColor.systemGray3
//
//        }else {
//            cell.discountPrice.isHidden = true
//            cell.productPriceLine.isHidden = true
//            cell.productPrice.textColor = UIColor.black
//        }
//        cell.productPrice.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(data.regularPrice ?? 0)
//
//        return cell
//    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = searchproductdata[indexPath.row]
        let vc = NewProductPageViewController.getVC(.productStoryBoard)
//            vc.isGroupBuy = false
            vc.slugid = data.slug
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: productsearchcollection.frame.width/2-5, height: 280)
//        return CGSize(width: self.productsearchcollection.frame.width/2.1, height: self.productsearchcollection.frame.height/2.7)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
      
            return 5
      
    }
}
extension ProductSearch_VC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
      
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            let height = scrollView.frame.size.height
            
            // If user scrolls to the bottom
            if offsetY > contentHeight - height {
                // Call your function to load more products
                loadMoreProducts()
            }
    }
    
    func loadMoreProducts() {
        guard !isLoadingNextPage && !isEndReached else {
            return // Return if already loading next page or end is reached
        }
        
        isLoadingNextPage = true
        
        // Call your API to fetch more products
        searchproduct(name: "productName" , limit: 40, page: categoryPage , value: searchText ?? "")
    }
}
