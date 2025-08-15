//
//  Services.swift
//  RGB
//
//  Created by usamaghalzai on 15/11/2021.
//  Copyright © 2021 usamaghalzai. All rights reserved.
//

import Moya
import Foundation

import AVFAudio
import UIKit
import SwiftyJSON
import FirebaseAnalytics

class APIServices{
//    static let placeClient = GMSPlacesClient()
    
    class  func createRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        let token = UserDefaults.standard.string(forKey:AppDefault.accessToken) ?? ""
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    class func pretty_function(_ file: String = #file, function: String = #function, line: Int = #line) {
        
        let fileString: NSString = NSString(string: file)
        if Thread.isMainThread {
            print("file:\(fileString.lastPathComponent) function:\(function) line:\(line) [M]")
        } else {
            print("file:\(fileString.lastPathComponent) function:\(function) line:\(line) [T]")
        }
    }
    class func getVideoToken(room:String,token:String,completion:@escaping(APIResult<String>)->Void){
          Provider.services.request(Services.getVideoToken(room: room, token: token)) { result in
              do{
                  let  productDeleteResponse: String =  try result.decoded(keypath: "videoToken")
                  completion(.success(productDeleteResponse))
              }
              catch{
                  print("-----Error------ \n",error)
                  completion(.failure(error.customDescription))
              }
          }
      } 
    class func getvideoComments(scheduleId:String,completion:@escaping(APIResult<[CommentsData]>)->Void){
        Provider.services.request(.getComments(scheduleId:scheduleId)) { result in
              do{
                  let  commentsData: [CommentsData] =  try result.decoded(keypath: "data")
                  completion(.success(commentsData))
              }
              catch{
                  print("-----Error------ \n",error)
                  completion(.failure(error.customDescription))
              }
          }
      } 
    class func customerEndCall(videoId:String,completion:@escaping(APIResult<[ChineseBellResponse]>)->Void){
          Provider.services.request(.customerEndCallApi(videoCallId: videoId)) { result in
              do{
                  let  commentsData: [ChineseBellResponse] =  try result.decoded(keypath: "data")
                  completion(.success(commentsData))
              }
              catch{
                  print("-----Error------ \n",error)
                  completion(.failure(error.customDescription))
              }
          }
      }
//    class func TPHitsApi(val: String,txt: String ,facet_by:String,completion:@escaping(APIResult<[TpResult]>)->Void) {
//        Provider.services.request(.typeSenseApi(val: val, txt: txt,facet_by: facet_by)) { result in
//          do{
//            let categories: [TpResult] = try result.decoded(keypath: "results")
//            completion(.success(categories))
//          }catch{
//              print("-----Error------ \n",error)
//              completion(.failure(error.customDescription))
//          }
//        }
//      }
    class func banner(isbackground:Bool,completion:@escaping(APIResult<[BannerResponse]>)->Void){
        
        
        if(isbackground){
            Provider.backgroundServices.request(.banner){ result in
                do{
                    
                    let banners: [BannerResponse] = try result.decoded(keypath: "data")
                    
                    completion(.success(banners))
                }catch{
                    if(error.customDescription == "Please authenticate" && AppDefault.islogin){
                        appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                    }else if(error.customDescription == "Please authenticate" && AppDefault.islogin == false){
                        DispatchQueue.main.async {
                            appDelegate.GotoDashBoard(ischecklogin: true)
                        }
                    }
                    else{
                        print("-----Error------ \n",error)
                        completion(.failure(error.customDescription))
                    }
                    
                }
            }
        }else{
            Provider.services.request(Services.banner){ result in
                do{
                    
                    let banners: [BannerResponse] = try result.decoded(keypath: "data")
                    
                    completion(.success(banners))
                }catch{
                    if(error.customDescription == "Please authenticate" && AppDefault.islogin){
                        appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                    }else if(error.customDescription == "Please authenticate" && AppDefault.islogin == false){
                        DispatchQueue.main.async {
                            appDelegate.GotoDashBoard(ischecklogin: true)
                        }
                    }
                    else{
                        print("-----Error------ \n",error)
                        completion(.failure(error.customDescription))
                    }
                }
            }
        }
        
        
    }
    class func categories(isbackground:Bool,id:String,limit:Int,completion:@escaping(APIResult<CategoriesMainModel>)->Void){
        
        
        if(isbackground){
            Provider.backgroundServices.request(.categories(id: id, limit: limit)){ result in
                do{
                    
                    let categories: CategoriesMainModel = try result.decoded(keypath: "data")
                    
                    completion(.success(categories))
                }catch{
                    if(error.customDescription == "Please authenticate" && AppDefault.islogin){
                        appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                    }else if(error.customDescription == "Please authenticate" && AppDefault.islogin == false){
                        DispatchQueue.main.async {
                            appDelegate.GotoDashBoard(ischecklogin: true)
                        }
                    }
                    else{
                        print("-----Error------ \n",error)
                        completion(.failure(error.customDescription))
                    }
                }
            }
            
        }else{
            Provider.services.request(.categories(id: id, limit: limit)){ result in
                do{
                    
                    let categories: CategoriesMainModel = try result.decoded(keypath: "data")
                    
                    completion(.success(categories))
                }catch{
                    if(error.customDescription == "Please authenticate" && AppDefault.islogin){
                        appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                    }else if(error.customDescription == "Please authenticate" && AppDefault.islogin == false){
                        DispatchQueue.main.async {
                            appDelegate.GotoDashBoard(ischecklogin: true)
                        }
                    }
                    else{
                        print("-----Error------ \n",error)
                        completion(.failure(error.customDescription))
                    }
                }
            }
            
        }
    }
    
