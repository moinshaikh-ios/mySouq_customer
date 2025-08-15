//
//  InVoice_ViewController.swift
//  Bazaar Ghar
//
//  Created by Umair Ali on 01/08/2024.
//

import UIKit

class InVoice_ViewController: UIViewController {
    @IBOutlet weak var headerview: UIView!
    @IBOutlet weak var invoicelbl: UILabel!
    @IBOutlet weak var datelbl: UILabel!
    @IBOutlet weak var totalamountlbl: UILabel!
    @IBOutlet weak var invoiceview: UIView!
    @IBOutlet weak var invoice_tbl: UITableView!
    @IBOutlet weak var thankyouplacingLbl: UILabel!
    @IBOutlet weak var invoiceLblar: UILabel!
    @IBOutlet weak var totalAmountLblar: UILabel!
    @IBOutlet weak var dateLblar: UILabel!
    @IBOutlet weak var itemsLblar: UILabel!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var myOrderBtn: UIButton!

    var orderID : String?
    var orderitems:CartItemsResponse?
    var mainpackageItems: [CartPackageItem]?
    var invoiceNumber : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        invoice_tbl.dataSource = self
        invoice_tbl.delegate = self
        invoicelbl.text = invoiceNumber
        headerview.backgroundColor = UIColor(named: "headercolor")
        invoiceview.backgroundColor = UIColor(named: "headercolor")
        totalamountlbl.text = "SAR \(String(format: "%.2f", orderitems?.total ?? 0))"
        setCurrentDate()
        self.navigationController?.navigationBar.isHidden = true
               tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        languageRender()
    }
    
    
    func languageRender() {
        thankyouplacingLbl.text = "thankyouplacingorder".pLocalized(lang: LanguageManager.language)
        headerLbl.text = "invoice".pLocalized(lang: LanguageManager.language)
        invoiceLblar.text = "invoice#".pLocalized(lang: LanguageManager.language)
        totalAmountLblar.text = "totalamount".pLocalized(lang: LanguageManager.language)
        dateLblar.text = "date".pLocalized(lang: LanguageManager.language)
        itemsLblar.text = "items".pLocalized(lang: LanguageManager.language)
        homeBtn.setTitle("home".pLocalized(lang: LanguageManager.language), for: .normal)
        myOrderBtn.setTitle("myorders".pLocalized(lang: LanguageManager.language), for: .normal)
    }
    
    func setCurrentDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        let currentDate = Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        
        datelbl.text = formattedDate
    }
    @IBAction func myorderbtntap(_ sender: Any) {
        let vc = Orders_VC.getVC(.orderJourneyStoryBoard)
        self.navigationController?.pushViewController(vc, animated: false)
    }

    @IBAction func homebtntap(_ sender: Any) {
        appDelegate.GotoDashBoard(ischecklogin: false)
    }
    
    
    
}
extension InVoice_ViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainpackageItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InVoice_TableViewCell", for: indexPath) as! InVoice_TableViewCell
        let data = mainpackageItems?[indexPath.row]
        cell.img.pLoadImage(url: data?.product?.mainImage ?? "")
        cell.produtname.text = LanguageManager.language == "ar" ? data?.product?.lang?.ar?.productName ?? data?.product?.productName : data?.product?.productName
        cell.Price.text    = appDelegate.currencylabel + "\(data?.product?.price?.pRoundTo(places: 2) ?? 0)"
        cell.qtylbl.text = "Qty \(data?.quantity ?? 0)"
        
        
//        cell.img.pLoadImage(url: orderitems?.orders?.first?.orderItems?[indexPath.row].product?.mainImage ?? ""
//)
//        cell.produtname.text =  orderitems?.orders?.first?.orderItems?[indexPath.row].product?.productName ?? ""
//        cell.qtylbl.text  = "\(orderitems?.orders?.first?.orderItems?[indexPath.row].product?.quantity ?? 0)"
//        cell.Price.attributedText    = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(orderitems?.orders?.first?.orderItems?[indexPath.row].product?.price ?? 0))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
        
    }
    
}
