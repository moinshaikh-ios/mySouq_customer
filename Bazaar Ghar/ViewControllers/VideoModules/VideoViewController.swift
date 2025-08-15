//
//  VideoViewController.swift
//  Bazaar Ghar
//
//  Created by Developer on 27/11/2023.
//

import UIKit
import SocketIO
import TwilioVideo
import SwiftyJSON



class VideoViewController: UIViewController {
    // MARK:- View Controller Members
    
    // Configure access token manually for testing, if desired! Create one manually in the console
    // at https://www.twilio.com/console/video/runtime/testing-tools
    var accessToken = "TWILIO_ACCESS_TOKEN"
  
    // Configure remote URL to fetch token from
  
    // Video SDK components
    @IBOutlet weak var isHideCollectionView: UIView!
    var videoToken = String()
    var room: Room?
    var camera: CameraSource?
    var localVideoTrack: LocalVideoTrack?
    var localAudioTrack: LocalAudioTrack?
    var remoteParticipant: RemoteParticipant?
    var getvidoebyproductIdsdata: [Product] = []
    var showCollectionView = ""

    
    
    // MARK:- UI Element Outlets and handles
    
    // `VideoView` created from a storyboard
    @IBOutlet weak var previewView: VideoView!
    @IBOutlet weak var SpeakerButton: UIButton!

    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var disconnectButton: UIButton!
    @IBOutlet weak var cameraFlip: UIButton!
    @IBOutlet weak var videoBtn: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var roomTextField: UITextField!
    @IBOutlet weak var roomLine: UIView!
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet  var remoteView: VideoView!
    @IBOutlet weak var showCaseCollectionView: UICollectionView!

    deinit {
        // We are done with camera
        if let camera = self.camera {
            camera.stopCapture()
            self.camera = nil
        }
    }
    
    var customer = String()
    var notificationId = String()
    var videoCallId = String()
    var manager:SocketManager?
    var socket: SocketIOClient?
    var audioSession = AVAudioSession.sharedInstance()
        var isMuted = false
    // MARK:- UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "QuickStart"
        self.messageLabel.adjustsFontSizeToFitWidth = true;
        self.messageLabel.minimumScaleFactor = 0.75;

        if PlatformUtils.isSimulator {
            self.previewView.removeFromSuperview()
        } else {
            // Preview our local camera track in the local video preview view.
            self.startPreview()
        }
        
        self.connectButton.adjustsImageWhenDisabled = true;
        
        // Disconnect and mic button will be displayed when the Client is connected to a Room.
        self.disconnectButton.isHidden = true
        self.micButton.isHidden = true
        
        self.roomTextField.autocapitalizationType = .none
        self.roomTextField.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(VideoViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)

      connectToARoom()
        SocketConnect()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
  
    }

    override var prefersHomeIndicatorAutoHidden: Bool {
        return self.room != nil
    }
    
    
