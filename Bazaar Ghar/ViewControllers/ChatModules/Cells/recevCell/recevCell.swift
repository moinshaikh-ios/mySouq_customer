//
//  sendCell.swift
//  FreshTrack
//
//  Created by Revive IT on 9/26/20.
//  Copyright © 2020 Zain. All rights reserved.
//

import UIKit

class recevCell: UITableViewCell {
    @IBOutlet weak var lbltime: UILabel!
    @IBOutlet weak var lbltext: UILabel!
     @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        img.clipsToBounds = true
        img.layer.cornerRadius = 8
        img.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner ,.layerMinXMaxYCorner ]
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
