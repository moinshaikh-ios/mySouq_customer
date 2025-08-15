//
//  PopupLoginVc.swift
//  Bazaar Ghar
//
//  Created by Zany on 28/08/2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import AuthenticationServices
import Firebase
import CryptoKit


class PopupLoginVc: UIViewController {

    
    @IBOutlet weak var cornerView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var textFeildLabel: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var loginWithAppleButton: UIButton!
    @IBOutlet weak var loginWithGoogleButton: UIButton!
    @IBOutlet weak var countryTblV: UITableView!
    @IBOutlet weak var countryView: UIView!
    @IBOutlet private weak var countryTextField: UITextField!
    @IBOutlet private weak var countryCodeLbl: UILabel!
    @IBOutlet private weak var loginLbl: UILabel!
    @IBOutlet private weak var orLbl: UILabel!

    
    let userdefault = UserDefaults()
    fileprivate var currentNonce: String?


    
    var filteredCountriesData: [(name: String, flag: String, phoneCode: String)] = []
        var countriesData: [(name: String, flag: String, phoneCode: String)] = [] // Your existing countriesData array
    var seletedCode: String?
    var selectedCountryCode: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false

    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Iterate through ISO country codes
        for code in NSLocale.isoCountryCodes {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
            let flag = countryFlag(code)
            let phoneCode = Utility().countryCodesToPhoneCodes[code] ?? "" // Get phone code from dictionary
            
            // Append country data (name, flag, phone code) to the array
            countriesData.append((name: name, flag: flag, phoneCode: phoneCode))
            languageRebder()
        }
        
        func languageRebder() {
            loginLbl.text = "login".pLocalized(lang: LanguageManager.language)
            textFeildLabel.placeholder = "entermobilenumber".pLocalized(lang: LanguageManager.language)
            nextButton.setTitle("next".pLocalized(lang: LanguageManager.language), for: .normal)
            orLbl.text = "or".pLocalized(lang: LanguageManager.language)
            loginWithGoogleButton.setTitle("signinwithgoogle".pLocalized(lang: LanguageManager.language), for: .normal)
            loginWithAppleButton.setTitle("signinwithapple".pLocalized(lang: LanguageManager.language), for: .normal)

        }
        
        // Function to generate country flag emoji
        func countryFlag(_ countryCode: String) -> String {
            let flagBase = UnicodeScalar("🇦").value - UnicodeScalar("A").value
            let flag = countryCode
                .uppercased()
                .unicodeScalars
                .compactMap({ UnicodeScalar(flagBase + $0.value)?.description })
                .joined()
            
            return flag
        }
        
        filteredCountriesData = countriesData

    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func countryCodeBtmTapped(_ sender: Any) {
        if countryView.isHidden == true {
            countryView.isHidden = false
        }else {
            countryView.isHidden = true
        }
    }
    @IBAction func countryCrossbtntapped(_ sender: Any) {
        countryView.isHidden = true
        countryTextField.text = ""
    }
    
    @IBAction func PhoneNumberLoginBtn(_ sender: Any) {

      guard  let phonenumber = textFeildLabel.text else {return}
        nextButton.isEnabled = false
        UIApplication.startActivityIndicator()
        DispatchQueue.main.async {
            PhoneAuthProvider.provider().verifyPhoneNumber((self.countryCodeLbl.text ?? "") + phonenumber, uiDelegate: nil) { verificationID, error in
                if let error = error {
                    print("Error occurred during phone verification: \(error.localizedDescription)")
                    UIApplication.pTopViewController().view.makeToast(error.localizedDescription)
                    UIApplication.stopActivityIndicator()
                    self.nextButton.isEnabled = true
                    return
                }
                
                guard let verificationID = verificationID else {
                    print("Failed to retrieve verification ID.")
                    UIApplication.stopActivityIndicator()
                    self.nextButton.isEnabled = true
                    return
                }
                
                self.dismiss(animated: true) {
                    appDelegate.verifyid = verificationID
                    appDelegate.phoneno = (self.countryCodeLbl.text ?? "") + phonenumber
                    appDelegate.phonenowithout = (self.countryCodeLbl.text ?? "") + phonenumber
                    NotificationCenter.default.post(name: Notification.Name("googleauth"), object: nil)
                    self.nextButton.isEnabled = true
                }
                UIApplication.stopActivityIndicator()
            }
        }
 }
    
