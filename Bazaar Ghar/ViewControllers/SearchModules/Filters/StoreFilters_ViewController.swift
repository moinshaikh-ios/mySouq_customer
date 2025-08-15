//
//  StoreFilters_ViewController.swift
//  Bazaar Ghar
//
//  Created by Umair Ali on 13/07/2024.
//


import UIKit
import RangeSeekSlider
import Typesense
protocol StoreFilters_ViewControllerDelegate: AnyObject {
    func StoreFilters_ViewControllerDidFinish(_ controller: StoreFilters_ViewController ,facetby:String,filterby:String)
}

class StoreFilters_ViewController: UIViewController {
   
    
    let rowHeight: CGFloat = 20 // Set your row height
    let maxHeight: CGFloat = 40.0
    @IBOutlet weak var categoriestbl: UITableView!
    @IBOutlet weak var store_collect: UICollectionView!
    @IBOutlet weak var size_collect: UICollectionView!
    @IBOutlet weak var FilterColletion: UICollectionView!
    @IBOutlet weak var heightFilter: NSLayoutConstraint!
    @IBOutlet weak var heightCategory: NSLayoutConstraint!
    @IBOutlet weak var heightStore: NSLayoutConstraint!
    @IBOutlet weak var heightrating: NSLayoutConstraint!
    @IBOutlet weak var heightsize: NSLayoutConstraint!
    @IBOutlet weak var heightcolor: NSLayoutConstraint!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var filterLbl: UILabel!
    
    @IBOutlet fileprivate weak var rangeSlider: RangeSeekSlider!
    
    var selectedIndex: Int?
    var sizeIndex: Int?
    var ratingndex: Int?
    var colorIndex: Int?

    @IBOutlet weak var rating_collect: UICollectionView!
    var  facetCounts: [FacetCounts] = []

    var SelectedCat0Model:  TypeSenseCount? = nil
    var SelectedCat1Model:  TypeSenseCount? = nil
    var SelectedCat2Model:  TypeSenseCount? = nil
    var SelectedStoreModel:  TypeSenseCount? = nil
    var SelectedsizeeModel:  TypeSenseCount? = nil
    var SelectedColorModel:  TypeSenseCount? = nil
    var SelectedratingModel:  TypeSenseCount? = nil
    var DisplayCat0Model:  FacetCounts? = nil
    var Cat0Model:  FacetCounts? = nil
    var Cat1Model:  FacetCounts? = nil
    var Cat2Model:  FacetCounts? = nil
    var StoreModel:  FacetCounts? = nil
    var ColorModel:  FacetCounts? = nil
    var priceModel:  FacetCounts? = nil
    var sizeModel:  FacetCounts? = nil
    var RatingmOdel:  FacetCounts? = nil
    var StyleModel:  FacetCounts? = nil
    var FiltermodelArray:  [TypeSenseCount] = []
    {
            didSet {
                if(FiltermodelArray.count > 0){
                self.heightFilter.constant = 60
            }else{
                self.heightFilter.constant = 0
            }
            
            
            
            
            if(Cat0Model?.counts?.count != 0){
                self.heightCategory.constant = 158
            }else{
                self.heightCategory.constant = 0
            }
            if(StoreModel?.counts?.count != 0 ){
                self.heightStore.constant = 65
            }else{
                self.heightStore.constant = 0
            }
            if(ColorModel?.counts?.count != 0){
                self.heightcolor.constant = 75
            }else{
                self.heightcolor.constant = 0
            }
             if(sizeModel?.counts?.count != 0){
            self.heightsize.constant = 130
            }else{
                self.heightsize.constant = 0
            }
            if(RatingmOdel?.counts?.count != 0){
                self.heightrating.constant = 65
            }else{
                self.heightrating.constant = 0
            }
            
            AppDefault.facetFilterArray = FiltermodelArray
          
             self.FilterColletion.reloadData()
        }
            
        }
    
    var selectedColor:  [String] = []
    var selectedSizes:  [String] = []
    var selectedRating:  [Int] = []
    var allfacetfilter : String = ""
    var priceFilter : [String] = []
    var categoryString : [String] = []
    var selectedStores: [String] = []
    var  lastquery = String()
    weak var delegate: StoreFilters_ViewControllerDelegate?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        LanguageRender()
        
        rangeSlider.delegate = self
        self.rangeSlider.colorBetweenHandles = UIColor(named: "headercolor")
        self.rangeSlider.handleColor = .white
        self.rangeSlider.handleBorderColor = UIColor(named: "headercolor")
        self.rangeSlider.handleBorderWidth = 1
        rangeSlider.numberFormatter.maximumFractionDigits = 0 // No decimals

