//
//  AgreementPopController.swift
//  Bazaar Ghar
//
//  Created by Umair Ali on 28/11/2024.
//

import UIKit

class AgreementPopController: UIViewController {

    @IBOutlet weak var checkbox_btn: UIButton!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!

    var titleText:String? = nil
    var headingText:String? = nil
    var isOneButton = false

    var btn1Title = "Agree"
    var btn2Title = "Cancel"

    var btn1Callback:(()->Void)?
    var btn2Callback:(()->Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {

            self.btn1.setTitle(self.btn1Title, for: .normal)
            self.btn1.layer.cornerRadius = 5
            self.btn2.setTitle(self.btn2Title, for: .normal)
            self.btn2.layer.cornerRadius = 5
            
            if self.isOneButton == true {
                self.btn1.isHidden = true
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func AgreeButton(_ sender: UIButton) {
        if let callback = self.btn1Callback{
            self.dismiss(animated: true) {
                callback()
            }
        }

    }
    @IBAction func cancelbtn(_ sender: Any) {
        if let callback = self.btn2Callback{
            self.dismiss(animated: true) {
                callback()
            }
        }
    }
    @IBAction func check_btn(_ sender: Any) {
        if checkbox_btn.isSelected == true{
            btn1.isEnabled = true
        }else{
            self.btn1.isEnabled = true
        }
        checkbox_btn.isSelected.toggle()
    }
    

}
