//
//  FacetSearchVc.swift
//  Bazaar Ghar
//
//  Created by Zany on 16/08/2024.
//

import UIKit
import Typesense
import DropDown


class FacetSearchVc: UIViewController, UISearchResultsUpdating {
    
    @IBOutlet weak var dropdownlabel: UILabel!
    @IBOutlet weak var dropdownButton: UIButton!
    @IBOutlet weak var productCounts: UILabel!
    @IBOutlet weak var noProductFoundLbl: UILabel!
    @IBOutlet weak var lastRandomProductsCollectionView: UICollectionView!
    @IBOutlet weak var filterButton: UIButton!
    let centerTransitioningDelegate = CenterTransitioningDelegate()
       @IBOutlet weak var noDataView: UIView!
    var hits: [SearchResultHit<Recipe>]
    var facetCounts: [FacetCounts]?
    var page = 1
    var origin = ""
    var Cat0Model:  FacetCounts? = nil
    let dropDown = DropDown()
    
    var Cat1Model:  FacetCounts? = nil
       var DisplayCat0Model:  FacetCounts? = nil
       var Cat2Model:  FacetCounts? = nil
       var StoreModel:  FacetCounts? = nil
       var ColorModel:  FacetCounts? = nil
       var priceModel:  FacetCounts? = nil
       var sizeModel:  FacetCounts? = nil
       var RatingmOdel:  FacetCounts? = nil
       var StyleModel:  FacetCounts? = nil
    
    // Your other properties
    let searchController = UISearchController(searchResultsController: nil)
    let client: Client
    
    required init?(coder aDecoder: NSCoder) {
        
        let config = Configuration(nodes: [Node(host: TypeSenseEnvironment.typesenseHost, port: TypeSenseEnvironment.typesensePort, nodeProtocol: TypeSenseEnvironment.typesenseProtocol)], apiKey: TypeSenseEnvironment.typesenseApiKey)
        self.client = Client(config: config)
        self.hits = []
        super.init(coder: aDecoder)
    }
    var searchText: String? {
        didSet {
            self.hits = []
            performSearch(with: searchText ?? "",page: 1, faceby: "", origin: AppDefault.getOrigin)
        }
    }
    var isLoadingData = false
    
    
    override func viewWillAppear(_ animated: Bool) {
        setupDropDown()
        self.dropdownlabel.text = "all".pLocalized(lang: LanguageManager.language)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search Recipes "
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        lastRandomProductsCollectionView.delegate = self
                lastRandomProductsCollectionView.dataSource = self
                lastRandomProductsCollectionView.register(UINib(nibName: "HomeLastProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeLastProductCollectionViewCell")
              
        
        if(hits.count == 0){
                    noDataView.isHidden = true
                }else{
                    noDataView.isHidden = false
                }
//                if(AppDefault.islogin ){
//
//                    if AppDefault.wishlistproduct != nil{
//                        wishList(isbackground: true)
//                    }else{
//                        wishList(isbackground: false)
//                    }
//
//
//                    }
    }
    
    func setupDropDown() {
        let isArabic = LanguageManager.language == "ar"
        
        // Set data source
        dropDown.dataSource = isArabic
            ? ["الكل", "السعودية", "باكستان", "الصين"]
            : ["All", "KSA", "PAK", "China"]
        
        // Anchor dropdown to the button
        dropDown.anchorView = dropdownButton
        dropDown.direction = .bottom
        
        // Fix semantic direction of the button
        dropdownButton.semanticContentAttribute = isArabic ? .forceRightToLeft : .forceLeftToRight
        
        // Optional: align dropdown text inside the cells
        dropDown.customCellConfiguration = { (index, item, cell) in
            cell.optionLabel.textAlignment = isArabic ? .right : .left
        }
        
        // Ensure proper layout before accessing button size
        dropdownButton.layoutIfNeeded()
        dropDown.width = dropdownButton.bounds.width
        
        // Position the dropdown correctly
        DispatchQueue.main.async {
            self.dropdownButton.layoutIfNeeded()
            self.dropDown.width = self.dropdownButton.bounds.width

            if let window = UIApplication.shared.windows.first {
                let buttonFrameInWindow = self.dropdownButton.convert(self.dropdownButton.bounds, to: window)
                let buttonX = buttonFrameInWindow.origin.x
                let screenWidth = UIScreen.main.bounds.width
                let dropDownWidth = self.dropDown.width ?? self.dropdownButton.bounds.width
                
                let xOffset: CGFloat
                
                if isArabic {
                    // Align 10pt from trailing edge (right side in RTL)
                    xOffset = (screenWidth - 10) - dropDownWidth - buttonX
                } else {
                    // Align 10pt from leading edge (left side in LTR)
                    xOffset = 10
                }

                self.dropDown.bottomOffset = CGPoint(x: xOffset, y: self.dropdownButton.bounds.height)
            }
        }
        
        // Set the initial label
        if let firstItem = dropDown.dataSource.first {
            self.dropdownlabel.text = AppDefault.origin
            print("First Time")
        }
        
        // Handle selection
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            print("Selected: \(item)")
            self.dropdownlabel.text = item
            
            if item == "All" || item == "الكل" {
                AppDefault.facetFilterArray = []
                self.hits = []
                AppDefault.origin = item
                AppDefault.getOrigin = ""
            } else {
                self.hits = []
                AppDefault.facetFilterArray = []
                AppDefault.origin = item
                let data = ["All", "KSA", "PAK", "China"]
                AppDefault.getOrigin = "&& origin:\(data[index].lowercased())"
            }
            
            self.performSearch(with: self.searchText ?? "", page: self.page ?? 1, faceby: "", origin: AppDefault.getOrigin)
        }
    }



    
    @IBAction func dropdownbutton(_ sender: Any) {
        dropDown.show()
    }
    @IBAction func filterButtonTap(_ sender: Any) {
           let vc = StoreFilters_ViewController.getVC(.searchStoryBoard)
        
           vc.delegate = self
           vc.Cat0Model = Cat0Model
           vc.Cat1Model = Cat1Model
           vc.Cat2Model = Cat2Model
           vc.StoreModel = StoreModel
           vc.ColorModel = ColorModel
           vc.priceModel = priceModel
           vc.sizeModel = sizeModel
           vc.RatingmOdel = RatingmOdel
           vc.StyleModel = StyleModel
   
           vc.DisplayCat0Model = self.DisplayCat0Model
   
   
           vc.modalPresentationStyle = .overFullScreen
           self.present(vc, animated: true, completion: nil)
   //        self.navigationController?.pushViewController(vc, animated: false)
       }
    
