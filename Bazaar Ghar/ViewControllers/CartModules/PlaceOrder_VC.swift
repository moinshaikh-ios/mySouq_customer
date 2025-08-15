//
//  PlaceOrder_VC.swift
//  Bazaar Ghar
//
//  Created by Umair ALi on 18/09/2023.
//

import UIKit

class PlaceOrder_VC: UIViewController {
    
    @IBOutlet weak var backBtn : UIButton!
    @IBOutlet weak var orderPlacedMessage : UILabel!
    @IBOutlet weak var orderTrackId : UILabel!
    @IBOutlet weak var thankYouShoppingMessage : UILabel!
    @IBOutlet weak var contactUsMessage : UILabel!
    @IBOutlet weak var continueShoppingBtn : UIButton!

    
    var orderID : String?

    override func viewDidLoad() {
        super.viewDidLoad()
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.LanguageRender()

    }
    
    func LanguageRender() {
    
        orderPlacedMessage.text = "orderplacemessage".pLocalized(lang: LanguageManager.language)
        orderTrackId.text = "ordertrackid".pLocalized(lang: LanguageManager.language) + (orderID ?? "")
        thankYouShoppingMessage.text = "thankyoushoppingmessage".pLocalized(lang: LanguageManager.language)
        contactUsMessage.text = "contactusmessage".pLocalized(lang: LanguageManager.language)
        continueShoppingBtn.setTitle("continueshopping".pLocalized(lang: LanguageManager.language), for: .normal)
        
        
        if LanguageManager.language == "ar"{
            backBtn.setImage(UIImage(systemName: "arrow.right"), for: .normal)
           }else{
               backBtn.setImage(UIImage(systemName: "arrow.left"), for: .normal)
           }

    }

    @IBAction func continueShoping(_ sender: Any) {
        DispatchQueue.main.async {
//            appDelegate.GotoDashBoard(ischecklogin: false)
            self.navigationController?.popToRootViewController(animated: true)
        }
    }


}
