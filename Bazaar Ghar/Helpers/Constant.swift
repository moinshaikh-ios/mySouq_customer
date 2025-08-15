//
//  Constant.swift
//
//
//  Created by Subramanian on 01/8/18.
//  Modified by Rehman on 12/4/20.
//  Copyright © 2020 Aquatic AV. All rights reserved.
//

import Foundation
import UIKit

let BLE_MUSIC_COLOR_NOTIFICATION = "BLE_MUSIC_COLOR_NOTIFICATION"
let BLE_BRIGHTNESS_NOTIFICATION = "BLE_BRIGHTNESS_NOTIFICATION"
let BLE_ON_OFF_NOTIFICATION = "BLE_ON_OFF_NOTIFICATION"
let BLE_MODE_CHANGE_NOTIFICATION = "BLE_MODE_CHANGE_NOTIFICATION"
let BLE_MODE_SPEED_CHANGE_NOTIFICATION = "BLE_MODE_SPEED_CHANGE_NOTIFICATION"

let UPDATE_TAB_BAR = "updateTabbar"



/// MARK : Common
struct Constant {
    static let emptyString = ""
    static let Bundle = "bundle"
    static let SimulatorPushToken = "SIMULATOR"
    static let DeviceUniqueId = "DeviceUniqueId"
    
    static var userFavColor = ""
    static var is_fav_enable = true
    static var BrunaBold = "Bruna-Bold.ttf"
    

    

}

/// MARK : StoryBoard
struct StoryBoard {
    struct Names {
      static let Main = "Main"
    }
    
    struct Segue {
   
    }
    
    struct Identifiers {
    
    }
}

/// Xib
struct Xibs {
    static let loaderView = "LoaderView"
}

/// Cell Identifiers
struct CellIdentifiers {
   
}

/// UserDefault Key Identifiers
struct UserDefaultKeys {
    static let AllFavColors = "allfavcolors"
    static let PresetColors = "PresetColors"
    static let PreviouslyConnectedDevice = "PreviouslyConnectedDevice"
    
    static let SavedBleDevice = "SavedBleDevice"

    static let PreviouslyConnectedDeviceName = "PreviouslyConnectedDeviceName"
    static let PreviouslyConnectedDeviceInfo = "PreviouslyConnectedDeviceInfo"
    static let FWVersion = "FWVersion"
    static let isManualDisconnect = "isManualDisconnect"
    static let BLEControllerON_OFFStatus = "BLEControllerON_OFFStatus"
    static let BLE_Logges = "BLE_Logges"
    static let RGB_ONLY = "Rgb_Only"
    static let HAS_RGB = "Has_Rgb"
    
    static let AUTH_TOKEN = "token"
    static let FIRST_NAME = "first_name"
    static let LAST_NAME = "last_name"
    static let USER_EMAIL = "user_email"
    static let ENCRYPTED_PASSWORD = "user_pwd_encrypted"
    static let PASSWORD = "user_pwd"
    static let ADDRESS = "address"
    static let CITY = "city"
    static let STATE = "state"
    static let ZIPCODE = "zip_code"
    static let PHONE = "phone"
    static let COUNTRY = "country"
    static let USER_ID = "user_id"
    static let IS_USER_VERIFIED = "is_user_verified"
    static let pushviewcontroller = ""
}

/// Observer Key Identifiers
struct ObserverKeys {
    static let networkReachable = "NetworkReachable"
    static let beaconsUpdated = "beaconsUpdated"
    static let bleONOFFStatusUpdated = "bleONOFFStatusUpdated"
}

/// Operation Queue Names
struct ThreadNames {
    
}

/// ImageNames
struct ImageNames {
    static let Adjust = "Adjust"
    static let Music = "Music"
    static let Mode = "Mode"
    static let Settings = "Settings"
}

// Push notification
struct PushNotification {
    
    struct PushKeyWords {
        static let Alerts = "alert"
        static let APS = "aps"
        static let PType = "notification_type"
    }
    
    struct PushType {
       
        static let General = "general"
        static let NewTask = "new_task"
        static let UpComing = "upcoming_task"
        static let Patient = "patient_assignment"
        static let Pending = "task_pending"
    }
}

struct CoreDataConstant {
    struct Entity {
   
    }
}

struct Constants {
    static let backgroundColor = UIColor(red: 23 / 255, green: 32 / 255, blue: 30 / 255, alpha: 1)
    static let mainFontColor = UIColor(red: 0 / 255, green: 204 / 255, blue: 45 / 255, alpha: 1)
    static let secondaryFontColor = UIColor(red: 177 / 255, green: 177 / 255, blue: 177 / 255, alpha: 1)
    static let errorColor = UIColor.red
    static let textFieldBackgroundColor = UIColor(red: 36 / 255.0, green: 48 / 255.0, blue: 45 / 255.0, alpha: 1.0)
    static let borderRadius: CGFloat = 4
    static let borderWidth: CGFloat = 1
    struct Storyboard {
        
        static let loginVC = "LoginVC"
        static let signupVC = "sbSignup"
        static let mainVC = "sbMainVC"
        static let initialVC = "sbInitial"
        static let addressVC = "sbAddress"
        static let environmentVC = "sbEnvironment"
        static let deviceVC = "sbDevice"
        static let deviceNameVC = "sbDeviceName"
        static let receiptVC = "sbReceipt"
        static let welcomeVC = "sbWelcome"
        static let settingsVC = "BLELSettingVC"
        static let forgotVC = "ForgotPasswordVC"
        static let resetVC = "ResetPasswordVC"
        static let codeverify = "CodeVerificationVC"
        static let rgbonly = "BLEDProfileRgbOnlyVC"
        static let whyacc = "WhyAccountVC"
        static let productTypeVC = "ProductTypeVC"
        static let devicepVC = "SelectDeviceProfileVC"
    }
}