    class func categories2(isbackground:Bool,id:String,limit:Int,completion:@escaping(APIResult<CategoriesResponse>)->Void){
        
        
        if(isbackground){
            Provider.backgroundServices.request(.categories(id: id, limit: limit)){ result in
                do{
                    
                    let categories: CategoriesResponse = try result.decoded(keypath: "data")
                    
                    completion(.success(categories))
                }catch{
                    if(error.customDescription == "Please authenticate" && AppDefault.islogin){
                        appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                    }else if(error.customDescription == "Please authenticate" && AppDefault.islogin == false){
                        DispatchQueue.main.async {
                            appDelegate.GotoDashBoard(ischecklogin: true)
                        }
                    }
                    else{
                        print("-----Error------ \n",error)
                        completion(.failure(error.customDescription))
                    }
                }
            }
            
        }else{
            Provider.services.request(.categories(id: id, limit: limit)){ result in
                do{
                    
                    let categories: CategoriesResponse = try result.decoded(keypath: "data")
                    
                    completion(.success(categories))
                }catch{
                    if(error.customDescription == "Please authenticate" && AppDefault.islogin){
                        appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                    }else if(error.customDescription == "Please authenticate" && AppDefault.islogin == false){
                        DispatchQueue.main.async {
                            appDelegate.GotoDashBoard(ischecklogin: true)
                        }
                    }
                    else{
                        print("-----Error------ \n",error)
                        completion(.failure(error.customDescription))
                    }
                }
            }
            
        }
    }
    
    
    class func getAllCategories(isbackground:Bool,completion:@escaping(APIResult<[getAllCategoryResponse]>)->Void){
        
        
        if(isbackground){
            Provider.backgroundServices.request(.getAllCategories){ result in
                do{
                    
                    let categories: [getAllCategoryResponse] = try result.decoded(keypath: "data")
                    
                    completion(.success(categories))
                }catch{
                    if(error.customDescription == "Please authenticate" && AppDefault.islogin){
                        appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                    }else if(error.customDescription == "Please authenticate" && AppDefault.islogin == false){
                        DispatchQueue.main.async {
                            appDelegate.GotoDashBoard(ischecklogin: true)
                        }
                    }
                    else{
                        print("-----Error------ \n",error)
                        completion(.failure(error.customDescription))
                    }
                }
            }
            
        }else{
            Provider.services.request(.getAllCategories){ result in
                do{
                    
                    let categories: [getAllCategoryResponse] = try result.decoded(keypath: "data")
                    
                    completion(.success(categories))
                }catch{
                    if(error.customDescription == "Please authenticate" && AppDefault.islogin){
                        appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                    }else if(error.customDescription == "Please authenticate" && AppDefault.islogin == false){
                        DispatchQueue.main.async {
                            appDelegate.GotoDashBoard(ischecklogin: true)
                        }
                    }
                    else{
                        print("-----Error------ \n",error)
                        completion(.failure(error.customDescription))
                    }
                }
            }
            
        }
    }
    
    
    
    class func productcategories(cat:String,cat2:String,cat3:String,cat4:String,cat5:String,cat6:String,isbackground:Bool,completion:@escaping(APIResult<[PChat]>)->Void){
        if(isbackground){
            Provider.backgroundServices.request(.productcategories(cat: cat, cat2: cat2, cat3: cat3, cat4: cat4, cat5: cat5, cat6: cat6)){ result in
                do{
                    
                    let categories: [PChat] = try result.decoded(keypath: "data")
                    
                    completion(.success(categories))
                }catch{
                    if(error.customDescription == "Please authenticate" && AppDefault.islogin){
                        appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                    }else if(error.customDescription == "Please authenticate" && AppDefault.islogin == false){
                        DispatchQueue.main.async {
                            appDelegate.GotoDashBoard(ischecklogin: true)
                        }
                    }
                    else{
                        print("-----Error------ \n",error)
                        completion(.failure(error.customDescription))
                    }
                }
            }
        }else{
            Provider.services.request(.productcategories(cat: cat, cat2: cat2, cat3: cat3, cat4: cat4, cat5: cat5, cat6: cat6)){ result in
                do{
                    
                    let categories: [PChat] = try result.decoded(keypath: "data")
                    
                    completion(.success(categories))
                }catch{
                    if(error.customDescription == "Please authenticate" && AppDefault.islogin){
                        appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                    }else if(error.customDescription == "Please authenticate" && AppDefault.islogin == false){
                        DispatchQueue.main.async {
                            appDelegate.GotoDashBoard(ischecklogin: true)
                        }
                    }
                    else{
                        print("-----Error------ \n",error)
                        completion(.failure(error.customDescription))
                    }
                }
            }
        }
        
    }
    
    class func shopchinaproductcategories(cat:String,cat2:String,cat3:String,cat4:String,cat5:String,cat6:String,origin:String,isbackground:Bool,completion:@escaping(APIResult<[PChat]>)->Void){
        if(isbackground){
            Provider.backgroundServices.request(.shopchinaproductcategories(cat: cat, cat2: cat2, cat3: cat3, cat4: cat4, cat5: cat5,cat6:cat6,origin: origin)){ result in
                do{
                    
                    let categories: [PChat] = try result.decoded(keypath: "data")
                    
                    completion(.success(categories))
                }catch{
                    if(error.customDescription == "Please authenticate" && AppDefault.islogin){
                        appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                    }else if(error.customDescription == "Please authenticate" && AppDefault.islogin == false){
                        DispatchQueue.main.async {
                            appDelegate.GotoDashBoard(ischecklogin: true)
                        }
                    }
                    else{
                        print("-----Error------ \n",error)
                        completion(.failure(error.customDescription))
                    }
                }
            }
        }else{
            Provider.services.request(.shopchinaproductcategories(cat: cat, cat2: cat2, cat3: cat3, cat4: cat4, cat5: cat5,cat6:cat6,origin: origin)){ result in
                do{
                    
                    let categories: [PChat] = try result.decoded(keypath: "data")
                    
                    completion(.success(categories))
                }catch{
                    if(error.customDescription == "Please authenticate" && AppDefault.islogin){
                        appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                    }else if(error.customDescription == "Please authenticate" && AppDefault.islogin == false){
                        DispatchQueue.main.async {
                            appDelegate.GotoDashBoard(ischecklogin: true)
                        }
                    }
                    else{
                        print("-----Error------ \n",error)
                        completion(.failure(error.customDescription))
                    }
                }
            }
        }
        
    }

    
    class func randomproduct(cat:String,cat2:String,cat3:String,cat4:String,cat5:String ,isbackground :Bool,completion:@escaping(APIResult<[Product]>)->Void){
        if(isbackground){
            Provider.backgroundServices.request(.productcategories(cat: cat, cat2: cat2, cat3: cat3, cat4: cat4, cat5: cat5, cat6: "")){ result in
                
                do{
                    
                    let categories: [Product] = try result.decoded(keypath: "data")
                    
                    completion(.success(categories))
                }catch{
                    if(error.customDescription == "Please authenticate" && AppDefault.islogin){
                        appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                    }else if(error.customDescription == "Please authenticate" && AppDefault.islogin == false){
                        appDelegate.GotoDashBoard(ischecklogin: true)
                    }
                    else{
                        print("-----Error------ \n",error)
                        completion(.failure(error.customDescription))
                    }
                }
            }
        }else{
            Provider.services.request(.randomproduct){ result in
                
                do{
                    
                    let categories: [Product] = try result.decoded(keypath: "data")
                    
                    completion(.success(categories))
                }catch{
                    if(error.customDescription == "Please authenticate" && AppDefault.islogin){
                        appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                    }else if(error.customDescription == "Please authenticate" && AppDefault.islogin == false){
                        DispatchQueue.main.async {
                            appDelegate.GotoDashBoard(ischecklogin: true)
                        }
                    }
                    else{
                        print("-----Error------ \n",error)
                        completion(.failure(error.customDescription))
                    }
                }
            }
        }
        
    }
    
