//
//  LIVE_videoNew.swift
//  Bazaar Ghar
//
//  Created by Developer on 14/06/2024.
//

import UIKit
import AudioToolbox

class LIVE_videoNew: UIViewController {
    @IBOutlet weak var searchFeild: UITextField!
    @IBOutlet weak var headerlbl: UILabel!
    @IBOutlet weak var nearByBtn: UIButton!
    @IBOutlet weak var categoriesBtn: UIButton!
    @IBOutlet weak var headerview: UIView!
    @IBOutlet weak var videocategorytableview: UITableView!
    
    @IBOutlet weak var categoryview: UIView!
    @IBOutlet weak var novideosview: UIView!
    @IBOutlet weak var catbtnview: UIView!
    @IBOutlet weak var nearByView: UIView!
    @IBOutlet weak var cartCount: UILabel!
    @IBOutlet weak var cartCountView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var categoriesLbl: UILabel!
    @IBOutlet weak var nearByLbl: UILabel!

    
    var cartCountShow: String? {
        didSet {
            if Int(cartCountShow ?? "0") ?? 0 > 0 {
                self.cartCountView.isHidden = false
            }
            self.cartCount.text = cartCountShow
        }
    }
    
    var LiveVideoData: [LiveStreamingResults] = []
    var LiveStreamingResultsdata: [LiveStreamingResults] = []
    var LiveStreamingResultsdatafilter: [LiveStreamingResults] = []

