//
//  CheckBox.swift
//  RGB
//
//  Created by Zaeem EhsanUllah on 30/07/2022.
//

import UIKit

class CheckBox: UIButton {

    let checkedImage = UIImage(named: "ic_checkbox_selected")! as UIImage
        let uncheckedImage = UIImage(named: "ic_unchecked_checkbox")! as UIImage
        
        // Bool property
        var isChecked: Bool = false {
            didSet {
                if isChecked == true {
                    self.setImage(checkedImage, for: UIControl.State.normal)
                } else {
                    self.setImage(uncheckedImage, for: UIControl.State.normal)
                }
            }
        }
            
        override func awakeFromNib() {
            
            self.isChecked = false
        }

}
