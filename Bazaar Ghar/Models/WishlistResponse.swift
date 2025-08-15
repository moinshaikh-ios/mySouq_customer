//
//  WishlistResponse.swift
//  Bazaar Ghar
//
//  Created by Zany on 21/09/2023.
//

import Foundation

struct WishlistResponse: Codable {
    let products: [Product]?
    let user, createdAt, updatedAt: String?
    let v: Int?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case products, user, createdAt, updatedAt
        case v = "__v"
        case id
    }
}

struct WishlistProduct: Codable {
    let featured, onSale: Bool?
    let attributes: [WishlistAttribute]?
    let selectedAttributes: [SelectObjItems]?
    let isVariable: Bool?
    let productType: String?
    let gallery: [String]?
    let variantGroupBuy: Bool?
    let categoryTree: [String]?
    let onDeal, relief: Bool?
    let videoType: String?
    let platform: String?
    let currency: String?
    let embedding: [Double]?
    let platformID: String?
    let active: Bool?
//    let categories: [Categories]?
    let category: WishlistCategory?
    let createdAt, description: String?
    let isCompleted: Bool?
    let mainImage: String?
    let platformRegularPrice, platformSalePrice: Double?
    let price: Double?
    let productName: String?
    let quantity: Int?
    let regularPrice, salePrice: Double?
    let sellerDetail: String?
    let sku, slug: String?
    let updatedAt: String?
    let user: WishlistProductUser?
    let videoURL: String?
    let weight: Double?
    let lang: Lang?
    let v: Int?
    let variants: [Product]?
    let groupBuy, reviews: [String]?
    let id, skuAttribute: String?
    let mainProduct: String?

    enum CodingKeys: String, CodingKey {
        case featured, onSale, attributes, selectedAttributes, isVariable, productType, gallery, variantGroupBuy, categoryTree, onDeal, relief, videoType, platform, currency, embedding
        case platformID = "platformId"
        case active, category, createdAt, description, isCompleted, mainImage, platformRegularPrice, platformSalePrice, price, productName, quantity, regularPrice, salePrice, sellerDetail, sku, slug, updatedAt, user
        case videoURL = "videoUrl"
        case weight, lang
        case v = "__v"
        case variants, groupBuy, reviews, id
        case skuAttribute = "sku_attribute"
        case mainProduct
    }
}



struct WishlistProductGroupBuy: Codable {
    
    let buyAbleProduct, remainingProduct, groupSalePrice: Double?
    let status: String?
//    let productID: PurpleProductID?
    let limit: Int?
    let startDate, endDate: String?
    let minSubscription, maxSubscription: Double?
    let sellerID: FluffySellerID?
    let discount: Double?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case buyAbleProduct, remainingProduct, groupSalePrice, status
//        case productID = "productId"
        case limit, startDate, endDate, minSubscription, maxSubscription
        case sellerID = "sellerId"
        case discount, id
    }
}
struct PurpleProductID: Codable {
    let onSale: Bool?
    let productName, slug: String?
    let user: ProductUser?
    let mainImage: String?
    let category: ProductCategory?
    let price, regularPrice, salePrice: Double?
    let variants: [String]?
    let groupBuy: [WishlistProductGroupBuy]?
    let reviews: [String]?
    let id: String?
    
