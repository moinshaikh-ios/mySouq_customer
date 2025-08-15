//
//  orderproductcell.swift
//  Bazaar Ghar
//
//  Created by Developer on 19/09/2023.
//

import UIKit

class orderproductcell: UITableViewCell {
    @IBOutlet weak var productimg: UIImageView!
    @IBOutlet weak var productname: UILabel!
    @IBOutlet weak var productprice: UILabel!
    @IBOutlet weak var returnBtn: UIButton!
    @IBOutlet weak var productReviewBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
