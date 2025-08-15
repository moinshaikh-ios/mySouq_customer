//
//  SingleVideoCell.swift
//  Bazaar Ghar
//
//  Created by Umair ALi on 27/09/2023.
//

import UIKit
import AVFoundation
import AVKit
import Presentr
import SocketIO
import SwiftyJSON

class SingleVideoCell: UITableViewCell {
    @IBOutlet weak var shoowcaseheight: NSLayoutConstraint!

    @IBOutlet weak var showCaseCollectionView: UICollectionView!
    @IBOutlet weak var isHideCollectionView: UIView!
    @IBOutlet weak var likelbl: UILabel!
    @IBOutlet weak var likeview: UIView!
    @IBOutlet weak var shareview: UIView!
    @IBOutlet weak var exclamationview: UIView!
    @IBOutlet weak var volumeview: UIView!
    var showCollectionView = ""
    @IBOutlet weak var expandview: UIView!
    
    
    var manager:SocketManager?
    var socket: SocketIOClient?
    @IBOutlet weak var headerlbl: UILabel!
    @IBOutlet weak var storename: UILabel!
    @IBOutlet weak var saysomethingfield: UITextField!
    @IBOutlet weak var buybtn: UIButton!
    @IBOutlet weak var messagebtn: UIButton!
    @IBOutlet weak var likebtn: UIButton!
    @IBOutlet weak var sharebtn: UIButton!
    @IBOutlet weak var exclamationbtn: UIButton!
    @IBOutlet weak var volumebtn: UIButton!
    @IBOutlet weak var hiddenview: UIView!
 
    @IBOutlet weak var followbtn: UIButton!
    @IBOutlet weak var expandbtn: UIButton!
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var videoProductCollectionV: UICollectionView!
    @IBOutlet weak var videoPlayBtn: UIButton!
    @IBOutlet weak var hiddenviewheight: NSLayoutConstraint!
    @IBOutlet weak var topViewHeigth: NSLayoutConstraint!
    @IBOutlet weak var dropDownBtn: UIButton!

    @IBOutlet weak var storeimg: UIImageView!
    
    @IBOutlet weak var viewslbl: UILabel!
    @IBOutlet weak var storeImgView: UIView!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var storeBtn: UIButton!
    @IBOutlet weak var commentTFBtn: UIButton!
    @IBOutlet weak var commentTFBtnView: UIView!

    @IBOutlet weak var progressView: UIProgressView!
    
    let centerTransitioningDelegate = CenterTransitioningDelegate()
    var randomproductapiModel: [PChat] = []

    var avPlayer: AVPlayer?
    var avPlayerLayer: AVPlayerLayer?
    var paused: Bool = false
    var observer: Any? = nil
    let interval = CMTime(seconds: 1.0, preferredTimescale: 10)
    var LiveStreamingResultsdataArray: LiveStreamingResults? = nil{
        didSet{
            if LiveStreamingResultsdataArray?.hls == nil {
                let fileUrl = URL(string: LiveStreamingResultsdataArray?.streamingURL ?? "")
                if let url = fileUrl {
                    self.videoPlayerItem = AVPlayerItem.init(url:url)
                }
                
            }
            else {
                let fileUrl = URL(string: LiveStreamingResultsdataArray?.hls ?? "")
                self.videoPlayerItem = AVPlayerItem.init(url:fileUrl!)
            }
 
    
            
            self.headerlbl.text = LanguageManager.language == "ar" ? LiveStreamingResultsdataArray?.lang?.ar?.title : LiveStreamingResultsdataArray?.title
            self.storename.text = LiveStreamingResultsdataArray?.brandName
            self.storename.text = LanguageManager.language == "ar" ? LiveStreamingResultsdataArray?.lang?.ar?.brandName : LiveStreamingResultsdataArray?.brandName
            buybtn.setTitle("buy".pLocalized(lang: LanguageManager.language), for: .normal)
            hiddenview.isHidden = true
            likelbl.text = "\(LiveStreamingResultsdataArray?.like ?? 0)"
        }
    }
    var videoPlayerItem: AVPlayerItem? = nil {
          didSet {
              if let videoPlayerItem = videoPlayerItem {
//                  videoPlayerItem.preferredForwardBufferDuration = 4  // Buffer 10 seconds ahead for faster start
//                                  videoPlayerItem.canUseNetworkResourcesForLiveStreamingWhilePaused = true
//                                  videoPlayerItem.preferredPeakBitRate = 500
//                  s for smoother playback
                  self.videoPlayerItem?.preferredForwardBufferDuration = 1
                  self.videoPlayerItem?.preferredPeakBitRate = 80000
                  avPlayer?.replaceCurrentItem(with: videoPlayerItem)
              }
          }
      }

    
    var getvidoebyproductIdsdata: [Product] = []
    var productIds = [String](){
        didSet {
//            getvidoebyproductIds(productIds: productIds)
        }
    }
    
