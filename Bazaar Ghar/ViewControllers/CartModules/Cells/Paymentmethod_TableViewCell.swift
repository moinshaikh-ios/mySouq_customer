//
//  Paymentmethod_TableViewCell.swift
//  Bazaar Ghar
//
//  Created by Umair Ali on 15/07/2024.
//

import UIKit

class Paymentmethod_TableViewCell: UITableViewCell {
    @IBOutlet weak var namelbl: UILabel!
    @IBOutlet weak var methodImg: UIButton!
    @IBOutlet weak var checkBtn: UIButton!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
