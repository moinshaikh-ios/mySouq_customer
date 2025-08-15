//
//  New_SingleVideoview.swift
//  Bazaar Ghar
//
//  Created by Umair Ali on 12/07/2024.
//


import UIKit
import AVFoundation
import AVKit
import SocketIO
import SwiftyJSON

class New_SingleVideoview: UIViewController {


    @IBOutlet weak var singlevideotable: UITableView!
    var showCollectionView = ""

    var LiveStreamingResultsdata: [LiveStreamingResults] = []
    var getvidoebyproductIdsdata: [Product] = []
    var  socketid = String()
    var productIds = [String]()
    var aboutToBecomeInvisibleCell = -1
    var avPlayerLayer: AVPlayerLayer!
    var videoURLs = Array<URL>()
    var firstLoad = true
    var visibleIP : IndexPath?
    var indexValue =  0
    var currentIndex: Int = 0
   
    var indexPath = IndexPath()
    
    var isLiked = false
    var page : Int? {
        didSet {
            print(page)
        }
    }
    var catId : String? {
        didSet {
            print(catId)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        singlevideotable.dataSource = self
        singlevideotable.delegate = self
        visibleIP = IndexPath.init(row: 0, section: 0)
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback,mode: .default,options: [])
            try AVAudioSession.sharedInstance().setActive(true)
            
        } catch {
            
        }

        currentIndex = self.indexValue
            DispatchQueue.main.async {
                self.scrollToRow(at: self.indexValue)
            }
        
        }
    
    func showShareSheet(id:String) {
        print(id)
        guard let url = URL(string: id) else { return }

        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)

        // On iPad, provide a sourceView and sourceRect to display the share sheet as a popover
        if let popoverPresentationController = activityViewController.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
//            popoverPresentationController.sourceRect = sender.frame
        }

        // Present the share sheet
        present(activityViewController, animated: true, completion: nil)
    }
    
    
  
    
 
    
 
    

    
    func getStreamingVideos(limit:Int,page:Int,categories: [String],city:String){
       APIServices.getStreamingVideos(limit:limit,page:page,categories:categories,userId:"", city: city,completion: {[weak self] data in
           switch data{
           case .success(let res):
              

               self?.LiveStreamingResultsdata += res.results ?? []
               if(res.results?.count == 0){
                   self?.page = 1
                   self?.LiveStreamingResultsdata += res.featured ?? []
               }
               self?.singlevideotable.reloadData()
//                self?.videocategorytableview.reloadData()
//                self?.count += 1
//                if res.results?.count ?? 0 > 5 {
//                    self?.novideosview.isHidden = true
//
//                }else {
//                    self?.novideosview.isHidden = false
////                    self?.categoryview.isHidden = false
//                }
               self?.page! += 1

           case .failure(let error):
               print(error)
//                self?.view.makeToast(error)
           }
       })
   }
    
    
    
}
extension New_SingleVideoview:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LiveStreamingResultsdata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.singlevideotable.dequeueReusableCell(withIdentifier: "SingleVideoCell") as! SingleVideoCell
        let data = LiveStreamingResultsdata[indexPath.row]
        cell.navigationController = self.navigationController
//        self.initializeSocket(scheduleId: data.resultID ?? "")
        cell.getLike(token: AppDefault.accessToken, scheduleId: data.resultID ?? "", userId: AppDefault.currentUser?.id ?? "", indexPath: indexPath)
        cell.LiveStreamingResultsdataArray = data
            if(indexPath.row == indexValue){
                self.playVideoOnTheCell(cell: cell, indexPath: indexPath)
            }
        
        cell.headerlbl.text = data.title
        cell.storename.text = data.brandName
        
        cell.updateMuteButtonImage()
        if data.brandLogo == nil {
            cell.storeimg.image = UIImage(named: "AppIcon")  // pLoadImage(url: data.thumbnail ?? "")
        }else {
            cell.storeimg.pLoadImage(url: data.brandLogo ?? "")
        }