    weak var navigationController: UINavigationController?
    
    var isliked: Bool? {
        didSet{
            isliked ?? false ? likebtn.setBackgroundImage(UIImage(named: "like_fill" ), for: .normal) : likebtn.setBackgroundImage(UIImage(named: "likethumb" ), for: .normal)
        }
    }
    var isFollow : Bool? {
        didSet {
            if isFollow == true {
                self.followbtn.setTitle("followed".pLocalized(lang: LanguageManager.language), for: .normal)
            }else {
                self.followbtn.setTitle("follow".pLocalized(lang: LanguageManager.language), for: .normal)
            }
        }
    }
    var storeId:String?{
        didSet {
            followcheck(storeId: storeId ?? "")
        }
    }
//    var progressView: UIProgressView!
    var likeId = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        hiddenviewheight.constant = 0
        self.setupMoviePlayer()
        saysomethingfield.attributedPlaceholder = NSAttributedString(
                  string: "Say something...",
                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
              )
        NotificationCenter.default.addObserver(self, selector: #selector(hideandshow), name: NSNotification.Name(rawValue: "showviews"), object: nil)
        isHideCollectionView.isHidden = true
        
        SocketConnect(socketId: AppDefault.socketId)
        // Add Slider
               progressView.trackTintColor = UIColor.lightGray
               progressView.progressTintColor = UIColor.white
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(progressViewTapped(_:)))
            progressView.addGestureRecognizer(tapGestureRecognizer)
               // Add periodic time observer to update slider
        setupProgressTimer()

       }
    @objc private func progressViewTapped(_ sender: UITapGestureRecognizer) {
        let touchPoint = sender.location(in: progressView)
        let percentage = touchPoint.x / progressView.bounds.width
        guard let duration = avPlayer?.currentItem?.duration.seconds else { return }
        
        // Calculate the new time based on touch percentage
        let newTime = Double(percentage) * duration
        let seekTime = CMTime(seconds: newTime, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        
        avPlayer?.seek(to: seekTime, completionHandler: { [weak self] finished in
            if finished {
                // Optionally update progress after seeking
                self?.updateProgress()
            }
        })
    }
    private func setupProgressTimer() {
         Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true, block: { [weak self] (completion) in
            guard let self = self else { return }
            self.updateProgress()
        })
    }

    //update progression of video, based on it's own data

    private func updateProgress() {
        guard let duration = avPlayer?.currentItem?.duration.seconds,
            let currentMoment = avPlayer?.currentItem?.currentTime().seconds else { return }

        progressView.progress = Float(currentMoment / duration)
    }
    
     func unfollowStore(storeId:String){
        APIServices.unfollowstore(storeId: storeId){[weak self] data in
            switch data{
            case .success(let res):
                if(res == "OK"){
                    self?.followbtn.setTitle("follow".pLocalized(lang: LanguageManager.language), for: .normal)
                    self?.isFollow = false
                }
             
            case .failure(let error):
                print(error)
                
                if(error == "Please authenticate" && AppDefault.islogin){
                    DispatchQueue.main.async {
                        appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                          let vc = PopupLoginVc.getVC(.popups)
                        vc.modalPresentationStyle = .overFullScreen
                        UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
                    }
                }else if(error == "Please authenticate" && AppDefault.islogin == false){
                      let vc = PopupLoginVc.getVC(.popups)
                    vc.modalPresentationStyle = .overFullScreen
                    UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
//                    appDelegate.GotoDashBoard(ischecklogin: true)
                }
                else{
//                    if self?.varientSlug != nil {
//                        print(error)
//                        self?.view.makeToast(error)
//                    }else {
//                        self?.view.makeToast("Please Select Varient")
//                    }
                }
            }
        }
    }
    
     func followStore(storeId:String,web:Bool){
        APIServices.followStore(storeId: storeId, web: web){[weak self] data in
            switch data{
            case .success(let res):
                self?.followbtn.setTitle("followed".pLocalized(lang: LanguageManager.language), for: .normal)
                self?.isFollow = true
             //
            case .failure(let error):
                print(error)
                
                if(error == "Please authenticate" && AppDefault.islogin){
                    DispatchQueue.main.async {
                        appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                          let vc = PopupLoginVc.getVC(.popups)
                        vc.modalPresentationStyle = .overFullScreen
                        UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
                    }
                }else if(error == "Please authenticate" && AppDefault.islogin == false){
                      let vc = PopupLoginVc.getVC(.popups)
                    vc.modalPresentationStyle = .overFullScreen
                    UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
//                    appDelegate.GotoDashBoard(ischecklogin: true)
                }
                else{
//                    if self?.varientSlug != nil {
//                        print(error)
//                        self?.view.makeToast(error)
//                    }else {
//                        self?.view.makeToast("Please Select Varient")
//                    }
                }            }
        }
    }
    
    private func followcheck(storeId:String){
        APIServices.followcheck(storeId: storeId){[weak self] data in
            switch data{
            case .success(let res):
                if(res == "OK"){
                    self?.isFollow = true
                }else{
                    self?.isFollow = false
                }
            case .failure(let error):
                print(error)
                self?.isFollow = false

                if(error == "Please authenticate" && AppDefault.islogin){
                    DispatchQueue.main.async {
                        appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
//                          let vc = PopupLoginVc.getVC(.popups)
//                        vc.modalPresentationStyle = .overFullScreen
//                        self?.present(vc, animated: true, completion: nil)
                    }
                }else if(error == "Please authenticate" && AppDefault.islogin == false){
//                      let vc = PopupLoginVc.getVC(.popups)
//                    vc.modalPresentationStyle = .overFullScreen
//                    self?.present(vc, animated: true, completion: nil)
//                    appDelegate.GotoDashBoard(ischecklogin: true)
                }
                else{
//                    if self?.varientSlug != nil {
//                        print(error)
//                        self?.view.makeToast(error)
//                    }else {
//                        self?.view.makeToast("Please Select Varient")
//                    }
                }
            }
        }
    }
    
    func getLike(token:String,scheduleId:String,userId:String,indexPath:IndexPath){
       APIServices.getLike(scheduleId: scheduleId, userId: userId){[weak self] data in
           switch data{
           case .success(let res):
               self?.isliked = true
               self?.likeId = res.id ?? ""
           case .failure(let error):
               self?.isliked = false
               self?.likeId =  ""
               if error == "Please authenticate" {
                   if AppDefault.islogin{
                   }else{
//                       DispatchQueue.main.async {
//                          self.selectedIndex = 0
//                       }
                    
                   }
               }
           }
       }
   }
    
    func savelike(token:String,scheduleId:String,userId:String,indexPath:IndexPath,id:String, likeId: String){
       APIServices.savelike(token: token, scheduleId: scheduleId, userId: userId){[weak self] data in
           switch data{
           case .success(let res):
               if res.deleteLike == true {
                   self?.isliked = false
               }else {
                   self?.isliked = true
               }
               self?.likeId = res.id ?? ""
               self?.likelbl.text = "\(res.likeCount ?? 0)"
           case .failure(let error):
               UIApplication.pTopViewController().view.makeToast(error)
               if error == "Please authenticate" {
                   if AppDefault.islogin{
                       
                   }else{
//                       DispatchQueue.main.async {
//                          self.selectedIndex = 0
//                       }
//                         let vc = PopupLoginVc.getVC(.popups)
//                       vc.modalPresentationStyle = .overFullScreen
//                       self?.present(vc, animated: true, completion: nil)
                   }
               }
           }
       }
   }
    