    class func getrandomproduct(isbackground :Bool,completion:@escaping(APIResult<[Product]>)->Void){
        if(isbackground){
            Provider.backgroundServices.request(.randomproduct){ result in
                
                do{
                    
                    let categories: [Product] = try result.decoded(keypath: "data")
                    
                    completion(.success(categories))
                }catch{
                    if(error.customDescription == "Please authenticate" && AppDefault.islogin){
                        appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                    }else if(error.customDescription == "Please authenticate" && AppDefault.islogin == false){
                        DispatchQueue.main.async {
                            appDelegate.GotoDashBoard(ischecklogin: true)
                        }
                    }
                    else{
                        print("-----Error------ \n",error)
                        completion(.failure(error.customDescription))
                    }
                }
            }
        
        }else {
            Provider.services.request(.randomproduct){ result in
                
                do{
                    
                    let categories: [Product] = try result.decoded(keypath: "data")
                    
                    completion(.success(categories))
                }catch{
                    if(error.customDescription == "Please authenticate" && AppDefault.islogin){
                        appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                    }else if(error.customDescription == "Please authenticate" && AppDefault.islogin == false){
                        DispatchQueue.main.async {
                            appDelegate.GotoDashBoard(ischecklogin: true)
                        }
                    }
                    else{
                        print("-----Error------ \n",error)
                        completion(.failure(error.customDescription))
                    }
                }
            }
        
        }
          
    }
    class func getrandomproduct(isbackground:Bool,origin :String,completion:@escaping(APIResult<[Product]>)->Void){
        if isbackground == true {
            Provider.backgroundServices.request(.shopChinarandomproduct(origin: origin)){ result in
                
                do{
                    
                    let categories: [Product] = try result.decoded(keypath: "data")
                    
                    completion(.success(categories))
                }catch{
                    if(error.customDescription == "Please authenticate" && AppDefault.islogin){
                        appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                    }else if(error.customDescription == "Please authenticate" && AppDefault.islogin == false){
                        DispatchQueue.main.async {
                            appDelegate.GotoDashBoard(ischecklogin: true)
                        }
                    }
                    else{
                        print("-----Error------ \n",error)
                        completion(.failure(error.customDescription))
                    }
                }
            }

        }else {
            Provider.services.request(.shopChinarandomproduct(origin: origin)){ result in
                
                do{
                    
                    let categories: [Product] = try result.decoded(keypath: "data")
                    
                    completion(.success(categories))
                }catch{
                    if(error.customDescription == "Please authenticate" && AppDefault.islogin){
                        appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                    }else if(error.customDescription == "Please authenticate" && AppDefault.islogin == false){
                        DispatchQueue.main.async {
                            appDelegate.GotoDashBoard(ischecklogin: true)
                        }
                    }
                    else{
                        print("-----Error------ \n",error)
                        completion(.failure(error.customDescription))
                    }
                }
            }

        }
    }
    
//    class func typeSenseApi(val: String,txt: String ,facet_by:String,completion:@escaping(APIResult<[TypeSenseResult]>)->Void) {
//        Provider.services.request(.typeSenseApi(val: val, txt: txt,facet_by: facet_by)) { result in
//          do{
//            let categories: [TypeSenseResult] = try result.decoded(keypath: "results")
//            completion(.success(categories))
//          }catch{
//              print("-----Error------ \n",error)
//              completion(.failure(error.customDescription))
//          }
//        }
//      }
    
    class func productcategoriesdetails(slug:String,completion:@escaping(APIResult<ProductCategoriesDetailsResponse>)->Void) {
        Provider.services.request(.productcategoriesdetails(slug: slug)) { result in
            do{
                
                let categories: ProductCategoriesDetailsResponse = try result.decoded(keypath: "data")
                
                Analytics.logEvent("product_page_view", parameters: [
                          "action": "product_page_view",
                          "category": "Ecommerce",
                          "label": "Ecommerce",
                        ])
                
                completion(.success(categories))
            }catch{
                if(error.customDescription == "Please authenticate" && AppDefault.islogin){
                    appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                }else{
                    
                    print("-----Error------ \n",error)
                    completion(.failure(error.customDescription))
                    
                }
            }
        }
    }
    class func orderTracking(id:String,completion:@escaping(APIResult<OrderTrackingResponse>)->Void) {
        Provider.services.request(.orderTrack(id: id)) { result in
            do{
                
                let orderTrack: OrderTrackingResponse = try result.decoded(keypath: "data")
                
                completion(.success(orderTrack))
            }catch{
                if(error.customDescription == "Please authenticate" && AppDefault.islogin){
                    appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                }else{
                    
                    print("-----Error------ \n",error)
                    completion(.failure(error.customDescription))
                    
                }
            }
        }
    }
    
    
    class func getAllProductsByCategories(limit:Int, page:Int,sortBy:String,category:String,active:Bool,user:String,completion:@escaping(APIResult<getAllProductCategoriesMainModel>)->Void){
        Provider.services.request(.getAllProductsByCategories(limit: limit, page: page, sortBy: sortBy, category: category, active: active, user: user)) { result in
            do{
                
                let  getAllProductsByCategories: getAllProductCategoriesMainModel =  try result.decoded(keypath: "data")
                
                completion(.success(getAllProductsByCategories))
            }catch{
                if(error.customDescription == "Please authenticate" && AppDefault.islogin){
                    appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                }else if(error.customDescription == "Please authenticate" && AppDefault.islogin == false){
                    DispatchQueue.main.async {
                        appDelegate.GotoDashBoard(ischecklogin: true)
                    }
                }
                else{
                    print("-----Error------ \n",error)
                    completion(.failure(error.customDescription))
                }
            }
        }
    }
    class func shopChinagetAllProductsByCategories(limit:Int, page:Int,sortBy:String,category:String,active:Bool,origin:String,completion:@escaping(APIResult<getAllProductCategoriesMainModel>)->Void){
        Provider.services.request(.shopchinagetAllProductsByCategories(limit: limit, page: page, sortBy: sortBy, category: category, active: active, origin: origin)) { result in
            do{
                
                let  getAllProductsByCategories: getAllProductCategoriesMainModel =  try result.decoded(keypath: "data")
                
                completion(.success(getAllProductsByCategories))
            }catch{
                if(error.customDescription == "Please authenticate" && AppDefault.islogin){
                    appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                }else if(error.customDescription == "Please authenticate" && AppDefault.islogin == false){
                    DispatchQueue.main.async {
                        appDelegate.GotoDashBoard(ischecklogin: true)
                    }
                }
                else{
                    print("-----Error------ \n",error)
                    completion(.failure(error.customDescription))
                }
            }
        }
    }
    class func getAllProductsByCategoriesbyid(limit:Int, page:Int,sortBy:String,category:String,active:Bool,origin:String,completion:@escaping(APIResult<getAllProductCategoriesMainModel>)->Void){
        Provider.services.request(.getAllProductsByCategoriesbyid(limit: limit, page: page, sortBy: sortBy, category: category, active: active, origin: origin)) { result in
            do{
                
                let  getAllProductsByCategories: getAllProductCategoriesMainModel =  try result.decoded(keypath: "data")
                
                completion(.success(getAllProductsByCategories))
            }catch{
                if(error.customDescription == "Please authenticate" && AppDefault.islogin){
                    appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                }else if(error.customDescription == "Please authenticate" && AppDefault.islogin == false){
                    DispatchQueue.main.async {
                        appDelegate.GotoDashBoard(ischecklogin: true)
                    }
                }
                else{
                    print("-----Error------ \n",error)
                    completion(.failure(error.customDescription))
                }
            }
        }
    }
    class func GetloginOTp(googleId:String,displayName:String,completion:@escaping(APIResult<UserData>)->Void){
        Provider.services.request(.loginwithOtp(googleId:googleId , displayName: displayName)) { result in
            do{
                
                let  res : UserData =  try result.decoded(keypath: "data")
                
                
                
                completion(.success(res))
            }catch{
                if(error.customDescription == "Please authenticate" && AppDefault.islogin){
                    appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                }else if(error.customDescription == "Please authenticate" && AppDefault.islogin == false){
                    DispatchQueue.main.async {
                        appDelegate.GotoDashBoard(ischecklogin: true)
                    }
                }
                else{
                    print("-----Error------ \n",error)
                    completion(.failure(error.customDescription))
                }
            }
        }
    }
    
