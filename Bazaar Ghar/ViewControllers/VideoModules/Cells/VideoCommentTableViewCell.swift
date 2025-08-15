//
//  VideoCommentTableViewCell.swift
//  Bazaar Ghar
//
//  Created by Developer on 01/08/2024.
//

import UIKit

class VideoCommentTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var commentLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
