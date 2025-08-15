//
//  LanguagePopupViewController.swift
//  Bazaar Ghar
//
//  Created by Developer on 22/04/2024.
//

import UIKit

class LanguagePopupViewController: UIViewController {
    @IBOutlet weak var alertTitle: UILabel!

    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var engImg: UIImageView!
    @IBOutlet weak var arabicImg: UIImageView!

    var titleText:String? = nil
    var headingText:String? = nil

    var btn1Title = "Cancel".pLocalized()
    var btn2Title = "Ok".pLocalized()
    var btn1Callback:(()->Void)?
    var btn2Callback:(()->Void)?
    var isOneButton = false
    var isLang : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.alertTitle.text = self.titleText?.pLocalized()

            self.btn1.setTitle(self.btn1Title.pLocalized(), for: .normal)
            self.btn2.setTitle(self.btn2Title.pLocalized(), for: .normal)
            self.btn1.layer.cornerRadius = 5
            self.btn2.layer.cornerRadius = 5
            
            if self.isOneButton == true {
                self.btn1.isHidden = true
            }
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        AppDefault.languages = LanguageManager.language
        if LanguageManager.language == "ar"{
            engImg.image = UIImage(named: "radioBlue")
            arabicImg.image = UIImage(named: "selectedRadioBlue")
        }else {
            engImg.image = UIImage(named: "selectedRadioBlue")
            arabicImg.image = UIImage(named: "radioBlue")
        }
    }
    
    @IBAction func radioEnglis(_ sender: UIButton) {
        AppDefault.languages = "en"
        engImg.image = UIImage(named: "selectedRadioBlue")
        arabicImg.image = UIImage(named: "radioBlue")
//        appDelegate.shouldUseCustomFont = true
    }
    @IBAction func radioArabic(_ sender: UIButton) {
        AppDefault.languages = "ar"
        engImg.image = UIImage(named: "radioBlue")
        arabicImg.image = UIImage(named: "selectedRadioBlue")
//        appDelegate.shouldUseCustomFont = true
    }
    
    @IBAction func didTapLeftButton(_ sender: UIButton) {
        if let callback = self.btn1Callback{
            self.dismiss(animated: true) {
                callback()
            }
        }
    }
    @IBAction func didTapRightButton(_ sender: UIButton) {
        if let callback = self.btn2Callback{
            self.dismiss(animated: true) {
                callback()
            }
        }
    }
}
