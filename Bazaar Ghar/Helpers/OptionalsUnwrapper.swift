//
//  OptionalsUnwrapper.swift
//  RGB
//
//  Created by Usama on 25/02/2022.
//

//MARK:- MODULES
import Foundation
import UIKit

//MARK:- PROTOCOL
protocol OptionalType { init() }

//MARK:- EXTENSIONS
extension String: OptionalType {}
extension Int: OptionalType {}
extension Double: OptionalType {}
extension Bool: OptionalType {}
extension Float: OptionalType {}
extension CGFloat: OptionalType {}
extension CGRect: OptionalType {}
extension Dictionary : OptionalType { }
extension UIImage: OptionalType {}
extension IndexPath: OptionalType {}
extension UIFont: OptionalType {
    
}
extension UIView: OptionalType {}
extension Data: OptionalType {}
extension UIViewController:OptionalType {}
extension Int64 : OptionalType {}

prefix operator /

//unwrapping values
prefix func /<T: OptionalType>( value: T?) -> T {
    guard let validValue = value else { return T() }
    return validValue
}
