//
//  SenderimageCell.swift
//  Bazaar Ghar
//
//  Created by ChAwais on 13/12/2023.
//

import UIKit

class SenderimageCell: UITableViewCell {
    
    @IBOutlet weak var playImage: UIImageView!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var imageTapper: UIButton!
    @IBOutlet weak var days: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
