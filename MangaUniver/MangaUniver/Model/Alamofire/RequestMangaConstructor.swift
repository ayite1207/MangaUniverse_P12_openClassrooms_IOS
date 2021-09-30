//
//  requestMangaManager.swift
//  MangaUniver
//
//  Created by ayite on 25/07/2021.
//

import Foundation


enum RequestMangaConstructor {
    case samouraiManga
    case parodyManga
    case psychologicalManga
    
    var mangaCategory : String {
        switch self {
        case .samouraiManga:
            return "samouraiManga"
        case .parodyManga:
            return "parodyManga"
        case .psychologicalManga:
            return "psychologicalManga"
        }
    }
    
    var path : String {
        switch self {
        case .samouraiManga, .parodyManga, .psychologicalManga:
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
        }
    }
    
}