    class func moreFrom(category:String,user:String,completion:@escaping(APIResult<moreFomDataClass>)->Void){
        Provider.services.request(.moreFrom(category: category, user: user)) { result in
            do{
                
                let  res : moreFomDataClass =  try result.decoded(keypath: "data")
                
                
                
                completion(.success(res))
            }catch{
                if(error.customDescription == "Please authenticate" && AppDefault.islogin){
                    appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                }else if(error.customDescription == "Please authenticate" && AppDefault.islogin == false){
                    DispatchQueue.main.async {
                        appDelegate.GotoDashBoard(ischecklogin: true)
                    }
                }
                else{
                    print("-----Error------ \n",error)
                    completion(.failure(error.customDescription))
                }
            }
        }
    }
    
    class func loginWithGoogleVerification(googleId:String,displayName:String,completion:@escaping(APIResult<UserData>)->Void){
        Provider.services.request(.loginWithGoogleVerification(googleId:googleId , displayName: displayName)) { result in
            do{
                
                let  res : UserData =  try result.decoded(keypath: "data")
                
                
                
                completion(.success(res))
            }catch{
                if(error.customDescription == "Please authenticate" && AppDefault.islogin){
                    appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                }else if(error.customDescription == "Please authenticate" && AppDefault.islogin == false){
                    DispatchQueue.main.async {
                        appDelegate.GotoDashBoard(ischecklogin: true)
                    }
                }
                else{
                    print("-----Error------ \n",error)
                    completion(.failure(error.customDescription))
                }
            }
        }
    }
    class func getLoginGoogle(googleId:String,displayName:String,completion:@escaping(APIResult<UserData>)->Void){
        Provider.services.request(.loginwithgoogle(googleId:googleId , displayName: displayName)) { result in
            do{
                
                let  res : UserData =  try result.decoded(keypath: "data")
                
                
                
                completion(.success(res))
            }catch{
                if(error.customDescription == "Please authenticate" && AppDefault.islogin){
                    appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                }else if(error.customDescription == "Please authenticate" && AppDefault.islogin == false){
                    DispatchQueue.main.async {
                        appDelegate.GotoDashBoard(ischecklogin: true)
                    }
                }
                else{
                    print("-----Error------ \n",error)
                    completion(.failure(error.customDescription))
                }
            }
        }
    }
    
    class func searchproduct(name:String,limit:Int, page:Int,value:String,completion:@escaping(APIResult<[Product]>)->Void){
        Provider.services.request(.searchproduct(name:name,limit: limit, page: page,value: value)) { result in
            do{
                
                let  searchproduct: [Product] =  try result.decoded(keypath: "results")
                
                completion(.success(searchproduct))
            }catch{
                if(error.customDescription == "Please authenticate" && AppDefault.islogin){
                    appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                }else if(error.customDescription == "Please authenticate" && AppDefault.islogin == false){
                    DispatchQueue.main.async {
                        appDelegate.GotoDashBoard(ischecklogin: true)
                    }
                }
                else{
                    print("-----Error------ \n",error)
                    completion(.failure(error.customDescription))
                }
            }
        }
    }
    
