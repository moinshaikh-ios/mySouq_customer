//
//  Return_OrderViewController.swift
//  Bazaar Ghar
//
//  Created by Mac on 26/11/2024.
//

import UIKit
import DropDown
import Alamofire

class Return_OrderViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var headerview: UIView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var QuantityLbl: UILabel!
    @IBOutlet weak var minusview: UIView!
    @IBOutlet weak var dropDownbtn: UIButton!
    @IBOutlet weak var dropDownLbl: UILabel!
    @IBOutlet weak var otherFeildView: UIView!
    @IBOutlet weak var reasonTF: UITextField!
    @IBOutlet weak var returnTxtView: UITextView!
    @IBOutlet weak var quantityV1: UIView!
    @IBOutlet weak var quantityV2: UIView!
    @IBOutlet weak var uploadImageView: UIView!
    @IBOutlet weak var returnUploadImageCollectionView: UICollectionView!

    var productNameValue: String?
    var productPriceValue: String?
    var productImgValue: String?
    var selectedImages: [UIImage] = [] {
        didSet {
            if selectedImages.count == 0 {
                uploadImageView.isHidden = true
            }else {
                uploadImageView.isHidden = false
            }
            returnUploadImageCollectionView.reloadData()
        }
    }
    let dropDown = DropDown()

    var quantity: Int = 1
    var c = 1 {
        didSet {
            QuantityLbl.text = "\(c)"
            if c == 1 {
                minusview.backgroundColor = .white
                minusBtn.setTitleColor(primaryColor!, for: .normal)
            } else {
                minusview.backgroundColor = primaryColor!
                minusBtn.setTitleColor(UIColor.white, for: .normal)
            }
        }
    }
    
    var orderID : String?
    var refundProduct : String?
    let boundary = "Boundary-\(UUID().uuidString)"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
           if quantity == 1 {
               quantityV1.isHidden = true
               quantityV2.isHidden = true
           }else {
               quantityV1.isHidden = false
               quantityV2.isHidden = false
           }
       }
    
    func setupUI() {
        headerview.backgroundColor = UIColor(named: "headercolor")
        
        productImage.pLoadImage(url: productImgValue ?? "")
        productName.text = productNameValue ?? ""
        productPrice.text = productPriceValue ?? ""
        
        dropDownLbl.text = "Select Reason"
        dropDownbtn.addTarget(self, action: #selector(showDropDown), for: .touchUpInside)

        dropDown.anchorView = dropDownbtn
        dropDown.dataSource = [
            "I received a damaged product",
            "I received a wrong product",
            "Product quality is not as shown in the product image",
            "I have changed my mind",
            "Other"
        ]
        dropDown.bottomOffset = CGPoint(x: 0, y: dropDownbtn.bounds.height)
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            dropDownLbl.text = item
            otherFeildView.isHidden = item != "Other"
            if item != "Other" {
                reasonTF.text = ""
            }
        }
        
        returnTxtView.delegate = self
        returnTxtView.addPlaceholder("Tell us more about how you feel about the product!")
    }
    
    @objc func showDropDown() {
        dropDown.show()
    }
    
    @IBAction func SubtractBtn(_ sender: UIButton) {
        if c != 1 {
            c -= 1
        }
    }
    
    @IBAction func Addbtn(_ sender: UIButton) {
        if c != quantity {
            c += 1
        }
    }
    
    @IBAction func uploadBtnTapped(_ sender: UIButton) {
        if selectedImages.count == 5 {
            self.view.makeToast("only 5 images allowed")
        }else {
            pickImage()
        }
    }
    
    func pickImage() {
         let imagePicker = UIImagePickerController()
         imagePicker.delegate = self
         imagePicker.sourceType = .photoLibrary
         present(imagePicker, animated: true)
     }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)

        if let image = info[.originalImage] as? UIImage {
            selectedImages.append(image)
            print("Image selected: \(image)")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        print("Image selection canceled.")
    }
    
    @IBAction func submitBtnTapped(_ sender: UIButton) {

        if dropDownLbl.text == "Select Reason" {
            self.view.makeToast("Please Select Reason")
               return
           }
        if returnTxtView.text == ""  {
            self.view.makeToast("Please write more about product")
               return
           }
        if dropDownLbl.text == "other" {
            if reasonTF.text == ""  {
                self.view.makeToast("Please write reason")
                   return
               }
          }
        guard !selectedImages.isEmpty else {
            self.view.makeToast("Please upload image")
               return
           }

        let parameters: [String: Any] = [
            "orderId": orderID ?? "",
            "refundProduct[product]": refundProduct ?? "",
            "refundProduct[quantity]": "\(c)",
            "refundReason": dropDownLbl.text ?? "",
            "refundNote": returnTxtView.text ?? "",
        ]
        
        uploadRefundRequest(parameters: parameters, selectedImages: selectedImages)

//           uploadRefundRequest(parameters: parameters)
    }
    
    func uploadRefundRequest(parameters: [String: Any], selectedImages: [UIImage]) {
        let url = "\(AppConstants.API.baseURL)refund"

        AF.upload(
            multipartFormData: { multipartFormData in
                // Append text parameters
                for (key, value) in parameters {
                    if let stringValue = value as? String {
                        multipartFormData.append(Data(stringValue.utf8), withName: key)
                    }
                }

                // Append images
                for (index, image) in selectedImages.enumerated() {
                    if let imageData = image.jpegData(compressionQuality: 0.8) {
                        let fileName = "refund_image_\(index + 1).jpg"
                        multipartFormData.append(imageData, withName: "refundImage", fileName: fileName, mimeType: "image/jpeg")
                    }
                }
            },
            to: url, // Directly use the URL string
            method: .post,
            headers: HTTPHeaders(["Authorization": "Bearer \(AppDefault.accessToken)"])
        )
        .validate()
        .responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any], let message = json["message"] as? String {
                    print("Server Message: \(message)")
                    DispatchQueue.main.async {
                        self.view.makeToast(message)
                    }
                } else {
                    print("Unexpected response format.")
                    DispatchQueue.main.async {
                        self.view.makeToast("Unexpected response format.")
                    }
                }
            case .failure(let error):
                print("Request failed with error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.view.makeToast("Request failed with error: \(error.localizedDescription)")
                }
            }
        }
    }


}

extension Return_OrderViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        print("Text changed: \(textView.text ?? "")")
        if textView.text.count > 0 {
            returnTxtView.hidePlaceholder()
        }else {
            returnTxtView.showPlaceholder()
        }
    }

}

extension Return_OrderViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "returnUploadImage_CollectionViewCell", for: indexPath) as! returnUploadImage_CollectionViewCell
        
        cell.img.image = selectedImages[indexPath.item]
        cell.crossBtn.mk_addTapHandler { (btn) in
             self.crossBtnTapped(btn: btn, indexPath: indexPath)
        }
        
        return cell
    }

    func crossBtnTapped(btn:UIButton, indexPath:IndexPath){
        selectedImages.remove(at: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
    }

}
