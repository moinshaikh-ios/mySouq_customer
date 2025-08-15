//
//  HotDealProductsViewController.swift
//  Bazaar Ghar
//
//  Created by Developer on 14/03/2024.
//

import UIKit

class HotDealProductsViewController: UIViewController {

    @IBOutlet weak var hotDealCollectionV: UICollectionView!

    var groupbydealsdata: [GroupByResult] = [] {
        didSet {
//            hotDealCollectionV.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

}

extension HotDealProductsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return groupbydealsdata.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotDealCollectionViewCell", for: indexPath) as! HotDealCollectionViewCell
            let data = groupbydealsdata[indexPath.row]
            
            cell.mainImage.pLoadImage(url: data.productID?.mainImage ?? "")
            cell.brandName.text =  data.productID?.productName
        cell.regularPrice.text =    appDelegate.currencylabel + Utility().formatNumberWithCommas(data.productID?.regularPrice ?? 0, label: cell.regularPrice)
            cell.days.text = "\(data.remainingTime?.days ?? 0)"
            cell.hours.text = "\(data.remainingTime?.hours ?? 0)"
            cell.minutes.text = "\(data.remainingTime?.minutes ?? 0)"
            cell.dayslbl.text = "days".pLocalized(lang: LanguageManager.language)
            cell.hrslbl.text = "hrs".pLocalized(lang: LanguageManager.language)
            cell.minslbl.text = "mins".pLocalized(lang: LanguageManager.language)
            if data.productID?.onSale == true {
                cell.salePrice.isHidden = false
                cell.salePrice.text =   appDelegate.currencylabel + Utility().formatNumberWithCommas(data.productID?.salePrice ?? 0, label:    cell.salePrice)
                cell.productPriceLine.isHidden = false
                cell.regularPrice.textColor = UIColor.systemGray3

            }else {
                cell.salePrice.isHidden = true
                cell.productPriceLine.isHidden = true
                cell.regularPrice.textColor = UIColor.black

             }
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: self.hotDealCollectionV.frame.width/1.2, height: self.hotDealCollectionV.frame.height)
    }
    
}
