////
////  ChatServices.swift
////  RGB
////
////  Created by Usama on 27/04/2022.
////
//
//import Foundation
//import Moya
//import Alamofire
//class ChatServices {
//    class func getRoomByUserId(roomName:String,campaignId:Int,pageNo:Int,take:Int,completion:@escaping(APIResult<Rooms>)->Void) {
//        Provider.services.request(.getUserRoomsByUserId(roomName: roomName,campaignId:campaignId, pageNo: pageNo, take: take)) { result in
//            do {
//                let rooms:Rooms =  try result.decoded(keypath: "responseData.data")
//                completion(.success(rooms))
//            }catch {
//                print("Error:- ",error)
//                completion(.failure(error.customDescription))
//            }
//        }
//    }
//
//    class func getCampaignsDdl(allowedOnCampaignsId:String,productId:Int,completion:@escaping(APIResult<CampaignsList>)->Void) {
//        Provider.services.request(.getCampaignsDdl(allowedOnCampaignsId: allowedOnCampaignsId, productId: productId)) { result in
//            do {
//                let campaignList:CampaignsList =  try result.decoded(keypath: "responseData")
//                completion(.success(campaignList))
//            }catch {
//                print("Error:- ",error)
//                completion(.failure(error.customDescription))
//            }
//        }
//    }
//
//    class func getDealersByUser(completion:@escaping(APIResult<[ChatMember]>)->Void) {
//        Provider.services.request(.getDealersByUser) { result in
//            do {
//                let rooms:[ChatMember] =  try result.decoded()
//                completion(.success(rooms))
//            }catch {
//                print("Error:- ",error)
//                completion(.failure(error.customDescription))
//            }
//        }
//    }
//    class func updateBulkFavorite(_ ids:[Int],completion:@escaping(APIResult<Bool>)->Void) {
//        Provider.services.request(.makeRoomFavBulk(ids, isFav: true, hubUserId: /SignalRService.shared.hubId)) { result in
//            do {
//                let code:Int = try result.decoded(keypath: "responseCode")
//                completion(.success(code == 1 ? true : false))
//            }catch {
//                print("Error:- ",error)
//                completion(.failure(error.customDescription))
//            }
//        }
//    }
//
//    class func updateFavorite(_ room:Room,completion:@escaping(APIResult<Bool>)->Void) {
//        Provider.services.request(.makeRoomFav(room)) { result in
//            do {
//                let success:Int = try result.decoded(keypath: "responseCode")
//                completion(.success(success == 1 ? true : false))
//            }catch {
//                print("Error:- ",error)
//                completion(.failure(error.customDescription))
//            }
//        }
//    }
//    class func getChatDetails(room:Room,take:Int,skip:Int, allowedOnCampaignsId: String,completion:@escaping(APIResult<Messages>)->Void) {
//        Provider.services.request(.getChatDetails(room, take: take, skip: skip, allowedOnCampaignsId:allowedOnCampaignsId)) { result in
//            do {
//                let messages:Messages = try result.decoded(keypath: "responseData")
//                completion(.success(messages))
//            }catch {
//                print("Error:- ",error)
//                completion(.failure(error.customDescription))
//            }
//        }
//    }
//    class func uploadFile(file:Data,fileName:String,completion:@escaping(APIResult<String>)->Void) {
//        UIApplication.startActivityIndicator(with: "Uploading")
//        Provider.backgroundServices.request(.uploadFile(file, name: fileName)) { result in
//            UIApplication.stopActivityIndicator()
//            do {
//                let url:String = try result.decoded(keypath: "responseData")
//                completion(.success(url))
//            }catch {
//                print("Error:- ",error)
//                completion(.failure(error.customDescription))
//            }
//        }
//    }
//
//    class func sendMessage(_ message:NewMessage,completion:@escaping(APIResult<Message>)->Void) {
//        Provider.services.request(.sendMessage(message)) { result in
//            do {
//                let message:Message = try result.decoded(keypath: "responseData")
//                completion(.success(message))
//            }catch {
//                print("Error:- ",error)
//                completion(.failure(error.customDescription))
//            }
//        }
//    }
//
//    class func updateCampaignIdInRoom(_ roomId:Int, hubId: Int, campaignId:Int,completion:@escaping(APIResult<Message>)->Void) {
//        Provider.services.request(.updateCampaignIdInRoom(roomId, hubId: hubId, campaignId: campaignId)) { result in
//            do {
//                let message:Message = try result.decoded(keypath: "responseData")
//                completion(.success(message))
//            }catch {
//                print("Error:- ",error)
//                completion(.failure(error.customDescription))
//            }
//        }
//    }
//
//    class func createRoom(_ request:[String:Any],completion:@escaping(APIResult<Bool>)->Void) {
//        Provider.services.request(.createRoom(dict: request)) { result in
//            do {
//                let success:Bool = try result.decoded(keypath: "responseData.success")
//                completion(.success(success))
//            }catch {
//                print("Error:- ",error)
//                completion(.failure(error.customDescription))
//            }
//        }
//    }
//    class func deleteRooms(_ ids:[Int],completion:@escaping(APIResult<Bool>)->Void) {
//        Provider.services.request(.deleteRooms(ids)) { result in
//            do {
//                let code:Int = try result.decoded(keypath: "responseCode")
//                completion(.success(code == 1 ? true : false))
//            }catch {
//                print("Error:- ",error)
//                completion(.failure(error.customDescription))
//            }
//        }
//    }
//}