//    func deletelike(token:String,scheduleId:String,userId:String,likeId:String,indexPath:IndexPath,id:String){
//       APIServices.deletelike(token: token, scheduleId: scheduleId, userId: userId, likeId: likeId){[weak self] data in
//           switch data{
//           case .success(let res):
//               self?.isliked = false
//               self?.likeId = ""
//               self?.likelbl.text = "\(res.likeCount ?? 0)"
//           case .failure(let error):
//               UIApplication.pTopViewController().view.makeToast(error)
//               if error == "Please authenticate" {
//                   if AppDefault.islogin{
//                       
//                   }else{
////                       DispatchQueue.main.async {
////                          self.selectedIndex = 0
////                       }
////                         let vc = PopupLoginVc.getVC(.popups)
////                       vc.modalPresentationStyle = .overFullScreen
////                       self?.present(vc, animated: true, completion: nil)
//                   }
//               }
//           }
//       }
//   }
    
    
    
    @objc func hideandshow(notification: Notification) {
         volumeview.isHidden = false
         volumebtn.isHidden = false
         exclamationview.isHidden = false
         exclamationbtn.isHidden = false
         expandbtn.isHidden = false
         shareview.isHidden = false
         sharebtn.isHidden = false
         likeview.isHidden = false
         likebtn.isHidden = false
         expandview.isHidden = false
         expandbtn.isHidden = false
         followbtn.isHidden = false
         storename.isHidden = false
         storeimg.isHidden = false
         headerlbl.isHidden = false
         hiddenview.isHidden = false
         buybtn.isHidden = false
         likelbl.isHidden = false
         storeImgView.isHidden = false
          commentBtn.isHidden = false
        commentTFBtn.isHidden = false
        commentTFBtnView.isHidden = false


    }

    
    func setupMoviePlayer() {
        self.avPlayer = AVPlayer.init(playerItem: self.videoPlayerItem)
                   avPlayerLayer = AVPlayerLayer(player: avPlayer)
                   avPlayerLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
                   avPlayer?.volume = 3
                   avPlayer?.actionAtItemEnd = .none

                   //        You need to have different variations
                   //        according to the device so as the avplayer fits well
               
                   avPlayerLayer?.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                  
         
                   avPlayerLayer?.videoGravity = .resizeAspect
                   
                   
                   self.backgroundColor = .clear
                   self.videoView.layer.insertSublayer(avPlayerLayer!, at: 0)
        // Initialize the player with the player item
//        self.avPlayer = AVPlayer.init(playerItem: self.videoPlayerItem)
//                  avPlayerLayer = AVPlayerLayer(player: avPlayer)
//                  avPlayerLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
//                  avPlayer?.volume = 3
//                  avPlayer?.actionAtItemEnd = .none
//
//                  //        You need to have different variations
//                  //        according to the device so as the avplayer fits well
//              
//                      avPlayerLayer?.frame = CGRect.init(x: 0, y: 0, width: self.videoView.frame.width, height: self.videoView.frame.height)
//                 
//                  self.backgroundColor = .clear
//                  self.videoView.layer.insertSublayer(avPlayerLayer!, at: 0)

        // Add observer to handle video end
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.playerItemDidReachEnd(notification:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: avPlayer?.currentItem)
    }

    
    func getvidoebyproductIds(productIds:[String]){
       APIServices.getvidoebyproductIds(productIds:productIds){[weak self] data in
           switch data{
           case .success(let res):
               self?.getvidoebyproductIdsdata = res
               self?.showCollectionView = productIds.first!
               
               self?.buybtn.setTitle("buy".pLocalized(lang: LanguageManager.language), for: .normal)

               if  res.count < 1 {
                   UIApplication.pTopViewController().view.makeToast("Showcase product data not found")
               }else {
                   if self?.hiddenview.isHidden == false {
                       self?.hiddenview.isHidden = true
                       self?.hiddenviewheight.constant = 0
                       self?.buybtn.setTitle("buy".pLocalized(lang: LanguageManager.language), for: .normal)
                   }else{
                       self?.hiddenview.isHidden = false
                       self?.hiddenviewheight.constant = 170
                       self?.buybtn.setTitle("close".pLocalized(lang: LanguageManager.language), for: .normal)

                   }
               }
               
               
               self?.showCaseCollectionView.reloadData()
              self?.videoProductCollectionV.reloadData()
           case .failure(let error):
               if productIds == [] {
                   UIApplication.pTopViewController().view.makeToast("Showcase product data not found")
               }
               print(error)
           }
       }
   }

       func stopPlayback(){
           self.avPlayer?.pause()
           removeObserver()
           paused = true
       }

       func startPlayback(){
//           self.addObserver()
           self.avPlayer?.play()
           paused = false
       }

       // A notification is fired and seeker is sent to the beginning to loop the video again
    @objc func playerItemDidReachEnd(notification: Notification) {
           let p: AVPlayerItem = notification.object as! AVPlayerItem
        p.seek(to: CMTime.zero)
       }
    
    
    func removeObserver() {
        if let observer = self.observer {
            avPlayer?.removeTimeObserver(observer)
            self.observer = nil
        }
    }
    
    func addObserver() {
        let intervel : CMTime = CMTimeMake(value: 10, timescale: 10)
        observer = avPlayer?.addPeriodicTimeObserver(forInterval: intervel, queue: DispatchQueue.main) { [weak self] time in

            guard let `self` = self,
                let playerItem = self.avPlayer?.currentItem else { return }

            let currentTime : Float64 = CMTimeGetSeconds(time)
            let totalDuration = CMTimeGetSeconds(playerItem.asset.duration)

            //this is the slider value update if you are using UISlider.
            let sliderValue = (currentTime/totalDuration)

            if currentTime >= totalDuration {
                if let observer = self.observer{
                    //removing time observer
                    self.avPlayer?.removeTimeObserver(observer)
                    self.observer = nil
                }
            }

            let playbackLikelyToKeepUp = self.avPlayer?.currentItem?.isPlaybackLikelyToKeepUp
            if playbackLikelyToKeepUp == false{
                print(self.avPlayer?.rate)
                UIApplication.startActivityIndicator()
            } else {
                //stop the activity indicator
                UIApplication.stopActivityIndicator()
            }
        }
    }
    func toggleMute() {
        if let player = avPlayer {
            player.isMuted = !player.isMuted
            updateMuteButtonImage()
        }
    }
    func updateMuteButtonImage() {
        if let player = avPlayer {
            let image = player.isMuted ? UIImage(named: "muteIcon") : UIImage(named: "speakerOn")
            volumebtn.setImage(image, for: .normal)
        }
    }

    @IBAction func buybtnTapped(_ sender: UIButton) {
        getvidoebyproductIds(productIds: productIds)
    }
    
    @IBAction func volumebtnTapped(_ sender: UIButton) {
        toggleMute()
    }
    @IBAction func dropDownBtnTapped(_ sender: UIButton) {
       
        if topViewHeigth.constant == 130 {
            topViewHeigth.constant = 35
            headerlbl.isHidden = true
            storename.isHidden = true
            dropDownBtn.setImage(UIImage(named: "dropdownselect"), for: .normal)

        }else {
            topViewHeigth.constant = 130
            headerlbl.isHidden = false
            storename.isHidden = false
            dropDownBtn.setImage(UIImage(named: "dropdownunselect"), for: .normal)

        }
    }
}
   