//        private func getVideoToken(room:String, token:String){
//            APIServices.getVideoToken(room: room, token: token){[weak self] data in
//                switch data{
//                case .success(let res):
//                   //
//                    self?.accessToken = res
//               
//                
//                   case .failure(let error):
//                    print(error)
//                }
//            }
//        }

  
    func setupRemoteVideoView() {
        // Create `VideoView` programmatically
        self.remoteView = VideoView(frame: CGRect.zero, delegate: self)
        
        // Ensure the `remoteView` is not nil before proceeding
        guard let remoteView = self.remoteView else {
            print("Failed to create remote VideoView")
            return
        }
        
        // Add `remoteView` to the view hierarchy
        self.view.insertSubview(remoteView, at: 0)
        
        // Set up constraints or frame to position the remote view correctly
        remoteView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            remoteView.topAnchor.constraint(equalTo: self.view.topAnchor),
            remoteView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            remoteView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            remoteView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
    
        remoteView.contentMode = .scaleAspectFill
        

    }
       

    
    func connectToARoom() {
        
        self.connectButton.isEnabled = true;
        // Prepare local media which we will share with Room Participants.
        self.prepareLocalMedia()
        
        // Preparing the connect options with the access token that we fetched (or hardcoded).
        let connectOptions = ConnectOptions(token: accessToken) { (builder) in
            
            // Use the local media that we prepared earlier.
            builder.audioTracks = self.localAudioTrack != nil ? [self.localAudioTrack!] : [LocalAudioTrack]()
            builder.videoTracks = self.localVideoTrack != nil ? [self.localVideoTrack!] : [LocalVideoTrack]()
            // Use the preferred audio codec
            if let preferredAudioCodec = Settings.shared.audioCodec {
                builder.preferredAudioCodecs = [preferredAudioCodec]
            }
            
            // Use Adpative Simulcast by setting builer.videoEncodingMode to .auto if preferredVideoCodec is .auto (default). The videoEncodingMode API is mutually exclusive with existing codec management APIs EncodingParameters.maxVideoBitrate and preferredVideoCodecs
            let preferredVideoCodec = Settings.shared.videoCodec
            if preferredVideoCodec == .auto {
                builder.videoEncodingMode = .auto
            } else if let codec = preferredVideoCodec.codec {
                builder.preferredVideoCodecs = [codec]
            }
            
            // Use the preferred encoding parameters
            if let encodingParameters = Settings.shared.getEncodingParameters() {
                builder.encodingParameters = encodingParameters
            }

            // Use the preferred signaling region
            if let signalingRegion = Settings.shared.signalingRegion {
                builder.region = signalingRegion
            }
            
            // The name of the Room where the Client will attempt to connect to. Please note that if you pass an empty
            // Room `name`, the Client will create one for you. You can get the name or sid from any connected Room.
            builder.roomName = self.videoCallId
        }
        
        // Connect to the Room using the options we provided.
        room = TwilioVideoSDK.connect(options: connectOptions, delegate: self)
        
        logMessage(messageText: "Attempting to connect to room \(String(describing:"room1" ))")  //self.roomTextField.text
        
        self.showRoomUI(inRoom: true)
        self.dismissKeyboard()
    }
  
    @IBAction func speakerbtn(_ sender: Any) {
       toggleAudioRoute()
//        if SpeakerButton.imageView?.image == UIImage(systemName: "speaker.wave.3.fill") {
//            SpeakerButton.setImage(UIImage(systemName: "speaker.slash.fill"), for: .normal)
//        }else {
//            SpeakerButton.setImage(UIImage(systemName: "speaker.wave.3.fill"), for: .normal)
//        }
    }
    func toggleAudioRoute() {
            let audioSession = AVAudioSession.sharedInstance()
            
            do {
                if audioSession.category != .playAndRecord || audioSession.mode != .voiceChat {
                    try audioSession.setCategory(.playAndRecord, mode: .voiceChat, options: .allowBluetooth)
                    try audioSession.setActive(true)
                }
                
                let currentRoute = audioSession.currentRoute
                var isSpeaker = false
                
                for output in currentRoute.outputs {
                    if output.portType == .builtInSpeaker {
                        isSpeaker = true
                    }
                }
                
                if isSpeaker {
                    try audioSession.overrideOutputAudioPort(.none)
                    SpeakerButton.setImage(UIImage(systemName: "speaker.slash.fill"), for: .normal)
                } else {
                    try audioSession.overrideOutputAudioPort(.speaker)
                    SpeakerButton.setImage(UIImage(systemName: "speaker.wave.3.fill"), for: .normal)
                }
            } catch let error {
                logMessage(messageText: "Failed to toggle audio route: \(error.localizedDescription)")
            }
        }
    
    // MARK:- IBActions
    @IBAction func connect(sender: AnyObject) {
        self.connectButton.isEnabled = false;

    }
    @IBAction func cameraFilp(sender: UIButton) {
        flipCamera()
    }
    
    @IBAction func toggleVideoButtonPressed(_ sender: UIButton) {
        toggleVideo()
    }
    
    func toggleVideo() {
            if let localVideoTrack = localVideoTrack {
                if localVideoTrack.isEnabled {
                    localVideoTrack.isEnabled = false
                    // Update UI or perform any actions for video pause
              videoBtn.setImage(UIImage(systemName: "video.slash.fill"), for: .normal)
                } else {
                    localVideoTrack.isEnabled = true
                    // Update UI or perform any actions for video resume
                    videoBtn.setImage(UIImage(systemName: "video.fill"), for: .normal)
                }
            }
        }
    
    @IBAction func disconnect(sender: UIButton) {
        appDelegate.ChineseShowCustomerAlertControllerHeight(title: "Are you sure you want to end this call?", heading: "End call", note: "", miscid: "self.miscid", btn1Title: "End Call", btn1Callback: {
            self.room!.disconnect()
            self.navigationController?.popViewController(animated: true)
        }, btn2Title: "Cancel") { token, id in
     
        }
        
    }
    
    @IBAction func toggleMic(sender: AnyObject) {
        if (self.localAudioTrack != nil) {
            self.localAudioTrack?.isEnabled = !(self.localAudioTrack?.isEnabled)!
            
            // Update the button title
            if (self.localAudioTrack?.isEnabled == true) {
                self.micButton.setImage(UIImage(named: "mic"), for: .normal)
            } else {
                self.micButton.setImage(UIImage(named: "mic_off"), for: .normal)
            }
        }

    }

    // MARK:- Private
    func startPreview() {
        if PlatformUtils.isSimulator {
            return
        }

        let frontCamera = CameraSource.captureDevice(position: .front)
        let backCamera = CameraSource.captureDevice(position: .back)

        if (frontCamera != nil || backCamera != nil) {

            let options = CameraSourceOptions { (builder) in
                if #available(iOS 13.0, *) {
                    // Track UIWindowScene events for the key window's scene.
                    // The example app disables multi-window support in the .plist (see UIApplicationSceneManifestKey).
                    builder.orientationTracker = UserInterfaceTracker(scene: UIApplication.shared.keyWindow!.windowScene!)
                }
            }
            // Preview our local camera track in the local video preview view.
            camera = CameraSource(options: options, delegate: self)
            localVideoTrack = LocalVideoTrack(source: camera!, enabled: true, name: "camera")

            // Add renderer to video track for local preview
            localVideoTrack!.addRenderer(self.previewView)
            logMessage(messageText: "Video track created")

            if (frontCamera != nil && backCamera != nil) {
                // We will flip camera on tap.
                let tap = UITapGestureRecognizer(target: self, action: #selector(VideoViewController.flipCamera))
                self.previewView.addGestureRecognizer(tap)
            }

            camera!.startCapture(device: frontCamera != nil ? frontCamera! : backCamera!) { (captureDevice, videoFormat, error) in
                if let error = error {
                    self.logMessage(messageText: "Capture failed with error.\ncode = \((error as NSError).code) error = \(error.localizedDescription)")
                } else {
                    self.previewView.shouldMirror = (captureDevice.position == .front)
                }
            }
        }
        else {
            self.logMessage(messageText:"No front or back capture device found!")
        }
    }

    @objc func flipCamera() {
        var newDevice: AVCaptureDevice?
        if let camera = self.camera, let captureDevice = camera.device {
            if captureDevice.position == .front {
                newDevice = CameraSource.captureDevice(position: .back)
            } else {
                newDevice = CameraSource.captureDevice(position: .front)
            }

            if let newDevice = newDevice {
                camera.selectCaptureDevice(newDevice) { (captureDevice, videoFormat, error) in
                    if let error = error {
                        self.logMessage(messageText: "Error selecting capture device.\ncode = \((error as NSError).code) error = \(error.localizedDescription)")
                    } else {
                        self.previewView.shouldMirror = (captureDevice.position == .front)
                    }
                }
            }
        }
    }

    func prepareLocalMedia() {

        // We will share local audio and video when we connect to the Room.

        // Create an audio track.
        if (localAudioTrack == nil) {
            localAudioTrack = LocalAudioTrack(options: nil, enabled: true, name: "Microphone")

            if (localAudioTrack == nil) {
                logMessage(messageText: "Failed to create audio track")
            }
        }

        // Create a video track which captures from the camera.
        if (localVideoTrack == nil) {
            self.startPreview()
        }
   }

    // Update our UI based upon if we are in a Room or not
    func showRoomUI(inRoom: Bool) {
        
        self.connectButton.isHidden = inRoom
        self.roomTextField.isHidden = inRoom
        self.roomLine.isHidden = inRoom
        self.roomLabel.isHidden = inRoom
        self.micButton.isHidden = !inRoom
        self.disconnectButton.isHidden = !inRoom
        self.navigationController?.setNavigationBarHidden(inRoom, animated: true)
        UIApplication.shared.isIdleTimerDisabled = inRoom

        // Show / hide the automatic home indicator on modern iPhones.
        self.setNeedsUpdateOfHomeIndicatorAutoHidden()
    }
    
    @objc func dismissKeyboard() {
        if (self.roomTextField.isFirstResponder) {
            self.roomTextField.resignFirstResponder()
        }
    }
    
    func logMessage(messageText: String) {
        NSLog(messageText)
        messageLabel.text = messageText
    }

    func renderRemoteParticipant(participant : RemoteParticipant) -> Bool {
        // This example renders the first subscribed RemoteVideoTrack from the RemoteParticipant.
        let videoPublications = participant.remoteVideoTracks
        for publication in videoPublications {
            if let subscribedVideoTrack = publication.remoteTrack,
                publication.isTrackSubscribed {
                setupRemoteVideoView()
                subscribedVideoTrack.addRenderer(self.remoteView!)
                self.remoteParticipant = participant
                return true
            }
        }
        return false
    }

    func renderRemoteParticipants(participants : Array<RemoteParticipant>) {
        for participant in participants {
            // Find the first renderable track.
            if participant.remoteVideoTracks.count > 0,
                renderRemoteParticipant(participant: participant) {
                break
            }
        }
    }

    func cleanupRemoteParticipant() {
        if self.remoteParticipant != nil {
            self.remoteView?.removeFromSuperview()
            self.remoteView = nil
            self.remoteParticipant = nil
        }
    }
}

