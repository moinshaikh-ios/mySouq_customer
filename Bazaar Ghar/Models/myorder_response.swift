//
//  myorder_response.swift
//  Bazaar Ghar
//
//  Created by Developer on 19/09/2023.
//

import Foundation
struct MyOrderResponse: Codable {
    let results: [MyOrderResult]?
    let totalResults, page, limit, totalPages: Int?
}

// MARK: - Result
struct MyOrderResult: Codable {
    let id, paymentMethod: String?
    let wallet: Bool? 
    let _id:String?
    let groupBuy: Bool?
    let groupBuyQuantity: Int?
    let customer: MyOrderCustomer?
    let seller: Seller?
    let orderTrack: [OrderTrack]?
    let orderDetail: String?
    let shippmentCharges: Double?
    let orderNote: String?
    let subTotal, retailTotal, discount: Double?
    let  subWeight: Double?
    let orderID, statusUpdatedAt: String?
    let adminDiscount: Double?
    let origin: String?
    
    let store: Store?
    let payableShippment, payable, v: Double?
    let createdAt, updatedAt: String?
    let orderStatus: OrderStatus?
    let orderItems: [NewOrderItem]?

    enum CodingKeys: String, CodingKey {
        case paymentMethod, wallet, groupBuy, groupBuyQuantity, orderTrack,customer, seller, orderDetail, shippmentCharges, orderNote, subTotal, retailTotal, discount, subWeight
        case orderID = "orderId"
        case statusUpdatedAt, adminDiscount,  store, payableShippment, payable
        case v = "__v"
        case createdAt, updatedAt, orderStatus, orderItems,id,_id,origin
    }
    func getDeliveryTime() -> Int? {
        let regionLowerCase = origin?.lowercased() ?? ""
            
            if regionLowerCase.contains("china") {
                return AppDefault.getDeliveryDate?.chinaDelivery
            } else if regionLowerCase.contains("ksa") || regionLowerCase.contains("saudi") {
                return AppDefault.getDeliveryDate?.ksaDelivery
            } else if regionLowerCase.contains("pak") || regionLowerCase.contains("pakistan") {
                return AppDefault.getDeliveryDate?.pakDelivery
            }else{
                return AppDefault.getDeliveryDate?.chinaDelivery
            }
            
           
        }
}
struct OrderTrack: Codable {
    let date, status: String?
    let state: Bool?
}
// MARK: - Customer
struct MyOrderCustomer: Codable {
    let id: String?
    let wallet: MyOrderWallet?
    let isEmailVarified, isPhoneVarified: Bool?
    let userType, role, googleID, fullname: String?
    let createdAt, updatedAt, refCode: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case wallet, isEmailVarified, isPhoneVarified, userType, role
        case googleID = "googleId"
        case fullname, createdAt, updatedAt, refCode
        case v = "__v"
    }
}

// MARK: - Wallet
struct MyOrderWallet: Codable {
    let balance: Float?}

// MARK: - OrderItem
struct NewOrderItem: Codable {
    let _id: String?
    let id : String?
    let adminDiscount: AdminDiscount?
    let discount, adminTotalDiscount: Double?
    let product: Product?
    let quantity: Int?
    let createdAt, updatedAt: String?
    let total, retailTotal, v: Double?
    let weight: Double?
    enum CodingKeys: String, CodingKey {
        case adminDiscount, discount, adminTotalDiscount, product, quantity, createdAt, updatedAt, total, weight, retailTotal,id,_id
        case v = "__v"
    }
}

// MARK: - AdminDiscount
struct AdminDiscount: Codable {
    let discountType: String?
    let amount: Double?
}

// MARK: - Product
struct MyOrderProduct: Codable {
    let featured, onSale: Bool?
    let attributes : [attributeobject]?
        let selectedAttributes: [SelectObjItems]?
    let isVariable: Bool?
    let productType: String?
    let gallery: String?
    let variantGroupBuy: Bool?
    let categoryTree: [String]?
    let onDeal, relief: Bool?
    let videoType, id, productName, slug: String?
    let mainImage: String?
    let active: Bool?
    let description: String?
    let price,  regularPrice, salePrice: Double?
    let quantity: Int?
    let weight: Double?
    let user, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case featured, onSale, attributes, selectedAttributes, isVariable, productType, gallery, variantGroupBuy, categoryTree, onDeal, relief, videoType
        case id = "_id"
        case productName, slug, mainImage, active, description, price, quantity, regularPrice, salePrice, weight, user, createdAt, updatedAt
    }
}

// MARK: - OrderStatus
struct OrderStatus: Codable {
    let id, name: String?
    let current: Bool?
    let order, createdAt, seller: String?
    let v: Int?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, current, order, createdAt, seller
        case v = "__v"
        case updatedAt
    }
}

// MARK: - Seller
struct Seller: Codable {
    let id: String?
    let _id: String?
    let isEmailVarified, isPhoneVarified: Bool?
    let userType, role, email, password: String?
    let fullname, phone, createdAt, updatedAt: String?
    let sellerDetail: MyOrderSellerDetail?
    let wallet: Wallet?
    let refCode: String?

    enum CodingKeys: String, CodingKey {
        case isEmailVarified, isPhoneVarified, userType, role, email, password, fullname, phone, createdAt, updatedAt, sellerDetail, wallet, refCode,id,_id
    }
}

// MARK: - SellerDetail
struct MyOrderSellerDetail: Codable {
    let id: String?
    let _id:String?
    let images: [String]?
    let brandName, description, market, seller: String?
    let createdAt, updatedAt: String?
    let v: Int?
    let address, city, cityCode, country: String?
    let approved: Bool?
    let rrp, alias, costCenterCode: String?
    let costCode: Bool?
    let slug: String?

    enum CodingKeys: String, CodingKey {
        case images, brandName, description, market, seller, createdAt, updatedAt
        case v = "__v"
        case address, city, cityCode, country, approved, rrp, alias, costCenterCode, costCode, slug,id,_id
    }
}

// MARK: - Store
struct Store: Codable {
    let id, brandName, slug: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case brandName, slug
    }
}

//
// MARK: - DataClass
struct DeliveryDataClass: Codable {
    var chinaDelivery, ksaDelivery, pakDelivery: Int?

    enum CodingKeys: String, CodingKey {
        case chinaDelivery = "CHINA_DELIVERY"
        case ksaDelivery = "KSA_DELIVERY"
        case pakDelivery = "PAK_DELIVERY"
    }
    func getDeliveryTime(region: String) -> Int? {
            let regionLowerCase = region.lowercased()
            
            if regionLowerCase.contains("china") {
                return chinaDelivery
            } else if regionLowerCase.contains("ksa") || regionLowerCase.contains("saudi") {
                return ksaDelivery
            } else if regionLowerCase.contains("pak") || regionLowerCase.contains("pakistan") {
                return pakDelivery
            }
            
            return nil
        }
    
    
    func getDeliveryTimeFormatted(region: String) -> String? {
        guard let days = getDeliveryTime(region:region) else { return nil }
        
        // Get current date
        let currentDate = Date()
        
        // Add delivery days to current date
        let calendar = Calendar.current
        guard let deliveryDate = calendar.date(byAdding: .day, value: days, to: currentDate) else { return nil }
        
        // Format the date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        let formattedDate = dateFormatter.string(from: deliveryDate)
        
        // Create the final message
        return LanguageManager.language == "ar" ? "اطلب الآن واحصل على \(formattedDate)" : "Order now and get by \(formattedDate)"
    }
}
