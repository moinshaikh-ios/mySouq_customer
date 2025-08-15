//
//  Live_videoCell1TableViewCell.swift
//  Bazaar Ghar
//
//  Created by Developer on 14/06/2024.
//

import UIKit

class Live_videoCell1TableViewCell: UITableViewCell {

    @IBOutlet weak var btntap: UIButton!
    @IBOutlet weak var imageofcell: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subttitle: UILabel!
    @IBOutlet weak var views: UILabel!
    weak var navigationController: UINavigationController?
    @IBOutlet weak var videocategoryCollectionView: UICollectionView!
    
   
    var LiveStreamingResultsdata: [LiveStreamingResults] = []{
        didSet{
            self.imageofcell.pLoadImage(url: LiveStreamingResultsdata.first?.thumbnail ?? "")
            self.title.text =  LiveStreamingResultsdata.first?.brandName ?? ""
            self.subttitle.text =  LiveStreamingResultsdata.first?.brandName ?? ""
            self.views.text =  "\(LiveStreamingResultsdata.first?.totalViews ?? 0)" + " views"
            self.videocategoryCollectionView.reloadData()
        }
    }
    var LiveStreamingResultsAlldata: [LiveStreamingResults] = []
    var id : String? {
        didSet{
//            getStreamingVideos(limit:20,page:1,categories: [id ?? ""])
        }
    } 
    var LiveVideoData: [LiveStreamingResults] = []{
        didSet{
            self.imageofcell.pLoadImage(url: LiveVideoData.first?.thumbnail ?? "")
            self.title.text =  LiveVideoData.first?.brandName ?? ""
            self.subttitle.text =  LiveVideoData.first?.brandName ?? ""
            self.views.text =  "\(LiveVideoData.first?.totalViews ?? 0)" + " views"
            self.videocategoryCollectionView.reloadData()
        }
    }
    var page = 1
    var catId : String?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let nib = UINib(nibName: "Live_videoCell1", bundle: nil)
        videocategoryCollectionView.register(nib, forCellWithReuseIdentifier: "Live_videoCell1")

    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnTapped(_ sender: UIButton) {
        let vc = New_SingleVideoview.getVC(.videoStoryBoard)
        if LiveVideoData.count > 0 {
            vc.LiveStreamingResultsdata = self.LiveVideoData
        }else {
            vc.LiveStreamingResultsdata = self.LiveStreamingResultsAlldata
            videoCountAPI(isbackground: false, slug: LiveStreamingResultsAlldata[sender.tag].slug ?? "")
        }
        vc.indexValue = sender.tag
        vc.page = self.page
        vc.catId = self.catId
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    private func videoCountAPI(isbackground:Bool,slug:String) {
        APIServices.videoCountApi(slug: slug,completion: {[weak self] data in
            switch data {
            case .success(let res):
                print(res)
                
                let viewData:[String: Any] = ["data": res]
                NotificationCenter.default.post(name: Notification.Name("updateview"), object: nil,userInfo: viewData)
             
                
                self?.videocategoryCollectionView.reloadData()
            case .failure(let error):
                print(error)
//                self?.view.makeToast(error)
            }
        })
    }
    
//    private func getStreamingVideos(limit:Int,page:Int,categories: [String]){
//        APIServices.getStreamingVideos(limit:limit,page:page,categories:categories,userId:"", city: "",completion: {[weak self] data in
//            switch data{
//            case .success(let res):
//               //
//        
//                self?.LiveStreamingResultsdata = res.results ?? []
//       
//
//            case .failure(let error):
//                print(error)
////                self?.view.makeToast(error)
//            }
//        })
//    }
    
}

extension Live_videoCell1TableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  LiveStreamingResultsdata.count - 1

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = LiveStreamingResultsdata[indexPath.row + 1]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Live_videoCell1", for: indexPath) as! Live_videoCell1
       
        cell.productimg.pLoadImage(url: data.thumbnail ?? "")
        cell.videoimg.pLoadImage(url: data.thumbnail ?? "")
        cell.viewslbl.text = "\(data.totalViews ?? 0)" + " views"
//        cell.Productname.text = data.brandName
//        cell.likeslbl.text = "\(data.like ?? 0)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
   
      
        return CGSize(width: self.videocategoryCollectionView.frame.width/2.05, height: self.videocategoryCollectionView.frame.height/2.02)
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        let data = btntap.tag + 1 + indexPath.row
        videoCountAPI(isbackground: false, slug: LiveStreamingResultsAlldata[data].slug ?? "")

        let vc = New_SingleVideoview.getVC(.videoStoryBoard)
            vc.LiveStreamingResultsdata = self.LiveStreamingResultsAlldata
            vc.indexValue = data
        vc.page = self.page
        vc.catId = self.catId
            self.navigationController?.pushViewController(vc, animated: false)

//                let data = LiveStreamingResultsdata[indexPath.row]
//
//                let vc = SingleVideoView.getVC(.main)
//                vc.LiveStreamingResultsdata = self.LiveStreamingResultsdata
//                vc.indexValue = indexPath.row
//                self.navigationController?.pushViewController(vc, animated: false)
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
         return UIEdgeInsets.zero // No insets
     }
     
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         return 5 // No spacing between lines
     }
     
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
         return 1 // No spacing between items
     }
    
}
