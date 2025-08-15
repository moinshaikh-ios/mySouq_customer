//
//  VediosSearch_VC.swift
//  Bazaar Ghar
//
//  Created by Umair ALi on 06/09/2023.
//

import UIKit

class VediosSearch_VC: UIViewController {
    @IBOutlet weak var dropdownbtn: UIButton!
    @IBOutlet weak var vediocategoryCollection:UICollectionView!
    @IBOutlet weak var vediosearchCollection:UICollectionView!
    
    @IBOutlet weak var notFound: UILabel!


    var searchVideodata: [LiveStreamingResults] = []
    var searchText: String? {
        didSet {
            self.array.removeAll()
            searchVideo(name: "title", value: searchText ?? "", limit: limit ?? 20, catId: self.array, page: 1)
        }
    }
    var selectedindex : Int? {
        didSet {
            vediocategoryCollection.reloadData()
        }
    }
    var array = [String]()
    var limit: Int?
    @IBOutlet weak var viewheight: NSLayoutConstraint!
    var isLoadingMore = false
    var count = 1
    var CategoriesResponsedata: [CategoriesResponse] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        vediocategoryCollection.dataSource = self
        vediocategoryCollection.delegate = self
        vediosearchCollection.dataSource = self
        vediosearchCollection.delegate = self
        self.viewheight.constant = 0
        self.categoriesApi(isbackground: false, id: "")
    }
    @IBAction func DropDownTapped(_ sender: Any) {
        self.dropdownbtn.isSelected = !self.dropdownbtn.isSelected
        
        
        if(self.dropdownbtn.isSelected){
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
               self.viewheight.constant = 90
               self.view.layoutIfNeeded()
           })
        }else{
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
               self.viewheight.constant = 0
               self.view.layoutIfNeeded()
           })

        }
    }
    override func viewWillAppear(_ animated: Bool) {
        notFound.isHidden = true
        searchVideo(name: "title", value: searchText ?? "", limit: limit ?? 20, catId: self.array, page: 1)
    }
    
    private func searchVideo(name:String,value:String,limit:Int,catId:[String],page:Int){
        APIServices.searchVideo(name:name,value:value,limit:limit,catId: catId, page: page){[weak self] data in
            switch data{
            case .success(let res):
                if page < 2 {
                    self?.searchVideodata.removeAll()
                }
                if res.results.count > 0 {
                    self?.notFound.isHidden = true
                    self?.searchVideodata += res.results
                    self?.isLoadingMore = false
                }else {
                    if page < 2 {
                        self?.notFound.isHidden = false
                    }
                }
                self?.vediosearchCollection.reloadData()

            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func categoriesApi(isbackground:Bool,id:String) {
        APIServices.categories(isbackground:isbackground, id: id, limit: 28,completion: {[weak self] data in
            switch data {
            case .success(let res):
                for i in (0 ..< (self?.CategoriesResponsedata.count ?? 0)).reversed() {
              
                    self?.CategoriesResponsedata[i].subCategories?.removeAll(where: {$0.categorySpecs?.productsCount == 0})
                }
                self?.CategoriesResponsedata = res.Categoriesdata ?? []
                
                self?.vediocategoryCollection.reloadData()
            case .failure(let error):
                print(error)
                self?.view.makeToast(error)
            }
        })
    }
    

}
extension VediosSearch_VC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == vediocategoryCollection
        {
            return CategoriesResponsedata.count
            
        }else {
            return searchVideodata.count
        }
    }
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if (collectionView == vediocategoryCollection){
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "vediocategory_Cell", for: indexPath) as! vediocategory_Cell
                let data = CategoriesResponsedata[indexPath.row]
                cell.imageView.pLoadImage(url: data.mainImage ?? "")
                cell.vedioCatLbl.text = LanguageManager.language == "ar" ? data.lang?.ar?.name ?? data.name : data.name ?? ""
                if selectedindex   == indexPath.row {
                    cell.imageView.borderWidth = 1
                    cell.borderView.borderColor = primaryColor
                }else {
                    cell.imageView.borderWidth = 0
                    cell.borderView.borderColor = UIColor(named: "greenColor")
                }
                return cell
            }else{
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "vediosearchcollection_Cell", for: indexPath) as! vediosearchcollection_Cell
                let data = searchVideodata[indexPath.row]
                cell.mainimageView.pLoadImage(url: data.thumbnail ?? "")
                if data.brandLogo == nil {
                    cell.productimageView.image = UIImage(named: "Logo-main")
                    cell.productimageView.contentMode = .scaleAspectFit
                }else {
                    cell.productimageView.pLoadImage(url: data.brandLogo ?? "")
                    cell.productimageView.contentMode = .scaleToFill
                }
                cell.productname.text = LanguageManager.language == "ar" ? data.lang?.ar?.title ?? data.title : data.title
                cell.storename.text = LanguageManager.language == "ar" ? data.lang?.ar?.brandName ?? data.brandName : data.brandName
                cell.viewslbl.text = "\(data.totalViews ?? 0) Views"
                return cell
            }
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            if collectionView == vediocategoryCollection {
                if CategoriesResponsedata[indexPath.row].categorySpecs?.productsCount ?? 0 > 0 {
                    return CGSize(width: collectionView.frame.size.width/5-10, height: collectionView.frame.size.height)
                }else {
                    return CGSize(width: 0, height: 0)
                }
            }else {
                let data = searchVideodata[indexPath.row]
                if data.title?.count ?? 0 > 47 {
                    return CGSize(width: collectionView.frame.size.width, height: 338)
                }else {
                    return CGSize(width: collectionView.frame.size.width, height: 325)

                }
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            
            UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == vediocategoryCollection
        {
            let data = CategoriesResponsedata[indexPath.row]
            self.selectedindex = indexPath.row
            self.array.removeAll()
            self.array.append(data.id ?? "")
            self.searchVideo(name: "title", value: searchText ?? "", limit: limit ?? 20, catId: self.array, page: 1)
         
            
        }else {
            let vc = New_SingleVideoview.getVC(.videoStoryBoard)
            vc.LiveStreamingResultsdata = self.searchVideodata
            vc.indexValue = indexPath.row
            vc.page = 2
            self.navigationController?.pushViewController(vc, animated: false)
            appDelegate.videoCountAPI(isbackground: false, slug: searchVideodata[indexPath.row].slug ?? "")
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
          let offsetY = scrollView.contentOffset.y
          let contentHeight = scrollView.contentSize.height
          let height = scrollView.frame.size.height

          if offsetY > contentHeight - height {
              if !isLoadingMore {
                  print("Load more")
                  isLoadingMore = true
                  count += 1
                  searchVideo(name: "title", value: searchText ?? "", limit: limit ?? 20, catId: self.array, page: count)
              }
          }
      }
        
}

