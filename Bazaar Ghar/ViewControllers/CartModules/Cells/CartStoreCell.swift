//
//  CartStoreCell.swift
//  Bazaar Ghar
//
//  Created by Zany on 30/08/2023.
//

import UIKit

class CartStoreCell: UITableViewCell {
    
    @IBOutlet weak var productdelete: UIButton!
    @IBOutlet weak var productPlus: UIButton!
    @IBOutlet weak var productMinus: UIButton!
    @IBOutlet weak var productQuantity: UILabel!
    @IBOutlet weak var productprice: UILabel!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productPriceLine: UIView!
    @IBOutlet weak var discountPrice: UILabel!
    @IBOutlet weak var varientName: UILabel!
    @IBOutlet weak var varientValue: UILabel!

    var packageItem  : CartPackageItem?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func deletePackageBtn(_ sender: Any) {
       
    }
    
 
}
