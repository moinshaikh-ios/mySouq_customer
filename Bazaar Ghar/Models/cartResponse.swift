import Foundation



// MARK: - DataClass
struct CoupenCartItemsResponse: Codable {
    let type: String?
    let cart: CartItemsResponse?
    let status: Int?
    let message: String?
}


// MARK: - DataClass
struct CartItemsResponse: Codable {
    let packages: [Package]?
    let total, subTotal, shippmentCharges: Double?
    let wallet: Bool?
    let paymentMethodTotal, payable, retailTotal, discount: Double?
    let user: DataUser?
    let id: String?
    let OrderDetailId:String?
}




// MARK: - Package
struct Package: Codable {
    let packageItems: [CartPackageItem]?
//    let shippmentCharges: Int?
    let inCart: Bool?
    let seller: CartSeller?
    let cart: String?
    let subTotal, retailTotal: Double?
    let packageWeight: Double?
    let discount: Double?
    let id: String?
}

// MARK: - PackageItem
struct CartPackageItem: Codable {
    let discount: Double?
    let _package: String?
    let product: CartProduct?
    let quantity : Int?
    let total: Double?
    let weight: Double?
    let retailTotal: Double?
    let id: String?
}

// MARK: - Product
struct CartProduct: Codable {
    let featured, onSale: Bool?
    let selectedAttributes: [SelectObjItems]?
    let  attributes: [Attributeobj]?
    let productType, productName, description: String?
    let weight: Double?
    let salePrice: Double?
    let regularPrice: Double?
    let quantity: Int?
    let mainImage: String?
    let user: ProductUser?
    let slug: String?
    let active: Bool?
    let origin : String?
    let price: Double?
    let id: String?
    let groupBuy: [ProductGroupBuy]?
    let lang: languagesModel?
}

struct ProductGroupBuy: Codable {
    
    let buyAbleProduct, remainingProduct, groupSalePrice: Int?
    let status: String?
//    let productID: PurpleProductID?
    let limit: Int?
    let startDate, endDate: String?
    let minSubscription, maxSubscription: Int?
    let sellerID: String?
    let discount: Int?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case buyAbleProduct, remainingProduct, groupSalePrice, status
//        case productID = "productId"
        case limit, startDate, endDate, minSubscription, maxSubscription
        case sellerID = "sellerId"
        case discount, id
    }
}

// MARK: - ProductUser
struct ProductUser: Codable {
    let id: String?
}

// MARK: - Seller
struct CartSeller: Codable {
    let id, email, fullname: String?
    let sellerDetail: CartSellerDetail?
    let sellerID: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case email, fullname, sellerDetail
        case sellerID = "id"
    }
}

// MARK: - SellerDetail
struct CartSellerDetail: Codable {
    let id, brandName, rrp, slug: String?
    let sellerDetailID: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case brandName, rrp, slug
        case sellerDetailID = "id"
    }
}

// MARK: - DataUser
struct DataUser: Codable {
    let wallet: CartWallet?
    let fullname, id: String?
    let defaultAddress: DefaultAddress?
}



// MARK: - Wallet
struct CartWallet: Codable {
    let balance: Float?}
// MARK: - Attribute

struct CitiesResponse: Codable {
    let cityCode, cityName: String?

    enum CodingKeys: String, CodingKey {
        case cityCode = "CITY_CODE"
        case cityName = "CITY_NAME"
    }
}
