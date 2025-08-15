//
//  AppButton.swift
//  BWorld
//
//  Created by Nouman Gul on 30/09/2020.
//

import UIKit
enum FontStyle:Int {
    case light = 0
    case regular = 25
    case medium = 50
    case bold = 100
    var name:String {
        switch self {
        case .light:
            return "Roboto-Light"
        case .regular:
            return "Roboto-Regular"
        case .medium:
            return "Roboto-Medium"
        case .bold:
            return "Roboto-Bold"
        }
    }
    
}
@IBDesignable
final class AppButton: UIButton {
    
    // Programmatically: use the enum
//    var classFont:FontClassType = .regular
//    var classFontSize:CGFloat = 16.0
    var fontWeight:Int = FontStyle.regular.rawValue
    override func layoutSubviews() {
        super.layoutSubviews()
//        setup()
    }
    func setup() {
//        self.titleLabel?.font = UIFont(name:(FontStyle(rawValue: fontWeight)?.name ?? FontStyle.regular.name),
//                           size: classFontSize) ?? .systemFont(ofSize: classFontSize)
//        if Constant.isPad{
//            let font = UIFont.setFontsWithClassType(classType: classFont, size: self.classFontSize+6)
//            self.titleLabel?.font =  font
//        }else{
//            let font = UIFont.setFontsWithClassType(classType: classFont, size: self.classFontSize)
//            self.titleLabel?.font =  font
//        }
    }
    
    // IB: use the adapter
    

    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        setup()
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
//        set(newValue) {
//            self.classFontSize = newValue
//            self.titleLabel?.font.withSize(newValue)
//        }
//    }
    @IBInspectable var Weight:Int {
        get {
            return self.fontWeight
        }
        set(newWeight) {
            self.fontWeight = newWeight
            self.titleLabel?.font =  UIFont(name:FontStyle(rawValue: self.fontWeight)?.name ?? FontStyle.regular.name, size: self.titleLabel?.font.pointSize ?? 15) ?? .systemFont(ofSize: self.titleLabel?.font.pointSize ?? 15)
        }
    }
}