// MARK:- UITextFieldDelegate
extension VideoViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.connect(sender: textField)
        return true
    }
}

// MARK:- RoomDelegate
extension VideoViewController : RoomDelegate {
    func roomDidConnect(room: Room) {
        logMessage(messageText: "Connected to room \(room.name) as \(room.localParticipant?.identity ?? "")")

        // This example only renders 1 RemoteVideoTrack at a time. Listen for all events to decide which track to render.
        for remoteParticipant in room.remoteParticipants {
            remoteParticipant.delegate = self
        }
    }

    func roomDidDisconnect(room: Room, error: Error?) {
        logMessage(messageText: "Disconnected from room \(room.name), error = \(String(describing: error))")
        
        self.cleanupRemoteParticipant()
        self.room = nil
        self.navigationController?.popViewController(animated: true)
        self.showRoomUI(inRoom: false)
    }

    func roomDidFailToConnect(room: Room, error: Error) {
        logMessage(messageText: "Failed to connect to room with error = \(String(describing: error))")
        self.room = nil
        self.navigationController?.popViewController(animated: true)
        self.showRoomUI(inRoom: false)
    }

    func roomIsReconnecting(room: Room, error: Error) {
        logMessage(messageText: "Reconnecting to room \(room.name), error = \(String(describing: error))")
    }

