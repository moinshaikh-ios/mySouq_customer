//
//  ReportViewController.swift
//  Bazaar Ghar
//
//  Created by Developer on 10/10/2023.
//

import UIKit

class ReportViewController: UIViewController  {

    @IBOutlet weak var reportTblV : UITableView!

    @IBOutlet weak var reasonTF: UITextField!
    
    var nameArray = ["Copyright","Fake Content","Nudity","Violence","Harassment","Spam","Unauthorized","Hate speech","Somthing else"]
    
    var selectedRow: Int?
    var videoId: String?
    var comment:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.isModalInPresentation = true
        reasonTF.attributedPlaceholder = NSAttributedString(
                  string: "Reasons",
                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
              )
        reportTblV.register(UINib(nibName: "ReportTableViewCell", bundle: nil), forCellReuseIdentifier: "ReportTableViewCell")

    }
    
    override func viewDidDisappear(_ animated: Bool) {
    }
    override func viewWillDisappear(_ animated: Bool) {
        let imageDataDict:[String: String] = ["val": "close"]
        NotificationCenter.default.post(name: Notification.Name("showviews"), object: nil,userInfo: imageDataDict)
    }
    private func report(comment:String,videoId:String){
        APIServices.report(comment: comment, videoId: videoId){[weak self] data in
            switch data{
            case .success(let res):
                UIApplication.pTopViewController().view.makeToast("Report successfully submit")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self?.dismiss(animated: true)
                }
            case .failure(let error):
                print(error)
                self?.view.makeToast(error)
            }
        }
    }
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        if comment != nil {
            report(comment:self.comment ?? "",videoId:self.videoId ?? "")
        }else {
            self.view.makeToast("please select reason")
        }
    }
    

    @IBAction func crossBtnTapped(_ sender: Any) {
        self.dismiss(animated: true)

    }
}
extension ReportViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportTableViewCell", for: indexPath) as! ReportTableViewCell

        
        cell.img.image = UIImage(named: "radioBlue")
        cell.lbl.text = nameArray[indexPath.row]
        
        if indexPath.row == selectedRow {
                    cell.img.image = UIImage(named: "radio-button-svgrepo-com") // Replace with your checked checkbox image
                } else {
//                    cell.img.tintColor = UIColor(hex: primaryColor)
                    cell.img.image = UIImage(systemName: "circle") // Replace with your unchecked checkbox image
                }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = nameArray[indexPath.row]
        if let selectedRow = selectedRow {
                   let previouslySelectedIndexPath = IndexPath(row: selectedRow, section: 0)
                   if let previouslySelectedCell = tableView.cellForRow(at: previouslySelectedIndexPath) as? ReportTableViewCell {
                       // Update the checkbox image for the previously selected cell to unchecked
                       previouslySelectedCell.img.image = UIImage(systemName: "circle") // Replace with your unchecked checkbox image
                   }
               }

               // Update the selected row and change the checkbox image for the selected cell
               selectedRow = indexPath.row
               let selectedCell = tableView.cellForRow(at: indexPath) as! ReportTableViewCell
               selectedCell.img.image = UIImage(named: "radio-button-svgrepo-com") // Replace with your checked checkbox image

               // Reload the selected cell to update the checkbox image
               tableView.reloadRows(at: [indexPath], with: .none)
              self.comment = data
    }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
}
