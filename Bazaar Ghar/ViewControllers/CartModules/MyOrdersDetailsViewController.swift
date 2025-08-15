//
//  MyOrdersDetailsViewController.swift
//  Bazaar Ghar
//
//  Created by Developer on 20/09/2023.
//

import UIKit
import SwiftUI
import StepperView

class MyOrdersDetailsViewController: UIViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var city: UILabel!

    @IBOutlet weak var orderlbl: UILabel!
    
    @IBOutlet weak var shippedtolbl: UILabel!
    @IBOutlet weak var expecteddeliverylbl: UILabel!
    
    @IBOutlet weak var pakagelbl: UILabel!
    @IBOutlet weak var confirmedlbl: UILabel!
    @IBOutlet weak var cashondeliverylbl: UILabel!
    @IBOutlet weak var deliverychargeslbl: UILabel!
    @IBOutlet weak var subtotallbl: UILabel!
 
    
    @IBOutlet weak var orderidlbl: UILabel!
    @IBOutlet weak var orderproductcell: UITableView!

    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var paymentMethodLbl: UILabel!
    @IBOutlet weak var subtotal: UILabel!
    
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var orderTrackingBtn: UIButton!
    var orderID = String()
    var price = Double()
    var orderResponse: [NewOrderItem]?
    var shipmentCharges : Double?
    var orderStatus : String?
    var singleOrderResponse: MyOrderResult?
    var orderStatuses: [OrderTrackingOrderStatus] = []

    @IBOutlet weak var deliverycharges: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        orderproductcell.delegate = self
        orderproductcell.dataSource = self
       
    
        
        // Add stepper content to the placeholder view
      
        confirmedlbl.text = orderStatus ?? ""
        name.text = AppDefault.currentUser?.defaultAddress?.fullname
        phone.text = AppDefault.currentUser?.defaultAddress?.phone
        city.text = AppDefault.currentUser?.defaultAddress?.city
        address.text = AppDefault.currentUser?.defaultAddress?.address
        orderidlbl.text = LanguageManager.language == "ar" ? "معرف الطلب #\(orderID)" :    "Order ID #\(orderID)"
        subtotal.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(singleOrderResponse?.subTotal ?? 0, label:  subtotal)
        deliverycharges.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(shipmentCharges ?? 0.0, label: deliverycharges)
        total.text = Utility().formatNumberWithCommas((singleOrderResponse?.subTotal ?? 0) + (shipmentCharges ?? 0.0), label: total)
        cashondeliverylbl.text = singleOrderResponse?.paymentMethod?.uppercased()

        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.LanguageRender()
        
        if(self.orderStatus == "Cancel"){
            orderTrackingBtn.isHidden = true
        }else{
            orderTrackingBtn.isHidden = false
        }
        
        if self.orderStatus == "New" {
            cancelBtn.isHidden = false
        }else {
            cancelBtn.isHidden = true
        }
    }
    
    private func cancelOrder(order:String,name:String) {
        APIServices.cancelOrder(order: order, name: name,completion: {[weak self] data in
            switch data{
            case .success(let res):
                if res == "OK" {
                    self?.view.makeToast("Order Successfully Cancelled")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            case .failure(let error):
                print(error)
            }
        })
    }
    
    @IBAction func cencelBtnTapped(_ sender: UIButton) {
        let id = singleOrderResponse?._id == nil ? (singleOrderResponse?.id ?? "") : (singleOrderResponse?._id ?? "")
        cancelOrder(order: id, name: "cancel")
    }
    
    @IBAction func orderTrackingBtnTapped(_ sender: UIButton) {
        let vc  =  OrderTrackVCViewController.getVC(.orderJourneyStoryBoard)
        
        vc.singleOrderResponse = singleOrderResponse
        self.navigationController?.pushViewController(vc, animated: false)
    }

   
    func LanguageRender(){
        orderlbl.text = "orderdetails".pLocalized(lang: LanguageManager.language)
        
        if LanguageManager.language == "ar"{
            backBtn.setImage(UIImage(systemName: "arrow.right"), for: .normal)
           }else{
               backBtn.setImage(UIImage(systemName: "arrow.left"), for: .normal)
           }
//        orderlbl.text = "orders".pLocalized(lang: LanguageManager.language)
        shippedtolbl.text = "shippedto".pLocalized(lang: LanguageManager.language)
        pakagelbl.text = "package".pLocalized(lang: LanguageManager.language)
        expecteddeliverylbl.text = LanguageManager.language ==  "ar" ? "وقت التسليم المتوقع: \(singleOrderResponse?.getDeliveryTime() ?? 0) يومًا":  "Expected delivery time : \(singleOrderResponse?.getDeliveryTime() ?? 0) Days"
        subtotallbl.text = "subtotal".pLocalized(lang: LanguageManager.language)
        deliverychargeslbl.text = "deliverycharges".pLocalized(lang: LanguageManager.language)
        totalLbl.text = "total".pLocalized(lang: LanguageManager.language)
        paymentMethodLbl.text = "paymentmethod".pLocalized(lang: LanguageManager.language)
 

           UIView.appearance().semanticContentAttribute = LanguageManager.language == "ar" ? .forceRightToLeft : .forceLeftToRight
            UITextField.appearance().textAlignment = LanguageManager.language == "ar" ? .right : .left
    }
//
//    func orderTrack(id: String) {
//        APIServices.orderTracking(id: id) { [weak self] data in
//            switch data {
//            case .success(let res):
//                DispatchQueue.main.async {
//                    // Safely unwrap the stepper content
//                    if let stepperContent = self?.createStepperView(orderStatuses: res.orderStatuses) {
//                        // Add the stepper content to the placeholder view
//                        self?.stepperView.addSubview(stepperContent)
//
//                        // Enable Auto Layout
//                        stepperContent.translatesAutoresizingMaskIntoConstraints = false
//
//                        // Set Auto Layout constraints
//                        NSLayoutConstraint.activate([
//                            stepperContent.leadingAnchor.constraint(equalTo: self!.stepperView.leadingAnchor),
//                            stepperContent.trailingAnchor.constraint(equalTo: self!.stepperView.trailingAnchor),
//                            stepperContent.topAnchor.constraint(equalTo: self!.stepperView.topAnchor),
//                            stepperContent.bottomAnchor.constraint(equalTo: self!.stepperView.bottomAnchor)
//                        ])
//
//                        self?.stepperView.layoutIfNeeded() // Force layout to calculate the size
//
//                        // Set the height of the stepperView based on the content's height
//                        let contentHeight = stepperContent.frame.height
//                        self?.stepperView.heightAnchor.constraint(equalToConstant: contentHeight).isActive = true
//                    }
//                }
//                print(res)
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }

    
    
}


