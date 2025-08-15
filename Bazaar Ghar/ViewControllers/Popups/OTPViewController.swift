//
//  OTPViewController.swift
//  Bazaar Ghar
//
//  Created by Developer on 05/09/2023.
//

import UIKit
import OTPFieldView
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import AuthenticationServices
import Firebase




class OTPViewController: UIViewController {
    

    @IBOutlet weak var otpTextFieldView: OTPFieldView!
    @IBOutlet weak var numberVerificationLbl: UILabel!
    @IBOutlet weak var resendbtn: UIButton!
    @IBOutlet weak var timerLabel: UILabel!


    var verifyid : String = ""
    var mobileNumber : String = ""

    var countdownTimer: Timer!
    var totalTime = 60

    override func viewDidLoad() {
        super.viewDidLoad()
        setupOtpView()
        numberVerificationLbl.text = "Please enter the verification code sent On " + mobileNumber
        startTimer()
       
        
    }
    
    func startTimer() {
        resendbtn.isHidden = true
        timerLabel.isHidden = false
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }

    @objc func updateTime() {
      
        timerLabel.text = "\(timeFormatted(totalTime))"

        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
            
        }
    }

    func endTimer() {
        resendbtn.isHidden = false
        timerLabel.isHidden = true
        countdownTimer.invalidate()
    }

    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d", seconds)
    }

    
    
    
    func setupOtpView(){
            self.otpTextFieldView.fieldsCount = 6
            self.otpTextFieldView.fieldBorderWidth = 2
            self.otpTextFieldView.defaultBorderColor = UIColor.black
        self.otpTextFieldView.filledBorderColor = UIColor.systemBlue
            self.otpTextFieldView.cursorColor = UIColor.red
            self.otpTextFieldView.displayType = .underlinedBottom
            self.otpTextFieldView.fieldSize = 50
            self.otpTextFieldView.separatorSpace = 8
            self.otpTextFieldView.shouldAllowIntermediateEditing = false
            self.otpTextFieldView.delegate = self
            self.otpTextFieldView.initializeUI()
        view.endEditing(true)
        }

    @IBAction func closeBtnTapped(_ sender: Any) {
        self.dismiss(animated: true)
        }
    @IBAction func PhoneNumberLoginBtn(_ sender: Any) {
            
        otpTextFieldView.initializeUI()

        PhoneAuthProvider.provider().verifyPhoneNumber(self.mobileNumber, uiDelegate: nil) {(verificationid, error) in
                 if error == nil{
                     self.verifyid = verificationid ?? ""
                     self.startTimer()

                 }else{
                     print("unable to get verification:", error?.localizedDescription)
                   
                 }
             }

 }
    

}

extension OTPViewController: OTPFieldViewDelegate {
    func hasEnteredAllOTP(hasEnteredAll hasEntered: Bool) -> Bool {
        print("Has entered all OTP? \(hasEntered)")
        return false
    }
    
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otp otpString: String) {
        print("OTPString: \(otpString)")
           let credentials = PhoneAuthProvider.provider().credential(withVerificationID: verifyid, verificationCode: otpString)
             Auth.auth().signIn(with: credentials) { (result, error) in
           if error == nil {
               self.loginWithGoogle(googleId: appDelegate.phoneno, displayName: result?.user.providerID ?? "", verificationid: self.verifyid )
            
          } else{
              self.view.makeToast("Invalid OTP")
              print(error?.localizedDescription)
       }
   }
   }
    
    private func loginWithGoogle(googleId:String,displayName:String,verificationid:String){
        APIServices.GetloginOTp(googleId: googleId, displayName: displayName){[weak self] data in
            switch data{
            case .success(let res):
             //
                
                
                if let cleanedPhoneNumber = Int(appDelegate.phonenowithout.components(separatedBy: CharacterSet.whitespaces).joined(separator: "")) {
                    // Multiply by 104727
                    let multipliedNumber = cleanedPhoneNumber * 104727

                    // Convert the result to a string
                    let resultString = String(multipliedNumber)

                    print(resultString) // Output the result
                    self?.loginWithGoogleVerification(googleId: res.phoneLoginToken ?? "", displayName: resultString)
                } else {
                    print("Invalid phone number format")
                }
                
                
               
               
                
            
             
            case .failure(let error):
                print(error)
            }
        }
    }
    private func loginWithGoogleVerification(googleId:String,displayName:String){
        APIServices.loginWithGoogleVerification(googleId: googleId, displayName: displayName){[weak self] data in
            switch data{
            case .success(let res):
                
            
                if res.user?.agreement == false{
                           appDelegate.showagreementControllerHeight(btn1Title: "Agree", btn1Callback: {
                               appDelegate.savechanges(fullname:"", email: "", userid: res.user?.id ?? "", agreement: "true")
                               
                               
                               AppDefault.currentUser = res.user
                               AppDefault.accessToken  = res.tokens?.access?.token ?? ""
                               AppDefault.refreshToken = res.tokens?.refresh?.token ?? ""
                               AppDefault.islogin = true
                               print("Token__")
                               
                               
                           
                               NotificationCenter.default.post(name: Notification.Name("isback"), object: nil)
                               self?.dismiss(animated: false){
                                   NotificationCenter.default.post(name: Notification.Name("isback"), object: nil)
                                   UIApplication.pTopViewController().tabBarController?.view.makeToast("loginsuccessfully".pLocalized(lang: LanguageManager.language))
                               }
                        
                           }, btn2Title: "Cancel") {
                               AppDefault.islogin = false
                               AppDefault.accessToken = ""
                               AppDefault.resetUserDefault()
                               AppDefault.wishlistproduct?.removeAll()
                             
                               appDelegate.GotoDashBoard(ischecklogin: false)
                  
                               UIApplication.pTopViewController().tabBarController?.view.makeToast("Successfully Logout")
                           }
                }else {
                    AppDefault.currentUser = res.user
                    AppDefault.accessToken  = res.tokens?.access?.token ?? ""
                    AppDefault.refreshToken = res.tokens?.refresh?.token ?? ""
                    AppDefault.islogin = true
                    print("Token__")
                    
                    
                
                    NotificationCenter.default.post(name: Notification.Name("isback"), object: nil)
                    self?.dismiss(animated: false){
                        NotificationCenter.default.post(name: Notification.Name("isback"), object: nil)
                        UIApplication.pTopViewController().tabBarController?.view.makeToast("loginsuccessfully".pLocalized(lang: LanguageManager.language))
                    }
                }
            
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    
}
