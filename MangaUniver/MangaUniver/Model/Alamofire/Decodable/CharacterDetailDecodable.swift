//
//  CharacterDetailDecodable.swift
//  MangaUniver
//
//  Created by ayite on 19/09/2021.
//

import Foundation

// MARK: - CharacterDetails

struct CharacterDetails: Decodable {
    let requestHash: String
    let requestCached: Bool
    let requestCacheExpiry, malID: Int
    let url: String
    let name, nameKanji: String
    let about: String
    let memberFavorites: Int
    let imageURL: String
    let animeography, mangaography, voiceActors: [Animeography]

    enum CodingKeys: String, CodingKey {
        case requestHash = "request_hash"
        case requestCached = "request_cached"
        case requestCacheExpiry = "request_cache_expiry"
        case malID = "mal_id"
        case url, name
        case nameKanji = "name_kanji"
        case about
        case memberFavorites = "member_favorites"
        case imageURL = "image_url"
        case animeography, mangaography
        case voiceActors = "voice_actors"
    }
}

// MARK: - Animeography

struct Animeography: Decodable {
    let malID: Int
    let name: String
    let url: String
    let imageURL: String
    let role: CharacterRole?
    let language: String?

    enum CodingKeys: String, CodingKey {
        case malID = "mal_id"
        case name, url
        case imageURL = "image_url"
        case role, language
    }
}

enum CharacterRole: String, Codable {
    case main = "Main"
    case supporting = "Supporting"
}


