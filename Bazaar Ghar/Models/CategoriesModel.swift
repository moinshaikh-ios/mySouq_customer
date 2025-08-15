//
//  CategoriesModel.swift
//  Bazaar Ghar
//
//  Created by Developer on 23/08/2023.
//
import Foundation

// MARK: - Result
struct CategoriesResponse: Codable {
    let gallery: [String]?
    let type: String?
    let attributes: [String]?
    let attributeRequired: Bool?
    let deleted: Bool?
    let name, createdAt, updatedAt: String?
    let mainImage: String?
    let description: String?
    let slug: String?
    let commission: Int?
    let bannerImage: String?
    let products: Int?
    let categorySpecs: CategorySpecs?
    let subCategories: [ResultSubCategory]?
    let id: String?
    let bannerPhone: String?

    enum CodingKeys: String, CodingKey {
        case gallery, type, attributes, attributeRequired, deleted, name, createdAt, updatedAt, mainImage, description, slug, commission
        case bannerImage, products, categorySpecs, subCategories, id, bannerPhone
    }
}

// MARK: - CategorySpecs
struct CategorySpecs: Codable {
    let productsCount: Int?
    let active: Bool?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case productsCount, active
        case id = "_id"
    }
}

// MARK: - ResultSubCategory
struct ResultSubCategory: Codable {
    let gallery: [String]?
    let type: String?
    let attributes: [String]?
    let attributeRequired: Bool?
    let deleted: Bool?
    let name: String?
    let mainCategory: String?
    let createdAt, updatedAt: String?
    let description: String?
    let commission: Int?
    let mainImage: String?
    let v: Int?
    let slug: String?
    let products: Int?
    let categorySpecs: CategorySpecs?
    let subCategories: [PurpleSubCategory]?
    let id: String?
    let bannerImage: String?

    enum CodingKeys: String, CodingKey {
        case gallery, type, attributes, attributeRequired, deleted, name, mainCategory, createdAt, updatedAt, description, commission, mainImage
        case v = "__v"
        case slug, products, categorySpecs, subCategories, id, bannerImage
    }
}

// MARK: - PurpleSubCategory
struct PurpleSubCategory: Codable {
    let gallery: [String]?
    let type: String?
    let attributes: [String]?
    let attributeRequired: Bool?
    let deleted: Bool?
    let name, mainCategory, createdAt, updatedAt: String?
    let description: String?
    let commission: Int?
    let mainImage: String?
    let slug: String?
    let products: Int?
    let categorySpecs: CategorySpecs?
    let subCategories: [FluffySubCategory]?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case gallery, type, attributes, attributeRequired, deleted, name, mainCategory, createdAt, updatedAt, description, commission, mainImage
        case slug, products, categorySpecs, subCategories, id
    }
}

// MARK: - FluffySubCategory
struct FluffySubCategory: Codable {
    let gallery: [String]?
    let type: String?
    let attributes: [String]?
    let attributeRequired: Bool?
    let name: String?
    let createdAt, updatedAt, slug: String?

    let id: String?

    enum CodingKeys: String, CodingKey {
        case gallery, type, attributes, attributeRequired, name
        case createdAt, updatedAt, slug, id
    }
}
