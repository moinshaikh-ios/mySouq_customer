import Foundation

// MARK: - OrderTrackingResponse

// MARK: - DataClass
struct OrderTrackingResponse: Codable {

    let orderTrack: [OrderTrack]?

    
    let orderNote: String?
    

    let orderID, statusUpdatedAt: String?
   
    let vendor: OrderTrackingVendor?

    let payableShippment, payable: Double?
    let orderStatus: OrderTrackingOrderStatus?
    let v: Int?
    let createdAt, updatedAt: String?
    let orderStatuses: [OrderTrackingOrderStatus]?
    let  rrp: [String]?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case     orderNote
        case orderID = "orderId"
        case statusUpdatedAt, vendor, payableShippment, payable, orderStatus
        case v = "__v"
        case createdAt, updatedAt, orderStatuses
//        case consignmentNo = "consignment_no"
        case rrp, id
        case orderTrack
    }
}

// MARK: - Address
struct OrderTrackingAddress: Codable {
    let localType, address, city, country: String?
    let fullname, phone, id: String?
}

// MARK: - Customer
struct OrderTrackingCustomer: Codable {
    let wallet: OrderTrackingWallet?
    let isPhoneVarified: Bool?
    let userType, role, status: String?
    let agreement: Bool?
    let googleID: String?
    let fullname, createdAt, updatedAt, refCode: String?
    let v: Int?
    let phone: String?
    let defaultAddress: OrderTrackingDefaultAddress?
    let payment: [OrderTrackingPayment]?
    let id: String?
    

    enum CodingKeys: String, CodingKey {
        case wallet, isPhoneVarified, userType, role, status, agreement
        case googleID = "googleId"
        case fullname, createdAt, updatedAt, refCode
        case v = "__v"
        case phone, defaultAddress, payment, id
    }
}

// MARK: - DefaultAddress
struct OrderTrackingDefaultAddress: Codable {
    let addressType, localType, address, area: String?
    let city, country, fullname, phone: String?
    let province: String?
    let zipCode: Int?
    let user, createdAt, updatedAt: String?
    let v: Int?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case addressType, localType, address, area, city, country, fullname, phone, province, zipCode, user, createdAt, updatedAt
        case v = "__v"
        case id
    }
}

// MARK: - Payment
struct OrderTrackingPayment: Codable {
    let paymentChanel: String?
}

// MARK: - SellerDetail
struct OrderTrackingSellerDetail: Codable {
    let featured: Bool?
    let images: [String]?
    let country: String?
    let categories: [String]?
    let categoryUpdated, costCode, approved: Bool?
    let brandName, description: String?

    let address, city: String?
    let zipCode: Int?
    let area, province, seller, createdAt: String?
    let updatedAt, rrp, slug, costCenterCode: String?
    let alias: String?
    let v: Int?
    let logo: String?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case featured, images, country, categories, categoryUpdated, costCode, approved, brandName, description, address, city, zipCode, area, province, seller, createdAt, updatedAt, rrp, slug, costCenterCode, alias
        case v = "__v"
        case logo, id
    }
}

// MARK: - Market
struct OrderTrackingMarket: Codable {
    let type, name, description, mainMarket: String?
    let createdAt, updatedAt: String?
    let image: String?
    let slug: String?
    let subMarkets: [String]?
    let id: String?
}

// MARK: - Wallet
struct OrderTrackingWallet: Codable {
    let balance: Double?
}

// MARK: - OrderAddress

// MARK: - OrderItem
struct OrderTrackingOrderItem: Codable {
    let adminDiscount: OrderTrackingAdminDiscount?
    let discount, adminTotalDiscount: Double?
    
    let quantity: Int?
    let createdAt, updatedAt: String?
    let total: Double?
 
    let retailTotal: Double?
    let  v: Int?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case adminDiscount, discount, adminTotalDiscount, quantity, createdAt, updatedAt, total, retailTotal
        case v = "__v"
        case id
    }
}

// MARK: - AdminDiscount
struct OrderTrackingAdminDiscount: Codable {
    let discountType: String?
    let amount: Double?
}

// MARK: - Product
struct OrderTrackingProduct: Codable {
    let featured, onSale: Bool?
    let attributes, selectedAttributes: [String]?
    let isVariable: Bool?
    let productType: String?
    let gallery: [String]?
    let variantGroupBuy: Bool?
    let categoryTree: [String]?
    let onDeal, relief: Bool?
    let videoType: String?
    let region: [String]?
    let origin, platform, currency: String?
    let embedding: [String]?
    let productName, description: String?
    let weight: Double?
    let regularPrice, salePrice: Double?
    let quantity: Int?
    let mainImage: String?
    let category: Category?
    let slug: String?
    let price: Double?
    let active: Bool?
    let user: OrderTrackingCustomer?
    let createdAt, updatedAt, id: String?
}

// MARK: - Category
struct OrderTrackingCategory: Codable {
    let gallery: [String]?
    let type: String?
    let attributes: [String]?
    let attributeRequired: Bool?
    let index: Int?
    let featured: Bool?
    let platform: String?
    let videoCount: Int?
    let aeID, location: [String]?
    let name, mainCategory: String?
    let commission: Int?
    let description: String?
    let mainImage: String?
    let categorySpecs: OrderTrackingCategorySpecs?
    let v: Int?
    let createdAt, updatedAt, slug, tree: String?
    let platformSpecs, subCategories, mappedWithCategory: [String]?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case gallery, type, attributes, attributeRequired, index, featured, platform, videoCount
        case aeID = "ae_id"
        case location, name, mainCategory, commission, description, mainImage, categorySpecs
        case v = "__v"
        case createdAt, updatedAt, slug, tree
        case platformSpecs = "platform_specs"
        case subCategories, mappedWithCategory, id
    }
}

// MARK: - CategorySpecs
struct OrderTrackingCategorySpecs: Codable {
    let productsCount: Int?
    let active: Bool?
    let id: String?
    let oldCategories: [String]?
    let new: Bool?
    let lastUpdated: String?
    let updated: Bool?

    enum CodingKeys: String, CodingKey {
        case productsCount, active
        case id = "_id"
        case oldCategories, new, lastUpdated, updated
    }
}

// MARK: - OrderStatus
struct OrderTrackingOrderStatus: Codable {
    let name: String?
    let current: Bool?
    let order, seller, createdAt, updatedAt: String?
    let v: Int?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case name, current, order, seller, createdAt, updatedAt
        case v = "__v"
        case id
    }
}

// MARK: - PaymentTrace
struct OrderTrackingPaymentTrace: Codable {
    let walletPaid, cardPaid: Double?
}

// MARK: - Store
struct OrderTrackingStore: Codable {
    let id, brandName, slug: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case brandName, slug
    }
}

// MARK: - Vendor
struct OrderTrackingVendor: Codable {
    let id, fullname: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case fullname
    }
}

// MARK: - Encode/decode helpers



// MARK: - DataClass
struct HotDealsResponse: Codable {
    let results: [HotDeals]?
    let page, limit, totalPages, totalResults: Int?
}

// MARK: - Result
struct HotDeals: Codable {
    let active: Bool?
    let name, description, expireDate: String?
    let image: String?
    let slug, createdAt, updatedAt: String?
    let v: Int?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case active, name, description, expireDate, image, slug, createdAt, updatedAt
        case v = "__v"
        case id
    }
}