    @IBAction func googleLoginButton(_ sender: Any) {

           UIApplication.startActivityIndicator()
           
           guard let clientID = FirebaseApp.app()?.options.clientID else { return }
           let config = GIDConfiguration(clientID: clientID)
           GIDSignIn.sharedInstance.configuration = config
           
           GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
               guard error == nil else {
                   UIApplication.stopActivityIndicator()
                   
                   return
               }
               
               guard let user = result?.user,
                     let idToken = user.idToken?.tokenString
               else {
                   return
               }
               
               let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                              accessToken: user.accessToken.tokenString)
               
               
               Auth.auth().signIn(with: credential) { result, error in
                   
                   AppDefault.uid = result?.user.uid ?? ""
                   AppDefault.displayName = result?.user.displayName ?? ""
                   if let profile = result?.additionalUserInfo?.profile,
                      let sub = profile["sub"] as? String {
                       // Access the 'sub' property here
                       AppDefault.uid = sub
                   } else {
                       print("Unable to retrieve user ID")
                   }
                   self.loginWithGoogle(googleId:  AppDefault.uid ?? "", displayName: result?.user.displayName ?? "")
                   print(result?.user.email ?? "")
                   print(result?.user.uid ?? "")
               }
           }

    }
    
    @IBAction func appleSignInButtonTapped(_ sender: Any) {
        let nonce = Utility().randomNonceString()
         currentNonce = nonce
         let appleIDProvider = ASAuthorizationAppleIDProvider()
         let request = appleIDProvider.createRequest()
         request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(value: nonce)

         let authorizationController = ASAuthorizationController(authorizationRequests: [request])
         authorizationController.delegate = self
         authorizationController.presentationContextProvider = self
         authorizationController.performRequests()
    }
    
    private func pushnotificationapi(){
        APIServices.pushnotificationapi{[weak self] data in
            switch data{
            case .success( _): break
                
                       
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func loginWithGoogle(googleId:String,displayName:String){
        APIServices.getLoginGoogle(googleId: googleId, displayName: displayName){[weak self] data in
            switch data{
            case .success(let res):
                if(res.user?.status == "active"){
                               AppDefault.currentUser = res.user
                               AppDefault.accessToken  = res.tokens?.access?.token ?? ""
                               AppDefault.refreshToken = res.tokens?.refresh?.token ?? ""
                               AppDefault.islogin = true
                    if(res.user?.isEmailVarified == false){
                        AppDefault.currentUser?.email = "legendsofgaming05@gmail.com"
                    }
                               self?.pushnotificationapi()
                               print("Token__")
                               UIApplication.stopActivityIndicator()

                               NotificationCenter.default.post(name: Notification.Name("isback"), object: nil)
                               self?.dismiss(animated: false){
                                   NotificationCenter.default.post(name: Notification.Name("isback"), object: nil)
                                   UIApplication.pTopViewController().tabBarController?.view.makeToast("loginsuccessfully".pLocalized(lang: LanguageManager.language))
           //                        appDelegate.GotoDashBoard(ischecklogin: false)
                               }
                           
                           }else{
                               let alert = UIAlertController(
                                   title: "alert".pLocalized(lang: LanguageManager.language),
                                   message: "pleasecontactsupport".pLocalized(lang: LanguageManager.language),
                                   preferredStyle: .alert)
                               alert.addAction(UIAlertAction(title: "ok".pLocalized(lang: LanguageManager.language), style: .default, handler: { action in
                                   UIApplication.stopActivityIndicator()
                               }))
                               self?.present(alert, animated: true, completion: nil)
                           }

                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func loginWithApple(token:String){
        APIServices.appleLogin(token: token){[weak self] data in
            switch data{
            case .success(let res):
             
              
                if(res.result?.user?.status == "active"){
                    AppDefault.currentUser = res.result?.user
                    AppDefault.accessToken  = res.result?.tokens?.access?.token ?? ""
                    AppDefault.refreshToken = res.result?.tokens?.refresh?.token ?? ""
                    AppDefault.islogin = true
                    self?.pushnotificationapi()
                    print("Token__")
                    UIApplication.stopActivityIndicator()

                    NotificationCenter.default.post(name: Notification.Name("isback"), object: nil)
                    self?.dismiss(animated: false){
                        NotificationCenter.default.post(name: Notification.Name("isback"), object: nil)
                        UIApplication.pTopViewController().tabBarController?.view.makeToast("loginsuccessfully".pLocalized(lang: LanguageManager.language))
                    }
                
                }else{
                    let alert = UIAlertController(title: "Alert", message: "Please contact us on our support.\r\nCall us 24/7 +92 301 1166 - 879.\r\nEmail: hello@mysouq.com ", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        UIApplication.stopActivityIndicator()
                    }))
                    self?.present(alert, animated: true, completion: nil)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    
 
    
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("isback"), object: nil)
        self.dismiss(animated: false){
            NotificationCenter.default.post(name: Notification.Name("isback"), object: nil)
        }
    }
    
}

extension PopupLoginVc: UITextFieldDelegate {
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
   }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField == countryTextField {
            guard let searchText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else {
                       return true
                   }
                   
                   filteredCountriesData = searchText.isEmpty ? countriesData : countriesData.filter { $0.name.lowercased().contains(searchText.lowercased()) }
                   countryTblV.reloadData()
                   
                   return true
        }else {
            if let countryCode = selectedCountryCode,
               let maxLength = Utility().countryPhoneLengths[countryCode] {
                           // Calculate the new length of the text field after editing
                           let currentText = textField.text ?? ""
                           let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
                           
                           return newText.count <= maxLength
                       }
        }
        return true
    }
}

@available(iOS 13.0, *)
extension PopupLoginVc: ASAuthorizationControllerDelegate {

  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      guard let nonce = currentNonce else {
        fatalError("Invalid state: A login callback was received, but no login request was sent.")
      }
      guard let appleIDToken = appleIDCredential.identityToken else {
        print("Unable to fetch identity token")
        return
      }
      guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
        print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
        return
      }
        UIApplication.startActivityIndicator()

      // Initialize a Firebase credential, including the user's full name.
      let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                        rawNonce: nonce,
                                                        fullName: appleIDCredential.fullName)
      // Sign in with Firebase.
      Auth.auth().signIn(with: credential) { (authResult, error) in
          if (error != nil) {
          // Error. If error.code == .MissingOrInvalidNonce, make sure
          // you're sending the SHA256-hashed nonce as a hex string with
          // your request to Apple.
              print(error?.localizedDescription)
          return
        }
          authResult?.user.getIDTokenForcingRefresh(true) { (idToken, error) in
              if let error = error {
                  print("Error getting Firebase ID token: \(error.localizedDescription)")
                  return
              }
              
              guard let idToken = idToken else {
                  print("No Firebase ID token returned")
                  return
              }
              UIApplication.stopActivityIndicator()
              self.loginWithApple(token: idToken)
          }
        // User is signed in to Firebase with Apple.
        // ...
      }
    }
  }

  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    print("Sign in with Apple errored: \(error)")
  }

}
extension PopupLoginVc: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view as! ASPresentationAnchor
    }
}


