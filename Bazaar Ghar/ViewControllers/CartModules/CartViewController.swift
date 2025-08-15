//
//  CartViewController.swift
//  Bazaar Ghar
//
//  Created by Zany on 29/08/2023.
//

import UIKit

class CartViewController: UIViewController {
    @IBOutlet weak var Backgroundpopview: UIView!
    @IBOutlet weak var popview: UIView!
    @IBOutlet weak internal var cartTableViewCell: UITableView!
    @IBOutlet weak var subTotal: UILabel!
    @IBOutlet weak var emptyCart: UIView!
    @IBOutlet weak var total: UILabel!
    var iccomeformProduct : Bool = false

    
    // localizationOutlest
    // localizationOutlest
     @IBOutlet weak var cartlbl: UILabel!
     @IBOutlet weak var emptycartlbl: UILabel!
     @IBOutlet weak var cartchargesmessagelbl: UILabel!
     @IBOutlet weak var totallbl: UILabel!
     @IBOutlet weak var subtotallbl: UILabel!
     @IBOutlet weak var waitlbl: UILabel!
     @IBOutlet weak var confirdeletecartlbl: UILabel!
     @IBOutlet weak var nolbl: UIButton!
     @IBOutlet weak var yeslbl: UIButton!
     @IBOutlet weak var checkoutbutton: UIButton!
    @IBOutlet weak var backbtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var headerBackgroudView: UIView!
    @IBOutlet weak var V1: UIView!
    @IBOutlet weak var V2: UIView!
    @IBOutlet weak var topCountView: UIView!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var checkoutbuttonView: UIView!
    @IBOutlet weak var headercheckoutLbl: UILabel!
    @IBOutlet weak var headercartLbl: UILabel!
    @IBOutlet weak var headerhomeLbl: UILabel!

