//
//  FAQ_VC.swift
//  Bazaar Ghar
//
//  Created by Umair ALi on 21/09/2023.
//

import UIKit

class FAQ_VC: UIViewController {
    @IBOutlet weak var FAQtable: UITableView!
  var name = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        name = ["hbsnbs","habsbxhdhjdvhjdJMZNBNXZBMNXZBNZXBXZMBXZBNZXBXZNNXZBXJZHGDJYASGDJBSAHDBJSHDBJAKNAKJHDKABDAMADBBSMDNBMDBMDBCMDHBCMDBCHJBCJDNCJNDCM,DM,MCDMKJKDJJDHDJHDC HDHDHDHHDHHHHKKSNKSJKDJKSJHKDSJKHDSJHJHKDJHKJHKJHKDJHFHJGDGHHGDJFSHJGDSFHJGGHJDFSHJGDFSHJKGJKHFDSKJHJHKDFSHJKFJDSHKHJFDSHJHJKFDSJHKSDFJHKHJKDFSHJDFSHHJDFSHJHJFDSHJDFSHJKJHKDFSHJKFDSHJKJHKDFSHJKFDSHJHJKFDSHJKFHJKDSJHKFJHKJHKDFSHJKFSHKJKHJFDSHJKFDSHJKvjnnabnasbnabsnmabSNABBASNMABMNABMNSBMANBSNMABSNABSMABSNMABSBAMBSMABSNMABSMNABSNMABSNSABMNABSABSAMBSMABSAMBSMABSAMBSAMBSMABSMASBASBSAhfvhjfvhjfvhjv","hbsnbs","habsbxhASMBASANSBAMSNBAMSADBFGMBMBFHNMHXMDBHNJBCJNXHKD,MDBXHMJ S JVBSMHCGBX SHBGZ JSMFNG SNBFG MNDBCBCMNSNBNMBSNSBNBBNBNNBNXNXZNXZNXZNNXNXNXNXNdhjdvhjdvjhfvhjfvhjfvhjv","hbsnbs","habsbxhdhjdvhjdvjhfvhjfvhjfvhjv","hbsnbs","habsbxhdhjdvhjdvjhfvhjfvhjfvhjv","hbsnbs","habsbxhdhjdvhjdvjhfvhjfvhjfvhjv habsbxhdhjdvhjdvjhfvhjfvhjfvhjv","hbsnbs","habsbxhdhjdvhjdvjhfvhjfvhjfvhjv habsbxhdhjdvhjdvjhfvhjfvhjfvhjv","hbsnbs","habsbxhdhjdvhjdvjhfvhjfvhjfvhjv"]
        self.FAQtable.estimatedRowHeight = 80
         self.FAQtable.rowHeight = UITableView.automaticDimension
     
         
        
        // Do any additional setup after loading the view.
    }


}
extension FAQ_VC:UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return name.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQ_CELL", for: indexPath) as! FAQ_CELL
        cell.txt.text =  name [indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
