//
//  popupChineseBellViewController.swift
//  Bazaar Ghar
//
//  Created by Developer on 29/12/2023.
//

import UIKit

class popupChineseBellViewController: UIViewController {

    @IBOutlet weak var alertTitle: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var noteLbl: UILabel!

    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    var titleText:String? = nil
    var titleLblText:String? = nil
    var noteText:String? = nil

    var btn1Title = "Cancel".pLocalized()
    var btn2Title = "Ok".pLocalized()
    var btn1Callback:(()->Void)?
    var btn2Callback:((_ token:String,_ videoid:String)->Void)?
    var isOneButton = false
    var miscid = String()
    var h : Float?
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.alertTitle.text = self.titleText?.pLocalized()
            self.titleLbl.text = self.titleLblText?.pLocalized()
            self.noteLbl.text = self.noteText?.pLocalized()

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
        if titleLbl.numberOfLines == 1 {
            h = 0.18
        }else {
            h = 0.22
        }
        if miscid == "hide" {
            btn1.isHidden = true
        }
        
    }
    private func getVideoToken(room:String, token:String, notificationId:String){
          APIServices.getVideoToken(room: room, token: token){[weak self] data in
              switch data{
              case .success(let res):
                  if let callback = self?.btn2Callback!(res, room){
                    
                      self?.dismiss(animated: true) {
                          callback
                      }
                  }
                 case .failure(let error):
                  print(error)
              }
          }
      }
    @IBAction func didTapLeftButton(_ sender: UIButton) {
        if let callback = self.btn1Callback{
            self.dismiss(animated: true) {
                callback()
            }
        }
    }
    @IBAction func didTapRightButton(_ sender: UIButton) {
 
        if(self.miscid == "self.miscid"){
            if let callback = self.btn2Callback{
                self.dismiss(animated: true) {
                    callback("test", "1")
                }
            }
        }else if (self.miscid == "hide"){
            if let callback = self.btn2Callback{
                self.dismiss(animated: true) {
                    callback("test", "1")
                }
            }
        }else{
            self.getVideoToken(room: miscid, token: AppDefault.accessToken, notificationId: "")
        }
         
        
            
      
    }
    
}
