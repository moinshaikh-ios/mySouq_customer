//
//  Privacypolicy_VC.swift
//  Bazaar Ghar
//
//  Created by Umair ALi on 22/09/2023.
//

import UIKit

class Privacypolicy_VC: UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var wishlistLbl: UILabel!

   
      override func viewDidLoad() {
          super.viewDidLoad()
      
//          if((self.tabBarController?.tabBar.isHidden) != nil){
//              appDelegate.isbutton = true
//          }else{
//              appDelegate.isbutton = false
//          }
//          NotificationCenter.default.post(name: Notification.Name("ishideen"), object: nil)
      }

    @IBAction func backBtnTapped(_ sender: Any) {
//        appDelegate.isbutton = false
//    NotificationCenter.default.post(name: Notification.Name("ishideen"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }

}
  
