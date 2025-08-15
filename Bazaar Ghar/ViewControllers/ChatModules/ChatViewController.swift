import UIKit
import AVKit
import AVFoundation
import SocketIO
import IQKeyboardManagerSwift
import SwiftyJSON
import Alamofire
import MobileCoreServices
import UniformTypeIdentifiers

class ChatViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var headerBackgroudView: UIView!
    @IBOutlet weak var ChatTblV: UITableView!
    @IBOutlet weak var messageTF: UITextView!
    @IBOutlet weak var attachmentBtn: UIButton!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var namestore: UILabel!
    @IBOutlet weak var inputViewBottom: NSLayoutConstraint!
    var msgArray = [String]()
    var manager:SocketManager?
    var socket: SocketIOClient?
    var PuserMainArray: PuserMainModel? = nil
    
    var messages: PMsg? = nil
    
    var latestMessages: [Pusermessage]? = nil
    var recieverId = ""
    var roomId = ""
    var storeName : String?
    var newChat : Bool?
    var NCroomId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerBackgroudView.backgroundColor = UIColor(named: "headercolor")
        self.navigationController?.navigationBar.isHidden = true
       
        ChatTblV.register(UINib(nibName: "sendCell", bundle: nil), forCellReuseIdentifier: "sendCell")
        ChatTblV.register(UINib(nibName: "recevCell", bundle: nil), forCellReuseIdentifier: "recevCell")
        ChatTblV.register(UINib(nibName: "receiverImageCell", bundle: nil), forCellReuseIdentifier: "receiverImageCell")
        ChatTblV.register(UINib(nibName: "SenderimageCell", bundle: nil), forCellReuseIdentifier: "SenderimageCell")
        
        
        ChatTblV.estimatedRowHeight = 60
        ChatTblV.rowHeight = UITableView.automaticDimension
        if newChat == true {
            namestore.text = storeName ?? ""
        }else {
            namestore.text = messages?.idarray?.brandName ?? ""
        }
        messageTF.text = ""
        LanguageManager.language == "ar" ?  messageTF.addPlaceholder("اكتب شيئًا...") :  messageTF.addPlaceholder("Write Something...")
        if(latestMessages?.count ?? 0 > 0){
            self.ChatTblV.scrollToBottom()
        }
        self.connectSocket()
        messageTF.centerVertically()
        
        
    }
    
    func LanguageRender() {
        UIView.appearance().semanticContentAttribute = LanguageManager.language == "ar" ? .forceRightToLeft : .forceLeftToRight
        UITextField.appearance().textAlignment = LanguageManager.language == "ar" ? .right : .left
        UITextView.appearance().textAlignment = LanguageManager.language == "ar" ? .right : .left
      UICollectionView.appearance().semanticContentAttribute = LanguageManager.language == "ar" ? .forceRightToLeft : .forceLeftToRight
      UICollectionViewCell.appearance().semanticContentAttribute = LanguageManager.language == "ar" ? .forceRightToLeft : .forceLeftToRight

        }
    
    @IBAction func sendbtnAction(_ sender: Any) {
 
            let str =  messageTF.text ?? ""
            let trimString = str.trimmingCharacters(in: .whitespaces)
            if(trimString != "" && trimString != "Type something here..."){
                var json = [String: Any]()
                json["receiverId"] = messages?.idarray?.sellerId ?? ""
                json["roomId"] = PuserMainArray?.roomId
                json["message"] = messageTF.text ?? ""
                json["senderId"] = AppDefault.currentUser?.id
                
                self.messageTF.text  = "Type something here..."
                self.messageTF.centerVertically()
                socket?.emit("newChatMessage", json)
                
                self.scrolltobottomTable()
                
            }

        
    }
        
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.addKeyboardObserver()
        self.LanguageRender()

        
    }
    override func viewDidDisappear(_ animated: Bool) {
       
    }
    

    
    
    @IBAction func backbtn(_ sender: Any) {
        self.socket?.emit("leaveRoom", ["userId":AppDefault.currentUser?.id ?? ""])
        self.navigationController?.popViewController(animated: true)
    }
    func showImagePreview(_ image: UIImage) {
           let imagePreviewVC = UIViewController()
           
           let backgroundView = UIView(frame: imagePreviewVC.view.bounds)
           backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
           imagePreviewVC.view.addSubview(backgroundView)
           
           let containerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 400))
           containerView.center = imagePreviewVC.view.center
           containerView.backgroundColor = .clear
           imagePreviewVC.view.addSubview(containerView)
           
           let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 400))
           scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
           scrollView.delegate = self
           scrollView.minimumZoomScale = 1.0
           scrollView.maximumZoomScale = 5.0
           containerView.addSubview(scrollView)
           
           let imageView = UIImageView(image: image)
           imageView.contentMode = .scaleAspectFit
           imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 400)
           scrollView.addSubview(imageView)
           
           scrollView.contentSize = imageView.frame.size
           
           // Add double-tap gesture recognizer for zooming
           let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapGesture(_:)))
           doubleTapGesture.numberOfTapsRequired = 2
           scrollView.addGestureRecognizer(doubleTapGesture)
           
           imageView.isUserInteractionEnabled = true
           

           let tap = UITapGestureRecognizer(target: self, action: #selector(closeImagePreview))
           backgroundView.addGestureRecognizer(tap)
           
           let navController = UINavigationController(rootViewController: imagePreviewVC)
           navController.modalPresentationStyle = .overFullScreen
           present(navController, animated: true, completion: nil)
       }
    @objc func closeImagePreview() {
        dismiss(animated: true, completion: nil)
    }
    @objc func handleDoubleTapGesture(_ sender: UITapGestureRecognizer) {
        guard let scrollView = sender.view?.superview as? UIScrollView else { return }
        
        if scrollView.zoomScale == scrollView.minimumZoomScale {
            let tapPoint = sender.location(in: sender.view)
            let zoomRect = zoomRectForScale(scale: scrollView.maximumZoomScale, center: tapPoint, in: scrollView)
            scrollView.zoom(to: zoomRect, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        }
    }
    func zoomRectForScale(scale: CGFloat, center: CGPoint, in scrollView: UIScrollView) -> CGRect {
        var zoomRect = CGRect()
        let size = CGSize(
            width: scrollView.frame.size.width / scale,
            height: scrollView.frame.size.height / scale
        )
        
        zoomRect.size = size
        zoomRect.origin = CGPoint(
            x: center.x - (size.width / 2.0),
            y: center.y - (size.height / 2.0)
        )
        
        return zoomRect
    }
    override func viewWillDisappear(_ animated: Bool) {
      
    }
    func scrolltobottomTable(){
        
        
        self.socket?.on("newChatMessage") { datas, ack in
            if let rooms = datas[0] as? [String: Any]{
                
                let obj = Pusermessage(jsonData: JSON(rawValue: rooms)!)
                
                
                
                if self.latestMessages?.filter({$0.id == obj.id}).count ?? 0 > 0{
                    
                }else{
                    self.latestMessages?.append(obj)
                }
            
                
                
             
                self.view.endEditing(true)
                self.ChatTblV.reloadData()
                if(self.latestMessages?.count ?? 0 > 0){
                    self.ChatTblV.scrollToBottom()
                }
              
            }
        }
        
    }

    
    @IBAction func attachedMediaBtnTapped(_ sender: Any) {
        let imagePicker = UIImagePickerController()
           imagePicker.sourceType = .photoLibrary
           imagePicker.delegate = self
           imagePicker.mediaTypes = [UTType.image.identifier, UTType.movie.identifier]
           present(imagePicker, animated: true, completion: nil)
        }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String {
                if mediaType == UTType.image.identifier {
                    if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                        // Do something with the selected image
                        UPLOD_PickSignature(token: AppDefault.accessToken, chatMedia: selectedImage, receiverId: self.recieverId, roomId: self.roomId, endpoint: "upload", type: "chatMedia", typeimg: "chatMedia", name: "chatMedia")
                    }
                } else if mediaType == UTType.movie.identifier {
                    if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                        // Handle the selected video URL
                        // For example, you can upload it or display it in a player
                        uploadVideo(token: AppDefault.accessToken, videoURL: videoURL, receiverId: self.recieverId, roomId: self.roomId, endpoint: "upload", name: "chatMedia")
                    }
                }
            }
            
            picker.dismiss(animated: true, completion: nil)
        }


    func uploadVideo(token: String, videoURL: URL, receiverId: String, roomId: String, endpoint: String, name: String) {
        UIApplication.startActivityIndicator()

        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token,
            "Content-Type": "multipart/form-data"
        ]

        let url = AppConstants.API.baseURLChatNotification.absoluteString + endpoint

        AF.upload(
            multipartFormData: { multipartFormData in
                // Add video file
                do {
                    let videoData = try Data(contentsOf: videoURL)
                    multipartFormData.append(videoData, withName: name, fileName: "video.mp4", mimeType: "video/mp4")
                } catch {
                    print("Error converting video file to Data: \(error)")
                }
                
                // Add other parameters
                multipartFormData.append(Data(receiverId.utf8), withName: "receiverId")
                multipartFormData.append(Data(roomId.utf8), withName: "roomId")
            },
            to: url,
            method: .post,
            headers: headers
        )
        .uploadProgress { progress in
            print("Upload Progress: \(progress.fractionCompleted * 100)%")
        }
        .response { response in
            UIApplication.stopActivityIndicator()

            if let error = response.error {
                self.view.makeToast(error.localizedDescription)
            } else {
                // Upload successful, handle response
                print("Upload successful")
            }
        }
    }

    
  

    func UPLOD_PickSignature(token: String, chatMedia: UIImage, receiverId: String, roomId: String, endpoint: String, type: String, typeimg: String, name: String) {
        UIApplication.startActivityIndicator()

        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token,
            "Content-Type": "multipart/form-data"
        ]

        guard let imgData = chatMedia.jpegData(compressionQuality: 0.7) else {
            print("Error: Could not convert image to data")
            return
        }

        let url = AppConstants.API.baseURLChatNotification.absoluteString + endpoint

        AF.upload(
            multipartFormData: { multipartFormData in
                // Add image data
                multipartFormData.append(imgData, withName: name, fileName: typeimg, mimeType: "image/jpeg")
                
                // Add other parameters
                multipartFormData.append(Data(receiverId.utf8), withName: "receiverId")
                multipartFormData.append(Data(roomId.utf8), withName: "roomId")
            },
            to: url,
            method: .post,
            headers: headers
        )
        .uploadProgress { progress in
            print("Upload Progress: \(progress.fractionCompleted * 100)%")
        }
        .response { response in
            UIApplication.stopActivityIndicator()

            if let error = response.error {
                self.view.makeToast(error.localizedDescription)
            } else {
                print("Upload successful")
                // Navigate to the desired view controller if needed
                // let vc = Product_VC.getVC(.main)
                // self.navigationController?.pushViewController(vc, animated: false)
            }
        }
    }

    

}