extension MyOrdersDetailsViewController : UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderResponse?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderproductcell2", for: indexPath) as! orderproductcell
        let data = orderResponse?[indexPath.row].product
        cell.productimg.pLoadImage(url: data?.mainImage ?? "")
        if(LanguageManager.language == "ar"){
            if(data?.lang != nil){
                cell.productname.text = data?.lang?.ar?.productName
            }else{
                cell.productname.text = data?.productName
            }
        }else{
            cell.productname.text = data?.productName
        }
        cell.productprice.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(data?.price ?? 0.0, label: cell.productprice)
        cell.returnBtn.mk_addTapHandler { (btn) in
             print("You can use here also directly : \(indexPath.row)")
             self.returnBtnTapped(btn: btn, indexPath: indexPath)
        }
        cell.productReviewBtn.mk_addTapHandler { (btn) in
             print("You can use here also directly : \(indexPath.row)")
             self.productReviewBtnTapped(btn: btn, indexPath: indexPath)
        }
        if self.orderStatus == "Delivered" {
            cell.returnBtn.isHidden = false
            cell.productReviewBtn.isHidden = false
        }else {
            cell.returnBtn.isHidden = true
            cell.productReviewBtn.isHidden = true
        }
        
        return cell
    }
    
    func returnBtnTapped(btn:UIButton, indexPath:IndexPath) {
        let data = orderResponse?[indexPath.row].product
        let vc = Return_OrderViewController.getVC(.orderJourneyStoryBoard)
        vc.productImgValue = data?.mainImage
        vc.productNameValue = data?.productName
        if data?.onSale == true {
            vc.productPriceValue = "SAR \(data?.salePrice ?? 0)"
        }else {
            vc.productPriceValue = "SAR \(data?.price ?? 0)"
        }
        vc.quantity = data?.quantity ?? 1
        if singleOrderResponse?.id == nil {
            vc.orderID = singleOrderResponse?._id
        }else {
            vc.orderID = singleOrderResponse?.id
        }
        if data?.id == nil {
            vc.refundProduct = data?._id
        }else {
            vc.refundProduct = data?.id
        }
        self.navigationController?.pushViewController(vc, animated: false)

    }
    
    func productReviewBtnTapped(btn:UIButton, indexPath:IndexPath) {
        let data = orderResponse?[indexPath.row].product
        let vc = Review_OrderViewController.getVC(.orderJourneyStoryBoard)
        vc.productImgValue = data?.mainImage
        vc.productNameValue = data?.productName
        if data?.onSale == true {
            vc.productPriceValue = "SAR \(data?.salePrice ?? 0)"
        }else {
            vc.productPriceValue = "SAR \(data?.price ?? 0)"
        }
        if data?.id == nil {
            vc.typeID = data?._id
        }else {
            vc.typeID = data?.id
        }
        if orderResponse?[indexPath.row].id == nil {
            vc.orderID = orderResponse?[indexPath.row]._id
        }else {
            vc.orderID = orderResponse?[indexPath.row].id
        }
        if singleOrderResponse?.seller?.sellerDetail?.id == nil {
            vc.sellerDetailId = singleOrderResponse?.seller?.sellerDetail?._id
        }else {
            vc.sellerDetailId = singleOrderResponse?.seller?.sellerDetail?.id     
        }
        if singleOrderResponse?.seller?.id == nil {
            vc.sellerId = singleOrderResponse?.seller?._id
        }else {
            vc.sellerId = singleOrderResponse?.seller?.id
        }
        
        self.navigationController?.pushViewController(vc, animated: false)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
       
    }
  
}

    
struct PitStopText {
    static var p1 = "What are Step Indicators? How do you represent them ?"
    static var p2 = "Step indicators are used to represent an ordered, sequential process."
        + "They can be used as navigation, or just as a visual indicator for where a user is within a process."
    static var p3 = "Even though some languages and platforms does not provide the component."
        + "Step Indicators are considered to be good, they are in fact an best way to represent the sequence of actions."
}
