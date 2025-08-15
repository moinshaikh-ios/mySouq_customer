////
////  RealTimeSearchViewController.swift
////  Bazaar Ghar
////
////  Created by Zany on 12/07/2024.
////
//
//import UIKit
//import Alamofire
//
//class RealTimeSearchViewController: UIViewController {
//   
//    private var results: [String] = []
//    var  facetCounts: [TypeSenseFacetCount] = []
//    @IBOutlet weak var lastRandomProductsCollectionView: UICollectionView!
//
//    @IBOutlet weak var filterButton: UIButton!
//    @IBOutlet weak var noDataView: UIView!
//    var DisplayCat0Model:  TypeSenseFacetCount? = nil
//    var Cat0Model:  TypeSenseFacetCount? = nil
//    var Cat1Model:  TypeSenseFacetCount? = nil
//    var Cat2Model:  TypeSenseFacetCount? = nil
//    var StoreModel:  TypeSenseFacetCount? = nil
//    var ColorModel:  TypeSenseFacetCount? = nil
//    var priceModel:  TypeSenseFacetCount? = nil
//    var sizeModel:  TypeSenseFacetCount? = nil
//    var RatingmOdel:  TypeSenseFacetCount? = nil
//    var StyleModel:  TypeSenseFacetCount? = nil
//    var typeSenseData : TypeSenseModel?
//    var hits: [TPHit]? = []
//    var searchText: String? {
//        didSet {
//            productcategoriesApi(val: "", str:  searchText ?? "*",facet_by: "lvl0,color,brandName,averageRating,price,size,style")
//        }
//    }
//    @IBOutlet weak var searchFeild: UITextField!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        lastRandomProductsCollectionView.delegate = self
//        lastRandomProductsCollectionView.dataSource = self
//        lastRandomProductsCollectionView.register(UINib(nibName: "HomeLastProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeLastProductCollectionViewCell")
//
//        
//        if(hits?.count == 0){
//            noDataView.isHidden = true
//        }else{
//            noDataView.isHidden = false
//        }
//
//        // Do any additional setup after loading the view.
//    }
//    @IBAction func filterButtonTap(_ sender: Any) {
//        let vc = StoreFilters_ViewController.getVC(.searchStoryBoard)
//
//        vc.delegate = self
//        vc.Cat0Model = Cat0Model
//        vc.Cat1Model = Cat1Model
//        vc.Cat2Model = Cat2Model
//        vc.StoreModel = StoreModel
//        vc.ColorModel = ColorModel
//        vc.priceModel = priceModel
//        vc.sizeModel = sizeModel
//        vc.RatingmOdel = RatingmOdel
//        vc.StyleModel = StyleModel
//        
//        vc.DisplayCat0Model = self.DisplayCat0Model
//        
//   
//        vc.modalPresentationStyle = .overFullScreen
//        self.present(vc, animated: true, completion: nil)
////        self.navigationController?.pushViewController(vc, animated: false)
//
//      
//    }
//    override func dismissViewController(_ sender: UIButton) {
//        AppDefault.facetFilterArray = []
//    }
//    override func popViewController(_ sender: UIButton) {
//        AppDefault.facetFilterArray = []
//    }
//    override func viewWillAppear(_ animated: Bool) {
//        productcategoriesApi(val: "", str: "*",facet_by: "lvl0,color,brandName,averageRating,price,size,style")
////        hitsapi(val: "", str: "*",facet_by: "lvl0,color,brandName,averageRating,price,size,style")
//
//    }
//     
// 
//    
//    private func productcategoriesApi(val:String, str: String,facet_by:String){
//        APIServices.typeSenseApi(val:val, txt: str ,facet_by:facet_by,completion: {[weak self] data in
//            switch data{
//            case .success(let res):
//                self?.hits = []
//                AppDefault.facetFilters = res
//                
//                for item in res.first?.facetCounts ?? []{
//                    if(item?.fieldName == "lvl0"){
//                        self?.Cat0Model = item
//                    }
//                    if(item?.fieldName == "lvl1"){
//                        self?.Cat1Model = item
//                    }
//                    if(item?.fieldName == "lvl2"){
//                        self?.Cat2Model = item
//                    }
//                    if(item?.fieldName == "color"){
//                        self?.ColorModel = item
//                    }
//                    if(item?.fieldName == "brandName"){
//                        self?.StoreModel = item
//                    }
//                    if(item?.fieldName == "averageRating"){
//                        self?.RatingmOdel = item
//                    }
//                    if(item?.fieldName == "price"){
//                        self?.priceModel = item
//                    }
//                     if(item?.fieldName == "size"){
//                        self?.sizeModel = item
//                    }
//                    if(item?.fieldName == "style"){
//                       self?.StyleModel = item
//                   }
//                }
//                
//                
//                if(self?.Cat0Model?.counts?.count == 1 && self?.Cat0Model?.counts?.count != 0 ){
//                
//                    self?.DisplayCat0Model = self?.Cat1Model
//                    
//                    
//                    
//                    
//                }else{
//                    self?.DisplayCat0Model = self?.Cat0Model
//                }
//                
//                if(self?.Cat1Model?.counts?.count == 1 && self?.Cat1Model?.counts?.count != 0 ){
//                
//                    self?.DisplayCat0Model = self?.Cat2Model
//                    
//                    
//                }else{
//                    if(self?.Cat0Model?.counts?.count == 0){
//                        self?.DisplayCat0Model = self?.Cat1Model
//                    }
//                    
//                }
//                
//                
//                
//                
//                
//                
//                
//                
//                for i in res {
//                                 
//                    for j in i.hits ?? []{
//                                     self?.hits?.append(j)
//                                 }
//                             }
//                
//                
//                
//                
//                
//
////                for r in res {
////                    for z in r.facetCounts ?? [] {
////                        self?.facetCounts.append(z!)
////                    }
////                }
//                
//                DispatchQueue.main.async {
//                    self?.lastRandomProductsCollectionView.reloadData()
//                }
////                DispatchQueue.main.async {
////                    self?.lastRandomProductsCollectionView.reloadData()
////                }
//               //
//            case .failure(let error):
//                print(error)
//                self?.view.makeToast(error)
//            }
//        })
//    }
//    private func hitsapi(val:String, str: String,facet_by:String){
//        APIServices.TPHitsApi(val:val, txt: str ,facet_by:facet_by,completion: {[weak self] data in
//            switch data{
//            case .success(let res):
//                
//                
////                for i in res {
////                    for j in i.hits ?? []{
////                        self?.hits?.append(j)
////                    }
////                }
//                
////                for i in res {
////                    for j in i.results ?? [] {
////                        self?.hits.append(contentsOf: j.hits!)
////                    }
////                }
////                for r in res {
////                    for z in r.facetCounts ?? [] {
////                        self?.facetCounts.append(z!)
////                    }
////                }
//                
//                
//                DispatchQueue.main.async {
//                    self?.lastRandomProductsCollectionView.reloadData()
//                }
//               //
//            case .failure(let error):
//                print(error)
//                self?.view.makeToast(error)
//            }
//        })
//    }
//   
//    @IBAction func searchButton(_ sender: Any) {
//        if(searchFeild.text?.count == 0){
//            self.view.makeToast("Please Enter Text")
//        }else{
//            productcategoriesApi(val: "", str: searchFeild.text ?? "",facet_by: "lvl0,color,brandName,averageRating,price,size,style")
//        }
//    }
//    
//}
//extension RealTimeSearchViewController: StoreFilters_ViewControllerDelegate{
//    func StoreFilters_ViewControllerDidFinish(_ controller: StoreFilters_ViewController, withData data: [TypeSenseResult]) {
//        print("Received data from child: \(data)")
//        self.hits?.removeAll()
//        self.hits = data.first?.hits ?? []
//        if(data.first?.hits?.count == 0){
//            noDataView.isHidden = false
//        }else{
//            noDataView.isHidden = true
//        }
//
//        self.lastRandomProductsCollectionView.reloadData()
//    }
//    
//    
//}
//
//extension RealTimeSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        
//        return hits?.count ?? 0
//        
//        }
//    
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeLastProductCollectionViewCell", for: indexPath) as! HomeLastProductCollectionViewCell
//        let data = hits?[indexPath.row].document
////        cell.productimage.pLoadImage(url: data?.mainImage ?? "")
////        cell.productname.text = data?.productName
////        if data?.onSale == true {
////                cell.discountPrice.isHidden = false
////            cell.discountPrice.text =  appDelegate.currencylabel + Utility().formatNumberWithCommas(Double(data?.salePrice ?? 0))
////                cell.productPriceLine.isHidden = false
////                cell.productPrice.textColor = UIColor.red
////                cell.discountPrice.textColor = UIColor(hexString: primaryColor)
////                cell.productPriceLine.backgroundColor = UIColor.red
////                
////            } else {
////                cell.discountPrice.isHidden = true
////                cell.productPriceLine.isHidden = true
////                cell.productPrice.textColor = UIColor(hexString: primaryColor)
////            }
//////            
//////                cell.wishlisticon.tag = indexPath.row
//////                cell.wishlisticon.addTarget(self, action: #selector(wishlistTap(sender:)), for: .touchUpInside)
////            
////          
////        cell.productPrice.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(Double(data?.regularPrice ?? 0))
//
//      
//        headerBackgroudView.backgroundColor = UIColor(named: "headercolor") cell.percentBGView, colors: [UIColor.primaryColor, UIColor.primaryColor, UIColor.headerSecondaryColor])
//       
//        cell.productimage.pLoadImage(url: data?.mainImage ?? "")
//        cell.productname.text =  data?.productName
//        cell.productPrice.text =  appDelegate.currencylabel + Utility().formatNumberWithCommas(data?.regularPrice ?? 0)
//        if data?.onSale == true {
//            cell.discountPrice.isHidden = false
//            let currencySymbol = appDelegate.currencylabel
//            let salePrice = Utility().formatNumberWithCommas(data?.salePrice ?? 0)
//
//            // Create an attributed string for the currency symbol with the desired color
//            let currencyAttributes: [NSAttributedString.Key: Any] = [
//                .foregroundColor: UIColor.black // Change to your desired color
//            ]
//            let attributedCurrencySymbol = NSAttributedString(string: currencySymbol, attributes: currencyAttributes)
//
//            // Create an attributed string for the sale price with the desired color
//            let priceAttributes: [NSAttributedString.Key: Any] = [
//                .foregroundColor: UIColor(hexString: primaryColor) // Change to your desired color
//            ]
//            let attributedPrice = NSAttributedString(string: salePrice, attributes: priceAttributes)
//
//            // Combine the attributed strings
//            let combinedAttributedString = NSMutableAttributedString()
//            combinedAttributedString.append(attributedCurrencySymbol)
//            combinedAttributedString.append(attributedPrice)
//            cell.discountPrice.attributedText = combinedAttributedString
//
////                cell.discountPrice.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(data?.salePrice ?? 0)
//            cell.productPriceLine.isHidden = false
//            cell.productPrice.textColor = UIColor.red
////                cell.discountPrice.textColor = UIColor(hexString: primaryColor)
//            cell.productPriceLine.backgroundColor = UIColor.red
//            
//        }else {
//            cell.discountPrice.isHidden = true
//            cell.productPriceLine.isHidden = true
//            cell.productPrice.textColor = UIColor(hexString: primaryColor)
//
//         }
////        cell.cartButton.addTarget(self, action: #selector(cartButtonTap(_:)), for: .touchUpInside)
//        
//        
//            return cell
//        }
//    
//
//    func applyGradientBackground(to view: UIView, topColor: UIColor, bottomColor: UIColor) {
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = view.bounds
//        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
//        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
//        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
//        view.layer.insertSublayer(gradientLayer, at: 0)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//       
//        return 10
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//       
//        return 5
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        return CGSize(width: lastRandomProductsCollectionView.frame.width/2.2-5, height:300)
//
//    
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        
//        return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
//        
//    }
//}
//