extension SingleVideoCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == showCaseCollectionView){
          return  getvidoebyproductIdsdata.count
        }else{
            return getvidoebyproductIdsdata.count
        }
     
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == showCaseCollectionView){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videoCallollectionViewCell", for: indexPath) as! videoCallollectionViewCell
            let data = getvidoebyproductIdsdata[indexPath.row]
            
            cell.img.pLoadImage(url: data.mainImage ?? "")
            cell.productname.text = data.productName
//            cell.aboutproduct.text = data.description
            
            cell.price.text = "NOW " + appDelegate.currencylabel + Utility().formatNumberWithCommas(data.price ?? 0, label: cell.price)//appDelegate.currencylabel + " \(data.price ?? 0)"
            
            cell.buynow.addTarget(self, action: #selector(viewproduct(_:)), for: .touchUpInside)
//            cell.crossBtn.addTarget(self, action: #selector(crossBtnTapped(_:)), for: .touchUpInside)
         
            
            if data.onSale == true {
                cell.Salesprice.isHidden = false
                cell.Salesprice.isHidden = false
                cell.Salesprice.text = "NOW " + appDelegate.currencylabel + Utility().formatNumberWithCommas(data.salePrice ?? 0, label: cell.Salesprice)//appDelegate.currencylabel + " \(data.salePrice ?? 0)"
                cell.productPriceLine.isHidden = false
                cell.price.textColor = UIColor.systemGray
                cell.price.text = "WAS " + appDelegate.currencylabel + Utility().formatNumberWithCommas(data.price ?? 0, label:  cell.price)//appDelegate.currencylabel + " \(data.price ?? 0)"
            }else {
                cell.Salesprice.isHidden = true
                cell.productPriceLine.isHidden = true
                cell.price.textColor = UIColor.black
            }
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videoProductCollectionViewCell", for: indexPath) as! videoProductCollectionViewCell
            let data = getvidoebyproductIdsdata[indexPath.row]
            
            cell.img.pLoadImage(url: data.mainImage ?? "")
            cell.price.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(data.price ?? 0, label:  cell.price)
            cell.productname.text = data.productName

            
            
            if data.onSale == true {
                cell.Salesprice.isHidden = false
                cell.price.isHidden = false
                cell.Salesprice.text =
                Utility().formatNumberWithCommas(data.salePrice ?? 0, label:   cell.Salesprice)
                cell.price.text = Utility().formatNumberWithCommas(data.regularPrice ?? 0, label:cell.price)
                cell.productPriceLine.isHidden = false
                cell.price.textColor = UIColor.red
                cell.productPriceLine.backgroundColor = UIColor.red
            }else {
                cell.productPriceLine.isHidden = true
                cell.price.isHidden = true
                cell.Salesprice.text = Utility().formatNumberWithCommas(data.regularPrice ?? 0, label: cell.Salesprice)
             }
            
            
            
    //        if data.onSale == true {
    //            cell.price.isHidden = false
    //            cell.price.isHidden = false
    //            cell.price.text = "NOW " + appDelegate.currencylabel + " \(data.salePrice ?? 0)"
    //            cell.productPriceLine.isHidden = false
    //            cell.price.textColor = UIColor.systemGray
    //            cell.price.text = "WAS " + appDelegate.currencylabel + " \(data.price ?? 0)"
    //        }else {
    //            cell.Salesprice.isHidden = true
    //            cell.productPriceLine.isHidden = true
    //            cell.price.textColor = UIColor.black
    //         }
            cell.buynow.tag = indexPath.row
            cell.buynow.addTarget(self, action: #selector(viewallitemtap(_:)), for: .touchUpInside)
                return cell
        }
        
      
    }
    @objc func viewallitemtap(_ sender: UIButton) {
        let data = getvidoebyproductIdsdata[sender.tag]
         stopPlayback()
        
        if (data.variants?.countVariants() ?? 0 > 0) {
            let vc = NewProductPageViewController.getVC(.productStoryBoard)
            vc.slugid = data.slug
            navigationController?.pushViewController(vc, animated: false)
        }else {
            let vc = CartPopupViewController.getVC(.popups)
            vc.modalPresentationStyle = .custom
            vc.transitioningDelegate = centerTransitioningDelegate
            vc.nav = self.navigationController
            vc.products = data
            UIApplication.pTopViewController().present(vc, animated: true, completion: nil)
            
        }
    }
    
    @objc func crossBtnTapped(_ sender: UIButton) {
        
        isHideCollectionView.isHidden = true
    }
    
    @objc func viewproduct(_ sender: UIButton) {

        let data = getvidoebyproductIdsdata[0]
        
        let vc = NewProductPageViewController.getVC(.productStoryBoard)
        //              vc.isGroupBuy = false
        vc.slugid = data.slug
        //              vc.isCome = true
        //           let vc = ProductDetail_VC.getVC(.main)
        //        vc.isGroupBuy = false
        //             vc.isCome = true
        //        vc.nav = self.navigationController
        self.navigationController?.present(vc, animated: true, completion: nil)
        //           self.navigationController?.pushViewController(vc, animated: false)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(collectionView == showCaseCollectionView){
           return CGSize(width: self.showCaseCollectionView.frame.width, height: self.showCaseCollectionView.frame.height)
        }else{
            return CGSize(width: self.videoProductCollectionV.frame.width/1.4, height: self.videoProductCollectionV.frame.height)
        }
     
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let data = getvidoebyproductIdsdata[indexPath.row]
//
//        let vc = ProductDetail_VC.getVC(.main)
//        vc.isGroupBuy = false
//        vc.slugid = data.slug
//        self.navigationController?.pushViewController(vc, animated: false)
    }
    
}

