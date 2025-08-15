//
//  AddressViewController.swift
//  Bazaar Ghar
//
//  Created by Developer on 20/09/2023.
//

import UIKit
import FirebaseAnalytics
class AddressViewController: UIViewController {

    @IBOutlet weak var addressTblv: UITableView!
    @IBOutlet weak var addressNotFoundLbl: UILabel!
    @IBOutlet weak var shippingaddresslbl: UILabel!

    @IBOutlet weak var addanewaddresslbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!

    var getAddressData: [DefaultAddress] = []
    var defaultAdress : DefaultAddress?
    override func viewDidLoad() {
        super.viewDidLoad()
       
//        if((self.tabBarController?.tabBar.isHidden) != nil){
//            appDelegate.isbutton = true
//        }else{
//            appDelegate.isbutton = false
//        }
//        NotificationCenter.default.post(name: Notification.Name("ishideen"), object: nil)
        addressTblv.delegate = self
        addressTblv.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getaddress()
        LanguageRender()
    }
    
    func LanguageRender() {
        if LanguageManager.language == "ar"{
            backBtn.setImage(UIImage(systemName: "arrow.right"), for: .normal)
            
        }else {
            backBtn.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        }
        shippingaddresslbl.text = "shippingaddress".pLocalized(lang: LanguageManager.language)
        addanewaddresslbl.text = "addnewaddress".pLocalized(lang: LanguageManager.language)
        
        addressNotFoundLbl.text = "youhavenoaddress".pLocalized(lang: LanguageManager.language)
    }
    
    private func getaddress() {
        APIServices.getaddress(completion: { [weak self] data in
            switch data {
            case .success(let res):
         //
                self?.getAddressData = res
                if res.count > 0 {
                    self?.addressTblv.isHidden = false
                    self?.addressNotFoundLbl.isHidden = true
                } else if( res.count  == 1 ) {
                    self?.defaultAdress(addressId: res[0].id ?? "", cartId: AppDefault.cartId ?? "")
                } else {
                    self?.addressTblv.isHidden = true
                    self?.addressNotFoundLbl.isHidden = false
                }
                
                self?.addressTblv.reloadData()
            case .failure(let error):
                print(error)
            }
        })
    }
    
    private func deleteAdrress(addressId:String){
        APIServices.addressDelete(addressId: addressId, completion: {[weak self] data in
            switch data{
            case .success(let res):
               //
                if(res == "OK"){
                    self?.view.makeToast("Address Deleted Successfully")
//                    UIApplication.pTopViewController().tabBarController?.view.makeToast("Successfully Deleted")
                }else{
                    self?.view.makeToast(res)
                }
                self?.getaddress()
            case .failure(let error):
                print(error)
//                self?.view.makeToast(error)
            }
        })
    }
    
    private func defaultAdress(addressId:String,cartId:String){
        APIServices.defaultAdrress(addressId: addressId, cartId: cartId, completion: {[weak self] data in
            switch data{
            case .success(let res):
               //
                AppDefault.currentUser?.defaultAddress = self?.defaultAdress 
                if(res == "ok"){
                    Analytics.logEvent("add-shipment-info", parameters: [
                                "action": "add-shipment-info",
                                "category": "Ecommerce",
                                "label": "Ecommerce",
                              ])
                    self?.view.makeToast("Set Default Address Successfully")
                }else{
//                    self?.view.makeToast(res)
                }
                
                
                self?.getaddress()
            case .failure(let error):
                print(error)
//                self?.view.makeToast(error)
            }
        })
    }

    
    
    @IBAction func AddAdressBtnTapped(_ sender: Any) {
        let vc = AddAddressViewController.getVC(.profileSubVIewStoryBoard)
        vc.isComeChange = false
        vc.isComeOrder = false
        self.navigationController?.pushViewController(vc, animated: false)
    }
   
    @IBAction func backBtnTapped(_ sender: Any) {
//        appDelegate.isbutton = false
//    NotificationCenter.default.post(name: Notification.Name("ishideen"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }

}


extension AddressViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getAddressData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTableViewCell", for: indexPath) as! AddressTableViewCell
        let data = getAddressData[indexPath.row]
        if data.localType == "local" {
            cell.addressType.text = (data.addressType ?? "") + " - Saudi Arabia"
           
        }else {
            cell.addressType.text = (data.addressType ?? "") + " - \(data.localType ?? "")"
        }
      
        cell.name.text = data.fullname
        cell.address.text = data.address
        cell.phone.text = data.phone
        cell.city.text = data.city
        
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(deleteBtnTapped(_:)), for: .touchUpInside)

        cell.changeBtn.tag = indexPath.row
        cell.changeBtn.addTarget(self, action: #selector(changeBtnTapped(_:)), for: .touchUpInside)
        cell.changelbl.text = "change".pLocalized(lang: LanguageManager.language)

        if getAddressData.count <= 0 {
            
        }
        if(data.id ?? "" == AppDefault.currentUser?.defaultAddress?.id ?? ""){
            cell.addressView.borderColor = UIColor.oceanBlue
            cell.addressView.borderWidth = 1
        }
        else {
            cell.addressView.borderColor = UIColor.white
            cell.addressView.borderWidth = 0
        }

        
        return cell
    }
    
    @objc func deleteBtnTapped(_ sender: UIButton) {
        
//        appDelegate.showCustomerAlertControllerHeight(title: "Are you sure you want to Delete Address?", heading: "Delete", btn1Title: "Cancel", btn1Callback: {
//             
//        }, btn2Title: "Delete") { [self] in
//                  let id = getAddressData[sender.tag]
//                  deleteAdrress(addressId: id.id ?? "")
//              }
        
        appDelegate.ChineseShowCustomerAlertControllerHeight(title: "Are you sure you want to Delete Address?", heading: "Delete", note: "", miscid: "self.miscid", btn1Title: "Cancel", btn1Callback: {
            
        }, btn2Title: "Delete") { token, id in
            let id = self.getAddressData[sender.tag]
            self.deleteAdrress(addressId: id.id ?? "")
        }
       
    }
    @objc func changeBtnTapped(_ sender: UIButton) {
        let data = getAddressData[sender.tag]
        let vc = AddAddressViewController.getVC(.profileSubVIewStoryBoard)
        vc.isComeChange = true
        vc.isComeOrder = false
        vc.fullname = data.fullname ?? ""
        vc.localType = data.localType ?? ""
        print("Phone Number \(data.phone ?? "")")
        if((data.phone?.contains("+")) != nil){
            vc.phone = "\(data.phone?.dropFirst(4) ?? "")"
        }else{
            
        }
        
        vc.cityy = data.city ?? ""
        vc.address = data.address ?? ""
        vc.addressLine_2 = data.addressLine2 ?? ""
        vc.zipCode = "\(data.zipCode ?? 0)"
        vc.addressID = data.id ?? ""
        vc.country = data.country ?? ""
        
        self.navigationController?.pushViewController(vc, animated: false)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let data = getAddressData[indexPath.row]
        if AppDefault.cartId == nil {
            view.makeToast("Make sure you have atleast 1 item in a cart")
        }else {
            self.defaultAdress = data
            defaultAdress(addressId: data.id ?? "", cartId: AppDefault.cartId ?? "")
//            cell.addressView.borderColor = UIColor(hexString: "#FF8319")
//            cell.addressView.borderWidth = 1
            
        }

    }
    
}
