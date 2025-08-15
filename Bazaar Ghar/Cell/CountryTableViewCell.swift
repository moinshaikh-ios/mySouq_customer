//
//  CountryTableViewCell.swift
//  Bazaar Ghar
//
//  Created by Developer on 25/09/2023.
//

import UIKit

class CountryTableViewCell: UITableViewCell {

    @IBOutlet weak var countryImgLbl: UILabel!
    @IBOutlet weak var countryNameLbl: UILabel!
    @IBOutlet weak var codeLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
