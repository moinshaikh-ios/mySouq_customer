//
//  AddToCartResponse.swift
//  Bazaar Ghar
//
//  Created by Developer on 13/09/2023.
//

import Foundation

struct AddToCartResponse: Codable {
//    let paymentTrace: PaymentTrace?
//    let packages: [AddToCartPackage]?
//    let total, subTotal, shippmentCharges: Int?
//    let wallet: Bool?
//    let paymentMethod: String?
//    let paymentMethodTotal, payable, retailTotal, discount: Int?
//    let user: AddToCartUser?
//    let createdAt, updatedAt: String?
//    let v: Int?
//    let cartPackages: [String]?
    let id: String?

    enum CodingKeys: String, CodingKey {
//        case paymentTrace, packages, total, subTotal, shippmentCharges, wallet, paymentMethod, paymentMethodTotal, payable, retailTotal, discount, user, createdAt, updatedAt
//        case v = "__v"
//        case cartPackages, id
        case id
//        case packages
    }
}

// MARK: - Package
struct AddToCartPackage: Codable {
    let packageItems: [PackageItem]?
    let shippmentCharges: Int?
    let inCart: Bool?
    let seller: AddToCartUser?
    let cart, createdAt, updatedAt: String?
    let subTotal, retailTotal: Double?
    let packageWeight: Double?
    let discount, v: Int?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case packageItems, shippmentCharges, inCart, seller, cart, createdAt, updatedAt, subTotal, retailTotal, packageWeight, discount
        case v = "__v"
        case id
    }
}


struct SelectObjItems: Codable {
    let name : String?
   let value : String?


}
// MARK: - PackageItem
struct PackageItem: Codable {
    let discount: Int?
    let package: String?
    let product: AddToCartProduct?
    let quantity, total: Double?
    let weight: Double?
    let retailTotal: Double?
    let createdAt, updatedAt: String?
    let v: Int?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case discount
        case package = "_package"
        case product, quantity, total, weight, retailTotal, createdAt, updatedAt
        case v = "__v"
        case id
    }
}

// MARK: - Product
struct AddToCartProduct: Codable {
    let featured, onSale: Bool?
    let attributes, selectedAttributes: [SelectObjItems]?
    let isVariable: Bool?
    let productType: String?
    let gallery: [String]?
    let variantGroupBuy: Bool?
    let categoryTree: [String]?
    let onDeal, relief: Bool?
    let videoType, productName, description, sku: String?
    let weight: Double?
    let regularPrice, salePrice: Double?
       let  quantity: Int?

        let mainImage: String?
    let category: Category?
    let user: AddToCartUser?
    let slug: String?
    let active: Bool?
    let price: Double?
      let  v: Int?
    let createdAt, updatedAt, sellerDetail: String?
    let variants, groupBuy, reviews: [String]?
    let id: String?
    let categories: Categories?

    enum CodingKeys: String, CodingKey {
        case featured, onSale, attributes, selectedAttributes, isVariable, productType, gallery, variantGroupBuy, categoryTree, onDeal, relief, videoType, productName, description, sku, weight, regularPrice, salePrice, quantity, mainImage, category, user, slug, active, price
        case v = "__v"
        case createdAt, updatedAt, sellerDetail, variants, groupBuy, reviews, id, categories
    }
}

// MARK: - Categories
struct Categories: Codable {
    let lvl0: String?
}

// MARK: - Category
struct Category: Codable {
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
    let categorySpecs: AddToCartCategorySpecs?
    let subCategories: [Category]?
    let id: String?
    let bannerImage: String?

    enum CodingKeys: String, CodingKey {
        case gallery, type, attributeRequired, deleted, name, mainCategory, createdAt, updatedAt
        case v = "__v"
        case description, mainImage, commission, slug, products, categorySpecs, subCategories, id, bannerImage
    }
}

// MARK: - CategorySpecs
struct AddToCartCategorySpecs: Codable {
    let productsCount: Int?
    let active: Bool?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case productsCount, active
        case id = "_id"
    }
}


// MARK: - User
struct AddToCartUser: Codable {
    let wallet: AddToCartWallet?
    let isEmailVarified, isPhoneVarified: Bool?
    let userType, role, email, fullname: String?
    let phone, createdAt, updatedAt, refCode: String?
    let v: Int?
    let sellerDetail: AddToCartSellerDetail?
    let id, googleID: String?

    enum CodingKeys: String, CodingKey {
        case wallet, isEmailVarified, isPhoneVarified, userType, role, email, fullname, phone, createdAt, updatedAt, refCode
        case v = "__v"
        case sellerDetail, id
        case googleID = "googleId"
    }
}

// MARK: - SellerDetail
struct AddToCartSellerDetail: Codable {
    let images: [String]?
    let country: String?
    let costCode, approved: Bool?
    let brandName, description: String?
    let market: AddToCartMarket?
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
struct AddToCartMarket: Codable {
    let type: String?
    let name: String?
    let description, createdAt, updatedAt: String?
    let v: Int?
    let image: String?
    let subMarkets: [Market]?
    let id, slug: String?
    let mainMarket: String?

    enum CodingKeys: String, CodingKey {
        case type, name, description, createdAt, updatedAt
        case v = "__v"
        case image, subMarkets, id, slug, mainMarket
    }
}

// MARK: - Wallet
struct AddToCartWallet: Codable {
    let balance: Float?}

// MARK: - PaymentTrace
struct PaymentTrace: Codable {
    let walletPaid, cardPaid: Int?
}
