//
//  PersonalDetailsViewController.swift
//  Bazaar Ghar
//
//  Created by Developer on 26/09/2023.
//

import UIKit

class PersonalDetailsViewController: UIViewController {
    @IBOutlet weak var personalDetailslbl: UILabel!
    @IBOutlet weak var fullnamelbl: UILabel!
    @IBOutlet weak var emaillbl: UILabel!
    @IBOutlet weak var emailfeildlbl: UITextField!
    @IBOutlet weak var savechnageslbl: UIButton!
    
    @IBOutlet weak var fullname: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    var fullName: String?
    var Email: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullname.delegate = self
        if((self.tabBarController?.tabBar.isHidden) != nil){
            appDelegate.isbutton = true
        }else{
            appDelegate.isbutton = false
        }
//        NotificationCenter.default.post(name: Notification.Name("ishideen"), object: nil)
        personalDetailslbl.text = "personaldetails".pLocalized(lang: LanguageManager.language)
        fullnamelbl.text = "fullname".pLocalized(lang: LanguageManager.language)
        fullname.placeholder = "fullnamefeild".pLocalized(lang: LanguageManager.language)
        emaillbl.text = "email".pLocalized(lang: LanguageManager.language)
        emailfeildlbl.placeholder = "enteremail".pLocalized(lang: LanguageManager.language)
        savechnageslbl.setTitle("savechanges".pLocalized(lang: LanguageManager.language), for: .normal)
        
        fullname.text = fullName
        if Email == "Add Email" {
            email.text = ""
        }else {
            email.text = Email
        }
       
        
        // Do any additional setup after loading the view.
    }
    @IBAction func savechangesbtn(_ sender: Any) {
        savechanges(fullname: fullname.text ?? "", email: email.text ?? "", userid: AppDefault.currentUser?.id ?? "", agreement: "")
    }
    func savechanges(fullname: String,email:String,userid:String,agreement:String){
        APIServices.personaldetail(fullname: fullname, email: email, userid: userid, agreement: agreement, completion:{ [weak self] data in
            switch data{
            case .success(let res):
                AppDefault.currentUser = res
                self?.view.makeToast("addressupdatesuccessfully".pLocalized(lang: LanguageManager.language))
                
                self?.navigationController?.popViewController(animated: false)
            case .failure(let error):
                print(error)
                self?.view.makeToast(error)
            }
        })
     }

    @IBAction func backBtnTapped(_ sender: Any) {
//        appDelegate.isbutton = false
//    NotificationCenter.default.post(name: Notification.Name("ishideen"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension PersonalDetailsViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // Get the current text in the text field
            let currentText = textField.text ?? ""
            
            // Create a string with the new text by replacing the range with the new string
            let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
            
            // Return true if the new text length is less than or equal to 24, otherwise false
            return updatedText.count <= 24
        }
}