struct IntercomUtils {
    struct IntercomKeys {
        //static let INTERCOM_APP_ID = "zhnskbf3"
        //static let INTERCOM_API_KEY = "ios_sdk-bd01f82a9ddf1629a3eda739aeaf4def21aade5d"
        
        static let INTERCOM_APP_ID = "rj3i0p4j"
        static let INTERCOM_API_KEY = "ios_sdk-6b7a25f97b3424f5ff48c3126aecc9cd954c098f"
        static let SECRET = "6WPXL-FxQmGKsnbNe5YOYS1HFgh773-RzEh-tIXs"
    }
}

struct SPA_COMMANDS{
    static let packet_HEADER = "5555"
    static let pump1_OFF = "01D300010000"
    static let pump1_LOW = "01D300010001"
    static let pump1_HIGH = "01D300010002"
    static let pump2_OFF = "01DD00010000"
    static let pump2_LOW = "01DD00010001"
    static let pump2_HIGH = "01DD00010002"
    static let light_OFF = "017404010000"
    static let light_ON = "017404010001"
    
    static let clean_cycle_ON = "012D01010001"
    static let clean_cycle_OFF = "012D01010000"

    static let temp_WRITE = "018F1C0100"
    static let boot_loader = "01141F010001"
    static let read_version = "0AF0F001005500000000000000000000"
    static let erase_flash = "0AF0F001005503B70155AA00480000"
    //5503800055AA00480000"
    static let device_reset = "0AF0F0010055090000000000000000"

    
}

/*
 Intercom.setApiKey("ios_sdk-6b7a25f97b3424f5ff48c3126aecc9cd954c098f", forAppId:"rj3i0p4j")
 Intercom.setUserHash("6WPXL-FxQmGKsnbNe5YOYS1HFgh773-RzEh-tIXs")
 */
// Localization Keys
struct Localization {
    /******************************************************************************/
    /// Common
    /******************************************************************************/
    
    static let AppName = "AppName"
    static let OkText = "Ok"
    static let CancelText = "CancelText"
    static let NotAvailable = "NotAvailable"
    static let Done = "Done"
    static let GetStarted = "GetStarted"
    static let Back = "Back"
    static let Next = "Next"
    static let Accept = "Accept"
    static let Dismiss = "Dismiss"
    static let Downloading = "Downloading"
    static let NotNow = "NotNow"
    static let Yes = "Yes"
    static let No = "No"
    static let Clear = "Clear"
    static let Proceed = "Proceed"
    static let By = "By"
    
    //AlertMessage
    static let NetworkError = "NetworkError"
    static let NetworkUnReachable = "NetworkUnReachable"
    static let UnKnownError = "UnKnownError"
    static let NoData = "NoData"
    static let Search = "Search"
    static let LoaderText = "LoaderText"
    static let Loading = "Loading"
    static let LocationPermissionDenied = "LocationPermissionDenied"
    static let SlowConnection = "SlowConnection"
    static let FillAllMandatoryField = "Please fill all the mandatory field."
    
    /******************************************************************************/
    /// Welcome Page
    /******************************************************************************/
    static let WelcomeMessage = "WelcomeMessage"
    
    /******************************************************************************/
    /// Login Page
    /******************************************************************************/
    static let Email = "Email";
    static let Password = "Password";
    
    //Alert Message
    static let EmailEmpty = "EmailEmpty"
    static let ValidEmail = "ValidEmail"
    static let PasswordEmpty = "PasswordEmpty"
    static let PasswordMinimumCount = "PasswordMinimumCount"
    
    /******************************************************************************/
    /// Forgot password view
    /******************************************************************************/
    static let ForgotPassword = "ForgotPassword"
    static let SendPassword = "SendPassword"
    
    //Alert Message
    static let ForgotPwdSuccess = "ForgotPwdSuccess"
    
    /******************************************************************************/
    /// Confirm Password
    /******************************************************************************/
    static let ChangePasswordMessage = "ChangePasswordMessage"
    static let ResetPasswordMessage = "ResetPasswordMessage"
    static let OldPassword = "OldPassword"
    static let NewPassword = "NewPassword"
    static let ConfirmPassword = "ConfirmPassword"
    
    //Alert Message
    static let NameEmpty = "NameEmpty"
    static let CurrentPwdNotMatched = "CurrentPwdNotMatched"
    static let ConfirmPwdNotMatched = "ConfirmPwdNotMatched"
    static let PwdLengthMismatch = "PwdLengthMismatch"
    static let PwdNotStrongEnough = "PwdNotStrongEnough"
    static let PwdAllMandatory = "PwdAllMandatory"
    static let PwdUpdateSuccess = "PwdUpdateSuccess"
    static let ValidToken = "ValidToken"
    static let ActivationSuccess = "ActivationSuccess"
    
    /******************************************************************************/
    /// New Password
    /******************************************************************************/
    
    
    //Alert Message
    static let NewPasswordUpdateSuccess = "NewPasswordUpdateSuccess"
    
    /******************************************************************************/
    /// Change Password
    /******************************************************************************/
    static let ValidCurrentPassword = "ValidCurrentPassword"
    
    //Alert Message
    static let OldPasswordNotMatched = "OldPasswordNotMatched"
    
    /******************************************************************************/
    /// Notification List
    /******************************************************************************/
    static let NewNotification = "NewNotification"
    static let UpcomingNotification = "UpcomingNotification"
    static let PatientNotification = "PatientNotification"
    static let PendingNotification = "PendingNotification"
    
    /******************************************************************************/
    /// Unsaved Changes
    /******************************************************************************/
    static let UnsavedMessage = "You have unsaved changes on this page. Do you want to leave this page?"
}