    func roomDidReconnect(room: Room) {
        logMessage(messageText: "Reconnected to room \(room.name)")
    }

    func participantDidConnect(room: Room, participant: RemoteParticipant) {
        // Listen for events from all Participants to decide which RemoteVideoTrack to render.
        participant.delegate = self

        logMessage(messageText: "Participant \(participant.identity) connected with \(participant.remoteAudioTracks.count) audio and \(participant.remoteVideoTracks.count) video tracks")
    }

    func participantDidDisconnect(room: Room, participant: RemoteParticipant) {
        logMessage(messageText: "Room \(room.name), Participant \(participant.identity) disconnected")
        self.navigationController?.popViewController(animated: true)

        // Nothing to do in this example. Subscription events are used to add/remove renderers.
    }
}

// MARK:- RemoteParticipantDelegate
extension VideoViewController : RemoteParticipantDelegate {

    func remoteParticipantDidPublishVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        // Remote Participant has offered to share the video Track.
        
        logMessage(messageText: "Participant \(participant.identity) published \(publication.trackName) video track")
    }

    func remoteParticipantDidUnpublishVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        // Remote Participant has stopped sharing the video Track.

        logMessage(messageText: "Participant \(participant.identity) unpublished \(publication.trackName) video track")
    }

    func remoteParticipantDidPublishAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        // Remote Participant has offered to share the audio Track.
        logMessage(messageText: "Participant \(participant.identity) published \(publication.trackName) audio track")
    }

    func remoteParticipantDidUnpublishAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        // Remote Participant has stopped sharing the audio Track.

        logMessage(messageText: "Participant \(participant.identity) unpublished \(publication.trackName) audio track")
    }

    func didSubscribeToVideoTrack(videoTrack: RemoteVideoTrack, publication: RemoteVideoTrackPublication, participant: RemoteParticipant) {
        // The LocalParticipant is subscribed to the RemoteParticipant's video Track. Frames will begin to arrive now.

        logMessage(messageText: "Subscribed to \(publication.trackName) video track for Participant \(participant.identity)")

        if (self.remoteParticipant == nil) {
            _ = renderRemoteParticipant(participant: participant)
        }
    }
    
    func didUnsubscribeFromVideoTrack(videoTrack: RemoteVideoTrack, publication: RemoteVideoTrackPublication, participant: RemoteParticipant) {
        // We are unsubscribed from the remote Participant's video Track. We will no longer receive the
        // remote Participant's video.
        
        logMessage(messageText: "Unsubscribed from \(publication.trackName) video track for Participant \(participant.identity)")

        if self.remoteParticipant == participant {
            cleanupRemoteParticipant()

            // Find another Participant video to render, if possible.
            if var remainingParticipants = room?.remoteParticipants,
                let index = remainingParticipants.firstIndex(of: participant) {
                remainingParticipants.remove(at: index)
                renderRemoteParticipants(participants: remainingParticipants)
            }
        }
    }

    func didSubscribeToAudioTrack(audioTrack: RemoteAudioTrack, publication: RemoteAudioTrackPublication, participant: RemoteParticipant) {
        // We are subscribed to the remote Participant's audio Track. We will start receiving the
        // remote Participant's audio now.
       
        logMessage(messageText: "Subscribed to \(publication.trackName) audio track for Participant \(participant.identity)")
    }
    
    func didUnsubscribeFromAudioTrack(audioTrack: RemoteAudioTrack, publication: RemoteAudioTrackPublication, participant: RemoteParticipant) {
        // We are unsubscribed from the remote Participant's audio Track. We will no longer receive the
        // remote Participant's audio.
        
        logMessage(messageText: "Unsubscribed from \(publication.trackName) audio track for Participant \(participant.identity)")
    }

    func remoteParticipantDidEnableVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        logMessage(messageText: "Participant \(participant.identity) enabled \(publication.trackName) video track")
    }

    func remoteParticipantDidDisableVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        logMessage(messageText: "Participant \(participant.identity) disabled \(publication.trackName) video track")
    }

    func remoteParticipantDidEnableAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        logMessage(messageText: "Participant \(participant.identity) enabled \(publication.trackName) audio track")
    }

    func remoteParticipantDidDisableAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        logMessage(messageText: "Participant \(participant.identity) disabled \(publication.trackName) audio track")
    }

    func didFailToSubscribeToAudioTrack(publication: RemoteAudioTrackPublication, error: Error, participant: RemoteParticipant) {
        logMessage(messageText: "FailedToSubscribe \(publication.trackName) audio track, error = \(String(describing: error))")
    }

    func didFailToSubscribeToVideoTrack(publication: RemoteVideoTrackPublication, error: Error, participant: RemoteParticipant) {
        logMessage(messageText: "FailedToSubscribe \(publication.trackName) video track, error = \(String(describing: error))")
    }
}

