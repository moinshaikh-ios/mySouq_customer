//
//  Live_VC.swift
//  Bazaar Ghar
//
//  Created by Umair ALi on 25/09/2023.
//

import UIKit
import AudioToolbox


class Live_VC: UIViewController {
    @IBOutlet weak var livetableview: UITableView!
    @IBOutlet weak var livecategorycollection: UICollectionView!
    @IBOutlet weak var headerlbl: UILabel!
    @IBOutlet weak var videoCollection: UICollectionView!
    @IBOutlet weak var liveVideoCiollectionView: UICollectionView!

    @IBOutlet weak var switchchange: UISwitch!
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    @IBOutlet weak var liveView: UIView!
    @IBOutlet weak var stackHeight: NSLayoutConstraint!

    var MainCategory = String()
    
    var LiveStreamingResultsdata: [LiveStreamingResults] = []
    var LiveVideoData: [LiveStreamingResults] = []

    var customCateogry: [CategoriesResponse]  = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.becomeFirstResponder()
        livecategorycollection.dataSource = self
        livecategorycollection.delegate = self
        livetableview.dataSource = self
        livetableview.delegate = self
        // Do any additional setup after loading the
        // Do any additional setup after loading the view.
        switchchange.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        
        scrollViewHeight.constant = CGFloat(((AppDefault.CategoriesResponsedata?.count ?? 0) + 1) * 400)
        
        self.headerlbl.text = "My Souq Trending"
        
    

    }
    
    override func viewWillAppear(_ animated: Bool) {
        switchchange.isOn = true
        getStreamingVideos(limit:20,page:1,categories: [])
        getLiveStream()

    }
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func getStreamingVideos(limit:Int,page:Int,categories: [String]){
        APIServices.getStreamingVideos(limit:limit,page:page,categories:categories,userId:"", city: "",completion: {[weak self] data in
            switch data{
            case .success(let res):
               //

                self?.LiveStreamingResultsdata = res.results ?? []
                self?.customCateogry = AppDefault.CategoriesResponsedata ?? []
                self?.videoCollection.reloadData()
                self?.liveVideoCiollectionView.reloadData()
                self?.livetableview.reloadData()
            case .failure(let error):
                print(error)
                self?.view.makeToast(error)
            }
        })
    }
    
    
    private func getLiveStream(){
        APIServices.getLiveStream(completion: {[weak self] data in
            switch data{
            case .success(let res):
               //

                self?.LiveVideoData = res
                
                if res.count > 0 {
                    self?.liveView.isHidden = false
                    self?.stackHeight.constant = 800
                    self?.scrollViewHeight.constant = CGFloat(((AppDefault.CategoriesResponsedata?.count ?? 0) + 2) * 400)

                }else {
                    self?.stackHeight.constant = 400
                    self?.liveView.isHidden = true
                    self?.scrollViewHeight.constant = CGFloat(((AppDefault.CategoriesResponsedata?.count ?? 0) + 1) * 400)

                }
                self?.liveVideoCiollectionView.reloadData()
                
            case .failure(let error):
                print(error)
                self?.view.makeToast(error)
            }
        })
    }
    
    @IBAction func switchChanged(_ sender: UISwitch) {
           if sender.isOn == false {
               AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
               Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(hideView), userInfo: nil, repeats: false)
           }
       }
    @objc func hideView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func bazaarGharImgBtnTapped(_ sender: Any) {
        
        navigationController?.popViewController(animated: false)
    }
    @IBAction func searchTapped(_ sender: Any) {
        
        let vc = Search_ViewController.getVC(.searchStoryBoard)
        self.navigationController?.pushViewController(vc, animated: false)
    }

}

extension Live_VC:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.customCateogry.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableCell", for: indexPath) as! CategoryTableCell
      let data = self.customCateogry[indexPath.row]
        cell.headerlbl.text = data.name ?? ""
//        cell.LiveStreamingResultsdata = self.LiveStreamingResultsdata
        cell.id = data.id ?? ""
        cell.navigationController = self.navigationController
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 400
        
    }
    
}

    extension Live_VC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if collectionView == videoCollection {
                return LiveStreamingResultsdata.count
            }else if collectionView == liveVideoCiollectionView{
                return LiveVideoData.count
            }else {
                return AppDefault.CategoriesResponsedata?.count ?? 0
            }
        }
        
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if collectionView == videoCollection {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Videoscategorycell1", for: indexPath) as! Videoscategorycell
                let data = LiveStreamingResultsdata[indexPath.row]
                cell.productimage.pLoadImage(url: data.thumbnail ?? "")
                cell.viewslbl.text = "\(data.totalViews ?? 0)"
                cell.Productname.text = data.brandName
                cell.likeslbl.text = "\(data.like ?? 0)"
                    return cell
            }else if collectionView == liveVideoCiollectionView {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Videoscategorycell2", for: indexPath) as! Videoscategorycell
                let data = LiveVideoData[indexPath.row]
                cell.productimage.pLoadImage(url: data.thumbnail ?? "")
                cell.viewslbl.text = "\(data.totalViews ?? 0)"
                cell.Productname.text = data.brandName
                cell.likeslbl.text = "\(data.like ?? 0)"
                    return cell
            }else {
                }
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiveCategory_Cell", for: indexPath) as! LiveCategory_Cell
                    let data = AppDefault.CategoriesResponsedata?[indexPath.row]
                    cell.imageView.pLoadImage(url: data?.mainImage ?? "")
                    cell.livecategorylbl.text = data?.name ?? ""
                    return cell
                }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            if collectionView == videoCollection {
                return CGSize(width: collectionView.frame.size.width/1.7, height: collectionView.frame.size.height)
            }else if collectionView == liveVideoCiollectionView {
                return CGSize(width: collectionView.frame.size.width/1.7, height: collectionView.frame.size.height)
            }else {
                return CGSize(width: collectionView.frame.size.width/4-10, height: collectionView.frame.size.height)
                
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            
            UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if collectionView == videoCollection {
                let data = LiveStreamingResultsdata[indexPath.row]
                let vc = New_SingleVideoview.getVC(.videoStoryBoard)
                vc.LiveStreamingResultsdata = self.LiveStreamingResultsdata
                vc.indexValue = indexPath.row
                vc.page = 2
                self.navigationController?.pushViewController(vc, animated: false)
            }else if collectionView == liveVideoCiollectionView {
                let data = LiveVideoData[indexPath.row]
                print(data)
            }else{
//                let data = LiveStreamingResultsdata[indexPath.row]
//
//                let vc = SingleVideoView.getVC(.main)
//                vc.LiveStreamingResultsdata = self.LiveStreamingResultsdata
//                vc.indexValue = indexPath.row
//                self.navigationController?.pushViewController(vc, animated: false)
            }
         }
        
    }

               
     
        



