//
//  AppDelegate.swift
//  Bazaar Ghar
//
//  Created by Developer on 18/08/2023.
//

import UIKit
import FirebaseCore
import UserNotifications
import IQKeyboardManagerSwift
import Presentr
import FirebaseAuth
import FirebaseMessaging
import UserNotifications
import AuthenticationServices
import Firebase
import FirebaseAnalytics
import FBSDKCoreKit


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
var slugid = String()
    var isback = false
    var verifyid = String()
    var phoneno = String()
    var videotoken = String()
    var videoid = String()
    var phonenowithout = String()
    var isbutton = Bool()
    let settings = FBSDKCoreKit.Settings.shared
    var currencyFont: UIFont?
    var font : UIFont? = UIFont(name: "custom-icons", size: 17)
    var currencylabel = ""
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
      var fcmtoken = String()
   

    var shouldUseCustomFont : Bool? {
        didSet {
            if let rootView = window?.rootViewController?.view {
                rootView.setAllLabelsFontConditionally(useCustomFont: shouldUseCustomFont ?? true)
            }
        }
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        
        
            
        
        
        
        
        UITabBar.appearance().tintColor = UIColor(named: "headercolor")

        AppDefault.allfacetString = ""
        AppDefault.facetFilterArray = []
        // Override point for customization after application launch.
        IQKeyboardManager.shared.toolbarConfiguration.placeholderConfiguration.showPlaceholder = false

//        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
      
        
      FirebaseApp.configure()
      registerForPushNotifications()
        
        
        if AppDefault.getAllCategoriesResponsedata?.count ?? 0 > 0{
            
        }else{
            self.onBoardingVc()
        }
        
        if AppDefault.languages == "en" {
             LanguageManager.language = AppDefault.languages

        }else {
            LanguageManager.language = AppDefault.languages
        }
        
        let token = Messaging.messaging().fcmToken
        print("_____________dt\(token)")
        Messaging.messaging().delegate = self
            
              UNUserNotificationCenter.current().delegate = self
              let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
              UNUserNotificationCenter.current().requestAuthorization(
               options: authOptions,
               completionHandler: { _, _ in }
              )
              application.registerForRemoteNotifications()
        settings.isAdvertiserTrackingEnabled = true
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.resignOnTouchOutside = true // Dismiss keyboard on tap

        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        AppDefault.languages = LanguageManager.language
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
         // Handle Facebook URL
         let facebookHandled = ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
         // You can add custom URL handling here
         return facebookHandled
       }
    
    func savechanges(fullname: String,email:String,userid:String,agreement:String){
        APIServices.personaldetail(fullname: fullname, email: email, userid: userid, agreement: agreement, completion:{ [weak self] data in
            switch data {
            case .success(let res):
                print("save agreemrnt : \(res)")
//                AppDefault.currentUser = res
            case .failure(let error):
                print(error)
                UIApplication.pTopViewController().view.makeToast(error)
            }
        })
     }
    
     func refreshToken(refreshToken:String){
        APIServices.refreshToken(refreshToken:refreshToken){[weak self] data in
            switch data{
            case .success(let res):
                
                AppDefault.currentUser = res.user
                AppDefault.accessToken  = res.tokens?.access?.token ?? ""
                AppDefault.refreshToken = res.tokens?.refresh?.token ?? ""
                AppDefault.islogin = true
                DispatchQueue.main.async {
                    self?.GotoDashBoard(ischecklogin: false)
                }
            case .failure(let error):
                print(error)
                
                if(error == "Token not found"){
                    AppDefault.islogin = false
                    AppDefault.accessToken = ""
                    AppDefault.wishlistproduct?.removeAll()
                    appDelegate.GotoDashBoard(ischecklogin: false)
                }
                let vc = PopupLoginVc.getVC(.popups)
                   vc.modalPresentationStyle = .overFullScreen
                UIApplication.topViewController()?.present(vc, animated: true)
//                UIApplication.topViewController()?.view.makeToast(error)
            }
        }
    }
    
    func videoCountAPI(isbackground:Bool,slug:String) {
        APIServices.videoCountApi(slug: slug,completion: {[weak self] data in
            switch data {
            case .success(let res):
                let viewData:[String: Any] = ["data": res]
                NotificationCenter.default.post(name: Notification.Name("updateview"), object: nil,userInfo: viewData)
              print(res)
            case .failure(let error):
                print(error)
//                self?.view.makeToast(error)
            }
        })
    }

    private func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            // 1. Check to see if permission is granted
            guard granted else { return }
            // 2. Attempt registration for remote notifications on the main thread
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    func onBoardingVc() {

        guard let tabBarViewController = UIStoryboard(name: "sidemenu", bundle: nil).instantiateViewController(withIdentifier: "Shake_ViewController") as? Shake_ViewController else {
            // Failed to instantiate TabBarViewController
            return
        }
        
      
       
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                // Failed to get AppDelegate
                return
            }
            
         
            appDelegate.window?.rootViewController?.dismiss(animated: false, completion: nil)
            
            appDelegate.window?.rootViewController = tabBarViewController
    }
  
    func GotoDashBoard(ischecklogin: Bool) {
        

        guard let tabBarViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RoundTabbarVc") as? RoundTabbarVc else {
            // Failed to instantiate TabBarViewController
            return
        }
        
        // Set the login status
        tabBarViewController.ischecklogin = ischecklogin
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                // Failed to get AppDelegate
                return
            }
            
            // Dismiss any presented view controllers before setting the root view controller
            appDelegate.window?.rootViewController?.dismiss(animated: false, completion: nil)
            
            appDelegate.window?.rootViewController = tabBarViewController
    }
     func GotoDashBoardnotification(ischecklogin: Bool,misc: String){
        
        // Load the TabBarViewController from the Main storyboard
        guard let tabBarViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RoundTabbarVc") as? RoundTabbarVc else {
            // Failed to instantiate TabBarViewController
            return
        }
        
        // Set the login status
        tabBarViewController.ischecklogin = ischecklogin
        tabBarViewController.miscid = misc
        
         guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                 // Failed to get AppDelegate
                 return
             }
             
             // Dismiss any presented view controllers before setting the root view controller
             appDelegate.window?.rootViewController?.dismiss(animated: false, completion: nil)
             
             appDelegate.window?.rootViewController = tabBarViewController
    }
       
    
    func showCustomerAlertControllerHeight(title:String,heading:String,btn1Title:String,btn1Callback:@escaping()->Void,btn2Title:String,btn2Callback:@escaping()->Void){
        guard let vc = UIStoryboard(name: "Popups", bundle: nil).instantiateViewController(withIdentifier: String(describing: PCustomAlertController.self)) as? PCustomAlertController else {return}
        let presenter = Presentr(presentationType: .custom(width: .fluid(percentage: 0.9), height: .fluid(percentage: 0.2), center: .center))
        presenter.roundCorners = true
        presenter.cornerRadius = 10
        vc.btn1Title = btn1Title
        vc.btn1Callback = {
          btn1Callback()
        }
        vc.btn2Title = btn2Title
        vc.btn2Callback = {
          btn2Callback()
        }
        vc.titleText = title
        vc.headingText = heading
        UIApplication.pTopViewController().customPresentViewController(presenter, viewController: vc, animated: true)
      }
    func showCustomerLanguageAlertControllerHeight(title:String,heading:String,btn1Title:String,btn1Callback:@escaping()->Void,btn2Title:String,btn2Callback:@escaping()->Void){
        guard let vc = UIStoryboard(name: "Popups", bundle: nil).instantiateViewController(withIdentifier: String(describing: LanguagePopupViewController.self)) as? LanguagePopupViewController else {return}
        let presenter = Presentr(presentationType: .custom(width: .fluid(percentage: 0.9), height: .fluid(percentage: 0.2), center: .center))
        presenter.roundCorners = true
        presenter.cornerRadius = 10
        vc.btn1Title = btn1Title
        vc.btn1Callback = {
          btn1Callback()
        }
        vc.btn2Title = btn2Title
        vc.btn2Callback = {
          btn2Callback()
        }
        vc.titleText = title
        vc.headingText = heading
        UIApplication.pTopViewController().customPresentViewController(presenter, viewController: vc, animated: true)
      }
    func showagreementControllerHeight(btn1Title:String,btn1Callback:@escaping()->Void,btn2Title:String,btn2Callback:@escaping()->Void){
        guard let vc = UIStoryboard(name: "Popups", bundle: nil).instantiateViewController(withIdentifier: String(describing: AgreementPopController.self)) as? AgreementPopController else {return}
        let presenter = Presentr(presentationType: .custom(width: .fluid(percentage: 0.9), height: .custom(size: 450), center: .center))
        presenter.roundCorners = true
        presenter.cornerRadius = 10
        vc.btn1Title = btn1Title
        vc.btn2Title = btn2Title
        vc.btn1Callback = {
          btn1Callback()
        }
        vc.btn2Callback = {
            btn2Callback()
        }
        UIApplication.pTopViewController().customPresentViewController(presenter, viewController: vc, animated: true)
      }
    func ChineseShowCustomerAlertControllerHeight(title:String,heading:String,note:String,miscid:String,btn1Title:String,btn1Callback:@escaping()->Void,btn2Title:String,btn2Callback:@escaping(_ token:String,_ id:String)->Void){
        guard let vc = UIStoryboard(name: "Popups", bundle: nil).instantiateViewController(withIdentifier: String(describing: popupChineseBellViewController.self)) as? popupChineseBellViewController else {return}
        if miscid == "" {
            var h = 0.0
            if title.count < 45{
                h = 0.19
            }else {
                h = 0.22
            }
            let presenter = Presentr(presentationType: .custom(width: .fluid(percentage: 0.9), height: .fluid(percentage: Float(h)), center: .center))
            presenter.roundCorners = true
            presenter.cornerRadius = 10
            vc.btn1Title = btn1Title
            vc.miscid = miscid
            vc.btn1Callback = {
              btn1Callback()
            }
            vc.btn2Title = btn2Title
            vc.btn2Callback = { (token, videoId) in
                btn2Callback(token, videoId)
            }
            vc.titleText = title
            vc.titleLblText = heading
            vc.noteText = note
            if miscid == "hide" {
                vc.btn1.isHidden = true
            }
            UIApplication.pTopViewController().customPresentViewController(presenter, viewController: vc, animated: true)
        }else {
            let presenter = Presentr(presentationType: .custom(width: .fluid(percentage: 0.9), height: .fluid(percentage: 0.18), center: .center))
            presenter.roundCorners = true
            presenter.cornerRadius = 10
            vc.btn1Title = btn1Title
            vc.miscid = miscid
            vc.btn1Callback = {
              btn1Callback()
            }
            vc.btn2Title = btn2Title
            vc.btn2Callback = { (token, videoId) in
                btn2Callback(token, videoId)
            }
            vc.titleText = title
            vc.titleLblText = heading
            vc.noteText = note

            UIApplication.pTopViewController().customPresentViewController(presenter, viewController: vc, animated: true)
        }
     
      }
      func showCustomerAlertControllerwithOneButton(title:String,btn2Title:String,btn2Callback:@escaping()->Void){
        guard let vc = UIStoryboard(name: "Popups", bundle: nil).instantiateViewController(withIdentifier: String(describing: PCustomAlertController.self)) as? PCustomAlertController else {return}
        let presenter = Presentr(presentationType: .custom(width: .fluid(percentage: 0.9), height: .fluid(percentage: 0.2), center: .center))
        presenter.roundCorners = true
        presenter.cornerRadius = 10
        vc.isOneButton = true

        vc.btn2Title = btn2Title
        vc.btn2Callback = {
          btn2Callback()
        }
        vc.titleText = title
        UIApplication.pTopViewController().customPresentViewController(presenter, viewController: vc, animated: true)
          
      }
      func showCustomerAlertController(title:String,btn1Title:String,btn1Callback:@escaping()->Void,btn2Title:String,btn2Callback:@escaping()->Void){
        guard let vc = UIStoryboard(name: "Popups", bundle: nil).instantiateViewController(withIdentifier: String(describing: PCustomAlertController.self)) as? PCustomAlertController else {return}
        let presenter = Presentr(presentationType: .custom(width: .fluid(percentage: 0.9), height: .fluid(percentage: 0.25), center: .center))
        presenter.roundCorners = true
        presenter.cornerRadius = 10
        vc.btn1Title = btn1Title
        vc.btn1Callback = {
          btn1Callback()
        }
        vc.btn2Title = btn2Title
        vc.btn2Callback = {
          btn2Callback()
        }
        vc.titleText = title
        UIApplication.pTopViewController().customPresentViewController(presenter, viewController: vc, animated: true)
      }
    
    
    
    
    func application(_ application: UIApplication,
                didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
      
        if let messageID = userInfo[gcmMessageIDKey] {
         print("Message ID: \(messageID)")
        }
        // Print full message.
        print(userInfo)
       }
       // [START receive_message]
       func application(_ application: UIApplication,
                didReceiveRemoteNotification userInfo: [AnyHashable: Any]) async
        -> UIBackgroundFetchResult {
       
        if let messageID = userInfo[gcmMessageIDKey] {
         print("Message ID: \(messageID)")
        }
        // Print full message.
        print(userInfo)
        return UIBackgroundFetchResult.newData
       }
       // [END receive_message]
       func application(_ application: UIApplication,
                didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
       }
      
    func application(_ application: UIApplication,
               didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
          let dt = deviceToken
          print("___________dt_________\(dt)")
        let firebaseAuth = Auth.auth()
        firebaseAuth.setAPNSToken(deviceToken, type: AuthAPNSTokenType.prod)
        Messaging.messaging().token { (token, error) in
          if let error = error {
            print("Error fetching remote instance ID: \(error.localizedDescription)")
          } else if let token = token {
            self.fcmtoken = token
            UserDefaults.standard.set(token , forKey: "Token2")
            print("Token is firebase \(token)")
          }
        }
      }
    
}

