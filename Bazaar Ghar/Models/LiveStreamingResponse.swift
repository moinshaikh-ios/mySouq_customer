//
//  LiveStreamingRespinse.swift
//  Bazaar Ghar
//
//  Created by Zany on 28/09/2023.
//

import Foundation


// MARK: - DataClass
struct LiveStreamingResponse: Codable {
    let page, totalPages, limit, totalResults: Int
    let results: [LiveStreamingResults]
    let featured: [LiveStreamingFeatured]
}

// MARK: - Featured
struct LiveStreamingFeatured: Codable {
    let id: String?
    let yt: Yt?
    let productsID: [String]?
    let totalViews, liveViews, fbViews: Int?
    let suspension: String?
    let featured, updatedURL: Bool?
    let categories: [String]?
    let fbID: String?
    let service: String?
    let duration: Double?
    let fbTotalViews: Int?
    let pin: Bool?
    let livePlatforms: [String]?
    let videoType: String?
    let simulcast: String?
    let streamingURL, shortVideoURL: String?
    let userID: String?
    let title: String?
    let slotStatus: String?
    let slug, userName: String?
    let brandName: String?
    let city: String?
    let brandID: String?
    let thumbnail: String?
    let description, storeSlug, fileID: String?
//    let socialPlatforms: [String]?
    let createdAt, updatedAt: String?
    let v: Int?
    let mbrURL: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case yt
        case productsID = "productsId"
        case totalViews, liveViews, fbViews, suspension, featured
        case updatedURL = "updatedUrl"
        case categories
        case fbID = "fbId"
        case service, duration, fbTotalViews, pin, livePlatforms, videoType, simulcast
        case streamingURL = "streamingUrl"
        case shortVideoURL = "shortVideoUrl"
        case userID = "userId"
        case title, slotStatus, slug, userName, brandName, city
        case brandID = "brandId"
        case thumbnail, description, storeSlug
        case fileID = "fileId"
        case  createdAt, updatedAt
        case v = "__v"
        case mbrURL = "mbrUrl"
    }
}


// MARK: - Yt
struct Yt: Codable {
    let views: Int?
}



// MARK: - DataClass
struct LiveStreamingData: Codable {
    let page, totalPages, limit, totalResults: Int?
    let results: [LiveStreamingResults]?
    let featured: [LiveStreamingResults]?
}

// MARK: - Featured
struct Featured: Codable {
    let id: String?
    let yt: RecordYt?
    let productsID: [String]?
    let totalViews, liveViews, fbViews: Int?
    let suspension: String?
    let featured, updatedURL: Bool?
    let categories: [String]?
    let fbID: String?
    let service: String?
    let duration: Double?
    let fbTotalViews: Int?
    let pin: Bool?
    let livePlatforms: [String]?
    let videoType: String?
    let simulcast: String?
    let streamingURL, shortVideoURL: String?
    let userID: String?
    let title: String?
    let slotStatus: String?
    let slug, userName, brandName, city: String?
    let brandID: String?
    let thumbnail: String?
    let description, storeSlug, fileID: String?
    
    let createdAt, updatedAt: String?
    let v: Int?
    let mbrURL: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case yt
        case productsID = "productsId"
        case totalViews, liveViews, fbViews, suspension, featured
        case updatedURL = "updatedUrl"
        case categories
        case fbID = "fbId"
        case service, duration, fbTotalViews, pin, livePlatforms, videoType, simulcast
        case streamingURL = "streamingUrl"
        case shortVideoURL = "shortVideoUrl"
        case userID = "userId"
        case title, slotStatus, slug, userName, brandName, city
        case brandID = "brandId"
        case thumbnail, description, storeSlug
        case fileID = "fileId"
        case  createdAt, updatedAt
        case v = "__v"
        case mbrURL = "mbrUrl"
    }
}




// MARK: - Yt
struct RecordYt: Codable {
    let views: Int?
}

// MARK: - Result
struct LiveStreamingResults: Codable {
    let id: String?
    let productsID: [String]?
    let featured: Bool?
    let categories: [String]?
    let duration: Double?
    let pin: Bool?
    let videoType: String?
    let streamingURL: String?
    let userID: String?
    let title: String?
    let slotStatus: String?
    let slug, brandName, brandID: String?
    let thumbnail: String?
    let description: String?
    var liveViews, totalViews, like: Int?
    let resultID: String?
    let mbrURL: String?
    let hls: String?
    let brandLogo: String?
    let lang: languagesModel?

