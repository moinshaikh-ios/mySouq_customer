//
//  ProductDetailVarientTableViewCell.swift
//  Bazaar Ghar
//
//  Created by Developer on 30/08/2023.
//

import UIKit

class ProductDetailVarientTableViewCell: UITableViewCell {

    @IBOutlet weak var attributesLbl: UILabel!
    
    @IBOutlet weak var attributesCollectionV: UICollectionView!
    var productModel : ProductCategoriesDetailsResponse?
    var productcategoriesdetailsdata : [Attributeobj]?{
        didSet{
            attributesCollectionV.reloadData()
        }
    }

    var productcategoriesdetailsvariantdata : [Variant]?{
        didSet{
            attributesCollectionV.reloadData()
        }
    }


    var SubCategorycollectionviewIndex : Int? = nil
    
    var index = Int()
    var totalIndex = Int()
    var totalindex = 0
    
    var tblCount:Int?
    var array : [Int] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension ProductDetailVarientTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.productcategoriesdetailsdata?[index].values?.count ?? 0
     }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubCategoriesCollectionView", for: indexPath) as! SubCategoriesCollectionView
        let data =  self.productcategoriesdetailsdata?[index].values?[indexPath.row].trimmingCharacters(in: .whitespaces)
        
         cell.subcollectionlabel.text = data
//        cell.subcollectionlabel.text = data?[index].value
        
        
        
        
//        if(productModel?.selectedAttributes?.contains(where: {$0.value == data}){
//            cell.subcollectionVie.backgroundColor =  Utilities.hexStringToUIColor(hex: "#53B4F7")
//            cell.subcollectionlabel.textColor = .white
//            cell.subcollectionVie.borderWidth = 0
//
//        }else{
//            cell.subcollectionVie.backgroundColor? = .white
//            cell.subcollectionlabel.textColor = .gray
//            cell.subcollectionVie.borderWidth = 1
//            cell.subcollectionVie.borderColor = UIColor.gray
//        }
//
        let attributes = [AppDefault.attribute1, AppDefault.attribute2, AppDefault.attribute3, AppDefault.attribute4, AppDefault.attribute5]
        let isSelected = (collectionView.tag < attributes.count) ? attributes[collectionView.tag] == data : false

        cell.subcollectionVie.backgroundColor = isSelected ? UIColor(named: "headercolor") : .white
        cell.subcollectionlabel.textColor = isSelected ? .white : .gray
        cell.subcollectionVie.borderWidth = isSelected ? 0 : 1
        cell.subcollectionVie.borderColor = isSelected ? nil : UIColor.gray
        
//        print(self.SubCategorycollectionviewIndex)
//        
//            if(self.SubCategorycollectionviewIndex == indexPath.row){
//                cell.subcollectionVie.backgroundColor =  Utilities.hexStringToUIColor(hex: "#53B4F7")
//                cell.subcollectionlabel.textColor = .white
//                cell.subcollectionVie.borderWidth = 0
//             
//            }else{
//                cell.subcollectionVie.backgroundColor? = .white
//                cell.subcollectionlabel.textColor = .gray
//                cell.subcollectionVie.borderWidth = 1
//                cell.subcollectionVie.borderColor = UIColor.gray
//            }
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        SubCategorycollectionviewIndex = indexPath.row

        // Fetch and filter only once
        var savedArray = UserDefaults.standard.array(forKey: "myNumbersArray") as? [Int] ?? []
        savedArray.append(collectionView.tag)
        savedArray = Array(Set(savedArray))

        print("Saved Array: \(savedArray)")

        // Trim and assign attributes dynamically
        if let data = self.productcategoriesdetailsdata?[collectionView.tag].values {
            let trimmedString = data[indexPath.row].trimmingCharacters(in: .whitespaces)
            
            switch collectionView.tag {
            case 0: AppDefault.attribute1 = trimmedString
            case 1: AppDefault.attribute2 = trimmedString
            case 2: AppDefault.attribute3 = trimmedString
            case 3: AppDefault.attribute4 = trimmedString
            case 4: AppDefault.attribute5 = trimmedString
            default: break
            }
        }

        // Check if selection is complete
        if savedArray.count == tblCount {
            print("success")

            let count = self.productcategoriesdetailsdata?.count ?? 0

            for variant in self.productcategoriesdetailsvariantdata ?? [] {
                // Evaluate only necessary conditions dynamically
                let selectedAttributes = [
                    count >= 1 ? AppDefault.attribute1?.lowercased() : nil,
                    count >= 2 ? AppDefault.attribute2?.lowercased() : nil,
                    count >= 3 ? AppDefault.attribute3?.lowercased() : nil,
                    count >= 4 ? AppDefault.attribute4?.lowercased() : nil,
                    count >= 5 ? AppDefault.attribute5?.lowercased() : nil
                ].compactMap { $0 } // Remove nil values

                let variantAttributes = variant.selectedAttributes?.prefix(selectedAttributes.count).compactMap { $0.value?.lowercased() } ?? []

                if selectedAttributes.elementsEqual(variantAttributes) {
                    print(variant.slug ?? "")
                    let imageDataDict: [String: String] = [
                        "variantSlug": variant.slug ?? "",
                        "iselectd": "true",
                        "SubCategorycollectionviewIndex": "\(indexPath.row)"
                    ]
                    NotificationCenter.default.post(name: Notification.Name("variantSlug"), object: nil, userInfo: imageDataDict)
                    break // Stop after finding the first match
                }
            }
        }
        
        saveAndAppendToArray(newElement: collectionView.tag)
        attributesCollectionV.reloadData()
    }

    
    func saveAndAppendToArray(newElement: Int) {
        let defaults = UserDefaults.standard
        let key = "myNumbersArray"
        
        // Retrieve the current array from UserDefaults, or create an empty one if it doesn't exist
        var currentArray = defaults.array(forKey: key) as? [Int] ?? [Int]()
        
        // Append the new element to the array
        currentArray.append(newElement)
        
        // Save the updated array back to UserDefaults
        defaults.set(currentArray, forKey: key)
        
        print("Updated Array: \(currentArray)")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
        let data =  self.productcategoriesdetailsdata?[index].values?[indexPath.row]
        
        if indexPath.row <= self.productcategoriesdetailsdata?[index].values?.count ?? 0 - 1 {
                  label.text = data
              }
              
              label.sizeToFit()
              return CGSize(width: label.frame.width + 20, height: 35)
    }
    
}
