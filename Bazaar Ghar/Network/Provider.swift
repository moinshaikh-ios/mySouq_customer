//
//  Services.swift
//  RGB
//
//  Created by usamaghalzai on 15/11/2021.
//  Copyright © 2021 usamaghalzai. All rights reserved.
//

import Foundation
import Moya

struct Provider {
    static let services = MoyaProvider<Services>(plugins: [
        Plugin.networkPlugin,
        NetworkLoggerPlugin(configuration: .init(logOptions: .verbose)), // ✅ Correct way to enable verbose logging
        Plugin.authPlugin
    ])
    
    static let backgroundServices = MoyaProvider<Services>(plugins: [
        NetworkLoggerPlugin(configuration: .init(logOptions: .verbose)), // ✅ Fixed verbose usage
        Plugin.authPlugin
    ])
}
