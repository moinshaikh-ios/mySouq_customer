//
//  StoreFilterscategory_TableViewCell.swift
//  Bazaar Ghar
//
//  Created by Umair Ali on 13/07/2024.
//

import UIKit

class StoreFilterscategory_TableViewCell: UITableViewCell {
    @IBOutlet weak var categoryBtnTap : UIButton!
    @IBOutlet weak var img : UIButton!
    @IBOutlet weak var lbl : UILabel!
    @IBOutlet weak var countlbl : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