        if(FiltermodelArray.count > 0){
            self.heightFilter.constant = 60
        }else{
            self.heightFilter.constant = 0
        }
     

//        self.rangeSlider.minValue =  CGFloat()
//        self.rangeSlider.maxValue =  CGFloat()
        updateRangeSlider(minValue:  self.priceModel?.stats?.min ?? 0.0, maxValue: self.priceModel?.stats?.max ?? 0.0, selectedMin: self.priceModel?.stats?.min ?? 0.0, selectedMax: self.priceModel?.stats?.max ?? 0.0)
        
        
        self.FiltermodelArray  = AppDefault.facetFilterArray ?? []
        allfacetfilter =  AppDefault.allfacetString
        FilterColletion.reloadData()
        
    }
    
    func LanguageRender(){
 
        clearBtn.setTitle("clear".pLocalized(lang: LanguageManager.language), for: .normal)
        filterLbl.text = "filter".pLocalized(lang: LanguageManager.language)
           UIView.appearance().semanticContentAttribute = LanguageManager.language == "ar" ? .forceRightToLeft : .forceLeftToRight
            UITextField.appearance().textAlignment = LanguageManager.language == "ar" ? .right : .left
         
    }
    

    override func viewWillAppear(_ animated: Bool) {
        categoriestbl.delegate = self
        categoriestbl.dataSource = self
        size_collect.dataSource = self
        size_collect.delegate = self
        store_collect.delegate = self
        store_collect.dataSource = self
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        rating_collect.delegate = self
        rating_collect.dataSource = self
        FilterColletion.delegate = self
        FilterColletion.dataSource = self
        allfacetfilter = AppDefault.allfacetString
        print("allfacetfilter\(allfacetfilter)")
        print("AppDefaultallfacetfilter\(AppDefault.allfacetString)")

//        productcategoriesApi(val: "", str: "*",facet_by: "lvl0,color,brandName,averageRating,price,size,style")
    }
  
    func updateRangeSlider(minValue: CGFloat, maxValue: CGFloat, selectedMin: CGFloat, selectedMax: CGFloat) {
        rangeSlider.minValue = minValue
        rangeSlider.maxValue = maxValue
        rangeSlider.selectedMinValue = selectedMin
        rangeSlider.selectedMaxValue = selectedMax

        // Redraw the slider to reflect the changes
        rangeSlider.layoutSubviews()
    }
   
    @objc func SelectCategorerybtn(_ sender: UIButton) {
        // Determine which model to use based on available counts
        let data = DisplayCat0Model?.counts?[sender.tag]
        
         
             let obj = TypeSenseCount(count: data?.count, highlighted:data?.highlighted , value: data?.value, isselected: true , isquery: DisplayCat0Model?.fieldName)
           
             self.SelectedCat0Model = obj
             self.SelectedCat1Model = obj
             
             if(FiltermodelArray.contains(where: { return $0.isquery == DisplayCat0Model?.fieldName}) == true) {
                 FiltermodelArray.removeAll(where: { return $0.isquery == DisplayCat0Model?.fieldName})
                 self.FiltermodelArray.append(self.SelectedCat0Model!)
             }else{
                 self.FiltermodelArray.append(self.SelectedCat0Model!)
             }
            // Cat0Model?.counts?[sender.tag].isselected = true
             
             self.categoriestbl.reloadData()
             
             
    }
   
   
 
    
    
    
    @IBAction func filterButton(_ sender: UIButton) {
        
            if(SelectedCat0Model?.isquery == "lvl0"){
                self.FetchData(val: "", txt: "*",facet_by: "lvl0,lvl1,color,brandName,averageRating,price,size,style", isclick: true)
                }
            if(SelectedCat0Model?.isquery == "lvl1"){
               self.FetchData(val: "", txt: "*",facet_by: "lvl1,lvl2,color,brandName,averageRating,price,size,style", isclick: true)
            }
            if(SelectedCat0Model?.isquery == "lvl2"){
               self.FetchData(val: "", txt: "*",facet_by: " lvl2,color,brandName,averageRating,price,size,style", isclick: true)
            }
            if(SelectedCat0Model?.isquery == nil){
               self.FetchData(val: "", txt: "*",facet_by: "color,brandName,averageRating,price,size,style", isclick: true)
            }
           
        
//        if(categoryString.count != 0){
//            self.FetchData(val: "", txt: "*",facet_by: "lvl1,lvl2,color,brandName,averageRating,price,size,style", isclick: true)
//        }
     
      
    }
    @IBAction func clearFilter(_ sender: UIButton) {
        if(allfacetfilter == "" && FiltermodelArray.count == 0){
            self.view.makeToast("No filter applied currently")
        }else{
            FiltermodelArray.removeAll()
            allfacetfilter = ""
            AppDefault.allfacetString = ""
          self.FetchData(val: "", txt: "*",facet_by: "lvl0,color,brandName,averageRating,price,size,style", isclick: true)
        }
      
      }
    
}
extension StoreFilters_ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == categoriestbl {
                    return DisplayCat0Model?.counts?.count ?? 0
                }else{
                    if(ColorModel != nil){
                        return ColorModel?.counts?.count ?? 0
                    }else{
                        return 0
                    }
                }
            }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreFilterscategory_TableViewCell", for: indexPath) as! StoreFilterscategory_TableViewCell
                  let data = DisplayCat0Model?.counts?[indexPath.row]
                
                  cell.lbl.text =  data?.highlighted
                  cell.countlbl.text  = String(describing: data?.count ?? 0)
                  cell.categoryBtnTap.tag = indexPath.row
                  cell.img.tag = indexPath.row
                  cell.categoryBtnTap.tintColor = .transparent
                  
      //            cell.img.addTarget(self, action: #selector(SelectCategorerybtn(_:)), for: .touchUpInside)
                  cell.categoryBtnTap.addTarget(self, action: #selector(SelectCategorerybtn(_:)), for: .touchUpInside)
                  
                  if(self.FiltermodelArray.contains(where: {$0.value == data?.value})){
                      cell.categoryBtnTap.isSelected = true
                      
                      cell.img.isSelected = true
                      
                  }else{
                      cell.categoryBtnTap.isSelected = false
                      cell.img.isSelected = false
                  }
                  return cell
              
             
       
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
//            if(Cat0Model?.counts?.count != 0){
//                let data = Cat0Model?.counts?[indexPath.row]
//                categoryString.append(data?.value ?? "")
//            }else{
                let data = DisplayCat0Model?.counts?[indexPath.row]
                categoryString.append(data?.value ?? "")
            
//            }
           
         
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Return a height based on the content of each row. This could depend on your data model.
        if tableView == categoriestbl {
            
            // Calculate height based on content, or use a specific value
            if let dataCount = DisplayCat0Model?.counts?.count {
                if dataCount <= 3 {
                    // Set table view height based on the number of items
                    self.heightCategory.constant = CGFloat(dataCount * 75)
                } else if(dataCount == 0){
                    // Set fixed height when item count is more than 3
                    self.heightCategory.constant = 0
                
                }
              
            }
        }
        return 44.0 // Default height for other tables if needed
    }
    
    private func FetchData(val:String, txt: String,facet_by:String,isclick:Bool){
            
          
            if(self.SelectedCat0Model != nil){
                if(SelectedCat0Model?.isquery == "lvl0"){
                    if(allfacetfilter == ""){
                        allfacetfilter  = "lvl0:=[\(self.SelectedCat0Model?.value ?? "")]"
//                        allfacetfilter  = "lvl0:=[\(categoryString[0])]"
                    }else{
                        allfacetfilter  += "&&lvl0:=[\(self.SelectedCat0Model?.value ?? "")]"
//                        allfacetfilter  += "&&lvl0:=[\((categoryString[0]))]"
                    }
                }
                if(SelectedCat0Model?.isquery == "lvl1"){
                    if(allfacetfilter == ""){
                        allfacetfilter  = "lvl1:=[\(self.SelectedCat0Model?.value ?? "")]"
                    }else{
                        allfacetfilter  += "&&lvl1:=[\(self.SelectedCat0Model?.value ?? "")]"
                    }
                }
                if(SelectedCat0Model?.isquery == "lvl2"){
                    if(allfacetfilter == ""){
                        allfacetfilter  = "lvl2:=[\(self.SelectedCat0Model?.value ?? "")]"
                    }else{
                        allfacetfilter  += "&&lvl2:=[\(self.SelectedCat0Model?.value ?? "")]"
                    }
                }
                
                
            }
            if(self.SelectedratingModel != nil){
                
                if(allfacetfilter == ""){
                    allfacetfilter  = "averageRating:=[\(self.SelectedratingModel?.value ?? "")]"
                }else{
                    allfacetfilter  += "&&averageRating:=[\(self.SelectedratingModel?.value ?? "")]"
                }
                 
            }
            if(SelectedColorModel != nil){
                
                if(allfacetfilter == ""){
                    allfacetfilter  =  "color:=[\(self.SelectedColorModel?.value ?? "")]"
                }else{
                    allfacetfilter  +=  "&&color:=[\(self.SelectedColorModel?.value ?? "")]"
                }
              
            }
            if(SelectedStoreModel != nil){
                
                if(allfacetfilter == ""){
                    allfacetfilter  =  "brandName:=[\(self.SelectedStoreModel?.value ?? "")]"
                }else{
                    allfacetfilter  +=  "&&brandName:=[\(self.SelectedStoreModel?.value ?? "")]"
                }
            }
        if(SelectedsizeeModel != nil){
            
            if(allfacetfilter == ""){
                allfacetfilter  =   "size:=[\(self.SelectedsizeeModel?.value ?? "")]"
            }else{
                allfacetfilter  +=   "&&size:=[\(self.SelectedsizeeModel?.value ?? "")]"
            }
        }
        
        if(allfacetfilter == ""){
                    if(rangeSlider.minValue != rangeSlider.selectedMinValue){
                        allfacetfilter  =   "price:>=\(Int(rangeSlider.selectedMinValue))"
                    }
            else if(rangeSlider.maxValue != rangeSlider.selectedMaxValue){
                allfacetfilter  =   "price:<=\(Int(rangeSlider.selectedMaxValue))"
            }
                }else{
//
                    if(rangeSlider.minValue != rangeSlider.selectedMinValue){
                        allfacetfilter  =   "&&price:>=\(Int(rangeSlider.selectedMinValue))"
                    }
            else if(rangeSlider.maxValue != rangeSlider.selectedMaxValue){
                allfacetfilter  =   "&&price:<=\(Int(rangeSlider.selectedMaxValue))"
            }
                }
                

            print(allfacetfilter)
       
        
      
        
        AppDefault.allfacetString =  allfacetfilter
        
           // allfacetfilter.append("productType:=[main]")
             
          
        
        
        
        if(isclick){
            self.dismiss(animated: true, completion: {
                self.delegate?.StoreFilters_ViewControllerDidFinish(self,facetby: self.allfacetfilter, filterby: "")
            })
        }
        
        
        
        
        
        }
    
}
extension StoreFilters_ViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == size_collect {
            
            
            let label = UILabel(frame: CGRect.zero)
            if indexPath.row <= self.sizeModel?.counts?.count ?? 0 - 1 {
               
                label.text =   "\(self.sizeModel?.counts?[indexPath.item].highlighted ?? "")" + " (\(self.sizeModel?.counts?[indexPath.item].count ?? 0))"
               
            }
            