    func updateSearchResults(for searchController: UISearchController) {
           guard let text = searchController.searchBar.text else {
               return
           }
        performSearch(with: searchController.searchBar.text ?? "*",page:1, faceby: "", origin: AppDefault.getOrigin)
       }
    func wishList(isbackground:Bool){
        APIServices.wishlist(isbackground: isbackground){[weak self] data in
          switch data{
          case .success(let res):
          //
            AppDefault.wishlistproduct = res.products
   
            
              self?.lastRandomProductsCollectionView.reloadData()
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

       
    func performSearch(with query: String, page: Int, faceby: String,origin:String) {
        UIApplication.startActivityIndicator()
        print("facetBy: \(faceby)")
        print("queryBy: \(query)")

        var mutableFaceby = faceby
        if !mutableFaceby.isEmpty {
            mutableFaceby += "&& productType:=[main]\(origin)"
        } else {
            mutableFaceby = "productType:=[main] \(origin)"
        }
        
        
        
        mutableFaceby  = trimLogicalOperators( from: mutableFaceby)

        let searchParameters = SearchParameters(
            q: query,
            queryBy: "productName",
            filterBy: mutableFaceby,
            facetBy: "averageRating,brandName,color,lvl0,lvl1,lvl2,price,size,style",
            maxFacetValues: 250,
            page: page,
            perPage: 20
        )

        Task {
            do {
                let (searchResult, _) = try await client.collection(name: TypeSenseEnvironment.typesenseCollection).documents().search(searchParameters, for: Recipe.self)
                self.facetCounts = searchResult?.facetCounts

                if !query.isEmpty {
                    self.hits += searchResult?.hits ?? []
                } else {
                    self.hits += searchResult?.hits ?? []
                }

                for item in searchResult?.facetCounts ?? [] {
                    switch item.fieldName {
                    case "lvl0": self.Cat0Model = item
                    case "lvl1": self.Cat1Model = item
                    case "lvl2": self.Cat2Model = item
                    case "color": self.ColorModel = item
                    case "brandName": self.StoreModel = item
                    case "averageRating": self.RatingmOdel = item
                    case "price": self.priceModel = item
                    case "size": self.sizeModel = item
                    case "style": self.StyleModel = item
                    default: break
                    }
                }

                if let cat0Count = self.Cat0Model?.counts?.count, cat0Count == 1 {
                    self.DisplayCat0Model = self.Cat1Model
                } else {
                    self.DisplayCat0Model = self.Cat0Model
                }

                if let cat1Count = self.Cat1Model?.counts?.count, cat1Count == 1 {
                    self.DisplayCat0Model = self.Cat2Model
                } else if self.Cat0Model?.counts?.count == 0 {
                    self.DisplayCat0Model = self.Cat1Model
                }
                if LanguageManager.language == "ar" {
                    productCounts.text = "\"\(Utility().formatNumberWithCommas(Double(searchResult?.found ?? 0), label: productCounts,addSymbol: false))\" تم العثور على العناصر"

                }else {
                    productCounts.text = "\"\(Utility().formatNumberWithCommas(Double(searchResult?.found ?? 0), label: productCounts,addSymbol: false))\" items found"
                }
                self.noDataView.isHidden = (searchResult?.found ?? 0) > 0
//                lastRandomProductsCollectionView.reloadData()
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    let startIndex = (self.hits.count) - (searchResult?.hits?.count ?? 0)
                    if(startIndex == 0){
                        self.lastRandomProductsCollectionView.reloadData()
                    }else{
                        let endIndex = startIndex + (searchResult?.hits?.count ?? 0)
                        let indexPaths = (startIndex..<endIndex).map { IndexPath(item: $0, section: 0) }
                        
                        self.lastRandomProductsCollectionView.performBatchUpdates({
                            self.lastRandomProductsCollectionView.insertItems(at: indexPaths)
                        }, completion: nil)
                        
//                        self.isLoadingNextPage = false
                    }
                }
                
                UIApplication.stopActivityIndicator()
                isLoadingData = false
            } catch {
                print("Error: \(error.localizedDescription)")
                if let decodingError = error as? DecodingError {
                    switch decodingError {
                    case .typeMismatch(let type, let context):
                        print("Type mismatch: \(type), Context: \(context)")
                    case .valueNotFound(let type, let context):
                        print("Value not found: \(type), Context: \(context)")
                    case .keyNotFound(let key, let context):
                        print("Key not found: \(key), Context: \(context)")
                    case .dataCorrupted(let context):
                        print("Data corrupted: \(context)")
                    @unknown default:
                        print("Unknown decoding error: \(error)")
                    }
                }
            }
        }
    }
    func trimLogicalOperators(from input: String) -> String {
        let pattern = #"^&&|&&$"#
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: input.utf16.count)
        return regex.stringByReplacingMatches(in: input, options: [], range: range, withTemplate: "")
    }

}

extension FacetSearchVc: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return hits.count
        
        }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeLastProductCollectionViewCell", for: indexPath) as! HomeLastProductCollectionViewCell
        
        if(hits[indexPath.row].document == nil)
        {
            
        }else{
            
            
            let data = hits[indexPath.row].document
            
            cell.percentBGView.backgroundColor = UIColor(named: "greenColor")
            if data?.regularPrice == nil || data?.salePrice == nil {
                
            }else {

                
                if let regularPrice = data?.regularPrice,
                   let salePrice = data?.salePrice,
                   regularPrice > 0 {

                    let discountPercentage = ((regularPrice - salePrice) / regularPrice) * 100
                    let englishNumber = discountPercentage
                    let arabicNumber = Utility().convertToArabicNumerals(englishNumber)

//                    cell.percentBGView.backgroundColor = UIColor(named: "greenColor")
                    cell.Offbanner.text = LanguageManager.language == "ar"
                        ? "خصم % \(arabicNumber)"
                        : String(format: "%.0f%% Off", discountPercentage)

                } else {
                    // Hide the discount badge or handle the case when price is invalid
                    cell.percentBGView.isHidden = true
                }
                
            }
            
            cell.productimage.pLoadImage(url: data?.mainImage ?? "")
            cell.backgroundImage.pLoadImage(url: data?.mainImage ?? "")
            if LanguageManager.language == "ar" && data?.lang?.ar != nil{
                if(data?.lang?.ar?.productName == nil){
                    cell.productname.text =  data?.productName
                }else{
                    cell.productname.text = data?.lang?.ar?.productName
                }
                
            }else{
                cell.productname.text =  data?.productName
            }
            
            if data?.onSale == true {
                cell.discountPrice.isHidden = false
                cell.productPrice.isHidden = false
                cell.discountPrice.attributedText = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(data?.salePrice ?? 0, label:  cell.discountPrice))
                cell.productPrice.attributedText = "\(appDelegate.currencylabel) \(Utility().formatNumberWithCommas(data?.regularPrice ?? 0, label:  cell.productPrice).trimmingCharacters(in: .whitespaces))".strikeThrough()
                cell.productPriceLine.isHidden = true
                cell.productPrice.textColor = UIColor.red
                cell.productPriceLine.backgroundColor = UIColor.red
                cell.percentBGView.isHidden = false
            }else {
                cell.productPriceLine.isHidden = true
                cell.productPrice.isHidden = true
                cell.discountPrice.attributedText = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(data?.regularPrice ?? 0, label: cell.discountPrice))
                cell.percentBGView.isHidden = true
            }
            //        if(data?.quantity != 0){
            //            cell.cartButton.tag = indexPath.row
            //            cell.cartButton.addTarget(self, action: #selector(cartButtonTap(_:)), for: .touchUpInside)
            //        }else if(data?.quantity == 0){
            //            let vc  = NewProductPageViewController.getVC(.productStoryBoard)
            //            self.navigationController?.pushViewController(vc, animated: true)
            //        }else if(data?.quantity != 0){
            //            cell.cartButton.tag = indexPath.row
            //            cell.cartButton.addTarget(self, action: #selector(cartButtonTap(_:)), for: .touchUpInside)
            //        }else{
            //            let vc  = NewProductPageViewController.getVC(.productStoryBoard)
            //            self.navigationController?.pushViewController(vc, animated: true)
            //        }
            cell.heartBtn.tag = indexPath.row
            cell.cartButton.tag = indexPath.row
            cell.cartButton.addTarget(self, action: #selector(cartButtonTap(_:)), for: .touchUpInside)
            cell.heartBtn.addTarget(self, action: #selector(homeLatestMobileheartButtonTap(_:)), for: .touchUpInside)
            
            if let wishlistProducts = AppDefault.wishlistproduct {
                if data?.id == nil {
                    if wishlistProducts.contains(where: { $0.id == data?._id }) {
                        cell.heartBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                        cell.heartBtn.tintColor = .red
                    } else {
                        cell.backgroundColor = .white
                        cell.heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
                        cell.heartBtn.tintColor = .white
                    }
                }else {
                    if wishlistProducts.contains(where: { $0.id == data?.id }) {
                        cell.heartBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                        cell.heartBtn.tintColor = .red
                    } else {
                        cell.backgroundColor = .white
                        cell.heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
                        cell.heartBtn.tintColor = .white
                    }
                }
                
            }
        }
        
            return cell
        }

    
    @objc func cartButtonTap(_ sender: UIButton) {
        let data = hits[sender.tag].document
        if(data?.variants?.count == 0){
          let vc = CartPopupViewController.getVC(.popups)
          vc.modalPresentationStyle = .custom
          vc.transitioningDelegate = centerTransitioningDelegate
        let newproduct = Product(featured: data?.featured, onSale: data?.onSale, isVariable: data?.isVariable, productName: data?.productName, slug: data?.slug, mainImage: data?.mainImage, regularPrice: data?.regularPrice, quantity: data?.quantity, price: data?.price, lang: nil, id: data?.id, salePrice: data?.salePrice, description: data?.description, _id: data?._id, selectedAttributes: [], brandLogo: "")
          vc.products = newproduct
          vc.nav = self.navigationController
          self.present(vc, animated: true, completion: nil)
        }else {
              let vc = NewProductPageViewController.getVC(.productStoryBoard)
                 vc.slugid = data?.slug
              self.navigationController?.pushViewController(vc, animated: true)
            }
    //    if (data?.variants?.first?.id == nil) {
    //    }else {
    //      let vc = NewProductPageViewController.getVC(.productStoryBoard)
    //      vc.slugid = data?.slug
    //      navigationController?.pushViewController(vc, animated: false)
    //    }
      }
    @objc func homeLatestMobileheartButtonTap(_ sender: UIButton) {
        if(AppDefault.islogin){
              let index = sender.tag
            let item = hits[index].document
            if item?.id == nil {
                self.wishListApi(productId: (item?._id ?? ""))
            }else {
                self.wishListApi(productId: (item?.id ?? ""))
            }            }else{
                let vc = PopupLoginVc.getVC(.popups)
              vc.modalPresentationStyle = .overFullScreen
              self.present(vc, animated: true, completion: nil)
            }
    }
    func applyGradientBackground(to view: UIView, topColor: UIColor, bottomColor: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
  
   

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        // Check if the scroll view has reached the bottom
        if offsetY > contentHeight - frameHeight && !isLoadingData {
            // Set the flag to prevent multiple calls
            isLoadingData = true
            
            // Increment the page number
            page += 1
            
            // Call your API
            if(AppDefault.faceby != ""){
                performSearch(with: searchController.searchBar.text ?? "", page: page, faceby:AppDefault.faceby ?? "" , origin: AppDefault.getOrigin)
            }else{
                performSearch(with: searchController.searchBar.text ?? "", page: page, faceby:  "" , origin: AppDefault.getOrigin)
            }
        }
        
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
       
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
       
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: lastRandomProductsCollectionView.frame.width/2-5, height:280)

    
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let data = hits[indexPath.row].document
        let vc = NewProductPageViewController.getVC(.productStoryBoard)
//                vc.isGroupBuy = false
                   vc.slugid = data?.slug
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
}


extension FacetSearchVc: StoreFilters_ViewControllerDelegate{
    func StoreFilters_ViewControllerDidFinish(_ controller: StoreFilters_ViewController, facetby: String, filterby: String) {
      
        self.hits.removeAll()
        self.page = 1
        AppDefault.faceby = facetby
        performSearch(with: searchController.searchBar.text ?? "*", page: page, faceby: facetby, origin: AppDefault.getOrigin)
    }
    
 

}

