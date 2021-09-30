//
//  FakeResponseData.swift
//  MangaUniverTests
//
//  Created by ayite on 04/09/2021.
//

import Foundation

final class FakeResponseData {
    static let responseOK = HTTPURLResponse(url: URL(string: "https://api.edamam.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    static let responseKO = HTTPURLResponse(url: URL(string: "https://api.edamam.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)!
    
    class NetworkError: Error {}
    static let networkError = NetworkError()
    
    static var correctData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "CategoryManga", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    
    static var characterData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "CharacterManga", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    
    static var topMangaDetailData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "TopMangaDetail", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    
    static var charactersData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "CharactersManga", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    
    static var resultsData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "SearchResult", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    
    static var topMangaPopularityData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "MangaTopPopularity", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    
    static var samouraiMangaData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "SamouraiManga", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    
    static var parodyMangaData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "ParodyManga", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    
    static var PsychologicaData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "PsychologicalManga", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    
    static let incorrectData = "erreur".data(using: .utf8)!
}
