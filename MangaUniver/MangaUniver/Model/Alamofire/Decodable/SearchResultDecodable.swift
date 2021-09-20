//
//  SearchResultDecodable.swift
//  MangaUniver
//
//  Created by ayite on 20/09/2021.
//

import Foundation

// MARK: - Welcome
struct SearchResult: Decodable {
    let results: [Results]
    let lastPage: Int

    enum CodingKeys: String, CodingKey {
        case results
        case lastPage = "last_page"
    }
}

// MARK: - Result
struct Results: Decodable {
    let malID: Int
    let url: String
    let imageURL: String
    let title: String
    let publishing: Bool
    let synopsis, type: String
    let chapters, volumes: Int
    let score: Double
    let startDate: String
    let endDate: String?
    let members: Int

    enum CodingKeys: String, CodingKey {
        case malID = "mal_id"
        case url
        case imageURL = "image_url"
        case title, publishing, synopsis, type, chapters, volumes, score
        case startDate = "start_date"
        case endDate = "end_date"
        case members
    }
}