extension SingleVideoCell {
    
  
    
    func SocketConnect(socketId:String) {
        print("VideoId:MiscId:\(AppDefault.socketId)")
        let baseURL = AppConstants.API.baseURLVideoStreaming
        let token = AppDefault.accessToken
        let id = AppDefault.socketId
        
        print("Connecting to socket at \(baseURL) with token: \(token)")
        
        manager = SocketManager(socketURL: AppConstants.API.baseURLVideoStreaming, config: [.log(true),
                                                                                            .compress,
                                                                                            .forceWebsockets(true),.connectParams( ["token":AppDefault.accessToken,"roomId":id,"feature":"call"])])
        socket = manager?.defaultSocket
        socket?.on(clientEvent: .connect) { data, ack in
            print("Socket connected")
            print("Socket ID: \(self.socket?.sid ?? "No ID")")

            
        }
        
        socket?.on(clientEvent: .disconnect) { data, ack in
            print("Socket disconnected")
        }
        socket?.on("pushProduct") { [self] data, ack in
            print("Received pushProduct event with data: \(data)")
//            self.view.makeToast("Received pushProduct event with data: \(data)")
            if let productdata = data.first as? [String: Any]{
                
                let obj = GetDataOfPushProduct(jsonData: JSON(rawValue: productdata)!)
                
                print(obj)
                
                
                   
                if(obj.product == showCollectionView){
                    isHideCollectionView.isHidden = true
                    showCollectionView = ""
                }else{
                    getvidoebyproductIds(productIds: [obj.product])
                }
              
                
                
                
                
            }
        }
            
//                    socket?.onAny { event in
//                        print("Received event: \(event.event), with items: \(String(describing: event.items))")
//                    }
            
            socket?.connect()
        }
    }
