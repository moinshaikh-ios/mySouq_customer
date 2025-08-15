//
//  TabBarViewController.swift
//  Bazaar Ghar
//
//  Created by Developer on 31/08/2023.
//

import UIKit

class TabBarViewController: UITabBarController {

var ischecklogin = false
    var miscid = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers?.forEach({
                  $0.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 12, weight: .regular)], for: .normal)
              })
        
//        UITabBar.appearance().tintColor = UIColor.black
        UITabBar.appearance().unselectedItemTintColor = UIColor.black
        LanguageRander()

        if(ischecklogin){
            DispatchQueue.main.async {
                self.ischecklogin = false
                  let vc = PopupLoginVc.getVC(.popups)
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
            
        if(miscid != ""){
            DispatchQueue.main.async {
                if self.miscid == "cancel" {
                    appDelegate.ChineseShowCustomerAlertControllerHeight(title: "Seller \(AppDefault.brandname) is busy." , heading: "Busy", note: "", miscid: "hide", btn1Title: "Cancel", btn1Callback: {
                        
                    }, btn2Title: "Ok") { token, id in
                        
                    }
                }else {
                    appDelegate.ChineseShowCustomerAlertControllerHeight(title: "The seller has accepted your call request.", heading: "Request Call", note: "", miscid: self.miscid, btn1Title: "Not now", btn1Callback: {
                        
                    }, btn2Title: "Accept") { token, id in
                        appDelegate.videotoken = token
                          appDelegate.videoid = id
                          
                          NotificationCenter.default.post(name: Notification.Name("videocallid"), object: nil)
                    }
                }
            
            }
        }
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("isback"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification3(notification:)), name: Notification.Name("RefreshAllTabs"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification2(notification:)), name: Notification.Name("googleauth"), object: nil)
    }
    
    func LanguageRander() {
        tabBar.semanticContentAttribute = LanguageManager.language == "ar" ? .forceRightToLeft : .forceLeftToRight
                tabBar.items?[0].title = "home".pLocalized(lang: LanguageManager.language)
                tabBar.items?[1].title = "categories".pLocalized(lang: LanguageManager.language)
                tabBar.items?[2].title = "cart".pLocalized(lang: LanguageManager.language)
                tabBar.items?[3].title = "inbox".pLocalized(lang: LanguageManager.language)
                tabBar.items?[4].title = "profile".pLocalized(lang: LanguageManager.language)
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
               
    }
    @objc func methodOfReceivedNotification3(notification: Notification) {
        LanguageRander()
    }
    @objc func methodOfReceivedNotification2(notification: Notification) {
        let vc = OTPViewController.getVC(.popups)        
        vc.verifyid = appDelegate.verifyid
        
        vc.mobileNumber = appDelegate.phoneno
        self.present(vc, animated: true)
     
    }
   
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title == "Cart" || item.title == "Profile" || item.title == "Inbox"{
            if AppDefault.islogin{
                
            }else{
                DispatchQueue.main.async {
                   self.selectedIndex = 0
                }
                  let vc = PopupLoginVc.getVC(.popups)
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true, completion: nil)
            }
            
            print("Login")

      }
    }
    

}