    // localizationOutlest
    // localizationOutlest

    
    var bannerapidata: [Package] = []
    var orderDetails: CartItemsResponse?
    var defaultAdress : DefaultAddress?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if((self.tabBarController?.tabBar.isHidden) != nil){
//            appDelegate.isbutton = true
//        }else{
//            appDelegate.isbutton = false
//        }
//        NotificationCenter.default.post(name: Notification.Name("ishideen"), object: nil)
        
        headerBackgroudView.backgroundColor = UIColor(named: "headercolor")
//        Utility().setGradientBackgroundForBtn(button: checkoutbutton, colors: [primaryColor, primaryColor, headerSecondaryColor])
//        headerBackgroudView.backgroundColor = UIColor(named: "headercolor") V1, colors: [primaryColor, primaryColor, headerSecondaryColor])
//        headerBackgroudView.backgroundColor = UIColor(named: "headercolor") V2, colors: [primaryColor, primaryColor, headerSecondaryColor])

        cartTableViewCell.dataSource = self
        cartTableViewCell.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotificationFromCartCell(notification:)), name: Notification.Name("reloadData"), object: nil)
        
        
        self.emptyCart.isHidden = true
        self.deleteBtn.isHidden = true
        self.popview.isHidden = true
        self.Backgroundpopview.isHidden = true

    }
    override func viewWillAppear(_ animated: Bool) {
        self.dismiss(animated: false)
        self.LanguageRender()
    
        self.navigationController?.isNavigationBarHidden = true
        if(appDelegate.isback){
            appDelegate.isback = false
            self.tabBarController?.selectedIndex = 0
        }
        getCartProducts()
    }
    
    func LanguageRender(){
        cartlbl.text = "cart".pLocalized(lang: LanguageManager.language)
        headercheckoutLbl.text = "checkout".pLocalized(lang: LanguageManager.language)
        headercartLbl.text = "cart".pLocalized(lang: LanguageManager.language)
        headerhomeLbl.text = "home".pLocalized(lang: LanguageManager.language)
        emptycartlbl.text = "emptycart".pLocalized(lang: LanguageManager.language)
//        cartchargesmessagelbl.text = "cartchargesmessage".pLocalized(lang: LanguageManager.language)
        totallbl.text = "total".pLocalized(lang: LanguageManager.language)
        subtotallbl.text = "subtotal".pLocalized(lang: LanguageManager.language)
        waitlbl.text = "wait".pLocalized(lang: LanguageManager.language)
        confirdeletecartlbl.text = "confirdeletecart".pLocalized(lang: LanguageManager.language)
        nolbl.setTitle("cancel".pLocalized(lang: LanguageManager.language),for: .normal)
        yeslbl.setTitle("delete".pLocalized(lang: LanguageManager.language),for: .normal)
        checkoutbutton.setTitle("checkout".pLocalized(lang: LanguageManager.language),for: .normal)
        if LanguageManager.language == "ar"{
            backbtn.setImage(UIImage(systemName: "arrow.right"), for: .normal)
           }else{
               backbtn.setImage(UIImage(systemName: "arrow.left"), for: .normal)
           }
        
    }
    
    @objc func methodOfReceivedNotificationFromCartCell(notification: Notification) {
        getCartProducts()
    }
    
    
    private func getCartProducts(){
    
        APIServices.getCartItems(background: false){[weak self] data in
            switch data{
            case .success(let res):
             
                AppDefault.cartId =  res.id
            
                AppDefault.currentUser?.defaultAddress = res.user?.defaultAddress
                self?.orderDetails = res
                    self?.bannerapidata = res.packages ?? []
                if(self?.bannerapidata.count ?? 0 > 0){
                    self?.emptyCart.isHidden = true
                    self?.deleteBtn.isHidden = false

                }else{
                    self?.emptyCart.isHidden = false
                    self?.deleteBtn.isHidden = true
                }
                
                if res.packages?.count == 0 {
                    self?.topCountView.isHidden = true
                    self?.priceView.isHidden = true
                    self?.checkoutbuttonView.isHidden = true
                    
                }else {
                    self?.topCountView.isHidden = false
                    self?.priceView.isHidden = false
                    self?.checkoutbuttonView.isHidden = false
                }
                if(self?.iccomeformProduct == true){
                    self?.iccomeformProduct = false
                    let vc = NewOrderConfirmation_ViewController.getVC(.orderJourneyStoryBoard)
                    vc.orderDetails =  self?.orderDetails
                    vc.bannerapidata = self?.bannerapidata ?? []
                    self?.navigationController?.pushViewController(vc, animated: false)
                    
                }

                self?.cartchargesmessagelbl.text = LanguageManager.language == "ar" ? "رسوم الشحن في المملكة العربية السعودية هي: 30.0 ريال سعودي لكل طرد" :"Shipping Charges in Saudia Arabia are SAR: 30.0 per package"

                self?.subTotal.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(res.subTotal ?? 0, label: self?.subTotal) //Utility().convertAmountInComma("\(res.subTotal ?? 0)")
                self?.total.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(res.total ?? 0, label:  self?.total) //Utility().convertAmountInComma("\(res.total ?? 0)")
                self?.cartTableViewCell.reloadData()
            
            case .failure(let error):
                print(error)
                self?.emptyCart.isHidden = false
                if(error == "Please authenticate" && AppDefault.islogin){
//                     appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                    let vc = PopupLoginVc.getVC(.popups)
                  vc.modalPresentationStyle = .overFullScreen
                  self?.present(vc, animated: true, completion: nil)
                 }else if(error == "Please authenticate" && !AppDefault.islogin){
                     //                     appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                        let vc = PopupLoginVc.getVC(.popups)
                        vc.modalPresentationStyle = .overFullScreen
                        self?.present(vc, animated: true, completion: nil)
                 }else{
                     if error != "OK" || error != "ok" {
                         self?.view.makeToast(error)

                     }
                 }
            }
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func deleteCartBtn(_ sender: Any) {
        
        appDelegate.ChineseShowCustomerAlertControllerHeight(
            title: LanguageManager.language == "ar" ? "هل أنت متأكد أنك تريد حذف كافة المنتجات من سلة التسوق؟" : "Are you sure you want to delete all products from cart?",
            heading: LanguageManager.language == "ar" ? "حذف الكل" : "Delete All",
            note: "",
            miscid: "self.miscid",
            btn1Title: LanguageManager.language == "ar" ? "يلغي" : "Cancel",
            btn1Callback: {
            
            }, btn2Title: "delete".pLocalized(lang: LanguageManager.language)) { token, id in
            self.deleteCartApi()
        }
        
//        popview.isHidden = false
//        self.Backgroundpopview.isHidden = false

    }
    
    @IBAction func checkout_btn(_ sender: Any) {
        
        let vc = NewOrderConfirmation_ViewController.getVC(.orderJourneyStoryBoard)
        vc.orderDetails =  orderDetails
        vc.bannerapidata = self.bannerapidata
        self.navigationController?.pushViewController(vc, animated: true)

    }

    
    @IBAction func yesBtn(_ sender: Any) {
        deleteCartApi()
        
    }
   
    private func deleteCartApi(){
        APIServices.deleteCart(){[weak self] data in
            switch data{
            case .success(let res):

             //
                self?.popview.isHidden = true
                self?.Backgroundpopview.isHidden = true

                self?.getCartProducts()
              

            case .failure(let error):
                print(error)
            }
        }
    }
    @IBAction func noBtn(_ sender: Any) {
        popview.isHidden = true
        self.Backgroundpopview.isHidden = true

    }
}



extension CartViewController : UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bannerapidata.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartStoreLableCell", for: indexPath) as! CartStoreLableCell
        let item = bannerapidata[indexPath.row]
        cell.storeLabel?.text = LanguageManager.language == "ar" ? "الحزمة \(indexPath.row + 1) بواسطة " + (item.seller?.sellerDetail?.brandName ?? "") : "Package \(indexPath.row + 1) by " + (item.seller?.sellerDetail?.brandName ?? "")
        cell.bannerapidata = item.packageItems
             return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = bannerapidata[indexPath.row]
        if(item.packageItems?.count ?? 0 == 1){
            return CGFloat(170 * (item.packageItems?.count ?? 0))
        }else{
            return CGFloat(150 * (item.packageItems?.count ?? 0))
        }
     
      
    }
  
}