extension PopupLoginVc: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return filteredCountriesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableViewCell", for: indexPath) as! CountryTableViewCell
            cell.countryImgLbl.font = UIFont.systemFont(ofSize: 40.0)

        cell.countryImgLbl.text = filteredCountriesData[indexPath.row].flag
        cell.countryNameLbl.text = filteredCountriesData[indexPath.row].name
        cell.codeLbl.text = filteredCountriesData[indexPath.row].phoneCode

            return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCountry = filteredCountriesData[indexPath.row]
        print("Selected country: \(selectedCountry.name)")
        seletedCode = selectedCountry.phoneCode
        if let countryCode = Utility().countryCode(for: selectedCountry.name) {
            print("Country Code for \(selectedCountry.name): \(countryCode)")
            didSelectCountry(withCode: countryCode)
        } else {
            print("Country Code not found for \(selectedCountry.name)")
        }

        // Update the text field with the selected country name
        countryCodeLbl.text = selectedCountry.phoneCode
        countryView.isHidden = true
    }
    
 
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    
}

extension PopupLoginVc {
    
    // Function to update phone number text field based on selected country
    func updatePhoneNumberTextFieldForCountry(_ countryCode: String) {
        if let maxLength = Utility().countryPhoneLengths[countryCode] {
//            textFeildLabel.placeholder = "Enter phone number (\(maxLength) digits)"
        }
    }
    
    // Function to handle country selection (e.g., from a list)
    func didSelectCountry(withCode countryCode: String) {
        selectedCountryCode = countryCode
//        updatePhoneNumberTextFieldForCountry(countryCode)
    }
}
