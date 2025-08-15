//
// NewOrderConfirmation_ViewController.swift
// Bazaar Ghar
//
// Created by Umair Ali on 15/07/2024.
//
import UIKit
import Frames
import Checkout
import AudioToolbox
import FirebaseAnalytics
import SwiftUI
import PassKit

class NewOrderConfirmation_ViewController: UIViewController {
    @IBOutlet weak var applePayView: UIView!

  @IBOutlet weak var mapview: UIView!
  @IBOutlet weak var codView: UIView!
  @IBOutlet weak var headerview: UIView!
  @IBOutlet weak var entercoupontxt: UITextField!
  @IBOutlet weak var discounttxt: UILabel!
  @IBOutlet weak var producttotaltxt: UILabel!
  @IBOutlet weak var addnewadressbtn: UIButton!
  @IBOutlet weak var placeorderbtn: UIButton!
    @IBOutlet weak var credViewHeight: NSLayoutConstraint!
    @IBOutlet weak var deliverytxt: UILabel!
  @IBOutlet weak var payabletxt: UILabel!
  @IBOutlet weak var applybtn: UIButton!
  @IBOutlet weak var totaltxt: UILabel!
  @IBOutlet weak var subtotaltxt: UILabel!
  @IBOutlet weak var coupouncodelbl: UILabel!
  @IBOutlet weak var orderinstructiontxt: UITextView!
  @IBOutlet weak var deliveryaddresslbl: UILabel!
  @IBOutlet weak var paymentmethodlbl: UILabel!
  @IBOutlet weak var ordersummarylbl: UILabel!
  @IBOutlet weak var ordersummarycollectview: UICollectionView!
    @IBOutlet weak var walletSwitch: UISwitch!

    @IBOutlet weak var paymentMethodHeight: NSLayoutConstraint!
    @IBOutlet weak var chkButton: UIButton!
    @IBOutlet weak var homelbl: UILabel!
  @IBOutlet weak var orderSummaryHeight: NSLayoutConstraint!
  @IBOutlet weak var scrollHeight: NSLayoutConstraint!
  @IBOutlet weak var addressLbl: UILabel!
  @IBOutlet weak var walletBalane: UILabel!
    @IBOutlet weak var headercheckoutLbl: UILabel!
    @IBOutlet weak var headercartLbl: UILabel!
    @IBOutlet weak var headerhomeLbl: UILabel!
    @IBOutlet weak var editLbl: UILabel!
    @IBOutlet weak var productTotalLbl: UILabel!
    @IBOutlet weak var dicountLbl: UILabel!
    @IBOutlet weak var subTotalLbl: UILabel!
    @IBOutlet weak var deliveryLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var payableLbl: UILabel!
    @IBOutlet weak var creditDebitLbl: UILabel!
    @IBOutlet weak var chkButtonCOD: UIButton!
    @IBOutlet weak var chkButtonApple: UIButton!
    @IBOutlet weak var emailhideview1: UIView!
    @IBOutlet weak var emailhideview2: UIView!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var emailhiddenlbl: UILabel!
    @IBOutlet weak var addressmainViewHeight: NSLayoutConstraint!
    @IBOutlet weak var addressviewHeight: NSLayoutConstraint!
    @IBOutlet weak var codViewHieght: NSLayoutConstraint!

    
    let paymentHandler = PaymentHandler()

    
    var walletBalance: Float?
    
    var orderDetails2: CartItemsResponse? {
        didSet {
            orderDetails = orderDetails2
            reloadData()
        }
    }
    var orderDetails: CartItemsResponse?
  var itemCount = 0
   
    @IBOutlet weak var creditCardView: UIView!
    var defaultAdress : DefaultAddress?
  var methodimgArray = ["creditcard"]
    var methodNameArray = [LanguageManager.language == "ar" ? "بطاقة الائتمان/الخصم" : "Credit/Debit Card"]
  var selectedIndex:Int?
    var bannerapidata2: [Package] = [] {
        didSet {
         bannerapidata = bannerapidata2
        }
    }   
    var bannerapidata: [Package] = []
    