    var CategoriesResponsedata: [CategoriesResponse] = [] {
        didSet {
//            videocategorytableview.reloadData()
        }
    }
    var searchVideodata: [LiveStreamingResults] = []
    var searchVideodatafilter: [LiveStreamingResults] = []
    var indexPath : IndexPath?
    var cat:String?
    var id:String?
    var isLoadingData = false
    var count = 6
    var ip : String? {
        didSet {
            if ip != nil {
                self.getStreamingVideos(limit:30,page:self.count,categories: self.id == nil ? [] : [self.id ?? ""], city: ip ?? "")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotificationFromCartCell(notification:)), name: Notification.Name("updateview"), object: nil)
        let nib = UINib(nibName: "Live_videoCell1TableViewCell", bundle: nil)
         videocategorytableview.register(nib, forCellReuseIdentifier: "Live_videoCell1TableViewCell")
        let nib2 = UINib(nibName: "Live_videoCell1TableViewCel2", bundle: nil)
         videocategorytableview.register(nib2, forCellReuseIdentifier: "Live_videoCell1TableViewCel2")
       
        
        headerview.backgroundColor = UIColor(named: "headercolor")
        videocategorytableview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        searchFeild.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.method(notification:)), name: Notification.Name("idpass"), object: nil)
        searchFeild.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        searchFeild.returnKeyType = .search
        searchFeild.translatesAutoresizingMaskIntoConstraints = false
        searchFeild.delegate = self
        getStreamingVideos(limit:200,page:1,categories: [], city: "")

        getLiveStream()


    }
    
   
    func LanguageRender() {
        headerlbl.text = "livevideo".pLocalized(lang: LanguageManager.language)
        searchFeild.placeholder = "whatareyoulookingfor".pLocalized(lang: LanguageManager.language)
        categoriesLbl.text = "categories".pLocalized(lang: LanguageManager.language)
        nearByLbl.text = "nearby".pLocalized(lang: LanguageManager.language)
    }
    @objc func methodOfReceivedNotificationFromCartCell(notification: Notification) {
        if let data = notification.userInfo?["data"] as? LiveStreamingResults {
       print(data)
            
         
            if let targetId = data.resultID {
                if let index = LiveStreamingResultsdata.firstIndex(where: { $0.resultID == targetId }) {
                    print("Found at index: \(index)")
                    LiveStreamingResultsdata[index] = data
                    
                    self.videocategorytableview.reloadData()
                } else {
                    print("ID not found.")
                }
            } else {
                print("data.id is nil.")
            }
            }
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
           let currentText = textField.text ?? ""
        self.ip = nil
        if currentText == "" {
            searchVideo(name: "title", value:  "", limit: 100, catId: [], page: 1)
        }else {
            searchVideo(name: "title", value: searchFeild.text ?? "", limit: 100, catId: [], page: 1)
        }
        
    }
    
    @objc func method(notification: Notification) {
        if let id = notification.userInfo?["id"] as? String {
            print(id)
            self.id = id
            LiveStreamingResultsdata.removeAll()
            searchVideodata.removeAll()
            catbtnview.backgroundColor = UIColor(named: "greenColor")
            nearByView.backgroundColor = UIColor(named: "headercolor")
            self.ip = nil
            nearByBtn.tag = 0
            getStreamingVideos(limit:30,page:1,categories: [self.id ?? ""], city: "")

        }
        if let cat = notification.userInfo?["cat"] as? String {
            print(cat)
            self.cat = cat
        }
        if let catname = notification.userInfo?["catname"] as? String {
            headerlbl.text = catname
        }

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        cartCountShow = AppDefault.cartCount
        self.CategoriesResponsedata = AppDefault.CategoriesResponsedata ?? []
       
//        getLiveStream()
        LanguageRender()
    }
 

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func getStreamingVideos(limit:Int,page:Int,categories: [String],city:String){
        APIServices.getStreamingVideos(limit:limit,page:page,categories:categories,userId:"", city: city,completion: {[weak self] data in
            switch data{
            case .success(let res):
                self?.LiveStreamingResultsdata += res.results?.shuffled() ?? []
                self?.videocategorytableview.reloadData()
                self?.count += 1
                if res.results?.count ?? 0 > 0 {
                    self?.novideosview.isHidden = true
                }else {
                    if page < 2 {
                        self?.novideosview.isHidden = false
                    }
//                    self?.categoryview.isHidden = false
                }
                self?.isLoadingData = false

            case .failure(let error):
                print(error)
//                self?.view.makeToast(error)
            }
        })
    }
    
    func loadMoreData() {
            guard !isLoadingData else { return }
            isLoadingData = true
            
            // Simulate an async data fetch
            DispatchQueue.global().async {
                // Fetch your additional data here
                let moreItems = ["Item 4", "Item 5", "Item 6"] // Example data
                
                // Simulate a network delay
                sleep(2)
                
                DispatchQueue.main.async {
                    if self.cat == "cat" {
                        self.getStreamingVideos(limit:30,page:self.count,categories: [self.id ?? ""], city: "")
                    }else if self.ip != nil {
                        self.getStreamingVideos(limit:30,page:self.count,categories: [], city: self.ip ?? "")
                    }else {
                        self.getStreamingVideos(limit:30,page:self.count,categories: [], city: "")
                    }
                }
            }
        }
    
    
    
    private func searchVideo(name:String,value:String,limit:Int,catId:[String],page:Int){
        APIServices.searchVideo(name:name,value:value,limit:limit,catId: catId, page: page){[weak self] data in
            switch data{
            case .success(let res):
//                if res.results.count > 0 {
//                    self?.notFound.isHidden = true
//                }else {
//                    self?.notFound.isHidden = false
//                }
                self?.searchVideodata = res.results
                self?.count += 1
                if res.results.count > 5 {
                    self?.novideosview.isHidden = true
                    
                }else {
                    self?.novideosview.isHidden = false
//                    self?.categoryview.isHidden = false
                }
             //
                self?.videocategorytableview.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    private func getLiveStream(){
        APIServices.getLiveStream(completion: {[weak self] data in
            switch data{
            case .success(let res):
                
                self?.LiveVideoData = res
                if(self?.LiveVideoData.count != 0){
                    
                    AppDefault.socketId = self?.LiveVideoData[0].resultID ?? ""
                }
                self?.videocategorytableview.reloadData()
                
            case .failure(let error):
                print(error)
                self?.view.makeToast(error)
            }
        })
    }

    
    @IBAction func seachTap(_ sender: Any) {
        self.ip = nil
        if(searchFeild.text == ""){
            searchVideo(name: "title", value:  "", limit: 30, catId: [], page: 1)
        }
        else{
            searchVideo(name: "title", value: searchFeild.text ?? "", limit: 30, catId: [], page: 1)
        }
    }
    
    
    @IBAction func categoriesTap(_ sender: Any) {
        let vc = CategoriesPopUpVC.getVC(.popups)
        vc.modalPresentationStyle = .overFullScreen
        vc.id = self.id
        self.present(vc, animated: true, completion: nil)
//        nearByView.backgroundColor = UIColor(named: "headercolor")
//        catbtnview.backgroundColor = UIColor(named: "greenColor")
    }
    @IBAction func cartbutton(_ sender: Any) {
        if(AppDefault.accessToken != ""){
            let vc = CartViewController
                .getVC(.main)
            self.navigationController?.pushViewController(vc, animated: false)
        }else{
          
               let vc = PopupLoginVc.getVC(.popups)
               vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
       
    }
    @IBAction func nearByTap(_ sender: Any) {
        if nearByBtn.tag == 0 {
            LiveStreamingResultsdata.removeAll()
            searchVideodata.removeAll()
            count = 0
            nearByView.backgroundColor = UIColor(named: "greenColor")
            catbtnview.backgroundColor = UIColor(named: "headercolor")
//            self.id = nil
            Task {
                let ip = await Utility().getMyPublicIpAsync()
                        print("Your Public IP Address: \(ip)")
                        self.ip = ip
                }
        }else {
            LiveStreamingResultsdata.removeAll()
            searchVideodata.removeAll()
            count = 0
            if self.id == nil {
                nearByView.backgroundColor = UIColor(named: "headercolor")
                catbtnview.backgroundColor = UIColor(named: "headercolor")
            }else {
                catbtnview.backgroundColor = UIColor(named: "greenColor")
                nearByView.backgroundColor = UIColor(named: "headercolor")
            }
            getStreamingVideos(limit:30,page:1,categories: self.id == nil ? [] : [self.id ?? ""], city: "")
        }
        nearByBtn.tag = nearByBtn.tag == 0 ? 1 : 0
        self.videocategorytableview.reloadData()
    }
    
    
}
extension LIVE_videoNew:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchFeild.text == "" {
               if searchVideodata.isEmpty {
                   return Int(ceil(Double(LiveStreamingResultsdata.count) / 5.0))
               } else {
                   return Int(ceil(Double(searchVideodata.count) / 5.0))
               }
           } else {
               return Int(ceil(Double(searchVideodata.count) / 5.0))
           }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchVideodata.isEmpty {
            self.indexPath = indexPath
            LiveStreamingResultsdatafilter.removeAll()

            let isEvenRow = indexPath.row % 2 == 0
            let cellIdentifier = isEvenRow ? "Live_videoCell1TableViewCell" : "Live_videoCell1TableViewCel2"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

            if let cell = cell as? Live_videoCell1TableViewCell {
                cell.page = count
                cell.catId = self.id

                let startIndex = indexPath.row * 5
                if startIndex < LiveStreamingResultsdata.count {
                    let endIndex = min(startIndex + 5, LiveStreamingResultsdata.count)
                    for i in startIndex..<endIndex {
                        LiveStreamingResultsdatafilter.append(LiveStreamingResultsdata[i])
                    }
                }

                cell.btntap.tag = indexPath.row * 5
                cell.LiveStreamingResultsdata = LiveStreamingResultsdatafilter
                cell.navigationController = self.navigationController
                cell.views.frame = cell.views.frame.inset(by: .zero)
                cell.LiveStreamingResultsAlldata = LiveStreamingResultsdata

                if !LiveVideoData.isEmpty {
                    cell.LiveVideoData = LiveVideoData
                }

                return cell

            } else if let cell = cell as? Live_videoCell1TableViewCel2 {
                cell.page = count
                cell.catId = self.id

                let startIndex = indexPath.row * 5
                if startIndex < LiveStreamingResultsdata.count {
                    let endIndex = min(startIndex + 5, LiveStreamingResultsdata.count)
                    for i in startIndex..<endIndex {
                        LiveStreamingResultsdatafilter.append(LiveStreamingResultsdata[i])
                    }
                }

                cell.buttontap.tag = indexPath.row * 5
                cell.LiveStreamingResultsdata = LiveStreamingResultsdatafilter
                cell.navigationController = self.navigationController
                cell.views.frame = cell.views.frame.inset(by: .zero)
                cell.LiveStreamingResultsAlldata = LiveStreamingResultsdata

                return cell
            }

        } else {
            searchVideodatafilter.removeAll()

            let data = searchVideodata[indexPath.row]
            let isEvenRow = indexPath.row % 2 == 0
            let cellIdentifier = isEvenRow ? "Live_videoCell1TableViewCell" : "Live_videoCell1TableViewCel2"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

            let startIndex = indexPath.row * 5
            if startIndex < searchVideodata.count {
                let endIndex = min(startIndex + 5, searchVideodata.count)
                for i in startIndex..<endIndex {
                    searchVideodatafilter.append(searchVideodata[i])
                }
            }

            if let cell = cell as? Live_videoCell1TableViewCell {
                cell.page = count
                cell.catId = self.id
                cell.btntap.tag = indexPath.row * 5
                cell.LiveStreamingResultsdata = searchVideodatafilter
                cell.navigationController = self.navigationController
                cell.views.frame = cell.views.frame.inset(by: .zero)
                cell.LiveStreamingResultsAlldata = searchVideodata
                return cell

            } else if let cell = cell as? Live_videoCell1TableViewCel2 {
                cell.page = count
                cell.catId = self.id
                cell.buttontap.tag = indexPath.row * 5
                cell.LiveStreamingResultsdata = searchVideodatafilter
                cell.navigationController = self.navigationController
                cell.views.frame = cell.views.frame.inset(by: .zero)
                cell.LiveStreamingResultsAlldata = searchVideodata
                return cell
            }
        }

        // Fallback in case the cell type doesn't match expected
        return UITableViewCell()
    }

   
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - frameHeight * 2 {
            loadMoreData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
}

extension LIVE_videoNew: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Dismiss the keyboard
        textField.resignFirstResponder()
        self.ip = nil
        if searchFeild.text == "" {
            searchVideo(name: "title", value:  "", limit: 100, catId: [], page: 1)
        }else {
            searchVideo(name: "title", value: searchFeild.text ?? "", limit: 100, catId: [], page: 1)
        }
        
        return true
    }
}