let appDelegate = UIApplication.shared.delegate as! AppDelegate



extension AppDelegate: UNUserNotificationCenterDelegate {
 // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    print(notification)
    let userInfo = notification.request.content.userInfo
    print(userInfo)
    let noti_type = userInfo["aps"] as? NSDictionary
    let alert = noti_type?["alert"] as? NSDictionary
    print(alert)
    let date = Date()
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd h:mm a"
    let dateString = df.string(from: date)
    print(dateString)
      
      let tittle = alert?["title"] as? String
     
      
//          let misc = userInfo["callSocketId"] as? String
          let misc = userInfo["misc"] as? String
      
      
      if(misc != "" && misc != nil){
          AppDefault.miscid = misc ?? ""
      }else{
          
      }
      let body = alert?["body"] as? String ?? ""
      let lastFourCharacters = String(body.suffix(5))
      if(lastFourCharacters == "busy."){
          appDelegate.ChineseShowCustomerAlertControllerHeight(title: "Seller \(AppDefault.brandname) is busy." , heading: "Busy", note: "", miscid: "hide", btn1Title: "Cancel", btn1Callback: {
              
          }, btn2Title: "Ok") { token, id in
        }
      }else{
          if(AppDefault.miscid != ""){
              self.GotoDashBoardnotification(ischecklogin: false, misc: AppDefault.miscid )
          }
      }
           
        
      
      
      
      

    
  }
 func userNotificationCenter(_ center: UNUserNotificationCenter,
               didReceive response: UNNotificationResponse) async {
  let userInfo = response.notification.request.content.userInfo
  // [START_EXCLUDE]
  // Print message ID.
  if let messageID = userInfo[gcmMessageIDKey] {
   print("Message ID: \(messageID)")
  }
  // [END_EXCLUDE]
  // With swizzling disabled you must let Messaging know about the message, for Analytics
  // Messaging.messaging().appDidReceiveMessage(userInfo)
  // Print full message.
  print(userInfo)
   let noti_type = userInfo["aps"] as? NSDictionary
   let alert = noti_type?["alert"] as? NSDictionary
     
     let tittle = alert?["title"] as? String
     


//         let misc = userInfo["callSocketId"] as? String
         let misc = userInfo["misc"] as? String

     if(misc != "" && misc != nil){
         AppDefault.miscid = misc ?? ""
     }else{
         
     }
     
     
     
     
     let body = alert?["body"] as? String ?? ""
     let lastFourCharacters = String(body.suffix(5))
     if(lastFourCharacters == "busy."){
         appDelegate.ChineseShowCustomerAlertControllerHeight(title: "Seller \(AppDefault.brandname) is busy." , heading: "Busy", note: "", miscid: "hide", btn1Title: "Cancel", btn1Callback: {
             
         }, btn2Title: "Ok") { token, id in
        }
     }else{
         if(AppDefault.miscid != ""){
             self.GotoDashBoardnotification(ischecklogin: false, misc: AppDefault.miscid )
             
         }else {
         }
     }
    
   let date = Date()
   let df = DateFormatter()
   df.dateFormat = "yyyy-MM-dd h:mm a"
   let dateString = df.string(from: date)
   print(dateString)
          
 }
}

extension AppDelegate: MessagingDelegate {
 // [START refresh_token]
 func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
  print("Firebase registration token: \(String(describing: fcmToken))")
   UserDefaults.standard.set(fcmToken ?? "" , forKey: "Token2")
     AppDefault.FcmToken = fcmToken ?? ""
  let dataDict: [String: String] = ["token": fcmToken ?? ""]
  NotificationCenter.default.post(
   name: Notification.Name("FCMToken"),
   object: nil,
   userInfo: dataDict
  )
  // TODO: If necessary send token to application server.
  // Note: This callback is fired at each app startup and whenever a new token is generated.
 }
 // [END refresh_token]
}
