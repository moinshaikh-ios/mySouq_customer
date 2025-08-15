//
//  VideoCommentViewController.swift
//  Bazaar Ghar
//
//  Created by Developer on 01/08/2024.
//

import UIKit
import SocketIO

class VideoCommentViewController: UIViewController {
    @IBOutlet weak var commentTblV: UITableView!
    @IBOutlet weak var sendTextFeild: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    var manager:SocketManager?
    var socket: SocketIOClient?
    var commentsData : [CommentsData]?
    var scheduleId : String?
    var commentArray = ["helooo","hdalsjdhkajlsdhkasjdhkasghdkasuhdkagisukdguaksdgkasugdkgkuagsdkuagsdkguaskudgaksdgukasgudkasugd","hi","wahat happend"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendTextFeild.attributedPlaceholder = NSAttributedString(
                  string: "Say something...",
                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
              )
        self.commentTblV.estimatedRowHeight = 50
          self.commentTblV.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.commentTblV.estimatedRowHeight = 50
          self.commentTblV.rowHeight = UITableView.automaticDimension
        initializeSocket(scheduleId: scheduleId ?? "")
        getVideoComments(scheduleId : scheduleId ?? "")
    }
    override func viewWillDisappear(_ animated: Bool) {
        let imageDataDict:[String: String] = ["val": "close"]
        NotificationCenter.default.post(name: Notification.Name("showviews"), object: nil,userInfo: imageDataDict)
    }
    func initializeSocket(scheduleId: String) {
        
            manager = SocketManager(socketURL:
                    URL(string: "https://video-api.mysouq.com")!, config: [.log(true), .compress, .forceWebsockets(true), .connectParams(["roomId": scheduleId])])
       socket   =  manager?.socket(forNamespace: "/")
        socket = manager?.defaultSocket
        setupSocketHandlers()
            socket?.connect()
        
   
        }
    
     func getVideoComments(scheduleId: String){
        APIServices.getvideoComments(scheduleId: scheduleId, completion: {[weak self] data in
            switch data{
            case .success(let res):
               
                self?.commentsData = res
                self?.commentTblV.reloadData()
                if(self?.commentsData?.count != 0){
                    self?.commentTblV.scrollToBottom()
                }
                
               //
                
            case .failure(let error):
                
              print(error)
                
            }
        })
    }
    @IBAction func sendButtonAction(_ sender: Any) {
        if(!AppDefault.islogin) {
                  let vc = PopupLoginVc.getVC(.popups)
                vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
            
        }else{
            let message: [String: Any] = [
                "comment": sendTextFeild.text ?? "",
                "senderId": socket?.sid ?? "",
                 "token": AppDefault.accessToken,
                "scheduleId": scheduleId ?? ""
              ]
            if(sendTextFeild.text?.count != 0){
                socket?.emit("newChatMessage", message)
                sendTextFeild.text = ""
            }else{
                view.makeToast("Enter Some Text")
            }
        }
       
    }
}

extension VideoCommentViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.commentTblV.dequeueReusableCell(withIdentifier: "VideoCommentTableViewCell") as! VideoCommentTableViewCell
        let data = commentsData?[indexPath.row]
        cell.commentLbl.text = data?.comment
        cell.nameLbl.text  =  data?.userName
        return cell
    }
    
   
    
}

extension VideoCommentViewController {
func setupSocketHandlers() {
    socket?.on(clientEvent: .connect) { (data, ack) in
        print("Socket connected: \(data)")
        // Emit a test event to verify communication
   
    }
    
    socket?.on("newChatMessage") { data, ack in
        
        print("Received newChatMessage: \(data)")
        if let first = data.first, let dict = first as? [String: Any] {
                       do {
                           let jsonData = try JSONSerialization.data(withJSONObject: dict, options: [])
                           let chatMessage = try JSONDecoder().decode(CommentsData.self, from: jsonData)
                           self.commentsData?.append(chatMessage)
                           self.commentTblV.reloadData()
                           if(self.commentsData?.count != 0){
                               self.commentTblV.scrollToBottom()
                           }
                       // Reload the table view to display the new comment
                       } catch {
                           print("Error parsing chat message: \(error)")
                       }
                   }
    }
    
    socket?.on(clientEvent: .disconnect) { (data, ack) in
        print("Socket disconnected: \(data)")
    }
    
    socket?.on(clientEvent: .error) { (data, ack) in
        print("Socket error: \(data)")
    }
    
    socket?.on(clientEvent: .statusChange) { (data, ack) in
        print("Socket status changed: \(data)")
    }

    socket?.on("testEventResponse") { data, ack in
        print("Received testEventResponse: \(data)")
    }
}
}
