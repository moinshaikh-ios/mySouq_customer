//
//  CardView.swift
//  RGB
//
//  Created by Zaeem EhsanUllah on 19/06/2022.
//

import UIKit

@IBDesignable
class CardView: UIView {

//    @IBInspectable var cornerRadius: CGFloat = 2
//
//    @IBInspectable var shadowOffsetWidth: Int = 0
//    @IBInspectable var shadowOffsetHeight: Int = 3
//    @IBInspectable var shadowColor: UIColor? = .black
//    @IBInspectable var shadowOpacity: Float = 0.5
    
    override init(frame: CGRect) {
          super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - UI Setup
        override func prepareForInterfaceBuilder() {
            commonInit()
        }
    
    func commonInit(){
        self.layer.cornerRadius = cRadius
        self.layer.shadowOffset.width = sOffsetWidth
        self.layer.shadowOffset.height = sOffsetHeight
        self.layer.shadowColor = shadowClr.cgColor
        self.layer.shadowOpacity = sOpacity
    }
    
    @IBInspectable
    var shadowClr: UIColor = .black {
        didSet {
            self.layer.shadowColor = shadowClr.cgColor
        }
    }
    
    @IBInspectable
    var cRadius: CGFloat = 2 {
        didSet {
            self.layer.cornerRadius = cRadius
        }
    }
    
    @IBInspectable
    var sOpacity: Float = 0.5 {
        didSet {
            self.layer.shadowOpacity = sOpacity
        }
    }
    
    @IBInspectable
    var sOffsetWidth: CGFloat = 0 {
        didSet {
            self.layer.shadowOffset.width = sOffsetWidth
        }
    }
    
    @IBInspectable
    var sOffsetHeight: CGFloat = 3 {
        didSet {
            self.layer.shadowOffset.height = sOffsetHeight
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
