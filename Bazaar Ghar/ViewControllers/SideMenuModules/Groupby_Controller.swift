//
//  Groupby_Controller.swift
//  Bazaar Ghar
//
//  Created by Umair Ali on 26/12/2024.
//

import UIKit

class Groupby_Controller: UIViewController {
    @IBOutlet weak var headerBackgroudView: UIView!
    @IBOutlet weak var hotDealView: UIView!
    @IBOutlet weak var nodealslbl: UILabel!

    @IBOutlet weak var hotDealCollectionV: UICollectionView!
    var groupbydealsdata: [GroupByResult] = [] {
        didSet {
            hotDealCollectionV.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        headerBackgroudView.backgroundColor = UIColor(named: "headercolor")
        // Do any additional setup after loading the view.
        self.hotDealView.isHidden = true
        self.nodealslbl.isHidden = false
            groupByDeals(limit: 20, page: 1, isbackground: false)
            
        
    }
    private func groupByDeals(limit:Int,page:Int,isbackground : Bool){
      
        APIServices.groupByDeals(limit: limit, page: page, isbackground: isbackground,completion: {[weak self] data in
            switch data{
            case .success(let res):
                if(res.result?.count ?? 0 > 0){
                    self?.groupbydealsdata = res.result ?? []
                    self?.hotDealView.isHidden = false
                    self?.nodealslbl.isHidden = true
                    self?.hotDealCollectionV.reloadData()
                }else{
                    self?.hotDealView.isHidden = true
                    self?.nodealslbl.isHidden = false
                }
               
            case .failure(let error):
                print(error)
                self?.hotDealView.isHidden = true
                self?.nodealslbl.isHidden = false
//                self?.view.makeToast(error)
            }
        })
    }

}

extension Groupby_Controller: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
                cell.salePrice.text =   appDelegate.currencylabel + Utility().formatNumberWithCommas(data.productID?.price ?? 0, label:    cell.salePrice)
                cell.productPriceLine.isHidden = false
                cell.regularPrice.textColor = UIColor.systemGray3

            }else {
                cell.salePrice.isHidden = true
                cell.productPriceLine.isHidden = true
                cell.regularPrice.textColor = UIColor.black

             }
        let regularPrice = data.productID?.regularPrice ?? 0
        let salePrice = data.productID?.price ?? 0

        let percentValue: Double = regularPrice > 0 ? ((regularPrice - salePrice) * 100) / regularPrice : 0   
        let kk =  percentValue
        let englishNumber = kk
        let arabicNumber = Utility().convertToArabicNumerals(englishNumber)
        cell.percentLbl.text = LanguageManager.language == "ar" ?  "خصم % \(arabicNumber)" : String(format: "%.0f%% Off", percentValue)
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: self.hotDealCollectionV.frame.width/1.2, height: self.hotDealCollectionV.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = groupbydealsdata[indexPath.row]
                  let vc = NewProductPageViewController.getVC(.productStoryBoard)
                  vc.isGroupBuy = true
                  vc.groupbydealsdata = data
                  vc.slugid = data.productID?.slug
                  self.navigationController?.pushViewController(vc, animated: false)



    }
    
}