    enum CodingKeys: String, CodingKey {
        case id = "_=]id"
        case productsID = "productsId"
        case featured, categories, duration, pin, videoType,lang
        case streamingURL = "streamingUrl"
        case userID = "userId"
        case title, slotStatus, slug, brandName
        case brandID = "brandId"
        case thumbnail, description, liveViews, totalViews, like,hls,brandLogo
        case resultID = "id"
        case mbrURL = "mbrUrl"
    }
}

// MARK: - ReportDataModel
struct ReportDataModel: Codable {
    let status: Int?
    let isSuccess: Bool?
    let data: ReportDataClass?
    let message: String?
}

// MARK: - DataClass
struct ReportDataClass: Codable {
    let userID, videoID, comment, createdAt: String?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case videoID = "videoId"
        case comment, createdAt, id
    }
}


struct Savelikedata: Codable {
    let data: SavelikeDataClass?
    let status: Int?
    let message: String?
}


    struct SavelikeDataClass: Codable {
        let platform, id, userID, scheduleID: String?
        let createdAt, updatedAt: String?
        let v, likeCount: Int?
        let deleteLike: Bool?

        enum CodingKeys: String, CodingKey {
            case platform
            case id = "_id"
            case userID = "userId"
            case scheduleID = "scheduleId"
            case createdAt, updatedAt
            case v = "__v"
            case likeCount, deleteLike
        }
    }


struct GetLikeData: Codable {
    let data: GetLikeDataClass?
    let status: Int?
    let message: String?
}

// MARK: - DataClass
struct GetLikeDataClass: Codable {
    let platform, userID, scheduleID, createdAt: String?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case platform
        case userID = "userId"
        case scheduleID = "scheduleId"
        case createdAt, id
    }
}


// MARK: - LiveVideoResponse
struct LiveVideoResponse: Codable {
    let hashes: Hashes?
    let productsID: [String]?
    let totalViews, liveViews, fbViews: Int?
    let suspension: String?
    let featured, updatedURL: Bool?
    let categories: [String]?
    let fbID: String?
    let service: String?
    let duration, fbTotalViews: Int?
    let pin: Bool?
    let livePlatforms: [String]?
    let videoType: String?
    let socialPlatforms: [String]?
    let simulcast, title, userID, description: String?
    let slug: String?
    let thumbnail: String?
    let userName, brandName, brandID, scheduleID: String?
    let slotStatus, createdAt: String?
    let hls: String?
    let like: Int?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case hashes
        case productsID = "productsId"
        case totalViews, liveViews, fbViews, suspension, featured
        case updatedURL = "updatedUrl"
        case categories
        case fbID = "fbId"
        case service, duration, fbTotalViews, pin, livePlatforms, videoType, socialPlatforms, simulcast, title
        case userID = "userId"
        case description, slug, thumbnail, userName, brandName
        case brandID = "brandId"
        case scheduleID = "scheduleId"
        case slotStatus, createdAt, hls, like, id
    }
}

// MARK: - Hashes
struct Hashes: Codable {
    let liveHash, playHash: String?
}



//// MARK: - Result
//struct LiveStreamingResults: Codable {
//    let id: String?
//    let productsID: [String]?
//    let featured: Bool?
//    let categories: [String]?
//    let duration: Double?
//    let pin: Bool?
//    let videoType: String?
//    let streamingURL: String?
//    let userID: String?
//    let title: String?
//    let slotStatus: String?
//    let slug: String?
//    let brandName: String?
//    let brandID: String?
//    let thumbnail: String?
//    let description: String?
//    let mbrURL: String?
//    let liveViews, totalViews, like: Int?
//    let resultID: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id = "_id"
//        case productsID = "productsId"
//        case featured, categories, duration, pin, videoType
//        case streamingURL = "streamingUrl"
//        case userID = "userId"
//        case title, slotStatus, slug, brandName
//        case brandID = "brandId"
//        case thumbnail, description
//        case mbrURL = "mbrUrl"
//        case liveViews, totalViews, like
//        case resultID = "id"
//    }
//}




struct ShopChinaStreaminVideoDataModel: Codable {
    let page, totalPages, limit, totalResults: Int?
    let results, featured: [LiveStreamingResults]?
}





// MARK: - DataClass
struct ProvinceDataModel: Codable {
    let countryname: String?
    let provinces: [Province]?
}

// MARK: - Province
struct Province: Codable {
    let province: String?
    let cities: [City]?
}

// MARK: - City
struct City: Codable {
    let city: String?
    let areas: [String]?
}
