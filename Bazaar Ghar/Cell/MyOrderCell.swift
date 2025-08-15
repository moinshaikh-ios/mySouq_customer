//
//  MyOrderCell.swift
//  Bazaar Ghar
//
//  Created by Developer on 19/09/2023.
//

import UIKit

class MyOrderCell: UITableViewCell {
    @IBOutlet weak var orderId: UILabel!

    @IBOutlet weak var orderproductcell: UITableView!
    
    @IBOutlet weak var deliverychargeslbl: UILabel!
    @IBOutlet weak var ecpecteddeliverylbl: UILabel!

    @IBOutlet weak var orderTotalprice: UILabel!
    @IBOutlet weak var statusBtn: UIButton!
    @IBOutlet weak var statusBtnWidth: NSLayoutConstraint!

    
    //var orderItemsResponse: MyOrderResult?
    
    var orderItemsResponse : MyOrderResult?{
        didSet{
            orderproductcell.reloadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        orderproductcell.delegate = self
        orderproductcell.dataSource = self
        ecpecteddeliverylbl.text = "expectedcharges".pLocalized(lang: LanguageManager.language)
//        deliverychargeslbl.text = "deliverycharges".pLocalized(lang: LanguageManager.language)


        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension MyOrderCell : UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderItemsResponse?.orderItems?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderproductcell", for: indexPath) as! orderproductcell
        let data = orderItemsResponse?.orderItems?[indexPath.row].product
        cell.productimg.pLoadImage(url: data?.mainImage ?? "")
        if(LanguageManager.language == "ar"){
            if(data?.lang != nil){
                cell.productname.text = data?.lang?.ar?.productName ?? ""
            }else{
                cell.productname.text = data?.productName ?? ""
            }
         
        }else{
            cell.productname.text = data?.productName
        }
       
        cell.productprice.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(data?.price ?? 0, label:  cell.productprice) //"PKR \(data?.price ?? 0)"
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        var count = 150 * (orderItemsResponse?.count ?? 0)
        return 100
       
    }
  
}



