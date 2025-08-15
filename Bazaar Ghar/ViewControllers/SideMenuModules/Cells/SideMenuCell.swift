//
//  ProSideMenuCell.swift
//  AgorzCustomer
//
//  Created by admin on 2/25/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class SideMenuCell: UITableViewCell {
    @IBOutlet weak var imagelbl: UIImageView!
    @IBOutlet weak var mylbl: UILabel!
    @IBOutlet weak var form_btn: UIButton!
    @IBOutlet weak var lab: UILabel!
    @IBOutlet weak var arrowBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func form_btn(_ sender: Any) {
        
        
    }
    
}
