//
//  Inbox_TableViewCell.swift
//  bazaar Ghar
//
//  Created by Umair ALi on 25/08/2023.
//

import UIKit

class Inbox_TableViewCell: UITableViewCell {
    @IBOutlet weak var inbox_img: UIImageView!
    
    @IBOutlet weak var lblcount: UILabel!
    @IBOutlet weak var namelbl: UILabel!
    @IBOutlet weak var inbox_date: UILabel!
    @IBOutlet weak var inbox_lbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