//        cell.getvidoebyproductIdsdata = self.getvidoebyproductIdsdata
        cell.productIds = data.productsID ?? []
        cell.hiddenview.isHidden = true
        cell.buybtn.tag = indexPath.row
        cell.exclamationbtn.tag = indexPath.row
        
        cell.sharebtn.tag = indexPath.row
        self.indexPath = indexPath
        cell.storeId = data.userID ?? ""
        cell.backBtn.mk_addTapHandler { (btn) in
             print("You can use here also directly : \(indexPath.row)")
             self.backBtnTapped(btn: btn, indexPath: indexPath)
        }
        cell.sharebtn.addTarget(self, action: #selector(shareBtnTapped(_:)), for: .touchUpInside)

        cell.exclamationbtn.mk_addTapHandler { (btn) in
             print("You can use here also directly : \(indexPath.row)")
             self.exclamationbtnTapped(btn: btn, indexPath: indexPath)
        }
        cell.backBtn.mk_addTapHandler { (btn) in
             print("You can use here also directly : \(indexPath.row)")
             self.backBtnTapped(btn: btn, indexPath: indexPath)
        }
        cell.videoPlayBtn.mk_addTapHandler { (btn) in
             print("You can use here also directly : \(indexPath.row)")
             self.videoPlayBtnTapped(btn: btn, indexPath: indexPath)
        }
        cell.likebtn.mk_addTapHandler { (btn) in
             print("You can use here also directly : \(indexPath.row)")
            if AppDefault.islogin{
                self.likeBtnTapped(btn: btn, indexPath: indexPath)
            }else{
               
            
                  let vc = PopupLoginVc.getVC(.popups)
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true, completion: nil)
            }
             
        }
        cell.commentBtn.mk_addTapHandler { (btn) in
             print("You can use here also directly : \(indexPath.row)")
             self.commentBtnTapped(btn: btn, indexPath: indexPath)
        }
        cell.commentTFBtn.mk_addTapHandler { (btn) in
             print("You can use here also directly : \(indexPath.row)")
             self.commentBtnTapped(btn: btn, indexPath: indexPath)
        }
        cell.storeBtn.mk_addTapHandler { (btn) in
             print("You can use here also directly : \(indexPath.row)")
             self.storeBtnTapped(btn: btn, indexPath: indexPath)
        }
        cell.followbtn.mk_addTapHandler { (btn) in
             print("You can use here also directly : \(indexPath.row)")
             self.followBtnTapped(btn: btn, indexPath: indexPath)
        }
        cell.buybtn.mk_addTapHandler { (btn) in
             print("You can use here also directly : \(indexPath.row)")
             self.buyBtnTapped(btn: btn, indexPath: indexPath)
        }
        
        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeUpGesture.direction = .up
        cell.videoView.addGestureRecognizer(swipeUpGesture)

        // Create a swipe down gesture recognizer
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeDownGesture.direction = .down
        cell.videoView.addGestureRecognizer(swipeDownGesture)
        
        cell.hiddenview.isHidden = true

       
        return cell
    }
    
    func videoPlayBtnTapped(btn:UIButton, indexPath:IndexPath) {
        let cell = singlevideotable.cellForRow(at: indexPath) as! SingleVideoCell
        cell.paused ? cell.startPlayback() : cell.stopPlayback()
        cell.paused ? cell.videoPlayBtn.setBackgroundImage(UIImage(systemName: "play.circle.fill"), for: .normal) : cell.videoPlayBtn.setBackgroundImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        cell.videoPlayBtn.isHidden = false
        if cell.videoPlayBtn.isHidden == false {
            Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { Timer in
                cell.videoPlayBtn.isHidden = true
            }
        }
    }
    func likeBtnTapped(btn:UIButton, indexPath:IndexPath) {
        let cell = singlevideotable.cellForRow(at: indexPath) as! SingleVideoCell
        let data = LiveStreamingResultsdata[indexPath.row]
        cell.savelike(token: AppDefault.accessToken, scheduleId: data.resultID ?? "", userId:  AppDefault.currentUser?.id ?? "", indexPath: indexPath, id: data.resultID ?? "",likeId: cell.likeId)
                
    }
    
    
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .up {
            // Handle swipe up
            print("Swiped up!")
            
            if currentIndex == LiveStreamingResultsdata.count - 1{
                if(catId != nil){
                    getStreamingVideos(limit:30,page:page ?? 1,categories: [catId ?? ""], city: "")
                }else{
                    getStreamingVideos(limit:30,page:page ?? 1,categories: [], city: "")
                }
            }else {
                currentIndex += 1
            }

            scrollToRow(at: currentIndex)

        } else if gesture.direction == .down {
            // Handle swipe down
            if currentIndex == 0{
            }else {
                currentIndex = currentIndex - 1
            }
            print("Swiped down!")
            scrollToRow(at: currentIndex)

        }
    }
    
    
    func scrollToRow(at index: Int) {
         let indexPath = IndexPath(row: index, section: 0)
         singlevideotable.scrollToRow(at: indexPath, at: .top, animated: true)
     }

    func getvidoebyproductIds(productIds:[String]){
        APIServices.getvidoebyproductIds(productIds:productIds){[weak self] data in
            switch data{
            case .success(let res):
               //
                self?.getvidoebyproductIdsdata = res
                self?.showCollectionView = productIds.first!
//                self?.showCaseCollectionView.reloadData()
//                self?.isHideCollectionView.isHidden = false
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func backBtnTapped(btn:UIButton, indexPath:IndexPath) {
        let cell = singlevideotable.cellForRow(at: indexPath) as! SingleVideoCell
        cell.stopPlayback()
      
        navigationController?.popViewController(animated: false)
    }
    func exclamationbtnTapped(btn:UIButton, indexPath:IndexPath) {
        let data = LiveStreamingResultsdata[indexPath.row]
        let cell = singlevideotable.cellForRow(at: indexPath) as! SingleVideoCell
        cell.volumeview.isHidden = true
        cell.volumebtn.isHidden = true
        cell.exclamationview.isHidden = true
        cell.exclamationbtn.isHidden = true
        cell.expandbtn.isHidden = true
        cell.shareview.isHidden = true
        cell.sharebtn.isHidden = true
        cell.likeview.isHidden = true
        cell.likebtn.isHidden = true
        cell.expandview.isHidden = true
        cell.expandbtn.isHidden = true
        cell.followbtn.isHidden = true
        cell.storename.isHidden = true
        cell.storeimg.isHidden = true
        cell.headerlbl.isHidden = true
        cell.hiddenview.isHidden = true
        cell.buybtn.isHidden = true
        cell.likelbl.isHidden = true
        cell.storeImgView.isHidden = true
        cell.commentBtn.isHidden = true
        cell.commentTFBtn.isHidden = true
        cell.commentTFBtnView.isHidden = true

        let vc = ReportViewController()
        vc.videoId = data.resultID
        self.present(vc, animated: true, completion: nil)
    }
    
    func commentBtnTapped(btn:UIButton, indexPath:IndexPath) {
        let data = LiveStreamingResultsdata[indexPath.row]
        let cell = singlevideotable.cellForRow(at: indexPath) as! SingleVideoCell
        cell.volumeview.isHidden = true
        cell.volumebtn.isHidden = true
        cell.exclamationview.isHidden = true
        cell.exclamationbtn.isHidden = true
        cell.expandbtn.isHidden = true
        cell.shareview.isHidden = true
        cell.sharebtn.isHidden = true
        cell.likeview.isHidden = true
        cell.likebtn.isHidden = true
        cell.expandview.isHidden = true
        cell.expandbtn.isHidden = true
        cell.followbtn.isHidden = true
        cell.storename.isHidden = true
        cell.storeimg.isHidden = true
        cell.headerlbl.isHidden = true
        cell.hiddenview.isHidden = true
        cell.buybtn.isHidden = true
        cell.likelbl.isHidden = true
        cell.storeImgView.isHidden = true
        cell.commentBtn.isHidden = true
        cell.commentTFBtn.isHidden = true
        cell.commentTFBtnView.isHidden = true

        
        let vc = VideoCommentViewController.getVC(.videoStoryBoard)
        vc.scheduleId = data.resultID ?? ""
        self.present(vc, animated: true, completion: nil)
    }
    
    func storeBtnTapped(btn:UIButton, indexPath:IndexPath) {
        let cell = singlevideotable.cellForRow(at: indexPath) as? SingleVideoCell
        cell?.stopPlayback()
        let data =  LiveStreamingResultsdata[indexPath.row]
        let vc = New_StoreVC.getVC(.productStoryBoard)
        vc.prductid = data.userID     //productcategoriesdetailsdata?.sellerDetail?.seller ?? ""
//        vc.brandName =  data.brandName        //productcategoriesdetailsdata?.sellerDetail?.brandName ?? ""
//        vc.gallaryImages = data.        //productcategoriesdetailsdata?.gallery
        vc.storeId = data.userID ?? ""    //productcategoriesdetailsdata?.sellerDetail?.seller ?? ""
        vc.sellerID = data.userID ?? ""
        
        self.navigationController?.pushViewController(vc, animated: false)

    }
    
    func followBtnTapped(btn:UIButton, indexPath:IndexPath) {
        let cell = singlevideotable.cellForRow(at: indexPath) as? SingleVideoCell
        let data =  LiveStreamingResultsdata[indexPath.row]
        if(cell?.isFollow == true){
            cell?.unfollowStore(storeId: data.userID ?? "")
        }else{
            cell?.followStore(storeId: data.userID ?? "", web: true)
        }
    }
    
    func buyBtnTapped(btn:UIButton, indexPath:IndexPath) {
//        let cell = singlevideotable.cellForRow(at: indexPath) as? SingleVideoCell
//        cell?.buybtn.setTitle("Buy", for: .normal)
//
//        if cell?.getvidoebyproductIdsdata.count == 0 {
//            UIApplication.pTopViewController().view.makeToast("Showcase product data not found")
//        }else {
//            if cell?.hiddenview.isHidden == false {
//                cell?.hiddenview.isHidden = true
//                cell?.hiddenviewheight.constant = 0
//                cell?.buybtn.setTitle("Buy", for: .normal)
//            }else{
//                cell?.hiddenview.isHidden = false
//                cell?.hiddenviewheight.constant = 170
//                cell?.buybtn.setTitle("Close", for: .normal)
//
//            }
//        }
    }
    
    
//    @objc func volumebtnTapped(_ sender: UIButton) {
//        let selectedCell = singlevideotable.cellForRow(at: self.indexPath) as! SingleVideoCell
//           selectedCell.toggleMute()
//    }
   
    @objc func shareBtnTapped(_ sender: UIButton) {
        let data = LiveStreamingResultsdata[sender.tag]
        showShareSheet(id: AppConstants.API.videoShareURl.absoluteString + (data.slug ?? ""))
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SingleVideoCell
        cell.paused ? cell.videoPlayBtn.setBackgroundImage(UIImage(systemName: "play.circle.fill"), for: .normal) : cell.videoPlayBtn.setBackgroundImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        cell.videoPlayBtn.isHidden = false
        if cell.videoPlayBtn.isHidden == false {
            Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { Timer in
                cell.videoPlayBtn.isHidden = true
            }
        }


    }
    func playVideoOnTheCell(cell : SingleVideoCell, indexPath : IndexPath){
           cell.startPlayback()
       }

       func stopPlayBack(cell : SingleVideoCell, indexPath : IndexPath){
           cell.stopPlayback()
       }

       func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
           print("end = \(indexPath)")
           if let videoCell = cell as? SingleVideoCell {
               videoCell.stopPlayback()
           }
       }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
           let indexPaths = self.singlevideotable.indexPathsForVisibleRows
           var cells = [Any]()
           for ip in indexPaths!{
               if let videoCell = self.singlevideotable.cellForRow(at: ip) as? SingleVideoCell{
                   cells.append(videoCell)
               }
           }
           let cellCount = cells.count
           if cellCount == 0 {return}
           if cellCount == 1{
               if visibleIP != indexPaths?[0]{
                   visibleIP = indexPaths?[0]
               }
               if let videoCell = cells.last! as? SingleVideoCell{
                   self.playVideoOnTheCell(cell: videoCell, indexPath: (indexPaths?.last)!)
               }
           }
           if cellCount >= 2 {
               for i in 0..<cellCount{
                   let cellRect = self.singlevideotable.rectForRow(at: (indexPaths?[i])!)
                   let intersect = cellRect.intersection(self.singlevideotable.bounds)
   //                curerntHeight is the height of the cell that
   //                is visible
                   let currentHeight = intersect.height
                   print("\n \(currentHeight)")
                   let cellHeight = (cells[i] as AnyObject).frame.size.height
   //                0.95 here denotes how much you want the cell to display
   //                for it to mark itself as visible,
   //                .95 denotes 95 percent,
   //                you can change the values accordingly
                   if currentHeight > (cellHeight * 0.95){
                       if visibleIP != indexPaths?[i]{
                           visibleIP = indexPaths?[i]
                           print ("visible = \(indexPaths?[i])")
                           if let videoCell = cells[i] as? SingleVideoCell{
                               self.playVideoOnTheCell(cell: videoCell, indexPath: (indexPaths?[i])!)
                           }
                       }
                   }
                   else{
                       if aboutToBecomeInvisibleCell != indexPaths?[i].row{
                           aboutToBecomeInvisibleCell = (indexPaths?[i].row)!
                           if let videoCell = cells[i] as? SingleVideoCell{
                               self.stopPlayBack(cell: videoCell, indexPath: (indexPaths?[i])!)
                           }

                       }
                   }
               }
           }
       }
 }



   
