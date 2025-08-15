//
//  Review_OrderViewController.swift
//  Bazaar Ghar
//
//  Created by Moeen on 26/11/2024.
//

import UIKit
import Alamofire
import Cosmos

class Review_OrderViewController: UIViewController {

    @IBOutlet weak var headerview: UIView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var ratingView: CosmosView!

    var productNameValue:String?
    var productPriceValue:String?
    var productImgValue:String?
    var typeID:String?
    var orderID : String?
    var sellerDetailId:String?
    var sellerId:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        productImage.pLoadImage(url: productImgValue ?? "")
        productName.text = productNameValue ?? ""
        productPrice.text = productPriceValue ?? ""
        
        headerview.backgroundColor = UIColor(named: "headercolor")
        reviewTextView.delegate = self
        reviewTextView.addPlaceholder("Enter your text here...")

    }
    
    @IBAction func submitBtnTapped(_ sender: UIButton) {
      
        let parameters: [String: Any] = [
            "typeId": typeID ?? "",
            "rating": Int(ratingView.rating),
            "sellerId": sellerId ?? "",
            "orderId": orderID ?? "",
            "sellerDetailId": sellerDetailId ?? "",
            "comment": [
                "comment": reviewTextView.text ?? ""
            ]
        ]
        
        if reviewTextView.text.count < 3 || reviewTextView.text.count > 200 {
            self.view.makeToast("comment character required min 3 max 200 ")
        }else {
            submitMultipartFormData(endpoint: "reviews", parameters: parameters)
        }        
    }
    
  

    func submitMultipartFormData(endpoint: String, parameters: [String: Any]) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(AppDefault.accessToken)"
        ]
        
        let url = AppConstants.API.baseURLString + endpoint
        
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                if let nestedDictionary = value as? [String: Any] {
                    for (nestedKey, nestedValue) in nestedDictionary {
                        let nestedKeyWithBrackets = "\(key)[\(nestedKey)]"
                        if let nestedStringValue = nestedValue as? String {
                            multipartFormData.append(nestedStringValue.data(using: .utf8)!, withName: nestedKeyWithBrackets)
                        }
                    }
                } else if let stringValue = value as? String {
                    multipartFormData.append(stringValue.data(using: .utf8)!, withName: key)
                } else if let numberValue = value as? NSNumber {
                    let stringValue = String(describing: numberValue)
                    multipartFormData.append(stringValue.data(using: .utf8)!, withName: key)
                } else {
                    print("Unsupported parameter type for key: \(key)")
                }
            }
        }, to: url, method: .post, headers: headers)
        .validate(statusCode: 200..<500)
        .response { response in
            if let error = response.error {
                print("Error: \(error.localizedDescription)")
                self.view.makeToast("Error: \(error.localizedDescription)")
            } else if let data = response.data {
                print("Upload successful, response: \(data)")
                self.view.makeToast("Review submitted successfully")
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.navigationController?.popViewController(animated: true)
                }
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let userMessage = json["userMessage"] as? String {
                    print(userMessage)
                    self.view.makeToast(userMessage)
                }
            } else {
                print("No data received")
                self.view.makeToast("No data received")
            }
        }
    }

//    func submitMultipartFormData(endpoint: String, parameters: [String: Any]) {
//        let headers: HTTPHeaders = [
//            "Authorization": "Bearer \(AppDefault.accessToken)"
//        ]
//        
//        let url = AppConstants.API.baseURLString + endpoint
//        
//        Alamofire.upload(multipartFormData: { multipartFormData in
//            for (key, value) in parameters {
//                if let nestedDictionary = value as? [String: Any] {
//                    for (nestedKey, nestedValue) in nestedDictionary {
//                        let nestedKeyWithBrackets = "\(key)[\(nestedKey)]"
//                        if let nestedStringValue = nestedValue as? String {
//                            multipartFormData.append(nestedStringValue.data(using: .utf8)!, withName: nestedKeyWithBrackets)
//                        }
//                    }
//                } else if let stringValue = value as? String {
//                    multipartFormData.append(stringValue.data(using: .utf8)!, withName: key)
//                } else if let numberValue = value as? NSNumber {
//                    let stringValue = String(describing: numberValue)
//                    multipartFormData.append(stringValue.data(using: .utf8)!, withName: key)
//                } else {
//                    print("Unsupported parameter type for key: \(key)")
//                }
//            }
//        },
//        to: url,
//        method: .post,
//        headers: headers,
//        encodingCompletion: { result in
//            switch result {
//            case .success(let upload, _, _):
//                upload.validate(statusCode: 200..<500).response { response in
//                    if let error = response.error {
//                        print("Error: \(error.localizedDescription)")
//                        self.view.makeToast("Error: \(error.localizedDescription)")
//                    } else if let data = response.data {
//                        print("Upload successful, response: \(data)")
//                        self.view.makeToast("review submitted successfully")
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                            self.navigationController?.popViewController(animated: true)
//                        }
//                        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//                           let userMessage = json["userMessage"] as? String {
//                            print(userMessage)
//                            self.view.makeToast(userMessage)
//                        }
//                    } else {
//                        print("No data received")
//                        self.view.makeToast("No data received")
//                    }
//                }
//            case .failure(let encodingError):
//                print("Encoding error: \(encodingError.localizedDescription)")
//                self.view.makeToast(encodingError.localizedDescription)
//            }
//        })
//    }



}

extension Review_OrderViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
         print("Text changed: \(textView.text ?? "")")
        if textView.text.count > 0 {
            reviewTextView.hidePlaceholder()
        }else {
            reviewTextView.showPlaceholder()
        }
     }
}
