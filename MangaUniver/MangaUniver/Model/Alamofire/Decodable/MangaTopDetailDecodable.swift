//
//  MangaTopDetail.swift
//  MangaUniver
//
//  Created by ayite on 16/08/2021.
//

import Foundation

// MARK: - MangaTopDetail
struct MangaTopDetail: Decodable {
    let requestHash: String?
    let requestCached: Bool?
    let requestCacheExpiry: Int?
    let malid: Int?
    let url: String?
    let title: String?
    let titleEnglish: String?
    let titleSynonyms: [String]?
    let titleJapanese: String?
    let status: String?
    let imageurl: String?
    let type: String?
    let volumes: Int?
    let chapters: Int?
    let publishing: Bool?
    let published: Published?
    let rank: Int?
    let score: Double?
    let scoredBy: Int?
    let popularity: Int?
    let members: Int?
    let favorites: Int?
    let synopsis: String?
    let background: String?
    let related: Related?
    let genres: [Author]?
    let authors: [Author]?
    let serializations: [Author]?

    enum CodingKeys: String, CodingKey {
        case requestHash = "request_hash"
        case requestCached = "request_cached"
        case requestCacheExpiry = "request_cache_expiry"
        case malid = "mal_id"
        case url
        case title
        case titleEnglish = "title_english"
        case titleSynonyms
        case titleJapanese = "title_japanese"
        case status
        case imageurl = "image_url"
        case type
        case volumes
        case chapters
        case publishing
        case published
        case rank
        case score
        case scoredBy = "scored_by"
        case popularity
        case members
        case favorites
        case synopsis
        case background
        case related
        case genres
        case authors
        case serializations
    }
}

// MARK: - Author
struct Author: Decodable {
    let malid: Int?
    let type: String?
    let name: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case malid = "mal_id"
        case type
        case name
        case url
    }
}

// MARK: - Published
struct Published: Decodable {
    let from: String?
    let to: String?
    let prop: Prop?
    let string: String?

    enum CodingKeys: String, CodingKey {
        case from
        case to
        case prop
        case string
    }
}

// MARK: - Prop
struct Prop: Decodable {
    let from: From?
    let to: From?

    enum CodingKeys: String, CodingKey {
        case from
        case to
    }
}

// MARK: - From
struct From: Decodable {
    let day: Int?
    let month: Int?
    let year: Int?

    enum CodingKeys: String, CodingKey {
        case day
        case month
        case year
    }
}

// MARK: - Related
struct Related: Decodable {
    let alternativeVersion: [Author]?
    let other: [Author]?
    let adaptation: [Author]?
    let spinOff: [Author]?

    enum CodingKeys: String, CodingKey {
        case alternativeVersion = "Alternative version"
        case other = "Other"
        case adaptation = "Adaptation"
        case spinOff = "Spin-off"
    }
}
