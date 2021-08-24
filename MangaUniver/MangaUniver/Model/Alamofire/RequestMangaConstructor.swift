//
//  requestMangaManager.swift
//  MangaUniver
//
//  Created by ayite on 25/07/2021.
//

import Foundation


enum RequestMangaConstructor {
    case topManga
    case samouraiManga
    case parodyManga
    case psychologicalManga
    case martialArtManga
    
    var mangaCategory : String {
        switch self {
        case .samouraiManga:
            return "samouraiManga"
        case .parodyManga:
            return "parodyManga"
        case .psychologicalManga:
            return "psychologicalManga"
        case .martialArtManga:
            return "martialArtManga"
        case .topManga:
            return ""
        }
    }
    
    var path : String {
        switch self {
        case .topManga:
            return "/top/manga/1/bypopularity"
        case .samouraiManga, .parodyManga, .psychologicalManga, .martialArtManga:
            return "/genre/manga/"
        }
    }
    
    var mangaNumber:  String {
        switch self {
        case .samouraiManga:
            return "21"
        case .parodyManga:
            return "20"
        case .psychologicalManga:
            return "40"
        case .martialArtManga:
            return "17"
        case .topManga:
            return ""
        }
    }
    
}