    var cartItems : [CartPackageItem] = [] {
        didSet {
            orderSummaryHeight.constant = 320 + CGFloat(cartItems.count * 150)
            scrollHeight.constant = CGFloat(orderSummaryHeight.constant) + 680
            ordersummarycollectview.reloadData()
        }
    }
    var cod = false
    

    
  override func viewDidLoad() {
    super.viewDidLoad()
      NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotificationFromCartCell(notification:)), name: Notification.Name("tokenData"), object: nil)


      
      
      let result = PaymentHandler.applePayStatus()
      var button: UIButton?
     
      if result.canMakePayments {
          button = PKPaymentButton(paymentButtonType:.plain, paymentButtonStyle: .black)
          button?.addTarget(self, action: #selector(NewOrderConfirmation_ViewController.payPressed), for: .touchUpInside)
      } else if result.canSetupCards {
          button = PKPaymentButton(paymentButtonType: .setUp, paymentButtonStyle: .black)
          button?.addTarget(self, action: #selector(NewOrderConfirmation_ViewController.setupPressed), for: .touchUpInside)
      }

      if let applePayButton = button {
          let constraints = [
            applePayButton.centerXAnchor.constraint(equalTo: applePayView.centerXAnchor),
                applePayButton.centerYAnchor.constraint(equalTo: applePayView.centerYAnchor),
                applePayButton.widthAnchor.constraint(equalTo: applePayView.widthAnchor),
                applePayButton.heightAnchor.constraint(equalTo: applePayView.heightAnchor)
          ]
          applePayButton.translatesAutoresizingMaskIntoConstraints = false
          applePayView.addSubview(applePayButton)
          applePayView.isHidden = true
          NSLayoutConstraint.activate(constraints)
      }

//      let region = MKCoordinateRegion(center: CLLocationCoordinate2DMake(37.7839, -122.4012), latitudinalMeters: 300, longitudinalMeters: 300)
//      mapView.setRegion(region, animated: true)
  
    ordersummarycollectview.delegate = self
    ordersummarycollectview.dataSource = self
    entercoupontxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
      applybtn.isEnabled = false
      applybtn.backgroundColor = .gray
      
      orderinstructiontxt.delegate = self
      headerview.backgroundColor = UIColor(named: "headercolor")
    orderinstructiontxt.addPlaceholder("orderinstruction".pLocalized(lang: LanguageManager.language))
      deliveryaddresslbl.attributedText = Utility().attributedStringWithColoredLastWord("deliveryaddress".pLocalized(lang: LanguageManager.language), lastWordColor: primaryColor!, otherWordsColor: UIColor(hexString: blackColor))
      paymentmethodlbl.attributedText = Utility().attributedStringWithColoredLastWord("paymentmethod".pLocalized(lang: LanguageManager.language), lastWordColor: primaryColor!, otherWordsColor: UIColor(hexString: blackColor))
    coupouncodelbl.attributedText = Utility().attributedStringWithColoredLastWord("couponcode".pLocalized(lang: LanguageManager.language), lastWordColor: primaryColor!, otherWordsColor: UIColor(hexString: blackColor))
    ordersummarylbl.attributedText = Utility().attributedStringWithColoredLastWord("ordersummary".pLocalized(lang: LanguageManager.language), lastWordColor: primaryColor!, otherWordsColor: UIColor(hexString: blackColor))
       let applebutton = UIButton(type: .system)
       addnewadressbtn.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
       // Add the dotted border
       addDottedBorder(to: applebutton)
       // Add the button to the view
       view.addSubview(applebutton)
     }
    @objc func methodOfReceivedNotificationFromCartCell(notification: Notification) {
        
        if let userInfo = notification.userInfo as? [String: String],
              let token = userInfo["token"] {
               print("Received token: \(token)")
            self.paymentApi(token: token, amount: self.orderDetails?.payable ?? 0.0, currency: "SAR", cartId: AppDefault.cartId ?? "")
               // You can now use the token as needed
           } else {
               print("Token not found in notification.")
           }
        
            

     }
    
    @objc func payPressed() {
            let status = PaymentHandler.applePayStatus()
            guard status.canMakePayments else {
                print("🚫 Apple Pay not available on this device")
                return
            }
        if AppDefault.currentUser?.email == nil || AppDefault.currentUser?.email == "" {
            emailhideview1.isHidden = false
            emailhideview2.isHidden = false
            emailhiddenlbl.isHidden = false
        }else {
            emailhideview1.isHidden = true
            emailhideview2.isHidden = true
            emailhiddenlbl.isHidden = true
            PaymentHandler.shared.startPayment(price: orderDetails?.total ?? 0) { success, token in
                if success, let token = token {
                    print("✅ Payment Successful, token:\n\(token)")
                    
                    
                    // 👉 Send `token` to your backend for processing
                } else {
                    print("❌ Payment Failed or Cancelled")
                }
            }
        }
    }

    @objc func setupPressed(sender: AnyObject) {
        let passLibrary = PKPassLibrary()
        passLibrary.openPaymentSetup()
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
         if let text = textField.text {
             if text.count == 5 {
                 applybtn.isEnabled = true
                 applybtn.backgroundColor = primaryColor!
             }else if text.count < 5 {
                 applybtn.isEnabled = false
                 applybtn.backgroundColor = .gray
             }
             
         }
     }
    
    func reloadData() {
        producttotaltxt.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(orderDetails?.retailTotal ?? 0, label: producttotaltxt)
        discounttxt.text = "(\(appDelegate.currencylabel + Utility().formatNumberWithCommas(orderDetails?.discount ?? 0, label: discounttxt)))"
        subtotaltxt.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(orderDetails?.subTotal ?? 0, label: subtotaltxt)
        deliverytxt.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(orderDetails?.shippmentCharges ?? 0, label: deliverytxt)
        totaltxt.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(orderDetails?.total ?? 0, label: totaltxt)
        payabletxt.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(orderDetails?.payable ?? 0 + 150, label: payabletxt)
         
          walletBalane.text = "(\(appDelegate.currencylabel + String(orderDetails?.user?.wallet?.balance ?? 0.0)))"
          //      walletBalane.text = "(\(appDelegate.currencylabel) + (orderDetails?.user?.wallet?.balance ?? 0.0) ?? 0.0))"
                walletBalance = Float(orderDetails?.user?.wallet?.balance ?? 0.0)
        
        cartItems.removeAll()
      for i in bannerapidata {
        cartItems += i.packageItems ?? []
      }

    }

  override func viewWillAppear(_ animated: Bool) {
    tabBarController?.tabBar.isHidden = true
      navigationController?.navigationBar.isHidden = true
      
    
      
      useWalltet(wallet: false)
      
      
     
    defaultAdress = AppDefault.currentUser?.defaultAddress
      if defaultAdress?.address == "" || defaultAdress?.address == nil{
          addressmainViewHeight.constant = 110
          addressviewHeight.constant = 0
      }else {
          addressmainViewHeight.constant = 220
          addressviewHeight.constant = 110
      }
      
      if defaultAdress?.localType == "local" {
          homelbl.text = (defaultAdress?.addressType?.capitalized.uppercased() ?? "") + " - Saudi Arabia".capitalized.uppercased()
       }else {
          homelbl.text = (defaultAdress?.addressType?.capitalized.uppercased() ?? "") + " - \(defaultAdress?.localType?.capitalized.uppercased() ?? "")"
      }
    addressLbl.text = defaultAdress?.address

    walletSwitch.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)

      reloadData()
      languageRender()
      
      let otherOrigin = orderDetails?.packages?.contains { pack in
          pack.packageItems?.contains { item in
              if let origin = item.product?.origin?.lowercased() {
                  return origin == "china" || origin == "pak"
              }
              return false
          } ?? false
      }
      if(otherOrigin == false && orderDetails?.payable ?? 0 <= 500){
          self.codView.isHidden = false
          self.codViewHieght.constant = 54
          self.paymentMethodHeight.constant = 280
      }else{
          self.codView.isHidden = true
          self.codViewHieght.constant = 0
          self.paymentMethodHeight.constant = 200
      }






  }
    
    func languageRender() {
        headercheckoutLbl.text = "checkout".pLocalized(lang: LanguageManager.language)
        headercartLbl.text = "cart".pLocalized(lang: LanguageManager.language)
        headerhomeLbl.text = "home".pLocalized(lang: LanguageManager.language)
        editLbl.text = "edit".pLocalized(lang: LanguageManager.language)
        addnewadressbtn.setTitle("addnewaddress".pLocalized(lang: LanguageManager.language), for: .normal)
        applybtn.setTitle("apply".pLocalized(lang: LanguageManager.language), for: .normal)
        entercoupontxt.placeholder = LanguageManager.language == "ar" ? "أدخل القسيمة" : "Enter Coupon"
        productTotalLbl.text = "producttotal".pLocalized(lang: LanguageManager.language)
        dicountLbl.text = "discount".pLocalized(lang: LanguageManager.language)
        subTotalLbl.text = "subtotal".pLocalized(lang: LanguageManager.language)
        deliveryLbl.text = "delivery".pLocalized(lang: LanguageManager.language)
        totalLbl.text = "total".pLocalized(lang: LanguageManager.language)
        payableLbl.text = "payable".pLocalized(lang: LanguageManager.language)
        placeorderbtn.setTitle("checkout".pLocalized(lang: LanguageManager.language), for: .normal)
        creditDebitLbl.text = LanguageManager.language == "ar" ? "بطاقة الائتمان/الخصم" : "Credit/Debit Card"
    }
   
    
     func addDottedBorder(to button: UIButton) {
       let dottedBorder = CAShapeLayer()
       dottedBorder.strokeColor = UIColor.black.cgColor
       dottedBorder.lineDashPattern = [4, 2] // Dash pattern (4 points on, 2 points off)
       dottedBorder.frame = button.bounds
       dottedBorder.fillColor = nil
       dottedBorder.path = UIBezierPath(roundedRect: button.bounds, cornerRadius: button.layer.cornerRadius).cgPath
       button.layer.addSublayer(dottedBorder)
     }
    @IBAction func switchChanged(_ sender: UISwitch) {
        if sender.isOn {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            self.useWalltet(wallet:true)
            
        }else {
         
                self.useWalltet(wallet:false)
           
            
        }
    }
  @IBAction func editbtn(_ sender: Any) {
    let vc = AddressViewController.getVC(.profileSubVIewStoryBoard)
    self.navigationController?.pushViewController(vc, animated: false)
  }
  @IBAction func addnewadressbtntap(_ sender: Any) {
    let vc = AddAddressViewController.getVC(.profileSubVIewStoryBoard)
    self.navigationController?.pushViewController(vc, animated: false)
  }
  @IBAction func applyBtnTapped(_ sender: Any) {
      entercoupontxt.resignFirstResponder()
      refCode(refCode: entercoupontxt.text ?? "")
   }
    
    @IBAction func savemailbtn(_ sender: Any) {
        email.resignFirstResponder()
        if email.text == "" {
            self.view.makeToast("emial is required")
        }else {
            savechanges(fullname: "", email: email.text ?? "", userid: AppDefault.currentUser?.id ?? "", agreement: "")
        }
       
    }
    
    @IBAction func debitcardBtnTapped(_ sender: Any) {
        cod = false
        chkButton.setBackgroundImage(UIImage(named: "checked"), for: .normal)
        chkButtonCOD.setBackgroundImage(UIImage(named: "uncheck"), for: .normal)
        chkButtonApple.setBackgroundImage(UIImage(named: "uncheck"), for: .normal)
        applePayView.isHidden = true
     }
    @IBAction func cashOnDeliveryBtnTapped(_ sender: Any) {
        cod = true
        chkButton.setBackgroundImage(UIImage(named: "uncheck"), for: .normal)
        chkButtonApple.setBackgroundImage(UIImage(named: "uncheck"), for: .normal)
        chkButtonCOD.setBackgroundImage(UIImage(named: "checked"), for: .normal)
        applePayView.isHidden = true

     }
    @IBAction func appleCardBtnTapped(_ sender: Any) {
        cod = false
        chkButtonApple.setBackgroundImage(UIImage(named: "checked"), for: .normal)
        chkButton.setBackgroundImage(UIImage(named: "uncheck"), for: .normal)
        chkButtonCOD.setBackgroundImage(UIImage(named: "uncheck"), for: .normal)
        applePayView.isHidden = false
     }
    
    @IBAction func placeorderbtntap(_ sender: Any) {
        
        if defaultAdress?.address == "" || defaultAdress?.address == nil{
            emailhideview1.isHidden = true
            emailhideview2.isHidden = true
            emailhiddenlbl.isHidden = true
            self.view.makeToast("Please Enter Address")
        }else {
            
            if AppDefault.currentUser?.email == nil || AppDefault.currentUser?.email == "" {
                emailhideview1.isHidden = false
                emailhideview2.isHidden = false
                emailhiddenlbl.isHidden = false
            }else {
                emailhideview1.isHidden = true
                emailhideview2.isHidden = true
                emailhiddenlbl.isHidden = true
                
                if(defaultAdress?.address == nil){
                    self.view.makeToast("Please Enter Address")
                }else{
                    if(orderDetails?.payable ?? 0.0 <= 0 && walletSwitch.isOn == true){
                        
                        self.placeOrder(cartId: orderDetails?.id ?? "")
                    }else{
                        if cod == true {
                            self.placeOrder(cartId: orderDetails?.id ?? "")
                        }else {
                            let viewController = Factory.getDefaultPaymentViewController { [weak self] result in
                                self?.handleTokenResponse(with: result)
                            }
                            Analytics.logEvent("InitiateCheckout", parameters: [
                                "action": "InitiateCheckout",
                                "category": "Ecommerce",
                                "label": "Ecommerce",
                            ])
                            self.navigationController?.pushViewController(viewController, animated: true)
                        }
                    }
                    
                }
                
            }
            
            
        }
            
          
    
//    placeOrder(cartId: orderDetails?.id ?? "")
  }
  private func placeOrder(cartId:String){
    APIServices.palceOrder(cartId: cartId){[weak self] data in
      switch data{
      case .success(let res):
      //
        let vc = InVoice_ViewController.getVC(.orderJourneyStoryBoard)
          vc.mainpackageItems = self?.cartItems
          vc.orderitems = self?.orderDetails
        self?.navigationController?.pushViewController(vc, animated: false)
      case .failure(let error):
        print(error)
      }
    }
  }
     func useWalltet(wallet:Bool){
      APIServices.useWalletApi(wallet: wallet){[weak self] data in
        switch data{
        case .success(let res):
        //
//             self?.cartItems = res.packages
            self?.orderDetails = res
            self?.producttotaltxt.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(res.retailTotal ?? 0, label:   self?.producttotaltxt)
            self?.discounttxt.text = "(\(appDelegate.currencylabel + Utility().formatNumberWithCommas(res.discount ?? 0, label:   self?.discounttxt)))"
            self?.subtotaltxt.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(res.subTotal ?? 0, label:   self?.subtotaltxt)
            self?.deliverytxt.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(res.shippmentCharges ?? 0, label:   self?.deliverytxt)
            self?.totaltxt.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(res.total ?? 0, label:   self?.totaltxt)
            self?.payabletxt.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(res.payable ?? 0 + 150, label:   self?.payabletxt)
            self?.walletBalane.text = "(\(appDelegate.currencylabel + Utility().formatNumberWithCommas(Double(res.user?.wallet?.balance ?? 0.0), label: self?.walletBalane)))"
                  self?.walletBalance = res.user?.wallet?.balance ?? 0.0
            
            if(res.payable ?? 0.0 <= 0 && self?.walletSwitch.isOn == true){
//                self?.creditCardView.isHidden = true
//                self?.credViewHeight.constant = 0
                self?.paymentMethodHeight.constant = 70 + 70
                self?.cod = false
                self?.codView.isHidden = true
                self?.codViewHieght.constant = 0

            }else{
              
                
                let otherOrigin = self?.orderDetails?.packages?.contains { pack in
                    pack.packageItems?.contains { item in
                        if let origin = item.product?.origin?.lowercased() {
                            return origin == "china" || origin == "pak"
                        }
                        return false
                    } ?? false
                }
                if(otherOrigin == false && self?.orderDetails?.total ?? 0 <= 500){
                    self?.codView.isHidden = false
                    self?.codViewHieght.constant = 54
                    self?.paymentMethodHeight.constant = 220 + 60
                }else{
                    self?.codView.isHidden = true
                    self?.codViewHieght.constant = 0
                    self?.paymentMethodHeight.constant = 130 + 70
                }
                

                
            }
            
            
            
            self?.ordersummarycollectview.reloadData()
        case .failure(let error):
          print(error)
            self?.walletSwitch.isOn = false
            self?.view.makeToast(error)
            
            
        }
      }
    }
    
    func refCode(refCode:String){
     APIServices.refCodeApi(refCodee: refCode) {[weak self] data in
       switch data{
       case .success(let res):
         print(res)
           self?.orderDetails2 = res.cart
           self?.bannerapidata2 = res.cart?.packages ?? []
       case .failure(let error):
         print(error)
        self?.view.makeToast(error)
       }
     }
   }
    func paymentApi(token:String,amount:Double,currency:String,cartId:String){
        APIServices.checkoutpayment(token: token, amount: amount, currency: currency, cartId: cartId){[weak self] data in
            switch data{
            case .success(let res):
                
                
                
                
                
                
                
                Analytics.logEvent("purchase", parameters: [
                    "action": "purchase",
                    "category": "Ecommerce",
                    "label": "Ecommerce",
                ])
                let vc = InVoice_ViewController.getVC(.orderJourneyStoryBoard)
                vc.mainpackageItems = self?.cartItems
                vc.orderitems = self?.orderDetails
                vc.invoiceNumber = res.orderDetailID
                self?.navigationController?.pushViewController(vc, animated: true)
                
            case .failure(let error):
                //         UIApplication.pTopViewController().navigationController?.popViewController(animated: true)
                self?.view.makeToast(error)
                
                
            }
        }
    }
  func payment3dsApi(token:String,amount:Double,currency:String,cartId:String){
    APIServices.payment3dsApi(token: token, amount: amount, currency: currency, cartId: cartId){[weak self] data in
     switch data{
     case .success(let res):
       
               
             
         self?.ThreeDsUrl(redirecturl: res.links?.redirect?.href ?? "")
               
               
               
        
     case .failure(let error):
//         UIApplication.pTopViewController().navigationController?.popViewController(animated: true)
         self?.view.makeToast(error)
         
         let alert = UIAlertController(title: "transactionfailed".pLocalized(lang: LanguageManager.language), message: error, preferredStyle: .alert)
      

         alert.addAction(UIAlertAction(title: "tryagain".pLocalized(lang: LanguageManager.language), style: .default, handler: nil))

         self?.present(alert, animated: true, completion: nil)
      }
     }
   }

}
extension NewOrderConfirmation_ViewController:UICollectionViewDelegate,UICollectionViewDataSource{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return cartItems.count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderSummary_CollectionViewCell", for: indexPath) as! OrderSummary_CollectionViewCell
    let data = cartItems[indexPath.row].product
    cell.img.pLoadImage(url: data?.mainImage ?? "")
      cell.productName.text = LanguageManager.language == "ar" ? data?.lang?.ar?.productName ?? data?.productName : data?.productName ?? ""
    if data?.onSale == true {
        cell.productPrice.attributedText = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(data?.salePrice ?? 0, label:   cell.productPrice))
    }else {
        cell.productPrice.attributedText = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(data?.regularPrice ?? 0, label:  cell.productPrice))
    }
    return cell
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      return CGSize(width: collectionView.frame.width, height: 140)
  }
}
extension NewOrderConfirmation_ViewController:UITableViewDelegate,UITableViewDataSource, UICollectionViewDelegateFlowLayout{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return methodNameArray.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Paymentmethod_TableViewCell", for: indexPath) as! Paymentmethod_TableViewCell
    cell.namelbl.text = methodNameArray[indexPath.row]
    cell.methodImg.setBackgroundImage(UIImage(systemName: methodimgArray[indexPath.row]), for: .normal)
    cell.checkBtn.tag = indexPath.row
    cell.checkBtn.addTarget(self, action: #selector(checkBtnTapped(_:)), for: .touchUpInside)
//    if selectedIndex == nil {
//      if indexPath.row == 1 {
//        cell.checkBtn.setBackgroundImage(UIImage(named: "checked"), for: .normal)
//      }
//    }else {
//      if selectedIndex == indexPath.row {
//        cell.checkBtn.setBackgroundImage(UIImage(named: "checked"), for: .normal)
//      }else {
//        cell.checkBtn.setBackgroundImage(UIImage(named: "uncheck"), for: .normal)
//      }
//    }
    return cell
  }
  private func handleTokenResponse(with result: Result<TokenDetails, TokenRequestError>) {
    switch result {
    case .failure(let failure):
      switch failure {
      case .userCancelled:
        print("user tapped cancelled with Error code : \(failure.code)")
      case .applePayTokenInvalid:
        showAlert(with: "Error code: \(failure.code)", title: "ApplePay Token Invalid")
      case .cardValidationError(let cardValidationError):
        showAlert(with: "Error code: \(cardValidationError.code)", title: "Card Validation Error")
      case .networkError(let networkError):
        showAlert(with: "Error code: \(networkError.code)", title: "Network Error")
      case .serverError(let serverError):
        showAlert(with: "Error code: \(serverError.code)", title: "Server Error")
      case .couldNotBuildURLForRequest:
        showAlert(with: "Error code: \(failure.code)", title: "Could Not Build URL")
      case .missingAPIKey:
        showAlert(with: "You need to make sure an API key is present", title: "Missing API Key")
      }
    case .success(let tokenDetails):
        payment3dsApi(token: tokenDetails.token, amount: orderDetails?.payable ?? 0.0
                   , currency: "SAR", cartId: AppDefault.cartId ?? "")
    }
  }
  private func showAlert(with message: String, title: String = "Payment") {
   DispatchQueue.main.async {
    let alert = UIAlertController(title: title,
                   message: message,
                   preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .default) { _ in
     alert.dismiss(animated: true)
    }
    alert.addAction(action)
    self.present(alert, animated: true)
   }
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row == 0 {
//      customizeNavigationBarAppearance(backgroundColor: .white, foregroundColor: .black)
//      let viewController = Factory.getDefaultPaymentViewController { [weak self] result in
//       self?.handleTokenResponse(with: result)
//      }
//      navigationController?.pushViewController(viewController, animated: true)
    }
  }
  @objc func checkBtnTapped(_ sender: UIButton) {
//    print("Button was clicked!")
//    self.selectedIndex = sender.tag
//    paymentmethodtblview.reloadData()
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
}

extension NewOrderConfirmation_ViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if  orderinstructiontxt.text == ""
           {
            orderinstructiontxt.showPlaceholder()
           }
           else
           {
               orderinstructiontxt.hidePlaceholder()
           }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
         let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
         return newText.count < 200
    }
    func ThreeDsUrl(redirecturl:String){
        if( AppConstants.API.environment == .prod){
            let threeDSWebViewController = ThreedsWebViewController(
                environment: .live, successUrl: URL(string: "https://mysouq.com/payment-success") ?? URL(fileURLWithPath: ""),
                failUrl: URL(string: "https://mysouq.com/payment-failure") ?? URL(fileURLWithPath: ""))
            threeDSWebViewController.authURL =  URL(string: redirecturl) ?? URL(fileURLWithPath: "")
            threeDSWebViewController.delegate = self
            present(threeDSWebViewController, animated: true)
        }else{
            let threeDSWebViewController = ThreedsWebViewController(
                environment: .sandbox, successUrl: URL(string: "https://stage.mysouq.com/payment-success") ?? URL(fileURLWithPath: ""),
                failUrl: URL(string: "https:/stage.mysouq.com/payment-failure") ?? URL(fileURLWithPath: ""))
            threeDSWebViewController.authURL =  URL(string: redirecturl) ?? URL(fileURLWithPath: "")
            threeDSWebViewController.delegate = self
            present(threeDSWebViewController, animated: true)
        }
        
        
    }
}
extension NewOrderConfirmation_ViewController: ThreedsWebViewControllerDelegate {

