//
//  Inbox_VC.swift
//  bazaar Ghar
//
//  Created by Umair ALi on 25/08/2023.
//

import UIKit
import SocketIO
import SwiftyJSON

class Inbox_VC: UIViewController {
    @IBOutlet weak var Inbox_tableview: UITableView!
    @IBOutlet weak var emptyLbl: UILabel!

  
  
    var manager:SocketManager?
    var socket: SocketIOClient?
    var isrelaoddaataa = false
    
   
    var messages: [PMsg]? = nil{
        didSet{
           
     
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true

        Inbox_tableview.dataSource  = self
        Inbox_tableview.delegate = self
        self.connectSocket()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.Inbox_tableview.reloadData()
    
    }
    override func viewWillDisappear(_ animated: Bool) {
     
    }
    @IBAction func backBtnTapped(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
        self.navigationController?.popViewController(animated: true)
    }
    
//    deinit {
//            // Disconnect the socket when the view controller is deallocated
//        socket?.disconnect()
//        }
    
}
extension Inbox_VC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Inbox_TableViewCell", for: indexPath) as! Inbox_TableViewCell
        let data = messages?[indexPath.row]
        if messages?.count ?? 0 > 0 {
            emptyLbl.isHidden = true
        }else {
            emptyLbl.isHidden = false
        }
        cell.inbox_lbl.text = data?.idarray?.brandName
        if let formattedDate = Utility().convertDateString(data?.idarray?.createdAt ?? "", fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", toFormat: "dd MMM yyyy") {
            print(formattedDate) // Output: April 18, 2024 05:24 AM
            cell.inbox_date.text = formattedDate
        }
        cell.selectionStyle = .none
        cell.namelbl.text = data?.idarray?.brandName.first?.description ?? ""
        if(data?.unreadCount ?? 0 > 0){
            cell.lblcount.isHidden = false
           
            if(data?.unreadCount ?? 0 > 9){
                cell.lblcount.text =  "9+"
            }else{
                cell.lblcount.text = "\(data?.unreadCount ?? 0)"
            }
        }else{
            cell.lblcount.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var ispass = false
        self.isrelaoddaataa = true
        let data = messages?[indexPath.row]
        self.socket?.emit("room-join", ["brandName":data?.idarray?.brandName ?? "","customerId":AppDefault.currentUser?.id ?? "","isSeller":false,"sellerId":data?.idarray?.sellerId ?? "","storeId":data?.idarray?.storeId ?? "","options":["page":1,"limit":200]])
        self.socket?.on("room-join") { datas, ack in
            if let rooms = datas[0] as? [String: Any]{
                
              
                let obj = PuserMainModel(jsonData: JSON(rawValue: rooms)!)
                
                
                print(obj)
                if(ispass == false){
                    let vc = ChatViewController.getVC(.chatBoard)
                    vc.socket = self.socket
                    vc.manager = self.manager
                    vc.messages = data
                    vc.latestMessages = obj.messages.chat
                    vc.PuserMainArray = obj
                    vc.newChat = false
                    self.navigationController?.pushViewController(vc, animated: true)
                    ispass = true
                }
            }
        }
        
     
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
extension Inbox_VC{
    
    
    
     func connectSocket() {
        
         
         
       
         manager = SocketManager(socketURL: AppConstants.API.baseURLChat, config: [.log(true),
                                                                                   .compress,
                                                                                   .forceWebsockets(true),.connectParams( ["token":AppDefault.accessToken])])
         socket = manager?.socket(forNamespace: "/chat/v1/message")
 
        
         if((self.socket?.connect()) != nil){
             
         }else{
          
             socket?.connect()
         }
        
        
         socket?.on(clientEvent: .connect) { (data, ack) in
           
            
            
             self.socket?.emit("allUnread", ["userId":AppDefault.currentUser?.id ?? ""])
             print(self.socket?.status)
             print("socketid " + (self.socket?.sid ?? ""))
            print("Socket Connected")
            
        
            
            }
            
        
    
        self.socket?.on("allUnread") { data, ack in
            if let rooms = data[0] as? [[String: Any]]{
              print(rooms)
                
                
                
                
                
                
                var messageItem:[PMsg] = []
                let Datamodel = JSON(rooms)
                let message = Datamodel.array
                
                for item in message ?? []{
                    
                    messageItem.append(PMsg(jsonData: item))
                }
                
                print(messageItem)
                   
                self.messages = messageItem
                
                
                self.Inbox_tableview.reloadData()
                
              
               
                
            }
        }
         
         
         
//         self.socket?.on("unread") { data, ack in
//             if let rooms = data[0] as? [[String: Any]]{
//                 print(rooms)
//             }
//         }
//         self.socket?.on("newChatMessage") { data, ack in
//             if let rooms = data[0] as? [[String: Any]]{
//                 print(rooms)
//             }
//         }
//         }
//         self.socket?.on("messages") { data, ack in
//             if let rooms = data[0] as? [[String: Any]]{
//                 print(rooms)
//             }
//         }
         
         
         
         socket?.on(clientEvent: .disconnect) { data, ack in
            // Handle the disconnection event
            print("Socket disconnected")
        }
        
        
      
    
       
    }
   
  
    
    
}
