//
//  InVoice_TableViewCell.swift
//  Bazaar Ghar
//
//  Created by Umair Ali on 01/08/2024.
//

import UIKit

class InVoice_TableViewCell: UITableViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var qtylbl: UILabel!
    @IBOutlet weak var produtname: UILabel!

    @IBOutlet weak var Price: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