    enum CodingKeys: String, CodingKey {
        case onSale, productName, slug, user
        case mainImage
        case category, price, regularPrice, salePrice, variants
        case groupBuy
        case reviews, id
    }
}
struct PurpleGroupBuy: Codable {
    let buyAbleProduct, remainingProduct, groupSalePrice: Double?
    let status: String?
    let productID: FluffyProductID?
    let limit: Int?
    let startDate, endDate: String?
    let minSubscription, maxSubscription: Double?
    let sellerID: FluffySellerID?
    let discount: Double?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case buyAbleProduct, remainingProduct, groupSalePrice, status
        case productID = "productId"
        case limit, startDate, endDate, minSubscription, maxSubscription
        case sellerID = "sellerId"
        case discount, id
    }
}
struct FluffyProductID: Codable {
    let onSale: Bool?
    let productName, slug: String?
    let user: ProductUser?
    let mainImage: String?
    let category: ProductCategory?
    let price, regularPrice, salePrice: Double?
    let variants: [String]?
    let groupBuy: [WishlistProductGroupBuy]?
    let reviews: [String]?
    let id: String?
}
struct FluffyGroupBuy: Codable {
    let buyAbleProduct, remainingProduct, groupSalePrice: Double?
    let status: String?
    let productID: TentacledProductID?
    let limit: Int?
    let startDate, endDate: String?
    let minSubscription, maxSubscription: Double?
    let sellerID: FluffySellerID?
    let discount: Int?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case buyAbleProduct, remainingProduct, groupSalePrice, status
        case productID = "productId"
        case limit, startDate, endDate, minSubscription, maxSubscription
        case sellerID = "sellerId"
        case discount, id
    }
}
struct TentacledProductID: Codable {
    let onSale: Bool?
    let productName, slug: String?
    let user: ProductUser?
    let mainImage: String?
    let category: ProductCategory?
    let price, regularPrice, salePrice: Double?
    let variants: [String]?
    let groupBuy: [WishlistProductGroupBuy]?
    let reviews: [String]?
    let id: String?
}

struct TentacledGroupBuy: Codable {
    let buyAbleProduct, remainingProduct, groupSalePrice: Double?
    let status: String?
    let productID: StickyProductID?
    let limit: Int?
    let startDate, endDate: String?
    let minSubscription, maxSubscription: Double?
    let sellerID: FluffySellerID?
    let discount: Double?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case buyAbleProduct, remainingProduct, groupSalePrice, status
        case productID = "productId"
        case limit, startDate, endDate, minSubscription, maxSubscription
        case sellerID = "sellerId"
        case discount, id
    }
}
struct StickyProductID: Codable {
    let onSale: Bool?
    let productName, slug: String?
    let user: PurpleUser?
    let mainImage: String?
    let category: PurpleCategory?
    let price, regularPrice, salePrice: Double?
    let variants: [String]?
    let groupBuy: [WishlistProductGroupBuy]?
    let reviews: [String]?
    let id: String?
}
struct StickyGroupBuy: Codable {
    let buyAbleProduct, remainingProduct, groupSalePrice: Double?
    let status: String?
    let productID: IndigoProductID?
    let limit: Int?
    let startDate, endDate: String?
    let minSubscription, maxSubscription: Double?
    let sellerID: PurpleSellerID?
    let discount: Double?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case buyAbleProduct, remainingProduct, groupSalePrice, status
        case productID = "productId"
        case limit, startDate, endDate, minSubscription, maxSubscription
        case sellerID = "sellerId"
        case discount, id
    }
}
struct IndigoProductID: Codable {
    let onSale: Bool?
    let productName, slug: String?
    let mainImage: String?
    let price, regularPrice, salePrice: Double?
    let id: String?
}

// MARK: - PurpleSellerID
struct PurpleSellerID: Codable {
    let fullname, id: String?
}
struct PurpleCategory: Codable {
    let gallery: [String]?
    let type: String?

    let attributeRequired, deleted: Bool?
    let name, createdAt, updatedAt: String?
    let mainImage: String?
    let description, slug: String?
    let v: Int?
    let bannerImage: String?
    let products: Int?
    let categorySpecs: CategorySpecs?
    let commission: Int?
    let subCategories: [CategorySubCategory]?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case gallery, type,  attributeRequired, deleted, name, createdAt, updatedAt, mainImage, description, slug
        case v = "__v"
        case bannerImage, products, categorySpecs, commission, subCategories, id
    }
}
struct CategorySubCategory: Codable {
    let gallery: [String]?
    let type: String?
 
