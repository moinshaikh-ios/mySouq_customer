//
//  inviteFriends.swift
//  Bazaar Ghar
//
//  Created by Developer on 22/09/2023.
//

import UIKit

class inviteFriends_Vc: UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var inviteFriendsLbl: UILabel!
    @IBOutlet weak var inviteShareRefferalMsgLbl: UILabel!
    @IBOutlet weak var copyBtn: UIButton!
    @IBOutlet weak var inviteFriendsBtn: UIButton!
    @IBOutlet weak var refCodeLbl: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
    
//        if((self.tabBarController?.tabBar.isHidden) != nil){
//            appDelegate.isbutton = true
//        }else{
//            appDelegate.isbutton = false
//        }
//        NotificationCenter.default.post(name: Notification.Name("ishideen"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refCodeLbl.text = AppDefault.currentUser?.refCode
        self.LanguageRender()
    }
    
    func LanguageRender() {
        
        inviteFriendsLbl.text = "invitefriends".pLocalized(lang: LanguageManager.language)
        inviteShareRefferalMsgLbl.text = "inviteShareRefferalMsg".pLocalized(lang: LanguageManager.language)
        copyBtn.setTitle("copy".pLocalized(lang: LanguageManager.language), for: .normal)
        inviteFriendsBtn.setTitle("invitefriends".pLocalized(lang: LanguageManager.language), for: .normal)

        
        if LanguageManager.language == "ar"{
            backBtn.setImage(UIImage(systemName: "arrow.right"), for: .normal)
           }else{
               backBtn.setImage(UIImage(systemName: "arrow.left"), for: .normal)
           }

    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
//        appDelegate.isbutton = false
//    NotificationCenter.default.post(name: Notification.Name("ishideen"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func inviteBtnTapped(_ sender: Any) {
        UIPasteboard.general.string = "Hello there this is my Referral code:\(refCodeLbl.text ?? "")\n \nPlease use this referral code on checkout at MySouq, You will get SAR 200 discount and I will get a commission on it The link is given below\n \nhttps://stage.mysouq.com/"
        self.view.makeToast("Refferal code copied")
    }
    @IBAction func copyBtnTapped(_ sender: Any) {
        UIPasteboard.general.string = "Hello there this is my Referral code:\(refCodeLbl.text ?? "")\n \nPlease use this referral code on checkout at MySouq, You will get SAR 200 discount and I will get a commission on it The link is given below\n \nhttps://stage.mysouq.com/"
        self.view.makeToast("Refferal code copied")

    }

}
