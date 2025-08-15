

import Foundation

struct DataClasss: Codable {
    let result: UserData?
}

struct UserData: Codable {
    let user: CurrentUser?
    let tokens: Tokens?
    let phoneLoginToken: String?
}

// MARK: - Tokens
struct Tokens: Codable {
    let access, refresh: Access?
}

// MARK: - Access
struct Access: Codable {
    let token, expires: String?
}

// MARK: - User
struct CurrentUser: Codable {
    
    let origin: Origin?
    let wallet: UserWallet?
    let isEmailVarified, isPhoneVarified,agreement: Bool?
    let userType, role,status, googleID, fullname: String?
    let createdAt, updatedAt, refCode: String?

    var defaultAddress: DefaultAddress?
    var email, id: String?

    enum CodingKeys: String, CodingKey {
        case origin, wallet, isEmailVarified, isPhoneVarified, status,userType, role
        case googleID = "googleId"
        case fullname, createdAt, updatedAt, refCode
    
        case defaultAddress, email, id,agreement
    }
    public static var shared: CurrentUser!
}
//public static var shared: CurrentUser!

// MARK: - DefaultAddress
struct DefaultAddress: Codable {
    let addressType, localType, address, addressLine2: String?
    let city, cityCode, fullname,email, phone: String?
    let province: String?
    let zipCode: Int?
    let user, createdAt, updatedAt: String?
    let id: String?
    let country:String?

    enum CodingKeys: String, CodingKey {
        case addressType, localType, address
        case addressLine2 = "addressLine_2"
        case city
        case cityCode = "city_code"
        case fullname, phone, province, zipCode, user, createdAt, updatedAt,email
        case id, country
    }
}


// MARK: - Origin
struct Origin: Codable {
    let source, version: String?
}

// MARK: - Wallet
struct UserWallet: Codable {
    let balance: Float
}

//struct Userdata: Codable {
//    let user: CurrentUser
//    let tokens: Tokens
//
//
//}
//
//// MARK: - Tokens
//struct Tokens: Codable {
//    let access, refresh: Access
//}
//
//// MARK: - Access
//struct Access: Codable {
//    let token, expires: String
//}
//
//// MARK: - User
//struct CurrentUser: Codable {
//
//    // new
//    let origin: Origin?
//    let wallet: Walet?
//    let isEmailVarified, isPhoneVarified: Bool?
//    let userType, role, googleID, fullname: String?
//    let createdAt, updatedAt, refCode: String?
//
//    let defaultAddress: DefaultAddress?
//    let email, id: String?
//    enum CodingKeys: String, CodingKey {
//        case origin, wallet, isEmailVarified, isPhoneVarified, userType, role
//        case googleID = "googleId"
//        case fullname, createdAt, updatedAt, refCode
//        case defaultAddress, email, id
//
//    }
//    public static var shared: CurrentUser!
//
//    struct DefaultAddress: Codable {
//        let addressType, localType, address, addressLine2: String?
//        let city, cityCode, fullname, phone: String?
//        let province: String?
//        let zipCode: Int?
//        let user, createdAt, updatedAt: String?
//
//        let id: String?
//
//        enum CodingKeys: String, CodingKey {
//            case addressType, localType, address
//            case addressLine2 = "addressLine_2"
//            case city
//            case cityCode = "city_code"
//            case fullname, phone, province, zipCode, user, createdAt, updatedAt
//            case id
//        }
//    }
//
//    struct Origin: Codable {
//        let source, version: String?
//    }
//    struct Walet: Codable {
//        let balance: Int?
//    }
//}
