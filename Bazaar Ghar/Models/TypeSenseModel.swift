
//struct TypeSenseModel: Codable {
//    let results: [TypeSenseResult?]?
//}
//
//// MARK: - Result
//struct TypeSenseResult: Codable {
//
//    let facetCounts: [TypeSenseFacetCount?]?
//    let found: Int?
//    let hits: [TPHit]?
//    let outOf, page: Int?
//    let requestParams: TypeSenseRequestParams?
//    let searchCutoff: Bool?
//    let searchTimeMS: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case facetCounts = "facet_counts"
//        case found
//        case hits
//        case outOf = "out_of"
//        case page
//        case requestParams = "request_params"
//        case searchCutoff = "search_cutoff"
//        case searchTimeMS = "search_time_ms"
//    }
//    public static var shared: [TypeSenseResult?]?
//}
//
//// MARK: - FacetCount
//struct TypeSenseFacetCount: Codable {
//    var counts: [TypeSenseCount?]?
//    let fieldName: String?
//    let sampled: Bool?
//    let stats: TypeSenseStats?
//
//    enum CodingKeys: String, CodingKey {
//        case counts
//        case fieldName = "field_name"
//        case sampled
//        case stats
//    }
//}
//
//// MARK: - Count
struct TypeSenseCount: Codable {
    let count: Int?
    let highlighted, value: String?
    var isselected: Bool?
    var isquery: String?

    enum CodingKeys: String, CodingKey {
        case count
        case highlighted
        case value
        case isselected
        case isquery
    }
}

//// MARK: - Stats
//struct TypeSenseStats: Codable {
//    let avg, max, min, sum: Double?
//    let totalValues: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case avg
//        case max
//        case min
//        case sum
//        case totalValues = "total_values"
//    }
//}
//
//// MARK: - Hit
//struct TypeSenseHit: Codable {
//    let document: TypeSenseDocument?
//    let highlight: TypeSenseHighlight?
//    let highlights: [TypeSenseHighlight?]?
//
//    enum CodingKeys: String, CodingKey {
//        case document
//        case highlight
//        case highlights
//    }
//}
//
//// MARK: - Document
//struct TypeSenseDocument: Codable {
//    let active: Bool?
//    let averageRating: Double?
//    let brandName: String?
//    let categories: TypeSenseCategories?
////    let categoryTree: [String?]
//    let createdAt: String?
//    let currency: String?
//    let documentDescription: String?
//    let featured: Bool?
//    let fiveStar, fourStar: Int?
//    let gallery: [String]?
//
//    let id: String?
//    let isVariable: Bool?
//    let lvl0: String?
//    let lvl1: String?
//    let mainImage: String?
//    let onDeal, onSale: Bool?
//    let oneStar: Int?
//    let platform: String?
//    let price: Int?
//    let productName: String?
//    let quantity: Int?
//    let ratings: TypeSenseRatings?
//
//    let regularPrice: Int?
//    let relief: Bool?
//    let salePrice: Int?
//    let selectedAttributes: [String?]
//    let sellerDetail: String?
//    let sku, slug: String?
//    let threeStar, total, twoStar: Int?
//    let user: TypeSenseUser?
//    let variantGroupBuy: Bool?
//    let videoType: TypeSenseVideoType?
//    let weight: Int?
//    let category: String?
//
//    enum CodingKeys: String, CodingKey {
//        case active
//        case averageRating = "averageRating"
//        case brandName = "brandName"
//        case categories
////        case categoryTree = "categoryTree"
//        case createdAt = "createdAt"
//        case currency
//        case documentDescription = "description"
//        case featured
//        case fiveStar = "fiveStar"
//        case fourStar = "fourStar"
//        case gallery
//        case id
//        case isVariable = "isVariable"
//        case lvl0
//        case lvl1
//        case mainImage = "mainImage"
//        case onDeal = "onDeal"
//        case onSale = "onSale"
//        case oneStar = "oneStar"
//                case platform
//        case price
//        case productName = "productName"
//        case quantity
//        case ratings
//        case regularPrice = "regularPrice"
//        case relief
//        case salePrice = "salePrice"
//        case selectedAttributes = "selectedAttributes"
//        case sellerDetail = "sellerDetail"
//        case sku
//        case slug
//        case threeStar = "threeStar"
//        case total
//        case twoStar = "twoStar"
//        case user
//        case variantGroupBuy = "variantGroupBuy"
//        case videoType = "videoType"
//        case weight
//        case category
//    }
//}
//
//// MARK: - Categories
//struct TypeSenseCategories: Codable {
//    let lvl0: String?
//    let lvl1: String?
//
//    enum CodingKeys: String, CodingKey {
//        case lvl0
//        case lvl1
//    }
//}
//
//enum TypeSenseCurrency: String, Codable {
//    case pkr
//}
//
//
//
//
//
//// MARK: - Ratings
//struct TypeSenseRatings: Codable {
//    let avg, total: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case avg
//        case total
//    }
//}
//
//// MARK: - User
//struct TypeSenseUser: Codable {
//    let fullname: String?
//    let id: String?
//    let sellerDetail: TypeSenseSellerDetail?
//
//    enum CodingKeys: String, CodingKey {
//        case fullname
//        case id
//        case sellerDetail = "sellerDetail"
//    }
//}
//
//// MARK: - SellerDetail
//struct TypeSenseSellerDetail: Codable {
//    let brandName: String?
//    let id: String?
//
//    enum CodingKeys: String, CodingKey {
//        case brandName = "brand_name"
//        case id
//    }
//}
//
//enum TypeSenseVideoType: String, Codable {
//    case bg
//}
//
//// MARK: - Highlight
//struct TypeSenseHighlight: Codable {
//}
//
//// MARK: - RequestParams
//struct TypeSenseRequestParams: Codable {
//    let collectionName, firstQ: String?
//    let perPage: Int?
//    let q: String?
//
//    enum CodingKeys: String, CodingKey {
//        case collectionName = "collection_name"
//        case firstQ = "first_q"
//        case perPage = "per_page"
//        case q
//    }
//}