// MARK:- VideoViewDelegate
extension VideoViewController : VideoViewDelegate {
    func videoViewDimensionsDidChange(view: VideoView, dimensions: CMVideoDimensions) {
        self.view.setNeedsLayout()
    }
}

// MARK:- CameraSourceDelegate
extension VideoViewController : CameraSourceDelegate {
    func cameraSourceDidFail(source: CameraSource, error: Error) {
        logMessage(messageText: "Camera source failed with error: \(error.localizedDescription)")
    }
}

extension VideoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return   getvidoebyproductIdsdata.count//getvidoebyproductIdsdata.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videoCallollectionViewCell", for: indexPath) as! videoCallollectionViewCell
        let data = getvidoebyproductIdsdata[indexPath.row]
        
        cell.img.pLoadImage(url: data.mainImage ?? "")
        cell.productname.text = data.productName
        cell.aboutproduct.text = data.description
        
        cell.price.text = "NOW " + appDelegate.currencylabel + Utility().formatNumberWithCommas(data.price ?? 0, label:  cell.price)//appDelegate.currencylabel + " \(data.price ?? 0)"

        cell.buynow.addTarget(self, action: #selector(viewproduct(_:)), for: .touchUpInside)
        cell.crossBtn.addTarget(self, action: #selector(crossBtnTapped(_:)), for: .touchUpInside)

  
        if data.onSale == true {
            cell.Salesprice.isHidden = false
            cell.Salesprice.isHidden = false
            cell.Salesprice.text = "NOW " + appDelegate.currencylabel + Utility().formatNumberWithCommas(data.salePrice ?? 0, label:cell.Salesprice)//appDelegate.currencylabel + " \(data.salePrice ?? 0)"
            cell.productPriceLine.isHidden = false
            cell.price.textColor = UIColor.systemGray
            cell.price.text = "WAS " + appDelegate.currencylabel + Utility().formatNumberWithCommas(data.price ?? 0, label:   cell.price)//appDelegate.currencylabel + " \(data.price ?? 0)"
        }else {
            cell.Salesprice.isHidden = true
            cell.productPriceLine.isHidden = true
            cell.price.textColor = UIColor.black
         }

            return cell
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
    self.present(vc, animated: true, completion: nil)
//           self.navigationController?.pushViewController(vc, animated: false)
   
   }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.showCaseCollectionView.frame.width, height: self.showCaseCollectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        let cell = self.showCaseCollectionView.dequeueReusableCell(withIdentifier: "SingleVideoCell") as! SingleVideoCell

//        let data = getvidoebyproductIdsdata[indexPath.row]
//        self.getvidoebyproductIds(productIds: data.productsID ?? [])
        
//        let data = getvidoebyproductIdsdata[indexPath.row]
//
//        
//        let vc = ProductDetail_VC.getVC(.main)
//        vc.isGroupBuy = false
//        vc.slugid = data.slug
//        vc.isCome = true
////        vc.modalPresentationStyle = .
//        self.present(vc, animated: true, completion: nil)
//        
        
        
        
        
//        let vc = ProductDetail_VC.getVC(.main)
//       
//        self.presentedViewController.(vc, animated: false)
    }
