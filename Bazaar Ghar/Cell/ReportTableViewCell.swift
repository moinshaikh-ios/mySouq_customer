//
//  ReportTableViewCell.swift
//  Bazaar Ghar
//
//  Created by Developer on 10/10/2023.
//

import UIKit

class ReportTableViewCell: UITableViewCell {

    @IBOutlet weak var img : UIImageView!
    @IBOutlet weak var lbl : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
