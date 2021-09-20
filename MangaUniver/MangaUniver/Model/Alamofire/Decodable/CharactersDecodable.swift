//
//  CharactersDecodable.swift
//  MangaUniver
//
//  Created by ayite on 14/09/2021.
//

import Foundation

// MARK: - Welcome
struct Characters: Decodable {
    let requestHash: String
    let requestCached: Bool
    let requestCacheExpiry: Int
    let characters: [Character]

    enum CodingKeys: String, CodingKey {
        case requestHash = "request_hash"
        case requestCached = "request_cached"
        case requestCacheExpiry = "request_cache_expiry"
        case characters
    }
}

// MARK: - Character
struct Character: Decodable {
    let malID: Int
    let url: String
    let imageURL: String
    let name: String
    let role: Role

    enum CodingKeys: String, CodingKey {
        case malID = "mal_id"
        case url
        case imageURL = "image_url"
        case name, role
    }
}

enum Role: String, Decodable {
    case main = "Main"
    case supporting = "Supporting"
}
