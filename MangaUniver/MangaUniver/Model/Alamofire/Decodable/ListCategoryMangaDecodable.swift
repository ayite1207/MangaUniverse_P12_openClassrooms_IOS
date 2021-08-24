//
//  MangaSamourai.swift
//  MangaUniver
//
//  Created by ayite on 21/07/2021.

import Foundation

// MARK: - Welcome
struct ListCategoryManga: Decodable {
    let requestHash: String
    let requestCached: Bool
    let malUrl: Malurl
    let itemCount: Int
    let manga: [Manga]

    enum CodingKeys: String, CodingKey {
        case requestHash = "request_hash"
        case requestCached = "request_cached"
        case malUrl = "mal_url"
        case itemCount = "item_count"
        case manga
    }
}

// MARK: - Malurl
struct Malurl: Decodable {
    let malId: Int
    let type: String
    let name: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case malId = "mal_id"
        case type
        case name
        case url
    }
}

// MARK: - Manga
struct Manga: Decodable {
    let malId: Int
    let url: String
    let title: String
    let imageUrl: String
    let synopsis: String
    let type: String
    let publishingStart: String?
    let volumes: Int?
    let members: Int
    let genres: [Malurl]
    let authors: [Malurl]
    let score: Double?
    let serialization: [String]

    enum CodingKeys: String, CodingKey {
        case malId = "mal_id"
        case url
        case title
        case imageUrl = "image_url"
        case synopsis
        case type
        case publishingStart = "publishing_start"
        case volumes
        case members
        case genres
        case authors
        case score
        case serialization
    }
}
