//
//  OrderConfirmation_VC.swift
//  Bazaar Ghar
//
//  Created by Developer on 14/09/2023.
//

import UIKit

class OrderConfirmation_VC: UIViewController {
    @IBOutlet weak var producttotal: UILabel!
    @IBOutlet weak var phone: UILabel!
    
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var discountonproduct: UILabel!
    @IBOutlet weak var subtotal: UILabel!
    @IBOutlet weak var addressType: UILabel!
    @IBOutlet weak var addressTypeView: UIView!

    @IBOutlet weak var deliverycharges: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var payable: UILabel!
    @IBOutlet weak var grandTotal: UILabel!
    @IBOutlet weak var totalitems: UILabel!
    @IBOutlet weak var placeorder: UIButton!
    @IBOutlet weak var editbtn: UIButton!
    @IBOutlet weak var adressViewHeight: NSLayoutConstraint!
    @IBOutlet weak var localTypeViewWidth: NSLayoutConstraint!
    @IBOutlet weak var orderInstructionTextView: UITextView!

    @IBOutlet weak var orderConfirmationLbl: UILabel!
    @IBOutlet weak var shippingAddress: UILabel!
    @IBOutlet weak var AddAddressBtn: UIButton!
    @IBOutlet weak var cashOnDeliveryLbl: UILabel!
    @IBOutlet weak var refrelCodeTF: UITextField!
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var orderSummaryLbl: UILabel!
    @IBOutlet weak var productTotalLbl: UILabel!
    @IBOutlet weak var dicountOnProductLbl: UILabel!
    @IBOutlet weak var subTotalLbl: UILabel!
    @IBOutlet weak var deliveryChargerLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var payableLbl: UILabel!
    
    @IBOutlet weak var backbutton: UIButton!
    