    let attributeRequired, deleted: Bool?
    let name: String?
    let mainCategory: String?
    let createdAt, updatedAt: String?
    let v: Int?
    let description: String?
    let mainImage: String?
    let commission: Int?
    let slug: String?
    let products: Int?
    let categorySpecs: CategorySpecs?
    let subCategories: [PurpleSubCategory]?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case gallery, type,  attributeRequired, deleted, name, createdAt, updatedAt
        case v = "__v"
        case description, mainImage, commission, slug, products, categorySpecs, subCategories, id
        case  mainCategory
    }
}
struct PurpleUser: Codable {
    let wallet: Wallet?
    let isEmailVarified, isPhoneVarified: Bool?
    let userType: String?
    let role: String?
    let email, fullname, phone, createdAt: String?
    let updatedAt, refCode: String?
    let v: Int?
    let sellerDetail: PurpleSellerDetail?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case wallet, isEmailVarified, isPhoneVarified, userType, role, email, fullname, phone, createdAt, updatedAt, refCode
        case v = "__v"
        case sellerDetail, id
    }
}
struct PurpleSellerDetail: Codable {
    let images: [String]?
    let country: String?
    let costCode, approved: Bool?
    let brandName, description: String?
    let market: String?
    let address: String?
    let cityCode: String?
    let city: String?
    let seller, createdAt, updatedAt, rrp: String?
    let v: Int?
    let alias, costCenterCode, slug, id: String?

    enum CodingKeys: String, CodingKey {
        case images, country, costCode, approved, brandName, description, market, address, cityCode, city, seller, createdAt, updatedAt, rrp
        case v = "__v"
        case alias, costCenterCode, slug, id
    }
}
struct ProductCategory: Codable {
    let gallery: [String]?
    let type: String?

    let attributeRequired, deleted: Bool?
    let name, createdAt, updatedAt: String?
    let mainImage: String?
    let description, slug: String?
    let commission, v: Int?
    let bannerImage: String?
    let products: Int?
    let categorySpecs: CategorySpecs?
    let subCategories: [CategorySubCategory]?
    let id, mainCategory: String?
    let bannerPhone: String?

    enum CodingKeys: String, CodingKey {
        case gallery, type, attributeRequired, deleted, name, createdAt, updatedAt, mainImage, description, slug, commission
        case v = "__v"
        case bannerImage, products, categorySpecs, subCategories, id, mainCategory, bannerPhone
    }
}
struct FluffySellerID: Codable {
    let fullname: String?
    let sellerDetail: SellerIDSellerDetail?
    let id: String?
}
struct SellerIDSellerDetail: Codable {
    let images: [String]?
    let country: String?
    let costCode, approved: Bool?
    let brandName, description: String?
    let market: MarketElement?
    let address: String?
    let cityCode: String?
    let city: String?
    let seller, createdAt, updatedAt, rrp: String?
    let v: Int?
    let alias, costCenterCode, slug, id: String?

    enum CodingKeys: String, CodingKey {
        case images, country, costCode, approved, brandName, description, market, address, cityCode, city, seller, createdAt, updatedAt, rrp
        case v = "__v"
        case alias, costCenterCode, slug, id
    }
}
struct MarketElement: Codable {
    let type: String?
    let name: String?
    let description, createdAt, updatedAt: String?
    let v: Int?
    let image: String?
    let id: String?
    let subMarkets: [MarketElement]?
    let slug: String?
    let mainMarket: String?

    enum CodingKeys: String, CodingKey {
        case type, name, description, createdAt, updatedAt
        case v = "__v"
        case image, id, subMarkets, slug, mainMarket
    }
}
// MARK: - Attribute
struct WishlistAttribute: Codable {
    let name: String?
    let values: [String]?
}

// MARK: - Category
struct WishlistCategory: Codable {
    let gallery: [String]?
    let type: String?
  
