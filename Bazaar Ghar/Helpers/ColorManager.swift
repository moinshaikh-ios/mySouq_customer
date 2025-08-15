//
//  ColorManager.swift
//  RGB
//
//  Created by Usama on 04/11/2021.
//

import UIKit
extension UIColor {
    func rgb() -> Int? {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            let iAlpha = Int(fAlpha * 255.0)

            //  (Bits 24-31 are alpha, 16-23 are red, 8-15 are green, 0-7 are blue).
            let rgb = (iAlpha << 24) + (iRed << 16) + (iGreen << 8) + iBlue
            return rgb
        } else {
            // Could not extract RGBA components:
            return nil
        }
    }
    
    func rgbValues() -> (UInt8,UInt8,UInt8,UInt8)? {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = UInt8(fRed * 255.0)
            let iGreen = UInt8(fGreen * 255.0)
            let iBlue = UInt8(fBlue * 255.0)
            let iAlpha = UInt8(fAlpha * 255.0)

            Logger.log(message:"red : \(iRed), green : \(iGreen), blue: \(iBlue)");
            //  (Bits 24-31 are alpha, 16-23 are red, 8-15 are green, 0-7 are blue).
            return (iRed, iGreen, iBlue, iAlpha)
        } else {
            // Could not extract RGBA components:
            return nil
        }
    }
}

