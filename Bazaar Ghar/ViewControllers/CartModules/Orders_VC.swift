//
//  Orders_VC.swift
//  Bazaar Ghar
//
//  Created by Developer on 19/09/2023.
//

import UIKit

class Orders_VC: UIViewController {

    @IBOutlet weak var noorderlabel: UILabel!
    @IBOutlet weak var ordertable: UITableView!
    
    @IBOutlet weak var orderlbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    private var currentPage = 1
    private var isLoading = false
    private var totalPages = 0
    private var orderResponse: [MyOrderResult] = [] // Replace `Order` with your model

  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
       

//        if((self.tabBarController?.tabBar.isHidden) != nil){
//            appDelegate.isbutton = true
//        }else{
//            appDelegate.isbutton = false
//        }
//        NotificationCenter.default.post(name: Notification.Name("ishideen"), object: nil)
        ordertable.dataSource = self
        ordertable.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        currentPage = 1
           totalPages = 0
           orderResponse = []
           ordertable.reloadData() // Clear existing data
           myOrders(page: currentPage, limit: 10)
        LanguageRender()
    }
    func LanguageRender(){
        orderlbl.text = "myorders".pLocalized(lang: LanguageManager.language)
        noorderlabel.text = "noorderlabel".pLocalized(lang: LanguageManager.language)

        if LanguageManager.language == "ar"{
            backBtn.setImage(UIImage(systemName: "arrow.right"), for: .normal)
            
        }else{
            backBtn.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        }
//        orderlbl.text = "order".pLocalized(lang: LanguageManager.language)
    }
    
    private func myOrders(page: Int, limit: Int, sortBy: String = "-createdAt") {
        guard !isLoading else { return } // Prevent duplicate API calls
        isLoading = true

        // Corrected completion closure signature
        APIServices.myorder(limit: limit, sortBy: sortBy, page: page, completion: { [weak self] data in
            guard let self = self else { return }
            self.isLoading = false

            switch data {
            case .success(let res):
                self.totalPages = res.totalPages ?? 1 // Update total pages if your API provides this
                let newOrders = res.results ?? []
                if res.results?.count ?? 0 > 0 {
                    self.noorderlabel.isHidden = true
                }else {
                    self.noorderlabel.isHidden = false
                }
                if page == 1 { // Reset the orders for the first page
                    self.orderResponse = newOrders
                } else { // Append for subsequent pages
                    self.orderResponse.append(contentsOf: newOrders)
                }

                self.ordertable.reloadData()

            case .failure(let error):
                print(error)
            }
        })
    }


    
    @IBAction func newBtnTapped(_ sender: Any) {
        let vc = MyOrdersDetailsViewController.getVC(.orderJourneyStoryBoard)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
//        appDelegate.isbutton = false
//    NotificationCenter.default.post(name: Notification.Name("ishideen"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension Orders_VC : UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderResponse.count
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        if offsetY > contentHeight - frameHeight - 100 { // Adjust the threshold as needed
            if currentPage < totalPages && !isLoading {
                currentPage += 1
                
                myOrders(page: currentPage, limit: 10)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrderCell", for: indexPath) as! MyOrderCell
        let data = orderResponse[indexPath.row]
        cell.orderItemsResponse = data
        
        cell.ecpecteddeliverylbl.text = LanguageManager.language == "ar" ?  "وقت التسليم المتوقع: \(data.getDeliveryTime() ?? 0) يومًا" :      "Expected delivery time : \(data.getDeliveryTime() ?? 0) Days"
        
        
        cell.orderId.text = LanguageManager.language == "ar" ?  "معرف الطلب #\(data.orderID ?? "")" : "Order ID #\(data.orderID ?? "")"
        cell.orderTotalprice.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(data.subTotal
                                                                                                 ?? 0, label: cell.orderTotalprice) //Utility().convertAmountInComma("\(data?.retailTotal ?? 0)")
        cell.statusBtn.setTitle(data.orderStatus?.name?.capitalized ?? "", for: .normal)
        if data.orderStatus?.name == "new" {
            cell.statusBtnWidth.constant = 35
        }else {
            cell.statusBtnWidth.constant = 60
        }
        cell.deliverychargeslbl.text = "\(appDelegate.currencylabel + Utility().formatNumberWithCommas(data.shippmentCharges ?? 0, label:  cell.deliverychargeslbl)) " + "deliverycharges".pLocalized(lang: LanguageManager.language)
             return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = orderResponse[indexPath.row]
        if(item.orderItems?.count ?? 0 == 1){
            return CGFloat(260 * (item.orderItems?.count ?? 0))
        }else{
            
            let value = 160
            let height = 100 * (item.orderItems?.count ?? 0)
            
            
            return CGFloat(value + height)
        }
     
      
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = orderResponse[indexPath.row].orderItems
        let dataid = orderResponse[indexPath.row]
        
        let vc = MyOrdersDetailsViewController.getVC(.orderJourneyStoryBoard)
        vc.price = dataid.retailTotal ?? 0.0
        
        vc.orderID = orderResponse.first?.orderID ?? ""
        vc.orderResponse = data
        vc.shipmentCharges = dataid.shippmentCharges
        vc.orderStatus = dataid.orderStatus?.name?.capitalized
        vc.singleOrderResponse = orderResponse[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: false)
    }
  
    
}