    func threeDSWebViewControllerAuthenticationDidSucceed(_ threeDSWebViewController: ThreedsWebViewController, token: String?) {
        print(token)
        self.dismiss(animated: true) {
            self.paymentApi(token: token ?? "", amount: self.orderDetails?.payable ?? 0.0, currency: "SAR", cartId: AppDefault.cartId ?? "")
        }
       
        
       
    }

    func threeDSWebViewControllerAuthenticationDidFail(_ threeDSWebViewController: ThreedsWebViewController) {
        self.dismiss(animated: true) {
            self.showAlert(with: "3DS payment failed", title: "Information")
        }
    }

}


extension NewOrderConfirmation_ViewController {
    func savechanges(fullname: String,email:String,userid:String,agreement:String){
        APIServices.personaldetail(fullname: fullname, email: email, userid: userid, agreement: agreement, completion:{ [weak self] data in
            switch data{
            case .success(let res):
                AppDefault.currentUser = res
                self?.view.makeToast("Email update successfully")
                self?.emailhideview1.isHidden = true
                self?.emailhideview2.isHidden = true
                self?.emailhiddenlbl.isHidden = true
            case .failure(let error):
                print(error)
                self?.view.makeToast(error)
            }
        })
     }

}


extension NewOrderConfirmation_ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // This dismisses the keyboard
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        
    }
 
    
}
