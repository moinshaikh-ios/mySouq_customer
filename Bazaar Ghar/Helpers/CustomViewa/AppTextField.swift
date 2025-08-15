//
//  AppTextField.swift
//  BWorld
//
//  Created by Nouman Gul on 30/09/2020.
//

import UIKit

@IBDesignable
open class AppTextField: UITextField {
    // Programmatically: use the enum
    var fieldWithUnderline:Bool = false
    var fieldWithRightArrow:Bool = false
    var padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
//    var classFont:FontClassType = .regular
//    var classFontSize:CGFloat = 16.0
    var fontWeight:Int = FontStyle.regular.rawValue
    open override func layoutSubviews() {
        super.layoutSubviews()
        //setup()
        setupView()
    }

    func setupView(){
//        self.font =  UIFont.init(name:FontStyle(rawValue: fontWeight)?.name ?? FontStyle.regular.name, size: classFontSize)
//        if Constant.isPad{
//            self.font = UIFont.setFontsWithClassType(classType: classFont, size: self.classFontSize+6)
//        }else{
//            self.font = UIFont.setFontsWithClassType(classType: classFont, size: self.classFontSize)
//        }
    }
    
//    @IBInspectable var fontsAdapter:Int {
//        get {
//            return self.classFont.rawValue
//        }
//        set( fontIndex) {
//           self.classFont = FontClassType(rawValue: fontIndex) ?? .regular
//        }
//    }
//    @IBInspectable var fontsSize:CGFloat {
//        get {
//            return self.classFontSize
//        }
//        set( fontSize) {
//           self.classFontSize = fontSize
//        }
//    }

    
    func setup() {
        if fieldWithUnderline{
            let border = CALayer()
            let width = CGFloat(0.8)
            border.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
            border.borderWidth = width
            self.layer.addSublayer(border)
            self.layer.masksToBounds = true
            
            
        }
        if fieldWithRightArrow{
            rightViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage.init(named: "textfield_arrow")
                        // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = UIColor(red: 0.66, green: 0.70, blue: 0.74, alpha: 1.00)
            rightView = imageView
            self.rightView = rightView
        }
    }

    // IB: use the adapter
    @IBInspectable var underline:Bool {
        get {
            return fieldWithUnderline
        }
        set( setUnderline) {
            fieldWithUnderline = setUnderline
        }
    }
    @IBInspectable var rightArrow:Bool {
        get {
            return fieldWithRightArrow
        }
        set( setRightArrow) {
            fieldWithRightArrow = setRightArrow
        }
    }
    
//    // IB: use the adapter
//    @IBInspectable var cornerRadius: CGFloat = 10.0 {
//        didSet {
//            self.layer.cornerRadius = cornerRadius
//        }
//    }
//    @IBInspectable var borderWidth: CGFloat = 0.0 {
//        didSet {
//            self.layer.borderWidth = borderWidth
//        }
//    }
//
//    @IBInspectable var borderColor: UIColor = .white {
//        didSet {
//            self.layer.borderColor = borderColor.cgColor
//        }
//    }
    
    func setRectPadding() -> UIEdgeInsets{
            return padding
        
    }
    
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: setRectPadding())
    }
    
    override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: setRectPadding())
    }
    
    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: setRectPadding())
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    @IBInspectable var Weight:Int {
        get {
            return self.fontWeight
        }
        set(newWeight) {
            self.fontWeight = newWeight
            self.font =  UIFont(name:FontStyle(rawValue: self.fontWeight)?.name ?? FontStyle.regular.name, size: self.font?.pointSize ?? 15) ?? .systemFont(ofSize: self.font?.pointSize ?? 15)
        }
    }
    
    //MARK: SHADOW PROPERTIES
//    @IBInspectable
//    var shadowRadius: CGFloat {
//        get {
//            return layer.shadowRadius
//        }
//        set {
//            layer.shadowRadius = newValue
//        }
//    }
//
//    @IBInspectable
//    var shadowOpacity: Float {
//        get {
//            return layer.shadowOpacity
//        }
//        set {
//            layer.shadowOpacity = newValue
//        }
//    }
//
//    @IBInspectable
//    var shadowOffset: CGSize {
//        get {
//            return layer.shadowOffset
//        }
//        set {
//            layer.shadowOffset = newValue
//        }
//    }
    
//    @IBInspectable
//    var shadowColor: UIColor? {
//        get {
//            if let color = layer.shadowColor {
//                return UIColor(cgColor: color)
//            }
//            return nil
//        }
//        set {
//            if let color = newValue {
//
//                layer.shadowColor = color.cgColor
//            } else {
//                layer.shadowColor = nil
//            }
//        }
//    }
}
