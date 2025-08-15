//
//  HotDealView.swift
//  Bazaar Ghar
//
//  Created by Developer on 24/04/2025.
//

import UIKit

class HotDealView: UIViewController,UITableViewDataSource , UITableViewDelegate {

    @IBOutlet weak var hotsdealsview: UITableView!
    
    var results: [HotDeals]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hotsdealsview.dataSource = self
        hotsdealsview.delegate = self
        hotdealsapi()
        // Do any additional setup after loading the view.
    }

    func hotdealsapi(){
      APIServices.hotdeals{[weak self] data in
       switch data{
       case .success(let res):
           
           self?.results = res.results ?? []
           self?.hotsdealsview.reloadData()
       case .failure(let error):
  //         UIApplication.pTopViewController().navigationController?.popViewController(animated: true)
           self?.view.makeToast(error)
        }
       }
     }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return results?.count ?? 0

     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "HotDealTableViewCell") as! HotDealTableViewCell
         let data = results?[indexPath.row]
         cell.imgProduct.pLoadImage(url: data?.image ?? "" )
         cell.productLabel.text = data?.name
 //
         return cell
     }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
         
     }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let data = results?[indexPath.row]
         let vc = HotDealProducts.getVC(.sidemenu)
         vc.headerName = data?.name ?? ""
         vc.id = data?.id ?? ""
         self.navigationController?.pushViewController(vc, animated: false)

        
 //        if categoryStates.isEmpty {
 //            self.backButton.isHidden = true // Hide back button when no more previous states
 //        }else{
 //            self.backButton.isHidden = false
 //        }
     }
    
    
}
