//
//  ChatCheckBox.swift
//  RGB
//
//  Created by Zaeem EhsanUllah on 07/08/2022.
//

import UIKit

class ChatCheckBox: UIButton {

    let checkedImage = UIImage(named: "ic_checkbox_selected")! as UIImage
        let uncheckedImage = UIImage(named: "ic_editList")! as UIImage
        
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