extension ChatViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return latestMessages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = latestMessages?[indexPath.row]
        self.recieverId = data?.receiverId ?? ""
        self.roomId = data?.roomId ?? ""
        if(data?.receiverId == AppDefault.currentUser?.id){
            if(data?.multimedia == nil){
                let cell = tableView.dequeueReusableCell(withIdentifier: "recevCell", for: indexPath) as! recevCell
                cell.lbltext.text = data?.message
//                cell.lbltime.text = data?.date
                if let formattedDate = Utility().convertDateString(data?.date ?? "", fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", toFormat: "MMMM dd, yyyy hh:mm a") {
                    print(formattedDate) // Output: April 18, 2024 05:24 AM
                    cell.lbltime.text = formattedDate
                }
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "receiverImageCell", for: indexPath) as! receiverImageCell
                if let formattedDate = Utility().convertDateString(data?.date ?? "", fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", toFormat: "MMMM dd, yyyy hh:mm a") {
                    print(formattedDate) // Output: April 18, 2024 05:24 AM
                    cell.days.text = formattedDate
                }
                if((data?.multimedia.contains(".mp4")) != nil){
                   
                                   if let multimediaString = data?.multimedia,
                                      let multimediaURL = URL(string: multimediaString) {
                                       self.generateThumbnail(from: multimediaURL) { thumbnail in
                                           // Update the imageView with the generated thumbnail
                                           DispatchQueue.main.async {
                                               if let thumbnail = thumbnail {
                                                   cell.mainImage?.image = thumbnail
                                                   cell.playImage.isHidden = false
                   //                                showImagePreview(thumbnail)
                                               }
                                           }
                                       }
                                   }
                               }
                cell.playImage.isHidden = true
                cell.mainImage.pLoadImage(url: data?.multimedia  ?? "")
                cell.imageTapper.mk_addTapHandler{ (btn) in
                    print("You can use here also directly : \(indexPath.row)")
                    self.imageTapper(btn: btn, indexPath: indexPath)
               }
                return cell
            }
            
            
            
            
        }else{
            
            
            if(data?.multimedia == nil){
                let cell = tableView.dequeueReusableCell(withIdentifier: "sendCell", for: indexPath) as! sendCell
                cell.lbltext.text = data?.message
//                cell.lbltime.text = data?.date
                if let formattedDate = Utility().convertDateString(data?.date ?? "", fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", toFormat: "MMMM dd, yyyy hh:mm a") {
                    print(formattedDate) // Output: April 18, 2024 05:24 AM
                    cell.lbltime.text = formattedDate
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SenderimageCell", for: indexPath) as! SenderimageCell
                if let formattedDate = Utility().convertDateString(data?.date ?? "", fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", toFormat: "MMMM dd, yyyy hh:mm a") {
                    print(formattedDate) // Output: April 18, 2024 05:24 AM
                    cell.days.text = formattedDate
                }
                
                                                                                             
                if((data?.multimedia.contains(".mp4")) != nil){
                    
                            
                                   if let multimediaString = data?.multimedia,
                                      let multimediaURL = URL(string: multimediaString) {
                                       self.generateThumbnail(from: multimediaURL) { thumbnail in
                                           // Update the imageView with the generated thumbnail
                                           DispatchQueue.main.async {
                                               if let thumbnail = thumbnail {
                                                   
                                                   cell.mainImage?.image = thumbnail
                                                   cell.playImage.isHidden = false
                                                   
                                                 
                   //                                showImagePreview(thumbnail)
                                               }
                                           }
                                       }
                                   }
                               }
               
                cell.playImage.isHidden = true
                cell.imageTapper.mk_addTapHandler{ (btn) in
                    print("You can use here also directly : \(indexPath.row)")
                    self.imageTapper(btn: btn, indexPath: indexPath)
               }
                cell.imageTapper.tag = indexPath.row
                cell.mainImage.pLoadImage(url: data?.multimedia  ?? "")
                return cell
            }
            
           
        }
        
       
    }
    
 
    func imageTapper(btn:UIButton, indexPath:IndexPath) {
        let data = latestMessages?[indexPath.row]
        if(data?.receiverId == AppDefault.currentUser?.id){
            if let multimedia = data?.multimedia, multimedia.contains(".mp4") {
                let cell = ChatTblV.cellForRow(at:indexPath) as? SenderimageCell
                if let videoURL = URL(string: data?.multimedia ?? "") {
                    playVideo(from: videoURL, on: self)
                }
            }
                
            if(data?.multimedia != nil){
                let cell = ChatTblV.cellForRow(at:indexPath) as? receiverImageCell
               
            if let image = cell?.mainImage?.image {
                                   showImagePreview(image)
                               }
            }
        }else{
            if let multimedia = data?.multimedia, multimedia.contains(".mp4") {
                let cell = ChatTblV.cellForRow(at:indexPath) as? SenderimageCell
                if let videoURL = URL(string: data?.multimedia ?? "") {
                    playVideo(from: videoURL, on: self)
                }
            }
            if(data?.multimedia != nil){
                let cell = ChatTblV.cellForRow(at:indexPath) as? SenderimageCell
                if let image = cell?.mainImage?.image {
                    showImagePreview(image)
                }
                
                
                
            }
        }
    }
    func playVideo(from url: URL, on viewController: UIViewController) {
        // Create an instance of AVPlayer with the video URL
        let player = AVPlayer(url: url)
        
        // Create an AVPlayerViewController to present the video
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        // Add a close button to the AVPlayerViewController
       
        
        // Add the close button as a subview
     
        
        // Present the AVPlayerViewController modally
        viewController.present(playerViewController, animated: true) {
            player.play()
        }
    }

    // Action for the close button
    @objc func closePlayer(_ sender: UIButton) {
        // Find the AVPlayerViewController in the presenting view controller stack
        if let presentedVC = sender.window?.rootViewController?.presentedViewController as? AVPlayerViewController {
            // Stop playback
            presentedVC.player?.pause()
            presentedVC.player = nil
            
            // Dismiss the AVPlayerViewController
            presentedVC.dismiss(animated: true, completion: nil)
        }
    }
    
    func generateThumbnail(from videoURL: URL, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let asset = AVAsset(url: videoURL)
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true // Ensure the thumbnail respects the video's orientation

            // Set the time to generate the thumbnail (e.g., at 1 second)
            let time = CMTime(seconds: 1.0, preferredTimescale: 600)

            do {
                let cgImage = try generator.copyCGImage(at: time, actualTime: nil)
                let thumbnail = UIImage(cgImage: cgImage)
                DispatchQueue.main.async {
                    completion(thumbnail)
                }
            } catch {
                print("Error generating thumbnail: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = latestMessages?[indexPath.row]
        if(data?.multimedia == nil){
            return UITableView.automaticDimension
        }else{
            return 170
        }
        
    }
}


extension UITableView {
    
    func register<T: UITableViewCell>(_: T.Type, indexPath: IndexPath) -> T {
        self.register(UINib(nibName: String(describing: T.self), bundle: .main), forCellReuseIdentifier: String(describing: T.self))
        let cell = self.dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as! T
        return cell
    }
    
   
    
    func scrollToBottom(){
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                section: self.numberOfSections - 1)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }
    
    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
    
    func removeEmptyView() {
        self.backgroundView = nil
    }
    
  
}
extension ChatViewController{
    
    
    
