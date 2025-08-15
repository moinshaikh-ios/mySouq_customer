//
//  Utilities.swift
//  Utitiliess
//
//  Created by Rehman on 8/10/20.
//  Copyright © 2020 Rehman. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

class Utilities {
    static var isFromWelcome : Bool = false
    static var isPreAuthorized : Bool = false
    static var isFromSpinner : Bool = false
    static var isAgreed : Bool = false
    static var isConnectionSuccessful : Bool = false
    static var connectionName : String = ""
    static var currentPeripheral: CBPeripheral? = nil
    static var isReload = false
    static var verificationCode : String = ""
    
    static var is_rgb_device : Bool = false
    static var env_name : String = ""
    static var env_ic : String = ""
    
    static var index : Int = 0
    static var isFirstTime : Bool = true
    
   
    static var device_id : Int = 701
    static var grey_color : String = "#c4c4c4"


    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    static func isPasswordValid(_ password : String) -> Bool
    {        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    static func saveDeviceInformation(device_name: String, connection_name: String, device_id: Int){
        let preferences = UserDefaults.standard
        print("saveDeviceInformation : \(device_name)")
        print("saveConnectionInformation : \(connection_name)")
        preferences.set(device_name, forKey: "device_name")
        preferences.set(connection_name, forKey: "connection_name")
        preferences.set(device_id, forKey: "device_id")
        
        // Checking the preference is saved or not
        didSave(preferences: preferences)
    }
    
    static func getDeviceName() -> String{
        let preferences = UserDefaults.standard
        if preferences.string(forKey: "device_name") != nil{
            let device_name = preferences.string(forKey: "device_name")
            return device_name!
        } else {
            return ""
        }
    }
    
    static func getDeviceId() -> Int{
        let preferences = UserDefaults.standard
        if preferences.string(forKey: "device_id") != nil{
            let device_id = preferences.integer(forKey: "device_id")
            return device_id
        } else {
            return -1
        }
    }
    
    static func getConnectionName() -> String{
        let preferences = UserDefaults.standard
        if preferences.string(forKey: "connection_name") != nil{
            let connection_name = preferences.string(forKey: "connection_name")
            return connection_name!
        } else {
            return ""
        }
    }
    
    static func getPrevConnectionName() -> String{
        let preferences = UserDefaults.standard
        if preferences.string(forKey: UserDefaultKeys.PreviouslyConnectedDeviceName) != nil{
            let connection_name = preferences.string(forKey: UserDefaultKeys.PreviouslyConnectedDeviceName)
            return connection_name!
        } else {
            return ""
        }
    }
    

    // Checking the UserDefaults is saved or not
    static func didSave(preferences: UserDefaults){
        let didSave = preferences.synchronize()
        if !didSave{
            // Couldn't Save
            print("Preferences could not be saved!")
        }
        else {
            print("Preferences saved successfully!")
        }
    }
}
