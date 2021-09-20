//
//  JikanService.swift
//  MangaUniver
//
//  Created by ayite on 09/07/2021.
//

import Foundation
import Alamofire

final class JikanService {

    // MARK: - Properties
    
    var urlR = "https://api.jikan.moe/v3"
    private let session: AlamofireSession

    // MARK: - Initializer

    init(session: AlamofireSession = RequestSession()) {
        self.session = session
    }

    // MARK: - Methodes
    
    func getCategoryManga(category: String?, path: String?, callback: @escaping (Result< ListCategoryManga, NetworkError>) -> Void) {
         var urlBase = urlR

        if let path = path {
            urlBase = "\(urlBase)\(path)"
        }
        if let gender = category {
            urlBase = "\(urlBase)\(gender)"
        }
        guard let url = URL(string: urlBase) else { return }
        getMangaData(baseUrl: url, parameters: nil, callback: callback)
        
    }
    
    func getMangaTopPopularity(callback: @escaping (Result< MangaTopPopularity, NetworkError>) -> Void) {
        guard let url = URL(string: "https://api.jikan.moe/v3/top/manga/1/bypopularity") else { return }
        getMangaData(baseUrl: url, parameters: nil, callback: callback)
    }
    
    func getMangaTopPopularityDetail(idOfTheManga: String?, callback: @escaping (Result< MangaTopDetail, NetworkError>) -> Void) {
        let urlStr = "https://api.jikan.moe/v3/manga/\(idOfTheManga ?? "")"
        guard let url = URL(string: urlStr) else { return }
        getMangaData(baseUrl: url, parameters: nil , callback: callback)
    }
    
    func getCharactersManga(idOfTheManga: String?, callback: @escaping (Result<Characters, NetworkError>) -> Void) {
        let urlStr = "https://api.jikan.moe/v3/manga/\(idOfTheManga ?? "")/characters"
        guard let url = URL(string: urlStr) else { return }
        getMangaData(baseUrl: url, parameters: nil , callback: callback)
    }
    
    func getCharacterDetailManga(idOfTheCharacter: String?, callback: @escaping (Result<CharacterDetails, NetworkError>) -> Void) {
        let urlStr = "https://api.jikan.moe/v3/character/\(idOfTheCharacter ?? "")"
        guard let url = URL(string: urlStr) else { return }
        getMangaData(baseUrl: url, parameters: nil , callback: callback)
    }
    
    func getSearchResultManga(str: String, callback: @escaping (Result<SearchResult, NetworkError>) -> Void) {
        let urlStr = "https://api.jikan.moe/v3/search/manga"
        guard let url = URL(string: urlStr) else { return }
        let parameters = [("q", str)]
        getMangaData(baseUrl: url, parameters: parameters , callback: callback)
    }

    func getMangaData<T: Decodable>(baseUrl: URL, parameters: [(String, Any)]?, callback: @escaping (Result<T, NetworkError>) -> Void) {
        let urlRequest = encode(baseUrl: baseUrl, with: parameters)
        Logger(url: urlRequest).show()
        
        session.request(url: urlRequest) { dataResponse in
            
            guard let data = dataResponse.data else {
                callback(.failure(.noData))
                return
            }
            
            guard dataResponse.response?.statusCode == 200 && dataResponse.error == nil else {
                callback(.failure(.noResponse))
                return
            }
            guard let dataDecoded = try? JSONDecoder().decode(T.self, from: data) else {
                callback(.failure(.undecodableData))
                return
            }
            callback(.success(dataDecoded))
        }
    }
    
    private func encode(baseUrl: URL, with parameters: [(String, Any)]?) -> URL {
        guard var urlComponents = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false), let parameters = parameters, !parameters.isEmpty else { return baseUrl }
        
        urlComponents.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            urlComponents.queryItems?.append(queryItem)
        }
        guard let url = urlComponents.url else { return baseUrl }
        return url
    }
}