            label.sizeToFit()
            return CGSize(width: label.bounds.width + 25, height: 45)
            
     
        }else if(collectionView == rating_collect){
            return CGSize(width: 100, height: self.rating_collect.frame.height)
        }
        else if(collectionView == FilterColletion){
            
            let label = UILabel(frame: CGRect.zero)
            if indexPath.row <= self.FiltermodelArray.count {
              
                label.text =  self.FiltermodelArray[indexPath.item].value
                
            }
            
            label.sizeToFit()
            return CGSize(width: label.frame.width + 20, height: 40)
            
            
            
            
        }
        else {
            return CGSize(width: collectionView.frame.width/3-10, height: collectionView.frame.height-2)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == store_collect {
            if(StoreModel != nil){
                return StoreModel?.counts?.count ?? 0
            }else{
                return 0
            }
              
            
         
        } else if collectionView == size_collect {
            if(sizeModel != nil){
                return sizeModel?.counts?.count ?? 0
            }else{
                return 0
            }
         
        } else if(collectionView == rating_collect){
            if(RatingmOdel != nil){
                return RatingmOdel?.counts?.count ?? 0
            }else{
                return 0
            }
        } else if(collectionView == FilterColletion){
          
            return FiltermodelArray.count ?? 0
          
        }
        
        else if(collectionView == colorCollectionView){
          
            return ColorModel?.counts?.count ?? 0
          
        }
        else{
            return 0
        }
        
    }
    @objc func buttonTapped(_ sender: UIButton) {
        var data = StoreModel?.counts?[sender.tag]
     
        let obj = TypeSenseCount(count: data?.count, highlighted:data?.highlighted , value: data?.value, isselected: true , isquery: "brandName")
      
        
        
        SelectedStoreModel = obj
       // StoreModel?.counts?[sender.tag]?.isselected = true
        sender.isSelected = !sender.isSelected
        
        
        if(FiltermodelArray.contains(where: { return $0.isquery == "brandName"}) == true) {
            FiltermodelArray.removeAll(where: { return $0.isquery == "brandName"})
            self.FiltermodelArray.append(self.SelectedStoreModel!)
        }else{
            self.FiltermodelArray.append(self.SelectedStoreModel!)
        }
        
        
        
        selectedIndex = sender.tag
        store_collect.reloadData()
        
        
        // Notify the view controller that the button was tapped
    }
    
    @objc func sizeCollection(_ sender: UIButton) {
        var data = sizeModel?.counts?[sender.tag]
        let obj = TypeSenseCount(count: data?.count, highlighted:data?.highlighted , value: data?.value, isselected: true , isquery: "size")
      
        sender.isSelected = !sender.isSelected
    
        SelectedsizeeModel = obj
       // StoreModel?.counts?[sender.tag]?.isselected = true
        sizeIndex = sender.tag
        
        
        if(FiltermodelArray.contains(where: { return $0.isquery == "size"}) == true) {
            FiltermodelArray.removeAll(where: { return $0.isquery == "size"})
            self.FiltermodelArray.append(self.SelectedsizeeModel!)
        }else{
            self.FiltermodelArray.append(self.SelectedsizeeModel!)
        }
        
        size_collect.reloadData()
        
        
        // Notify the view controller that the button was tapped
        
    }
    @objc func colorButtonTap(_ sender: UIButton) {
        var data = ColorModel?.counts?[sender.tag]
        let obj = TypeSenseCount(count: data?.count, highlighted:data?.highlighted , value: data?.value, isselected: true , isquery: "color")
        let colorData = ColorModel?.counts?[sender.tag]
        selectedColor.append(colorData?.value ?? "")
        colorIndex = sender.tag
       
        SelectedColorModel = obj
       // ColorModel?.counts?[sender.tag]?.isselected = true
        if(FiltermodelArray.contains(where: { return $0.isquery == "color"}) == true) {
            FiltermodelArray.removeAll(where: { return $0.isquery == "color"})
            self.FiltermodelArray.append(self.SelectedColorModel!)
        }else{
            self.FiltermodelArray.append(self.SelectedColorModel!)
        }
        colorCollectionView.reloadData()
        
        
        // Notify the view controller that the button was tapped
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == store_collect {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreFiltersStore_CollectionViewCell", for: indexPath) as! StoreFiltersStore_CollectionViewCell
           

            let data = StoreModel?.counts?[indexPath.row]
            let  label = "\(String(describing: data?.highlighted ?? ""))"  + " (\(String(describing: data?.count ?? 0)))"
            cell.storeBtn.setTitle(label,for: .normal)
//            cell.storeBtn.setTitle("\(data?.count ?? 0)", for: .normal)
            cell.storeBtn.tag = indexPath.row
            cell.storeBtn.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
//            cell.storeBtn.titleLabel?.font = UIFont(name: "Poppins", size: CGFloat(10))
            
            if indexPath.item == selectedIndex {
                       cell.storeview.backgroundColor = UIColor(named: "headercolor")
                       cell.storeBtn.backgroundColor = UIColor(named: "headercolor")
                       cell.storeview.cornerRadius = 4
                       cell.storeBtn.cornerRadius  = 4
                cell.storeBtn.tintColor = .white
                   
                
                   } else {
                       cell.storeBtn.tintColor = UIColor(hex: "#909090")
                       cell.storeview.backgroundColor = UIColor(hex: "#F1F2F1")
                       cell.storeBtn.backgroundColor = UIColor(hex: "#F1F2F1")
                       cell.storeview.cornerRadius = 4
                       cell.storeBtn.cornerRadius  = 4
                 
                   }
            
//            cell.lbl.text  = data?.highlighted ?? "" + "\(data?.highlighted?.count ?? 0)"
            
            return cell
            
        }else if collectionView == FilterColletion {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreFiltersStore_CollectionViewCell", for: indexPath) as! StoreFiltersStore_CollectionViewCell
            let data = FiltermodelArray[indexPath.row]
            print(allfacetfilter)
            
         
            
            cell.lbl.text  = data.highlighted ?? ""
            
            return cell
            
        }
        else if collectionView == size_collect {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Size_CollectionViewCell", for: indexPath) as! Size_CollectionViewCell
            let data = sizeModel?.counts?[indexPath.row]
            let label = "\(data?.highlighted ?? "")" + " (\(data?.count ?? 0))"
            cell.sizeButton.setTitle(label, for: .normal)
            cell.sizeButton.tag = indexPath.row
            cell.sizeButton.addTarget(self, action: #selector(sizeCollection(_:)), for: .touchUpInside)
            cell.sizeButton.titleLabel?.font = UIFont(name: "Bruna", size: CGFloat(10))
            if indexPath.item == sizeIndex {
                       cell.storeview.backgroundColor = UIColor(named: "headercolor")
                       cell.sizeButton.backgroundColor = UIColor(named: "headercolor")
                       cell.storeview.cornerRadius = 4
                       cell.sizeButton.cornerRadius  = 4
                cell.sizeButton.tintColor = .white
            } else {
                cell.sizeButton.tintColor = UIColor(hex: "#909090")
                cell.storeview.backgroundColor = UIColor(hex: "#F1F2F1")
                cell.sizeButton.backgroundColor = UIColor(hex: "#F1F2F1")
                cell.storeview.cornerRadius = 4
                cell.sizeButton.cornerRadius  = 4
            }
            cell.lbl.text  = data?.highlighted ?? "" + "\(data?.count ?? 0)"
            
            return cell
        }else if(collectionView == colorCollectionView) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorsFiltersStore_CollectionViewCell", for: indexPath) as! ColorsFiltersStore_CollectionViewCell
            let data = ColorModel?.counts?[indexPath.row]
            cell.colorBtnTap.tag = indexPath.row
            let label = "\(data?.highlighted ?? "")" + " (\(data?.count ?? 0))"
            cell.colorBtnTap.setTitle(label, for: .normal)
            if(self.SelectedColorModel?.value == data?.value){
                cell.colorBtnTap.isSelected = true
            }else{
                cell.colorBtnTap.isSelected = false
            }
            if indexPath.item == colorIndex {
                       cell.colorView.backgroundColor = UIColor(named: "headercolor")
                cell.colorBtnTap.backgroundColor = UIColor(named: "headercolor")
                       cell.colorView.cornerRadius = 4
                       cell.colorBtnTap.cornerRadius  = 4
                cell.colorBtnTap.tintColor = .white
            } else {
                cell.colorBtnTap.tintColor = UIColor(hex: "#909090")
                cell.colorView.backgroundColor = UIColor(hex: "#F1F2F1")
                cell.colorBtnTap.backgroundColor = UIColor(hex: "#F1F2F1")
                cell.colorView.cornerRadius = 4
                cell.colorBtnTap.cornerRadius  = 4
            }
            cell.colorBtnTap.addTarget(self, action: #selector(colorButtonTap(_:)), for: .touchUpInside)
//            cell.lbl.text = data?.highlighted
            return cell
        }
        
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreFiltersrating_CollectionViewCell", for: indexPath) as! StoreFiltersrating_CollectionViewCell
            let data = RatingmOdel?.counts?[indexPath.row]
           
            cell.lbl.text = data?.highlighted ?? ""
            if indexPath.item == ratingndex {
                       cell.ratingview.backgroundColor = UIColor(named: "headercolor")
                cell.lbl.textColor = .white
                       cell.ratingview.cornerRadius = 4
                                   
                   } else {
                       cell.ratingview.backgroundColor = UIColor(hex: "#F1F2F1")
                       cell.ratingview.cornerRadius = 4
                 
                   }
            return cell

        }
        
    }
   
    func replaceEveryFourthAndOperator(in inputString: String) -> String {
        // Split the string by "&&" to find occurrences
        var components = inputString.components(separatedBy: "&&")
        
        // Count the total occurrences of "&&"
        var count = 0
        
        // Iterate through the components to rebuild the string
        var result = ""
        
        for i in 0..<components.count {
            result += components[i]
            
            // Add "&&" after each component except the last one
            if i < components.count - 1 {
                count += 1
                // If the count is divisible by 4, use "&&&&" instead of "&&"
                if count % 4 == 0 {
                    result += "&&&&"
                } else {
                    result += "&&"
                }
            }
        }
        
        return result
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == store_collect{
           
            let data = StoreModel?.counts?[indexPath.row]
        
          
            selectedStores.append(data?.value ?? "")
            
            lastquery =  "brandName:=\(selectedStores)"
//            lastquery =   "brandName:=[\(data?.value ?? "")]"
           
           
           
           
        
        }else   if collectionView == FilterColletion{
            
            print("pop\(allfacetfilter)")
            let data = FiltermodelArray[indexPath.row]
            
  FiltermodelArray.remove(at: indexPath.row)
       
            if(data.isquery == "lvl0"){
                
                allfacetfilter  = allfacetfilter.replacingOccurrences(of: "lvl0:=[\(data.value ?? "")]", with: "")
                if allfacetfilter.hasPrefix("&&") {
                    allfacetfilter =  String(allfacetfilter.dropFirst(2))
                }
                 if allfacetfilter.hasSuffix("&&") {
                    allfacetfilter =  String(allfacetfilter.dropLast(2))
                }
                print("pop\(allfacetfilter)")
//                self.SelectedCat0Model = nil

                    self.FetchData(val: "", txt: "*",facet_by: "lvl1,lvl2,color,brandName,averageRating,price,size,style", isclick: true)
                       
                
            }
            if(data.isquery == "lvl1"){
                allfacetfilter =    allfacetfilter.replacingOccurrences(of: "lvl1:=[\(data.value ?? "")]", with: "")
               
                if allfacetfilter.hasPrefix("&&") {
                    allfacetfilter =  String(allfacetfilter.dropFirst(2))
                }
                 if allfacetfilter.hasSuffix("&&") {
                    allfacetfilter =  String(allfacetfilter.dropLast(2))
                     
                }
                if allfacetfilter.hasPrefix("&&&&") {
                    allfacetfilter =  String(allfacetfilter.dropFirst(4))
                }
                if allfacetfilter.hasSuffix("&&&&") {
                    allfacetfilter =  String(allfacetfilter.dropLast(4))
                }
                
                allfacetfilter = allfacetfilter.replacingOccurrences(of: "&&&&", with: "&&")
                print("pop\(allfacetfilter)")
                
                self.FetchData(val: "", txt: "*",facet_by: "lvl0,lvl1,color,brandName,averageRating,price,size,style", isclick: true)
                
//                self.SelectedCat0Model = nil
            }
            if(data.isquery == "lvl2"){
                allfacetfilter =    allfacetfilter.replacingOccurrences(of: "lvl2:=[\(data.value ?? "")]", with: "")
                
                 if allfacetfilter.hasPrefix("&&") {
                     allfacetfilter =  String(allfacetfilter.dropFirst(2))
                 }
                  if allfacetfilter.hasSuffix("&&") {
                     allfacetfilter =  String(allfacetfilter.dropLast(2))
                      
                 }
                 if allfacetfilter.hasPrefix("&&&&") {
                     allfacetfilter =  String(allfacetfilter.dropFirst(4))
                 }
                 if allfacetfilter.hasSuffix("&&&&") {
                     allfacetfilter =  String(allfacetfilter.dropLast(4))
                 }
                 
                 allfacetfilter = allfacetfilter.replacingOccurrences(of: "&&&&", with: "&&")
                 print("pop\(allfacetfilter)")
                self.FetchData(val: "", txt: "*",facet_by: "lvl2,color,brandName,averageRating,price,size,style", isclick: true)
                print("pop\(allfacetfilter)")
//                self.SelectedCat0Model = nil
            }
            if(data.isquery == "color"){
                
                
                
                allfacetfilter = allfacetfilter.replacingOccurrences(of: "color:=[\(data.value ??  "")]", with: "")
                
                 if allfacetfilter.hasPrefix("&&") {
                     allfacetfilter =  String(allfacetfilter.dropFirst(2))
                 }
                  if allfacetfilter.hasSuffix("&&") {
                     allfacetfilter =  String(allfacetfilter.dropLast(2))
                      
                 }
                 if allfacetfilter.hasPrefix("&&&&") {
                     allfacetfilter =  String(allfacetfilter.dropFirst(4))
                 }
                 if allfacetfilter.hasSuffix("&&&&") {
                     allfacetfilter =  String(allfacetfilter.dropLast(4))
                 }
                 
                 allfacetfilter = allfacetfilter.replacingOccurrences(of: "&&&&", with: "&&")
                 print("pop\(allfacetfilter)")
                print("pop\(allfacetfilter)")
                if(SelectedCat0Model?.isquery == "lvl0"){
                    self.FetchData(val: "", txt: "*",facet_by: "lvl0,lvl1,color,brandName,averageRating,price,size,style", isclick: true)
                }else if (SelectedCat0Model?.isquery == "lvl1"){
                    self.FetchData(val: "", txt: "*",facet_by: "lvl1,lvl2,color,brandName,averageRating,price,size,style", isclick: true)
                }else if(SelectedCat0Model?.isquery == "lvl2"){
                    self.FetchData(val: "", txt: "*",facet_by: "lvl2,color,brandName,averageRating,price,size,style", isclick: true)
                }else {
                    self.FetchData(val: "", txt: "*",facet_by: "color,brandName,averageRating,price,size,style", isclick: true)
                }
              
//                self.SelectedColorModel = nil
            }
            if(data.isquery == "brandName"){
                allfacetfilter = allfacetfilter.replacingOccurrences(of: "brandName:=[\(data.value ??  "")]", with: "")
                print("pop\(allfacetfilter)")
                
                 if allfacetfilter.hasPrefix("&&") {
                     allfacetfilter =  String(allfacetfilter.dropFirst(2))
                 }
                  if allfacetfilter.hasSuffix("&&") {
                     allfacetfilter =  String(allfacetfilter.dropLast(2))
                      
                 }
                 if allfacetfilter.hasPrefix("&&&&") {
                     allfacetfilter =  String(allfacetfilter.dropFirst(4))
                 }
                 if allfacetfilter.hasSuffix("&&&&") {
                     allfacetfilter =  String(allfacetfilter.dropLast(4))
                 }
                 
                 allfacetfilter = allfacetfilter.replacingOccurrences(of: "&&&&", with: "&&")
                 print("pop\(allfacetfilter)")
                if(SelectedCat0Model?.isquery == "lvl0"){
                    allfacetfilter = allfacetfilter.replacingOccurrences(of: "&&&&", with: "&&")
                    self.FetchData(val: "", txt: "*",facet_by: "lvl0,lvl1,color,brandName,averageRating,price,size,style", isclick: true)
                }else if (SelectedCat0Model?.isquery == "lvl1"){
                    allfacetfilter = allfacetfilter.replacingOccurrences(of: "&&&&", with: "&&")
                    self.FetchData(val: "", txt: "*",facet_by: "lvl1,lvl2,color,brandName,averageRating,price,size,style", isclick: true)
                }else if(SelectedCat0Model?.isquery == "lvl2"){
                    allfacetfilter = allfacetfilter.replacingOccurrences(of: "&&&&", with: "&&")
                    self.FetchData(val: "", txt: "*",facet_by: "lvl2,color,brandName,averageRating,price,size,style", isclick: true)
                }else {
                    allfacetfilter = allfacetfilter.replacingOccurrences(of: "&&&&", with: "&&")
                    self.FetchData(val: "", txt: "*",facet_by: "color,brandName,averageRating,price,size,style", isclick: true)
                }
//                self.SelectedStoreModel = nil
            }
            if(data.isquery == "averageRating"){
                allfacetfilter = allfacetfilter.replacingOccurrences(of: "averageRating:=[\(data.value ??  "")]", with: "")
//                self.SelectedratingModel = nil
                
                 if allfacetfilter.hasPrefix("&&") {
                     allfacetfilter =  String(allfacetfilter.dropFirst(2))
                 }
                  if allfacetfilter.hasSuffix("&&") {
                     allfacetfilter =  String(allfacetfilter.dropLast(2))
                      
                 }
                 if allfacetfilter.hasPrefix("&&&&") {
                     allfacetfilter =  String(allfacetfilter.dropFirst(4))
                 }
                 if allfacetfilter.hasSuffix("&&&&") {
                     allfacetfilter =  String(allfacetfilter.dropLast(4))
                 }
                 
                 allfacetfilter = allfacetfilter.replacingOccurrences(of: "&&&&", with: "&&")
                 print("pop\(allfacetfilter)")
                print("pop\(allfacetfilter)")
                if(SelectedCat0Model?.isquery == "lvl0"){
                    self.FetchData(val: "", txt: "*",facet_by: "lvl0,lvl1,color,brandName,averageRating,price,size,style", isclick: true)
                }else if (SelectedCat0Model?.isquery == "lvl1"){
                    self.FetchData(val: "", txt: "*",facet_by: "lvl1,lvl2,color,brandName,averageRating,price,size,style", isclick: true)
                }else if(SelectedCat0Model?.isquery == "lvl2"){
                    self.FetchData(val: "", txt: "*",facet_by: "lvl2,color,brandName,averageRating,price,size,style", isclick: true)
                }else {
                    self.FetchData(val: "", txt: "*",facet_by: "color,brandName,averageRating,price,size,style", isclick: true)
                }
            }
            if(data.isquery == "size"){
                allfacetfilter = allfacetfilter.replacingOccurrences(of: "size:=[\(data.value ??  "")]", with: "")
//                self.SelectedsizeeModel = nil
                
                 if allfacetfilter.hasPrefix("&&") {
                     allfacetfilter =  String(allfacetfilter.dropFirst(2))
                 }
                  if allfacetfilter.hasSuffix("&&") {
                     allfacetfilter =  String(allfacetfilter.dropLast(2))
                      
                 }
                 if allfacetfilter.hasPrefix("&&&&") {
                     allfacetfilter =  String(allfacetfilter.dropFirst(4))
                 }
                 if allfacetfilter.hasSuffix("&&&&") {
                     allfacetfilter =  String(allfacetfilter.dropLast(4))
                 }
                 
                 allfacetfilter = allfacetfilter.replacingOccurrences(of: "&&&&", with: "&&")
                 print("pop\(allfacetfilter)")
                
                if(SelectedCat0Model?.isquery == "lvl0"){
                    self.FetchData(val: "", txt: "*",facet_by: "lvl0,lvl1,color,brandName,averageRating,price,size,style", isclick: true)
                }else if (SelectedCat0Model?.isquery == "lvl1"){
                    self.FetchData(val: "", txt: "*",facet_by: "lvl1,lvl2,color,brandName,averageRating,price,size,style", isclick: true)
                }else if(SelectedCat0Model?.isquery == "lvl2"){
                    self.FetchData(val: "", txt: "*",facet_by: "lvl2,color,brandName,averageRating,price,size,style", isclick: true)
                }else {
                    self.FetchData(val: "", txt: "*",facet_by: "color,brandName,averageRating,price,size,style", isclick: true)
                }
            }
            
            if(data.isquery == "price_min" || data.isquery == "price_max") {
                // Remove the item from the FiltermodelArray
                
                // Also update the price range slider if needed
                if data.isquery == "price_min" {
                    rangeSlider.selectedMinValue = rangeSlider.minValue
                } else if data.isquery == "price_max" {
                    rangeSlider.selectedMaxValue = rangeSlider.maxValue
                }
                
                // Remove from allfacetfilter string
                if let value = data.value {
                    allfacetfilter = allfacetfilter.replacingOccurrences(of: "price:\(value)", with: "")
                    allfacetfilter = allfacetfilter.replacingOccurrences(of: "&&price:\(value)", with: "")
                }
                
                // Clean up any leading/trailing && operators
                if allfacetfilter.hasPrefix("&&") {
                    allfacetfilter = String(allfacetfilter.dropFirst(2))
                }
                if allfacetfilter.hasSuffix("&&") {
                    allfacetfilter = String(allfacetfilter.dropLast(2))
                }
                
                allfacetfilter = allfacetfilter.replacingOccurrences(of: "&&&&", with: "&&")
                
                print("Updated allfacetfilter: \(allfacetfilter)")
                
                if(SelectedCat0Model?.isquery == "lvl0"){
                    self.FetchData(val: "", txt: "*",facet_by: "lvl0,lvl1,color,brandName,averageRating,price,size,style", isclick: true)
                }else if (SelectedCat0Model?.isquery == "lvl1"){
                    self.FetchData(val: "", txt: "*",facet_by: "lvl1,lvl2,color,brandName,averageRating,price,size,style", isclick: true)
                }else if(SelectedCat0Model?.isquery == "lvl2"){
                    self.FetchData(val: "", txt: "*",facet_by: "lvl2,color,brandName,averageRating,price,size,style", isclick: true)
                }else {
                    self.FetchData(val: "", txt: "*",facet_by: "color,brandName,averageRating,price,size,style", isclick: true)
                }
            }
            
            print("pop\(allfacetfilter)")
              //  self.FetchData(val: "", txt: "*",facet_by: "lvl0,lvl1,color,brandName,averageRating,price,size,style", isclick: false)

            AppDefault.allfacetString = allfacetfilter
          
            self.FilterColletion.reloadData()
           
            
        }
        
        else if(collectionView == size_collect){
            let data = sizeModel?.counts?[indexPath.row]
          
            selectedSizes.append(data?.value ?? "")
            
            lastquery =  "size:=\(selectedSizes)"
//            lastquery =   "brandName:=[\(data?.value ?? "")]"
        }else if(collectionView == rating_collect){
            var data = RatingmOdel?.counts?[indexPath.row]
            selectedRating.append(Int(data?.value ?? "") ?? 0)
            ratingndex = indexPath.row
            lastquery =  "averageRating:=\(selectedRating)"
//            lastquery =   "brandName:=[\(data?.value ?? "")]"
        
            let obj = TypeSenseCount(count: data?.count, highlighted:data?.highlighted , value: data?.value, isselected: true , isquery: "averageRating")
          
            self.SelectedratingModel = obj
            
            
            if(FiltermodelArray.contains(where: { return $0.isquery == "averageRating"}) == true) {
                FiltermodelArray.removeAll(where: { return $0.isquery == "averageRating"})
                self.FiltermodelArray.append(self.SelectedratingModel!)
            }else{
                self.FiltermodelArray.append(self.SelectedratingModel!)
            }
            
          
            rating_collect.reloadData()
        }else{
            
        }
    }
    

}

extension StoreFilters_ViewController: RangeSeekSliderDelegate {
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        print("Selected range: \(minValue) - \(maxValue)")

        // Remove existing price filters if they exist
        FiltermodelArray.removeAll(where: { $0.isquery == "price_min" || $0.isquery == "price_max" })

        // Add new filter if minValue is greater than min range
        if slider.minValue != minValue {
            let minPriceFilter = TypeSenseCount(count: nil, highlighted: "Price ≥ \(Int(minValue))", value: ">=\(Int(minValue))", isselected: true, isquery: "price_min")
            FiltermodelArray.append(minPriceFilter)
        }

        // Add new filter if maxValue is less than max range
        if slider.maxValue != maxValue {
            let maxPriceFilter = TypeSenseCount(count: nil, highlighted: "Price ≤ \(Int(maxValue))", value: "<=\(Int(maxValue))", isselected: true, isquery: "price_max")
            FiltermodelArray.append(maxPriceFilter)
        }

        // Reload filter collection view to reflect changes
        self.FilterColletion.reloadData()
    }
}