    let attributeRequired: Bool?
    let name, slug: String?
    let commission: Int?
    let mainCategory: String?
    let createdAt, updatedAt: String?
    let v: Int?
    let description: String?
    let mainImage: String?
    let lang:languagesModel?
    let products: Int?
    let categorySpecs: CategorySpecs?
    let subCategories: [Category]?
    let id: String?
    let deleted: Bool?
    let bannerImage: String?

    enum CodingKeys: String, CodingKey {
        case gallery, type,  attributeRequired, name, slug, commission, mainCategory, createdAt, updatedAt
        case v = "__v"
        case description, mainImage, products, categorySpecs, subCategories, id, deleted, bannerImage, lang
    }
}

// MARK: - CategorySpecs
struct WishlistCategorySpecs: Codable {
    let productsCount: Int?
    let active: Bool?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case productsCount, active
        case id = "_id"
    }
}
struct CategoriesClass: Codable {
    let lvl0, lvl1, lvl2: String?
}

// MARK: - ProductUser
struct WishlistProductUser: Codable {
    let wallet: WishlistWallet?
    let isEmailVarified, isPhoneVarified: Bool?
    let userType: String?
    let role: String?
    let email, fullname, phone, createdAt: String?
    let updatedAt, refCode: String?
    let v: Int?
    let sellerDetail: WishlistSellerDetail?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case wallet, isEmailVarified, isPhoneVarified, userType, role, email, fullname, phone, createdAt, updatedAt, refCode
        case v = "__v"
        case sellerDetail, id
    }
}


// MARK: - SellerDetail
struct WishlistSellerDetail: Codable {
    let images: [String]?
    let country: String?
    let costCode, approved: Bool?
    let brandName, description: String?
    let market: WishlistMarket?
    let address: String?
    let cityCode: String?
    let city: String?
    let seller, createdAt, updatedAt, rrp: String?
    let v: Int?
    let alias, costCenterCode, slug, id: String?

    enum CodingKeys: String, CodingKey {
        case images, country, costCode, approved, brandName, description, market, address, cityCode, city, seller, createdAt, updatedAt, rrp
        case v = "__v"
        case alias, costCenterCode, slug, id
    }
}


// MARK: - Market
struct WishlistMarket: Codable {
    let type: String?
    let name: String?
    let description, createdAt, updatedAt: String?
    let v: Int?
    let image: String?
    let subMarkets: [WishlistMarket]?
    let id: String?
    let mainMarket: String?
    let slug: String?

    enum CodingKeys: String, CodingKey {
        case type, name, description, createdAt, updatedAt
        case v = "__v"
        case image, subMarkets, id, mainMarket, slug
    }
}



// MARK: - Wallet
struct WishlistWallet: Codable {
    let balance: Float?}

// MARK: - Variant
struct WishlistVariant: Codable {
    let featured, onSale: Bool?
   
    let selectedAttributes: [WishlistSelectedAttribute]?
    let isVariable: Bool?
    let productType: String?
    let gallery: [String]?
    let variantGroupBuy: Bool?
    let categoryTree: [String]?
    let onDeal, relief: Bool?
    let videoType: String?
    let productName, sku, mainProduct: String?
//    let user: String?
    let createdAt, updatedAt, slug: String?
    let active: Bool?
   
    let description: String?
    let price,  regularPrice, salePrice: Double?
    let quantity: Int?
    let weight: Int?
    let mainImage: String?

    let deleted: Bool?
    let sellerDetail: String?
 
    let id: String?

}

// MARK: - SelectedAttribute
struct WishlistSelectedAttribute: Codable {
    let name, value: String?
}

// MARK: - VariantUser
struct WishlistVariantUser: Codable {
    let wallet: WishlistWallet?
    let isEmailVarified, isPhoneVarified: Bool?
    let userType: String?
    let role: String?
    let email, fullname, phone, createdAt: String?
    let updatedAt: String?
    let sellerDetail: WishlistSellerDetail?
    let refCode, id: String?
}

