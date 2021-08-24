//
//  MangaToPopularity.swift
//  MangaUniver
//
//  Created by ayite on 09/07/2021.
//

import Foundation

// MARK: - MangaTopPopularity

struct MangaTopPopularity: Decodable {
    let requestHash: String
    let requestCached: Bool
    let requestCacheExpiry: Int
    let top: [Top]

    enum CodingKeys: String, CodingKey {
        case requestHash = "request_hash"
        case requestCached = "request_cached"
        case requestCacheExpiry = "request_cache_expiry"
        case top
    }
}

// MARK: - Top

struct Top: Decodable {
    let malID, rank: Int
    let title: String
    let url: String
    let type: TypeEnum
    let volumes: Int?
    let startDate: String
    let endDate: String?
    let members: Int
    let score: Double
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case malID = "mal_id"
        case rank, title, url, type, volumes
        case startDate = "start_date"
        case endDate = "end_date"
        case members, score
        case imageURL = "image_url"
    }
}

enum TypeEnum: String, Decodable {
    case manga = "Manga"
    case manhwa = "Manhwa"
}