    var orderDetails: CartItemsResponse?
    var itemCount = 0
    var defaultAdress : DefaultAddress?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.LanguageRender()
        orderInstructionTextView.addPlaceholder("orderinstruction".pLocalized(lang: LanguageManager.language))
            self.navigationController?.isNavigationBarHidden = true
            defaultAdress = AppDefault.currentUser?.defaultAddress
            setOrderData()
            getTotalItems()
            totalitems.text = "Total (" + "\(itemCount)" + " item)"
            getaddress()
    }
    
    func LanguageRender() {
        orderConfirmationLbl.text = "orderconfirmation".pLocalized(lang: LanguageManager.language)
        shippingAddress.text = "shippingaddress".pLocalized(lang: LanguageManager.language)
        AddAddressBtn.setTitle("addnewaddress".pLocalized(lang: LanguageManager.language), for: .normal)
        cashOnDeliveryLbl.text = "cashondelivery".pLocalized(lang: LanguageManager.language)
        refrelCodeTF.placeholder = "refferalcode".pLocalized(lang: LanguageManager.language)
        applyBtn.setTitle("apply".pLocalized(lang: LanguageManager.language), for: .normal)
        orderSummaryLbl.text = "ordersummary".pLocalized(lang: LanguageManager.language)
        productTotalLbl.text = "producttotal".pLocalized(lang: LanguageManager.language)
        dicountOnProductLbl.text = "discountonproduct".pLocalized(lang: LanguageManager.language)
        subTotalLbl.text = "subtotal".pLocalized(lang: LanguageManager.language)
        deliveryChargerLbl.text = "deliverycharges".pLocalized(lang: LanguageManager.language)
        totalLbl.text = "total".pLocalized(lang: LanguageManager.language)
        payableLbl.text = "payable".pLocalized(lang: LanguageManager.language)
        placeorder.setTitle("placeorder".pLocalized(lang: LanguageManager.language), for: .normal)
        
        
        if LanguageManager.language == "ar"{
            backbutton.setImage(UIImage(systemName: "arrow.right"), for: .normal)
           }else{
               backbutton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
           }
    }
    func setOrderData(){
        producttotal.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(orderDetails?.retailTotal ?? 0, label: producttotal) //Utility().convertAmountInComma("\(orderDetails?.retailTotal ?? 0)")
        discountonproduct.text =  "(" + appDelegate.currencylabel + Utility().formatNumberWithCommas(orderDetails?.discount ?? 0, label: discountonproduct) + ")"
        subtotal.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(orderDetails?.subTotal ?? 0, label: subtotal)
        deliverycharges.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(orderDetails?.shippmentCharges ?? 0, label: deliverycharges)
        total.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(orderDetails?.total ?? 0, label: total)
        payable.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(orderDetails?.payable ?? 0, label: payable)
        grandTotal.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(orderDetails?.payable ?? 0, label: grandTotal)
    }
    
    func getTotalItems(){
        var totalQuantity = 0
        
        if let orderDetails = orderDetails {
            for i in orderDetails.packages ?? [] {
                for j in i.packageItems ?? [] {
                    if let quantity = j.quantity {
                        totalQuantity += quantity
                    }
                }
            }
           
            
        }
        print(totalQuantity)
        itemCount = totalQuantity
    }
    
    func getaddress(){
        let data = defaultAdress
        if data?.id != nil{
            if data?.localType == "local"{
                self.addressType.text = "\(data?.addressType ?? "")" + " - Pakistan"
                localTypeViewWidth.constant = 120

            }else {
                self.addressType.text = "\(data?.addressType ?? "") - \(data?.localType ?? "")"
                localTypeViewWidth.constant = 160

            }
            self.name.text = data?.fullname
            self.address.text = data?.address
            self.city.text = data?.city
            self.phone.text = data?.phone
            
            self.adressViewHeight.constant = 200
            self.addressType.isHidden = false
            self.name.isHidden = false
            self.address.isHidden = false
            self.city.isHidden = false
            self.phone.isHidden = false
            self.addressTypeView.isHidden = false
            self.editbtn.isHidden = false
            
        }else {
            self.adressViewHeight.constant = 100
            self.addressType.isHidden = true
            self.name.isHidden = true
            self.address.isHidden = true
            self.city.isHidden = true
            self.phone.isHidden = true
            self.addressTypeView.isHidden = true
            self.editbtn.isHidden = true
        }
    }
    
    private func placeOrder(cartId:String){
    
        APIServices.palceOrder(cartId: cartId){[weak self] data in
            switch data{
            case .success(let res):
             //
                let vc = InVoice_ViewController.getVC(.orderJourneyStoryBoard)
//                vc.orderID = res
                self?.navigationController?.pushViewController(vc, animated: false)

            case .failure(let error):
                print(error)
            }
        }
    }

    
    @IBAction func back_btn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    @IBAction func applybtn(_ sender: Any) {
        
     
    }
    @IBAction func placeorderbtn(_ sender: Any) {
        let data = defaultAdress
        if data?.id != nil{
            placeOrder(cartId: orderDetails?.id ?? "")
        }else {
            view.makeToast("Please Add your Address")
        }

    }
    @IBAction func addnewaddress(_ sender: Any) {
        let vc = AddressViewController.getVC(.main)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    

    @IBAction func editAddressBtn(_ sender: Any) {
        let data = defaultAdress
        let vc = AddAddressViewController.getVC(.profileSubVIewStoryBoard)
        vc.isComeChange = true
        vc.isComeOrder = true
        vc.fullname = data?.fullname ?? ""
        vc.localType = data?.localType ?? ""
        vc.phone = data?.phone ?? ""
        vc.cityy = data?.city ?? ""
        vc.address = data?.address ?? ""
        vc.addressLine_2 = data?.addressLine2 ?? ""
        vc.zipCode = "\(data?.zipCode ?? 0)"
        vc.addressID = data?.id ?? ""
        vc.country = data?.country ?? ""
        self.navigationController?.pushViewController(vc, animated: false)
        
    }

}

extension OrderConfirmation_VC: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if  orderInstructionTextView.text == ""
           {
            orderInstructionTextView.showPlaceholder()
           }
           else
           {
               orderInstructionTextView.hidePlaceholder()
           }
    }

}