    class func searchstore(market:String,name:String,limit:Int, page:Int,value:String,city:String,completion:@escaping(APIResult<searchStoreDataClass>)->Void){
        Provider.services.request(.searchstore(market:market,name:name,limit: limit, page: page,value: value,city: city)) { result in
            do{
                
                let  searchstore: searchStoreDataClass =  try result.decoded(keypath: "data")
                
                completion(.success(searchstore))
            }catch{
                if(error.customDescription == "Please authenticate" && AppDefault.islogin){
                    appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                }else if(error.customDescription == "Please authenticate" && AppDefault.islogin == false){
                    DispatchQueue.main.async {
                        appDelegate.GotoDashBoard(ischecklogin: true)
                    }
                }
                else{
                    print("-----Error------ \n",error)
                    completion(.failure(error.customDescription))
                }
            }
        }
    }
    class func getSellerDetail(id:String,completion:@escaping(APIResult<getSellerDetailDataModel>)->Void){
        Provider.services.request(.getSellerDetail(id: id)) { result in
            do{
                
                let  searchstore: getSellerDetailDataModel =  try result.decoded(keypath: "data")
                
                completion(.success(searchstore))
            }catch{
                if(error.customDescription == "Please authenticate" && AppDefault.islogin){
                    appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                }else if(error.customDescription == "Please authenticate" && AppDefault.islogin == false){
                    DispatchQueue.main.async {
                        appDelegate.GotoDashBoard(ischecklogin: true)
                    }
                }
                else{
                    print("-----Error------ \n",error)
                    completion(.failure(error.customDescription))
                }
            }
        }
    }
    class func searchVideo(name:String,value:String,limit:Int,catId:[String],page:Int,completion:@escaping(APIResult<LiveStreamingResponse>)->Void){
        Provider.services.request(.searchVideo(name:name,value: value,limit: limit, catId: catId,page: page)) { result in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                do{
                    
                    let  searchVideo: LiveStreamingResponse =  try result.decoded(keypath: "data")
                    
                    completion(.success(searchVideo))
                }catch{
                    if(error.customDescription == "Please authenticate" && AppDefault.islogin){
                        appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                    }else if(error.customDescription == "Please authenticate" && AppDefault.islogin == false){
                        DispatchQueue.main.async {
                            appDelegate.GotoDashBoard(ischecklogin: true)
                        }
                    }
                    else{
                        print("-----Error------ \n",error)
                        completion(.failure(error.customDescription))
                    }
                }
            }
            
            
            
        }
    }
    
    class func getCartItems(background:Bool,completion:@escaping(APIResult<CartItemsResponse>)->Void){
        if background == true {
            Provider.backgroundServices.request(.getcartItems) { result in
                do{
                    
                    let  cartData: CartItemsResponse =  try result.decoded(keypath: "data")
                    
                    var kk = 0
                    for i in cartData.packages ?? [] {
                       kk += i.packageItems?.count ?? 0
                    }
                    AppDefault.cartCount = "\(kk)"
                    let imageDataDict:[String: Int] = ["count": kk]
                    NotificationCenter.default.post(name: Notification.Name("cartCount"), object: nil,userInfo: imageDataDict)

                    
                    completion(.success(cartData))
                }catch{
                    
                    print("-----Error------ \n",error)
                    completion(.failure(error.customDescription))
                    
                }
            }
        }else {
            Provider.services.request(.getcartItems) { result in
                do{
                    
                    let  cartData: CartItemsResponse =  try result.decoded(keypath: "data")
                    
                    var kk = 0
                    for i in cartData.packages ?? [] {
                       kk += i.packageItems?.count ?? 0
                    }
                    AppDefault.cartCount = "\(kk)"
                    let imageDataDict:[String: Int] = ["count": kk]
                    NotificationCenter.default.post(name: Notification.Name("cartCount"), object: nil,userInfo: imageDataDict)
                    
                    completion(.success(cartData))
                }catch{
                    
                    print("-----Error------ \n",error)
                    completion(.failure(error.customDescription))
                    
                }
            }
        }
    }
    
    class func useWalletApi(wallet:Bool,completion:@escaping(APIResult<CartItemsResponse>)->Void){
        Provider.services.request(.cartWalletMethod(wallet: wallet)) { result in
            do{
                
                let  cartData: CartItemsResponse =  try result.decoded(keypath: "data")
                
                completion(.success(cartData))
            }catch{
                print("-----Error------ \n",error)
                completion(.failure(error.customDescription))
                
            }
        }
    }
        
        
        
    
    class func followcheck(storeId:String,completion:@escaping(APIResult<String>)->Void){
        Provider.backgroundServices.request(.followcheck(storeId: storeId)) { result in
            
            
            do{
                
                let  cartData: String =  try result.decoded(keypath: "message")
               
                
                completion(.success(cartData))
            }catch{
                
                print("-----Error------ \n",error)
                completion(.failure(error.customDescription))
                
            }
        }
        
        
        
    }
    class func getDeliveryDate(completion:@escaping(APIResult<DeliveryDataClass>)->Void){
        Provider.backgroundServices.request(.getDeliveryDate) { result in
            
            
            do{
                
                let  cartData: DeliveryDataClass =  try result.decoded(keypath: "data")
               
                
                completion(.success(cartData))
            }catch{
                
                print("-----Error------ \n",error)
                completion(.failure(error.customDescription))
                
            }
        }
        
        
        
    }
    class func additemtocart(product:String,quantity:Int,completion:@escaping(APIResult<AddToCartResponse>)->Void){
        Provider.services.request(.addItemtoCart(product:product,quantity: quantity)) { result in
            
            
            do{
                
                let  searchVideo: AddToCartResponse =  try result.decoded(keypath: "data")
                Analytics.logEvent("add_to_cart", parameters: [
                          "action": "add_to_cart",
                          "category": "Ecommerce",
                          "label": "Ecommerce",
                        ])
                
                completion(.success(searchVideo))
            }catch{
                
                print("-----Error------ \n",error)
                completion(.failure(error.customDescription))
                
            }
            
            
            
            
        }
    }
    class func deletePackage(product:String,_package:String,completion:@escaping(APIResult<AddToCartResponse>)->Void){
        Provider.services.request(.deletePackage(productId:product,_package: _package)) { result in
            
            
            do{
                
                let  searchVideo: AddToCartResponse =  try result.decoded(keypath: "data")
                
                completion(.success(searchVideo))
            }catch{
                
                print("-----Error------ \n",error)
                completion(.failure(error.customDescription))
            }
        }
    }
    class func deleteCart(completion:@escaping(APIResult<AddToCartResponse>)->Void){
        Provider.services.request(.deleteCart) { result in
            
            
            do{
                
                let  searchVideo: AddToCartResponse =  try result.decoded(keypath: "data")
                
                completion(.success(searchVideo))
            }catch{
                if(error.customDescription == "Please authenticate" && AppDefault.islogin){
                    appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                }else if(error.customDescription == "Please authenticate" && AppDefault.islogin == false){
                    DispatchQueue.main.async {
                        appDelegate.GotoDashBoard(ischecklogin: true)
                    }
                }
                else{
                    print("-----Error------ \n",error)
                    completion(.failure(error.customDescription))
                }
            }
            
        }
        
    }
    class func citiesResponse(completion:@escaping(APIResult<[CitiesResponse]>)->Void){
        Provider.services.request(.cities) { result in
            
            
            do{
                
                let  searchVideo: [CitiesResponse] =  try result.decoded(keypath: "data")
                
                completion(.success(searchVideo))
            }catch{
                if(error.customDescription == "Please authenticate" && AppDefault.islogin){
                    appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                }else if(error.customDescription == "Please authenticate" && AppDefault.islogin == false){
                    DispatchQueue.main.async {
                        appDelegate.GotoDashBoard(ischecklogin: true)
                    }
                }
                else{
                    print("-----Error------ \n",error)
                    completion(.failure(error.customDescription))
                }
            }
            
            
            
            
        }
    }
    
    class func getaddress(completion:@escaping(APIResult<[DefaultAddress]>)->Void){
        Provider.services.request(.getaddress) { result in
            do{
                
                let  getaddress: [DefaultAddress] =  try result.decoded(keypath: "data")
                
                completion(.success(getaddress))
            }catch{
                
                print("-----Error------ \n",error)
                completion(.failure(error.customDescription))
            }
            
        }
    }
    class func followStore(storeId:String,web:Bool,completion:@escaping(APIResult<FollowedResponse>)->Void){
        Provider.backgroundServices.request(.followStore(storeId: storeId, web: web)) { result in
            do{
                
                let  getaddress: FollowedResponse =  try result.decoded(keypath: "data")
                
                completion(.success(getaddress))
            }catch{
                
                print("-----Error------ \n",error)
                completion(.failure(error.customDescription))
            }
            
        }
    }
    class func unfollowstore(storeId:String,completion:@escaping(APIResult<String>)->Void){
        Provider.backgroundServices.request(.unfollowstore(storeId: storeId)) { result in
            do{
                
                let  getaddress: String =  try result.decoded(keypath: "message")
                
                completion(.success(getaddress))
            }catch{
                
                print("-----Error------ \n",error)
                completion(.failure(error.customDescription))
            }
            
        }
    }
    
    class func addressDelete(addressId:String, completion:@escaping(APIResult<String>)->Void){
        Provider.services.request(.adressdelete(addressId: addressId)) { result in
            do{
                
                let  getaddress: String =  try result.decoded(keypath: "message")
                
                
                completion(.success(getaddress))
                
                
                
                
            }catch{
                if(error.customDescription == "Please authenticate" && AppDefault.islogin){
                    appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                }else if(error.customDescription == "Please authenticate" && AppDefault.islogin == false){
                    DispatchQueue.main.async {
                        appDelegate.GotoDashBoard(ischecklogin: true)
                    }
                }
                else{
                    print("-----Error------ \n",error)
                    completion(.failure(error.customDescription))
                }
            }
            
            
            
            
        }
    }
    
    
    
    class func palceOrder(cartId:String,completion:@escaping(APIResult<OrderResponse>)->Void){
        Provider.services.request(.placeOrder(cartId: cartId)) { result in
            do{
                
                let  orderPlace: OrderResponse =  try result.decoded(keypath: "data")
                
                completion(.success(orderPlace))
            }catch{
                if(error.customDescription == "Please authenticate" && AppDefault.islogin){
                    appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                }else if(error.customDescription == "Please authenticate" && AppDefault.islogin == false){
                    DispatchQueue.main.async {
                        appDelegate.GotoDashBoard(ischecklogin: true)
                    }
                }
                else{
                    print("-----Error------ \n",error)
                    completion(.failure(error.customDescription))
                }
            }
            
            
            
            
        }
    }
    
    class func myorder(limit:Int,sortBy:String,page:Int,completion:@escaping(APIResult<MyOrderResponse>)->Void){
        Provider.services.request(.myOrder(limit: limit,sortBy:sortBy,page:page )) { result in
            do{
                
                let  myOrder: MyOrderResponse =  try result.decoded(keypath: "data")
                
                completion(.success(myOrder))
            }catch{
                
                print("-----Error------ \n",error)
                completion(.failure(error.customDescription))
            }
            
            
            
            
        }
    }
    class func addAddress(fullname:String,phone:String,province:String,city:String,city_code:String,address:String,addressType:String,localType:String,zipCode:String,addressLine_2:String,country:String,area:String,completion:@escaping(APIResult<DefaultAddress>)->Void){
        Provider.services.request(.addAddress(fullname: fullname,phone:phone,province: province,city: city,city_code: city_code,address: address,addressType: addressType,localType: localType,zipCode: zipCode,addressLine_2: addressLine_2,country:country, area: area)) { result in
            do{
                
                let  addAddress: DefaultAddress =  try result.decoded(keypath: "data")
                
                completion(.success(addAddress))
            }catch{
                if(error.customDescription == "Please authenticate" && AppDefault.islogin){
                    appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                }else if(error.customDescription == "Please authenticate" && AppDefault.islogin == false){
                    DispatchQueue.main.async {
                        appDelegate.GotoDashBoard(ischecklogin: true)
                    }
                }
                else{
                    print("-----Error------ \n",error)
                    completion(.failure(error.customDescription))
                }
            }
            
            
            
            
        }
    }
    
    class func updateAddress(addressId:String,fullname:String,phone:String,province:String,city:String,city_code:String,address:String,addressType:String,localType:String,zipCode:String,addressLine_2:String,country:String,completion:@escaping(APIResult<DefaultAddress>)->Void){
        Provider.services.request(.updateAddress(addressId: addressId,fullname: fullname,phone:phone,province: province,city: city,city_code: city_code,address: address,addressType: addressType,localType: localType,zipCode: zipCode,addressLine_2: addressLine_2,country:country)) { result in
            do{
                
                let  updateAddress: DefaultAddress =  try result.decoded(keypath: "data")
                
                completion(.success(updateAddress))
            }catch{
                if(error.customDescription == "Please authenticate" && AppDefault.islogin){
                    appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                }else if(error.customDescription == "Please authenticate" && AppDefault.islogin == false){
                    DispatchQueue.main.async {
                        appDelegate.GotoDashBoard(ischecklogin: true)
                    }
                }
                else{
                    print("-----Error------ \n",error)
                    completion(.failure(error.customDescription))
                }
            }
            
        }
    }
    
    class func wishlist(isbackground:Bool ,completion:@escaping(APIResult<WishlistResponse>)->Void){
        if(isbackground){
            Provider.backgroundServices.request(.wishList) { result in
                do{
                    
                    let  wishList: WishlistResponse =  try result.decoded(keypath: "data")
                    Analytics.logEvent("add_to_wishlist", parameters: [
                                "action": "add_to_wishlist",
                                "category": "Ecommerce",
                                "label": "Ecommerce",
                              ])
                    completion(.success(wishList))
                }catch{
                    
                    print("-----Error------ \n",error)
                    completion(.failure(error.customDescription))
                    
                }
                
                
                
                
            }
        }else{
            Provider.services.request(.wishList) { result in
                do{
                    
                    let  wishList: WishlistResponse =  try result.decoded(keypath: "data")
                    
                    completion(.success(wishList))
                }catch{
                    
                    print("-----Error------ \n",error)
                    completion(.failure(error.customDescription))
                    
                }
                
                
                
                
            }
        }
        
    }
    
    class func newwishlist(product:String,completion:@escaping(APIResult<String>)->Void){
        Provider.services.request(.newishlist(product: product)) { result in
          do{
            let data: String = try result.decoded(keypath: "message")
            completion(.success(data))
          }catch{
            print("-----Error------ \n",error)
            completion(.failure(error.customDescription))
          }
        }
      }
    
    
    class func addwishlist(proudct:String,completion:@escaping(APIResult<String>)->Void){
        Provider.services.request(.addwishList(product: proudct)) { result in
            do{
                
                let  addwishList: String =  try result.decoded(keypath: "message")
                
                completion(.success(addwishList))
            }catch{
                if(error.customDescription == "Please authenticate" && AppDefault.islogin){
                    appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                }else if(error.customDescription == "Please authenticate" && AppDefault.islogin == false){
                    DispatchQueue.main.async {
                        appDelegate.GotoDashBoard(ischecklogin: true)
                    }
                }
                else{
                    print("-----Error------ \n",error)
                    completion(.failure(error.customDescription))
                }
            }
        }
    }
    class func checkoutpayment(token: String, amount: Double, currency: String, cartId: String,completion:@escaping(APIResult<CheckoutResponseModel>)->Void){
        Provider.services.request(.cardpaymentApi(token: token, amount: amount, currency: currency, cartId: cartId)) { result in
           do{
             let commentsData: CheckoutResponseModel = try result.decoded(keypath: "data")
             completion(.success(commentsData))
           }
           catch{
             print("-----Error------ \n",error)
             completion(.failure(error.customDescription))
           }
         }
    }
    class func payment3dsApi(token: String, amount: Double, currency: String, cartId: String,completion:@escaping(APIResult<checkout3dsReponse>)->Void){
        Provider.services.request(.payment3ds(token: token, amount: amount, currency: currency, cartId: cartId)) { result in
           do{
             let commentsData: checkout3dsReponse = try result.decoded(keypath: "data")
             completion(.success(commentsData))
           }
           catch{
             print("-----Error------ \n",error)
             completion(.failure(error.customDescription))
           }
         }
    }
    class func hotdealsPorductApi(id:String,completion:@escaping(APIResult<[HotDealsResponseData]>)->Void){
        Provider.services.request(.hotdealsapiproduct(id: id)) { result in
           do{
             let commentsData: [HotDealsResponseData] = try result.decoded(keypath: "data")
             completion(.success(commentsData))
           }
           catch{
             print("-----Error------ \n",error)
             completion(.failure(error.customDescription))
           }
         }
    }
    class func hotdeals(completion:@escaping(APIResult<HotDealsResponse>)->Void){
        Provider.services.request(.hotdealsapi) { result in
           do{
             let commentsData: HotDealsResponse = try result.decoded(keypath: "data")
             completion(.success(commentsData))
           }
           catch{
             print("-----Error------ \n",error)
             completion(.failure(error.customDescription))
           }
         }
       }
    class func removeWishList(product:String,completion:@escaping(APIResult<RemoveWishListResponse>)->Void){
        Provider.services.request(.wishListRemove(product: product)) { result in
            do{
                
                let  removewishListitem: RemoveWishListResponse =  try result.decoded(keypath: "data")
                
                completion(.success(removewishListitem))
            }catch{
                if(error.customDescription == "Please authenticate" && AppDefault.islogin){
                    appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                }else if(error.customDescription == "Please authenticate" && AppDefault.islogin == false){
                    DispatchQueue.main.async {
                        appDelegate.GotoDashBoard(ischecklogin: true)
                    }
                }
                else{
                    print("-----Error------ \n",error)
                    completion(.failure(error.customDescription))
                }
            }
            
            
            
            
        }
    }
    
    
    class func defaultAdrress(addressId:String,cartId:String, completion:@escaping(APIResult<String>)->Void){
        Provider.services.request(.defaultAdrress(addressId: addressId, cartId: cartId)) { result in
            do{
                
                let  defaultAdrress: String =  try result.decoded(keypath: "message")
                
                completion(.success(defaultAdrress))
                
                
            }catch{
                if(error.customDescription == "Please authenticate" && AppDefault.islogin){
                    appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                }else if(error.customDescription == "Please authenticate" && AppDefault.islogin == false){
                    DispatchQueue.main.async {
                        appDelegate.GotoDashBoard(ischecklogin: true)
                    }}
                else{
                    print("-----Error------ \n",error)
                    completion(.failure(error.customDescription))
                }
            }
            
        }
    }
    class func personaldetail(fullname:String,email:String,userid:String,agreement:String,completion:@escaping(APIResult<CurrentUser>)->Void){
        Provider.services.request(.personaldetail(fullname: fullname, email: email, userid: userid, agreement: agreement)) { result in
            do{
                
                let  personaldetail: CurrentUser =  try result.decoded(keypath: "data")
                
                completion(.success(personaldetail))
            }catch{
                if(error.customDescription == "Please authenticate" && AppDefault.islogin){
                    appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                }else if(error.customDescription == "Please authenticate" && AppDefault.islogin == false){
                    DispatchQueue.main.async {
                        appDelegate.GotoDashBoard(ischecklogin: true)
                    }}
                else{
                    print("-----Error------ \n",error)
                    completion(.failure(error.customDescription))
                }
            }
            
        }
    }
    
    class func collectionDataApi(limit:Int,page:Int,collectionId:String,completion:@escaping(APIResult<[CollectionData]>)->Void){
        Provider.services.request(.collectionDataApi(limit:limit , page: page, collectionId: collectionId)){ result in
            do{
                
                let  offersPageData: [CollectionData] =  try result.decoded(keypath: "data")
                
                completion(.success(offersPageData))
            }catch{
                    print("-----Error------ \n",error)
                    completion(.failure(error.customDescription))
                
            }
            
        }
    }
    
    
    class func getStreamingVideos(limit:Int,page:Int,categories:[String],userId:String,city:String,completion:@escaping(APIResult<LiveStreamingData>)->Void) {
        Provider.backgroundServices.request(.getStreamingVideos(limit:limit,page:page,categories: categories,userId: userId, city: city)) { result in
            do{
                
                let getStreamingVideos: LiveStreamingData = try result.decoded(keypath: "data")
                
                completion(.success(getStreamingVideos))
            }catch{
                if(error.customDescription == "Please authenticate" && AppDefault.islogin){
                    appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                }else if(error.customDescription == "Please authenticate" && AppDefault.islogin == false){
                    DispatchQueue.main.async {
                        appDelegate.GotoDashBoard(ischecklogin: true)
                    }
                }
                else{
                    print("-----Error------ \n",error)
                    completion(.failure(error.customDescription))
                }
            }
        }
    }
    class func refreshToken(refreshToken:String,completion:@escaping(APIResult<UserData>)->Void) {
        Provider.services.request(.refreshToken(refreshToken: refreshToken)){ result in
            do{
                
                let refreshToken: UserData = try result.decoded(keypath: "data")
                
                completion(.success(refreshToken))
            }catch{
                print("-----Error------ \n",error)
                completion(.failure(error.customDescription))
                
            }
        }
    }
    class func getvidoebyproductIds(productIds:[String],completion:@escaping(APIResult<[Product]>)->Void) {
        Provider.backgroundServices.request(.getvidoebyproductIds(productIds: productIds)){ result in
            do{
                
                let getvidoebyproductIds: [Product] = try result.decoded(keypath: "data")
                
                completion(.success(getvidoebyproductIds))
            }catch{
                
                print("-----Error------ \n",error)
                completion(.failure(error.customDescription))
                
            }
        }
    }
    class func groupByDeals(limit:Int,page:Int,isbackground :Bool,completion:@escaping(APIResult<GroupByDataModel>)->Void) {
        
        if(isbackground){
            Provider.backgroundServices.request(.groupByDeals(limit: limit, page: page)){ result in
                do{
                    
                    let groupByDeals: GroupByDataModel = try result.decoded(keypath: "data")
                    
                    completion(.success(groupByDeals))
                }catch{
                    
                    print("-----Error------ \n",error)
                    completion(.failure(error.customDescription))
                    
                }
            }
            
        }else{
            Provider.services.request(.groupByDeals(limit: limit, page: page)){ result in
                do{
                    
                    let groupByDeals: GroupByDataModel = try result.decoded(keypath: "data")
                    
                    completion(.success(groupByDeals))
                }catch{
                    
                    print("-----Error------ \n",error)
                    completion(.failure(error.customDescription))
                    
                }
                
            }
        }
        
    }
    
    class func chinesebell(sellerId:String,brandName:String,description:String,completion:@escaping(APIResult<ChineseBellResponse>)->Void) {
        Provider.services.request(.chinesebell(sellerId: sellerId, brandName: brandName, description: description)){ result in
            do{
                
                let chinesebell: ChineseBellResponse = try result.decoded(keypath: "data")
                
                completion(.success(chinesebell))
            }catch{
                
                print("-----Error------ \n",error)
                completion(.failure(error.customDescription))
                
            }
        }
    }
    
    class func pushnotificationapi(completion:@escaping(APIResult<Bool>)->Void){
        Provider.services.request(.pushnotificationapi) { result in
            do{
                
                completion(.success(true))
            }
            catch{
                print("-----Error------ \n",error)
                completion(.failure(error.customDescription))
            }
        }
    }
    
    class func deleteAccount(userId:String,status:String,completion:@escaping(APIResult<CurrentUser>)->Void) {
        Provider.services.request(.deleteAccount(userId: userId, status: status)){ result in
            do{
                
                let deleteAccount: CurrentUser = try result.decoded(keypath: "data")
                
                completion(.success(deleteAccount))
            }catch{
                
                print("-----Error------ \n",error)
                completion(.failure(error.customDescription))
                
            }
        }
    }
    class func appleLogin(token:String,completion:@escaping(APIResult<DataClasss>)->Void) {
        Provider.services.request(.appleLogin(token: token)){ result in
            do{
                let appleLogin: DataClasss = try result.decoded(keypath: "data")
                completion(.success(appleLogin))
            }catch{
                
                print("-----Error------ \n",error)
                completion(.failure(error.customDescription))
                
            }
        }
    }
    
    class func report(comment:String,videoId:String,completion:@escaping(APIResult<ReportDataModel>)->Void) {
        Provider.services.request(.report(comment: comment, videoId: videoId)){ result in
            do{
                let report: ReportDataModel = try result.decoded(keypath: "data")
                completion(.success(report))
            }catch{
                
                print("-----Error------ \n",error)
                completion(.failure(error.customDescription))
                
            }
        }
    }
    
    class func savelike(token:String,scheduleId:String,userId:String,completion:@escaping(APIResult<SavelikeDataClass>)->Void) {
        Provider.services.request(.savelike(token: token, scheduleId: scheduleId, userId: userId)){ result in
            do{
                let savelike: SavelikeDataClass = try result.decoded(keypath: "data")
                completion(.success(savelike))
            }catch{
                
                print("-----Error------ \n",error)
                completion(.failure(error.customDescription))
                
            }
        }
    }
    
    class func deletelike(token:String,scheduleId:String,userId:String,likeId:String,completion:@escaping(APIResult<SavelikeDataClass>)->Void) {
        Provider.services.request(.deletelike(token: token, scheduleId: scheduleId, userId: userId, likeId: likeId)){ result in
            do{
                let savelike: SavelikeDataClass = try result.decoded(keypath: "data")
                completion(.success(savelike))
            }catch{
                
                print("-----Error------ \n",error)
                completion(.failure(error.customDescription))
                
            }
        }
    }
    
    class func getLike(scheduleId:String,userId:String,completion:@escaping(APIResult<GetLikeDataClass>)->Void) {
        Provider.services.request(.getLike(scheduleId: scheduleId, userId: userId)){ result in
            do{
                let getLike: GetLikeDataClass = try result.decoded(keypath: "data")
                completion(.success(getLike))
            }catch{
                print("-----Error------ \n",error)
                completion(.failure(error.customDescription))
                
            }
        }
    }
    
    
    class func getLiveStream(completion:@escaping(APIResult<[LiveStreamingResults]>)->Void) {
        Provider.backgroundServices.request(.getLiveStream){ result in
            do{
                let getLiveStream: [LiveStreamingResults] = try result.decoded(keypath: "data")
                completion(.success(getLiveStream))
            }catch{
                print("-----Error------ \n",error)
                completion(.failure(error.customDescription))
                
            }
        }
    }
    
    class func shopchinaStreamingVideo(isBackground:Bool,origin:String,completion:@escaping(APIResult<ShopChinaStreaminVideoDataModel>)->Void) {
        if isBackground == true{
            Provider.backgroundServices.request(.shopchinaStreamingVideo(origin: origin)){ result in
                do{
                    let appleLogin: ShopChinaStreaminVideoDataModel = try result.decoded(keypath: "data")
                    completion(.success(appleLogin))
                }catch{
                    print("-----Error------ \n",error)
                    completion(.failure(error.customDescription))
                }
            }
        }else {
            Provider.services.request(.shopchinaStreamingVideo(origin: origin)){ result in
                do{
                    let appleLogin: ShopChinaStreaminVideoDataModel = try result.decoded(keypath: "data")
                    completion(.success(appleLogin))
                }catch{
                    print("-----Error------ \n",error)
                    completion(.failure(error.customDescription))
                }
            }
        }
    }
    
    class func getprovince(countryCode:String,language:String,checkCache:Bool,completion:@escaping(APIResult<ProvinceDataModel>)->Void){
        Provider.services.request(.getprovince(countryCode: countryCode, language: language, checkCache: checkCache)) { result in
            do{
                
                let  personaldetail: ProvinceDataModel =  try result.decoded(keypath: "data")
                
                completion(.success(personaldetail))
            }catch{
                if(error.customDescription == "Please authenticate" && AppDefault.islogin){
                    appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                }else if(error.customDescription == "Please authenticate" && AppDefault.islogin == false){
                    DispatchQueue.main.async {
                        appDelegate.GotoDashBoard(ischecklogin: true)
                    }}
                else{
                    print("-----Error------ \n",error)
                    completion(.failure(error.customDescription))
                }
            }
            
        }
    }
    class func cancelOrder(order:String,name:String,completion:@escaping(APIResult<String>)->Void){
        Provider.services.request(.cancelOrder(order: order, name: name)) { result in
            do{
                let  personaldetail: String =  try result.decoded(keypath: "message")
                
                completion(.success(personaldetail))
            }catch{
                print("-----Error------ \n",error)
                completion(.failure(error.customDescription))
            }
        }
    }
    
    class func refCodeApi(refCodee:String,completion:@escaping(APIResult<CoupenCartItemsResponse>)->Void){
        Provider.services.request(.refCode(refCode: refCodee)) { result in
            do{
                let  personaldetail: CoupenCartItemsResponse =  try result.decoded(keypath: "data")
                completion(.success(personaldetail))
            }catch{
                if(error.customDescription == "Please authenticate" && AppDefault.islogin){
                    appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                }else if(error.customDescription == "Please authenticate" && AppDefault.islogin == false){
                    DispatchQueue.main.async {
                        appDelegate.GotoDashBoard(ischecklogin: true)
                    }
                }
                else{
                    print("-----Error------ \n",error)
                    completion(.failure(error.customDescription))
                }
            }
            
        }
    }
    
    class func videoCountApi(slug:String,completion:@escaping(APIResult<LiveStreamingResults>)->Void){
        Provider.services.request(.videoCount(slug: slug)) { result in
            do{
                let  personaldetail: LiveStreamingResults =  try result.decoded(keypath: "data")
                completion(.success(personaldetail))
            }catch{
                if(error.customDescription == "Please authenticate" && AppDefault.islogin){
                    appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                }else if(error.customDescription == "Please authenticate" && AppDefault.islogin == false){
                    DispatchQueue.main.async {
                        appDelegate.GotoDashBoard(ischecklogin: true)
                    }
                }
                else{
                    print("-----Error------ \n",error)
                    completion(.failure(error.customDescription))
                }
            }
            
        }
    }
    
}
class DashboardManager {
    static let shared = DashboardManager()
    
    private lazy var tabBarViewController: TabBarViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController else {
            fatalError("Unable to instantiate TabBarViewController")
        }
        return viewController
    }()
    
    func goToDashboard(ischecklogin: Bool) {
        // Set the login status
        tabBarViewController.ischecklogin = ischecklogin
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        // Dismiss any presented view controllers before setting the root view controller
        appDelegate.window?.rootViewController?.dismiss(animated: false, completion: nil)
        
        // Set the root view controller of the window
        appDelegate.window?.rootViewController = tabBarViewController
        
        // Make the window visible
        appDelegate.window?.makeKeyAndVisible()
    }
    
    // Ensure that the instance of TabBarViewController is deallocated when it's no longer needed
    deinit {
        print("DashboardManager deallocated")
    }
}
