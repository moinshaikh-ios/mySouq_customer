//
//  AppLable.swift
//  BWorld
//
//  Created by Nouman Gul on 30/09/2020.
//

import Foundation

import UIKit
class AppLabel : UILabel{
    // Programmatically: use the enum
//    var classFontSize:CGFloat = self.font.pointSize
    var fontWeight:Int = FontStyle.regular.rawValue
    override func layoutSubviews() {
        super.layoutSubviews()
//        setupView()
    }

    func setupView(){
        self.font =  UIFont.init(name:FontStyle(rawValue: self.fontWeight)?.name ?? FontStyle.regular.name, size: self.font.pointSize)
//        DispatchQueue.main.async {
//            if Constant.isPad{
//                self.font = UIFont.setFontsWithClassType(classType: self.classFont, size: self.classFontSize+6)
//            }else{
//                self.font = UIFont.setFontsWithClassType(classType: self.classFont, size: self.classFontSize)
//            }
//        }
    }
//
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
    override init(frame: CGRect){
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    @IBInspectable var Weight:Int {
        get {
            return self.fontWeight
        }
        set(newWeight) {
            self.fontWeight = newWeight
            self.font =  UIFont.init(name:FontStyle(rawValue: self.fontWeight)?.name ?? FontStyle.regular.name, size: self.font.pointSize)
        }
    }
}
