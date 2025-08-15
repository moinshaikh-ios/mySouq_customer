//
//  addwishlist.swift
//  Bazaar Ghar
//
//  Created by Zany on 21/09/2023.
//

import Foundation

struct AddWishlistResponse: Codable {
    let products: [AddWishlistProduct]?
    let user, createdAt, updatedAt: String?
    let v: Int?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case products, user, createdAt, updatedAt
        case v = "__v"
        case id
    }
}

// MARK: - Product
struct AddWishlistProduct: Codable {
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
    let categories: Categories?
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
        case active, categories, category, createdAt, description, isCompleted, mainImage, platformRegularPrice, platformSalePrice, price, productName, quantity, regularPrice, salePrice, sellerDetail, sku, slug, updatedAt, user
        case videoURL = "videoUrl"
        case weight, lang
        case v = "__v"
        case variants, groupBuy, reviews, id
        case skuAttribute = "sku_attribute"
        case mainProduct
    }
}



// MARK: - Category
struct AddWishlistCategory: Codable {
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
    let products: Int?
    let categorySpecs: AddWishlistCategorySpecs?
    let subCategories: [AddWishlistCategory]?
    let id: String?
    let deleted: Bool?

    enum CodingKeys: String, CodingKey {
        case gallery, type, attributeRequired, name, slug, commission, mainCategory, createdAt, updatedAt
        case v = "__v"
        case description, mainImage, products, categorySpecs, subCategories, id, deleted
    }
}

// MARK: - CategorySpecs
struct AddWishlistCategorySpecs: Codable {
    let productsCount: Int?
    let active: Bool?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case productsCount, active
        case id = "_id"
    }
}


// MARK: - User
struct AddWishlistUser: Codable {
    let wallet: AddWishlistWallet?
    let isEmailVarified, isPhoneVarified: Bool?
    let userType, role, email, fullname: String?
    let phone, createdAt, updatedAt, refCode: String?
    let v: Int?
    let sellerDetail: AddWishlistSellerDetail?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case wallet, isEmailVarified, isPhoneVarified, userType, role, email, fullname, phone, createdAt, updatedAt, refCode
        case v = "__v"
        case sellerDetail, id
    }
}

// MARK: - SellerDetail
struct AddWishlistSellerDetail: Codable {
    let images: [String]?
    let country: String?
    let costCode, approved: Bool?
    let brandName, description: String?
    let market: AddWishlistMarket?
    let address, cityCode, city, seller: String?
    let createdAt, updatedAt, rrp: String?
    let v: Int?
    let alias, costCenterCode, slug, id: String?

    enum CodingKeys: String, CodingKey {
        case images, country, costCode, approved, brandName, description, market, address, cityCode, city, seller, createdAt, updatedAt, rrp
        case v = "__v"
        case alias, costCenterCode, slug, id
    }
}

// MARK: - Market
struct AddWishlistMarket: Codable {
    let type, name, description, createdAt: String?
    let updatedAt: String?
    let v: Int?
    let image: String?
    let subMarkets: [AddWishlistMarket]?
    let id, mainMarket: String?

    enum CodingKeys: String, CodingKey {
        case type, name, description, createdAt, updatedAt
        case v = "__v"
        case image, subMarkets, id, mainMarket
    }
}

// MARK: - Wallet
struct AddWishlistWallet: Codable {
    let balance: Float?}

// MARK: - RemoveWishList
struct RemoveWishListResponse: Codable {
    let products: [String]?
    let user, createdAt, updatedAt: String?
    let v: Int?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case products, user, createdAt, updatedAt
        case v = "__v"
        case id
    }
}
