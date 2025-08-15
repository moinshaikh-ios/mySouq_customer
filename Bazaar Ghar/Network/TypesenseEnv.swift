//
//  TypesenseEnv.swift
//  Bazaar Ghar
//
//  Created by Umair Ali on 26/12/2024.
//

import Foundation

enum TypeSenseEnvironmentType {
    case staging
    case production
}


// ------------ TYPESENSE ------------

struct TypeSenseEnvironment {
    static var current: TypeSenseEnvironmentType =  {
        return AppConstants.API.environment == .staging ? .staging : .production
    }()

    static var typesenseHost: String {
        switch current {
        case .staging:
            return "search.mysouq.com"
        case .production:
            return "search.mysouq.com"
        }
    }

    static var typesensePort: String {
        return "443" // Common for both environments
    }

    static var typesenseProtocol: String {
        return "https" // Common for both environments
    }

    static var typesenseApiKey: String {
        switch current {
        case .staging:
            return "AnbD9rboKH4vMS0yYF4EX585fwBe8aaJ"
        case .production:
            return "IL3q1iIgHhZ3pnjlYGicNJnsKT9bAilR"
        }
    }

    static var typesenseCollection: String {
        switch current {
        case .staging:
            return "mysouq_stage_products"
        case .production:
            return "mysouq_live_products"
        }
    }
}
