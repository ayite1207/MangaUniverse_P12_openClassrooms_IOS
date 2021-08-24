//
//  NetWorkError.swift
//  MangaUniver
//
//  Created by ayite on 09/07/2021.
//

import Foundation

enum NetworkError: Error {

    // MARK: - Cases
    
    case noData
    case noResponse
    case undecodableData
    
    // MARK: - Properties
    
    var description : String {
        switch self {
        case .noData :
            return "There is no data !"
        case .noResponse :
            return "The response is not correct !"
        case .undecodableData :
           return "Data can't be decoded !"
        }
    }
}
