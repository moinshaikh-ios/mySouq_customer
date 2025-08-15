//
//  PCustomAlertController.swift
//  Plancky
//
//  Created by Invision-75 on 16/02/2021.
//  Copyright © 2021 nketc. All rights reserved.
//

import UIKit

class PCustomAlertController: UIViewController {
    @IBOutlet weak var alertTitle: UILabel!
    @IBOutlet weak var alertHeading: UILabel!

    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    var titleText:String? = nil
    var headingText:String? = nil

    var btn1Title = "Cancel".pLocalized()
    var btn2Title = "Ok".pLocalized()
    var btn1Callback:(()->Void)?
    var btn2Callback:(()->Void)?
    var isOneButton = false
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.alertTitle.text = self.titleText?.pLocalized()
            self.alertHeading.text = self.headingText?.pLocalized()

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
