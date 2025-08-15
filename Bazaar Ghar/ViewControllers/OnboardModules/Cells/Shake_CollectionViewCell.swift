//
//  Shake_CollectionViewCell.swift
//  Bazaar Ghar
//
//  Created by Umair Ali on 25/07/2024.
//

import UIKit

class Shake_CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var bgimg: UIImageView!
    @IBOutlet weak var indicatorimg: UIImageView!

    @IBOutlet weak var nextbtn: UIButton!
    @IBOutlet weak var descriptiontxt: UILabel!
    @IBOutlet weak var lbl_first: UILabel!
    @IBOutlet weak var shakeview: UIView!
 
    @IBOutlet weak var shipview: UIView!

    @IBOutlet weak var skipbtn: UIButton!
    
    
    override class func awakeFromNib() {

    }
}
