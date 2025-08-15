//
//  MyWallet_VC.swift
//  Bazaar Ghar
//
//  Created by Umair ALi on 21/09/2023.
//

import UIKit

    class MyWallet_VC: UIViewController {

        @IBOutlet weak var walletBalance: UILabel!
        @IBOutlet weak var walletlbl: UILabel!
        @IBOutlet weak var remainingBalancelbl: UILabel!
        @IBOutlet weak var backbtn: UIButton!


        var walletPrice = ""
        
        override func viewDidLoad() {
            super.viewDidLoad()
          
//            if((self.tabBarController?.tabBar.isHidden) != nil){
//                appDelegate.isbutton = true
//            }else{
//                appDelegate.isbutton = false
//            }
//            NotificationCenter.default.post(name: Notification.Name("ishideen"), object: nil)

        }
        override func viewWillAppear(_ animated: Bool) {
            walletBalance.text = walletPrice
            self.LanguageRender()

        }
        func LanguageRender() {

            walletlbl.text = "wallet".pLocalized(lang: LanguageManager.language)
            remainingBalancelbl.text = "remainingbalance".pLocalized(lang: LanguageManager.language)
          
            
            if LanguageManager.language == "ar"{
                backbtn.setImage(UIImage(systemName: "arrow.right"), for: .normal)
               }else{
                   backbtn.setImage(UIImage(systemName: "arrow.left"), for: .normal)
               }

        }
        
        @IBAction func backBtnTapped(_ sender: Any) {
//            appDelegate.isbutton = false
//        NotificationCenter.default.post(name: Notification.Name("ishideen"), object: nil)
            self.navigationController?.popViewController(animated: true)
        }
        

}