//    func getvidoebyproductIds(productIds:String){
//       APIServices.getvidoebyproductIds(productIds:productIds){[weak self] data in
//           switch data{
//           case .success(let res):
////               self?.getvidoebyproductIdsdata = res
////              self?.videoProductCollectionV.reloadData()
//           case .failure(let error):
//               print(error)
//           }
//       }
//   }
    
}


extension VideoViewController {
    
   
    
    func getvidoebyproductIds(productIds:[String]){
       APIServices.getvidoebyproductIds(productIds:productIds){[weak self] data in
           switch data{
           case .success(let res):
              //
               self?.getvidoebyproductIdsdata = res
               self?.showCollectionView = productIds.first!
               self?.showCaseCollectionView.reloadData()
               self?.isHideCollectionView.isHidden = false
           case .failure(let error):
               print(error)
           }
       }
   }
    
    
    func SocketConnect() {
        print("VideoId:MiscId:\(videoCallId)")
        let baseURL = AppConstants.API.baseURLVideoStreamingSocket
        let token = AppDefault.accessToken
        
        print("Connecting to socket at \(baseURL) with token: \(token)")
        
        manager = SocketManager(socketURL:baseURL, config: [.log(true),
                                                                                            .compress,
                                                                                            .forceWebsockets(true),.connectParams( ["token":AppDefault.accessToken,"roomId":videoCallId,"feature":"call"])])
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
    
    
    
    //extension VideoViewController {
    //
    //    func SocketConeect() {
    //
    //        manager = SocketManager(socketURL: AppConstants.API.baseURLVideoStreaming, config: [.log(true),
    //                                                                                  .compress,
    //                                                                                  .forceWebsockets(true),.connectParams( ["token":AppDefault.accessToken])])
    //        socket = manager?.defaultSocket
    //
    //        if((self.socket?.connect()) != nil){
    //
    //        }else{
    //
    //            socket?.connect()
    //        }
    //
    //        socket?.on(clientEvent: .connect) { (data, ack) in
    //
    //            print(self.socket?.status)
    //            print("socketid " + (self.socket?.sid ?? ""))
    //           print("Socket Connected")
    //
    //
    //
    //           }
    //
    //        socket?.on("pushProduct") { data, ack in
    //
    //                print("pushProduct",data)
    //
    //        }
    //
    //        socket?.on(clientEvent: .disconnect) { data, ack in
    //           // Handle the disconnection event
    //           print("Socket disconnected")
    //       }
    //
    //    }
    //
    //
    //}