    func connectSocket() {
        
        self.socket?.on("newChatMessage") { datas, ack in
            if let rooms = datas[0] as? [String: Any]{
                
                let obj = Pusermessage(jsonData: JSON(rawValue: rooms)!)
                
                
                
                if self.latestMessages?.filter({$0.id == obj.id}).count ?? 0 > 0{
                    
                }else{
                    self.latestMessages?.append(obj)
                }
            
                
                
             
                self.view.endEditing(true)
                self.ChatTblV.reloadData()
                self.ChatTblV.scrollToBottom()
            }
        }
    }
}
extension ChatViewController:UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        if  textView.text == ""
           {
            textView.showPlaceholder()
           }
           else
           {
               textView.hidePlaceholder()
           }
         
        }
     
     
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
          let count = textView.text.count + (text.count - range.length)
     
         return true
     }
     
//     func textViewDidBeginEditing(_ textView: UITextView) {
//         if textView.text == "Type something here..." {
//             textView.text = ""
//         }
//     }
    
    private func textFieldDidEndEditing(_ textField: UITextField) {
      if textField.text == "" {
//          textField.text = "Type something here..."
          sendBtn.isHidden = true
        }else {
            sendBtn.isHidden = false
        }
        
        msgArray.append(textField.text ?? "")
        

    }
    
    
    
    
    
     
    
}
extension ChatViewController{
    
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChange(notification:)), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        
        if keyboardSize.height > 200  && inputViewBottom.constant < 100{
            let window = UIApplication.shared.keyWindow
            
            UIView.animate(withDuration: 0.1) {
                
                if let win = window {
                    self.inputViewBottom.constant = self.inputViewBottom.constant + keyboardSize.height -  win.safeAreaInsets.bottom
                }
                self.view.layoutIfNeeded()
              
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        
        if keyboardSize.height > 200  && inputViewBottom.constant > 100 {
            
            UIView.animate(withDuration: 0.1) {
                self.inputViewBottom.constant = 10
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardFrameChange(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        
        if keyboardSize.height > 200  && inputViewBottom.constant > 100 {
            let window = UIApplication.shared.keyWindow
            
            UIView.animate(withDuration: 0.1) {
                
                if let win = window {
                    self.inputViewBottom.constant = 10 + keyboardSize.height -  win.safeAreaInsets.bottom
                }
                self.view.layoutIfNeeded()
            }
        }
    }
    
}
extension UITextView {
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
}

