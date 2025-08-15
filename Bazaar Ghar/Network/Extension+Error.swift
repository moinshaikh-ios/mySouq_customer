//
//  Services.swift
//  RGB
//
//  Created by usamaghalzai on 15/11/2021.
//  Copyright © 2021 usamaghalzai. All rights reserved.
//

import Foundation
import Moya

extension Error{
    var customDescription:String{
        get{
            if let error = self as? MoyaError, let response = error.response,
               let json = try? response.mapJSON() as? [String: Any] {
                if let messages = json["message"] as? [String],
                let message = messages.first{
                    return message
                }else if let message = json["message"] as? String {
                    return message
                }                
            }
            return localizedDescription
        }
    }
}
