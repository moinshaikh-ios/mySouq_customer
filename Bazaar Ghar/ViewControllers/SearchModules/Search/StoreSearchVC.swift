//
//  StoreSearchVC.swift
//  Bazaar Ghar
//
//  Created by Zany on 06/09/2023.
//

import UIKit
import DropDown

class StoreSearchVC: UIViewController {
    
    @IBOutlet weak internal var storeCollectionView: UICollectionView!
    @IBOutlet weak internal var citydropdown: UITableView!

    @IBOutlet weak var crossbtn: UIButton!
    @IBOutlet weak var hiddenview: UIView!
    let dropDown = DropDown()
    @IBOutlet weak var dropdownLabel: UILabel!
    @IBOutlet weak var dropdownbutton: UIButton!
    
    @IBOutlet weak var notFound: UILabel!

    var searchstoredata: [searchStoreResult]? = []
    var city: [CitiesResponse] = []
    var searchText: String? {
        didSet {
            if isMarket == true {
                searchstore(market: marketID ?? "",name: "brandName" , limit: 36, page: 1, value: searchText ?? "",city: "")
            } else {
                searchstore(market: "",name: "brandName" , limit: 36, page: 1, value: searchText ?? "",city: "")
            }
        }
    }
    
    var marketID: String?
    var isMarket: Bool?
    var isNavBar : Bool?
    var isLoadingMore = false
    var count = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        citydropdown.delegate = self
        citydropdown.dataSource = self
        self.navigationController?.isNavigationBarHidden = isNavBar ?? true
// UIView or UIBarButtonItem
        dropdownLabel.text  = "Filter by City"
        setupCollectionView()
     
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        notFound.isHidden = true
        crossbtn.isHidden = true
        getcities()
        hiddenview.isHidden = true
        
    }
    
    func setupCollectionView() {
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        storeCollectionView.register(nib, forCellWithReuseIdentifier: "cell")
        storeCollectionView.delegate = self
        storeCollectionView.dataSource = self
    }
    @IBAction func crossbtntap(_ sender: Any) {
        dropdownLabel.text = "Filter by City"
        crossbtn.isHidden = true
        if isMarket == true {
            searchstore(market: marketID ?? "",name: "brandName" , limit: 36, page: 1, value: searchText ?? "",city: "")
        }else {
            searchstore(market: "",name: "brandName" , limit: 36, page: 1, value: searchText ?? "",city: "")
        }

    }
    @IBAction func dropdownBtn(_ sender: Any) {
        if hiddenview.isHidden == true
        {
            hiddenview.isHidden = false
        }else{
            hiddenview.isHidden = true
        }
    }
   
    
    private func searchstore(market:String,name:String,limit:Int,page:Int,value:String,city: String){
        APIServices.searchstore(market:market,name:name,limit:limit,page:page,value:value,city: city){[weak self] data in
            switch data{
            case .success(let res):
                if page < 2 {
                    self?.searchstoredata?.removeAll()
                }
                if res.results?.count ?? 0 > 0 {
                    self?.notFound.isHidden = true
                    self?.searchstoredata! += res.results ?? []
                    self?.storeCollectionView.reloadData()
                    self?.isLoadingMore = false
                }else {
                    if page < 2 {
                        self?.notFound.isHidden = false
                    }
                }
                self?.storeCollectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }

    private func getcities(){
        APIServices.citiesResponse(){[weak self] data in
            switch data{
            case .success(let res):
                self?.city = res
                self?.citydropdown.reloadData()
//                for item in res{
//
//                    self?.dropDown.dataSource.append(item.cityName ?? "")
//                }
//                self?.dropDown.reloadAllComponents()
               
            case .failure(let error):
                print(error)
            }
        }
    }


}
extension StoreSearchVC: UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return city.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = city[indexPath.row]
        let cityName  = data.cityName
        dropdownLabel.text = cityName
        hiddenview.isHidden = true
        if isMarket == true {
            self.searchstore(market:marketID ?? "",name: "brandName" , limit: 36, page: 1, value: searchText ?? "",city: cityName ?? "")

        }else {
            self.searchstore(market:"",name: "brandName" , limit: 36, page: 1, value: searchText ?? "",city: cityName ?? "")

        }
        crossbtn.isHidden = false
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "citiesdropdownCell", for: indexPath) as! citiesdropdownCell
        let data =  city[indexPath.row]
        cell.cityname.text = data.cityName ?? ""

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 33
    }
    
    
}

extension StoreSearchVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchstoredata?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        let data = searchstoredata?[indexPath.row]
        cell.imageView.contentMode = .scaleAspectFill
        cell.imageView.layer.cornerRadius = 10
        cell.imageView.pLoadImage(url: data?.images?.last ?? "")
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = searchstoredata?[indexPath.row]
        let vc = New_StoreVC.getVC(.productStoryBoard)
        vc.prductid = data?.seller ?? ""
//        vc.brandName = data?.brandName ?? ""
        vc.storeId = data?.seller ?? ""
        vc.sellerID = data?.seller
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: storeCollectionView.frame.width-5, height: storeCollectionView.frame.height/2)
     
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
                  if isMarket == true {
                      searchstore(market: marketID ?? "",name: "brandName" , limit: 36, page: count, value: searchText ?? "",city: "")
                  }else {
                      searchstore(market: "",name: "brandName" , limit: 36, page: count, value: searchText ?? "",city: "")
                  }
              }
          }
      }
    
}
