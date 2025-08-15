//
//  Logger.swift
//  
//
//  Created by Subramanian on 01/08/18.
//  Modified by Rehman on 12/4/20.
//  Copyright © 2020 Aquatic AV. All rights reserved.
//

import Foundation
import SwiftLog

class Logger {
    
    static let enable = false
    
    class func log(message: Any, function: String = #function, file: String = #file, line: Int = #line) {
        
        if Logger.enable {
            logw(String(format: "[%@ : %@ : %d]  %@ \n\n", file, function, line, message as! CVarArg))
        }
    }
}
