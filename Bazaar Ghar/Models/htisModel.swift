import Foundation
public struct Recipe: Codable {
  var directions: [String]?
  public var id: String?
  var ingredient_names: [String]?
  var ingredients_with_measurements: [String]?
  var link: String?
  var recipe_id: Int?
//  var title: String?
  var _id: String?
    var active: Bool?
    var variants: [Variants]?


    var featured, onSale, isVariable: Bool?
    var productName, slug: String?
    var mainImage: String?
    var regularPrice: Double?
    var quantity: Int?
    var price: Double?
    var lang: languagesModel?
    var sku: String?
    var description: String?
    let salePrice: Double?
 
}














struct checkout3dsReponse: Codable {
    let id, status: String?
    let customer: Customer?
    let the3Ds: The3Ds?
    let links: Links3ds?

    enum CodingKeys: String, CodingKey {
        case id, status, customer
        case the3Ds = "3ds"
        case links = "_links"
    }
}

// MARK: - Customer
struct Customer: Codable {
    let id, email: String?
}

// MARK: - Links
struct Links3ds: Codable {
    let linksSelf, actions, redirect: Actions3ds?

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case actions, redirect
    }
}

// MARK: - Actions
struct Actions3ds: Codable {
    let href: String?
}

// MARK: - The3Ds
struct The3Ds: Codable {
    let downgraded: Bool?
    let enrolled: String?
}
