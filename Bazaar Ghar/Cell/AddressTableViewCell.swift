//
//  AddressTableViewCell.swift
//  Bazaar Ghar
//
//  Created by Developer on 21/09/2023.
//

import UIKit

class AddressTableViewCell: UITableViewCell {

    @IBOutlet weak var addressType: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var changelbl: UILabel!

    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var changeBtn: UIButton!
    
    @IBOutlet weak var addressView: UIView!



    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        changelbl.text = "change".pLocalized(lang: LanguageManager.language)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
