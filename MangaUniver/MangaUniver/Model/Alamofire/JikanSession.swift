//
//  JikanSession.swift
//  MangaUniver
//
//  Created by ayite on 09/07/2021.
//

import Foundation
import Alamofire

protocol AlamofireSession {
    func request(url: URL, callback: @escaping (AFDataResponse<Any>) -> Void)
}

final class RequestSession: AlamofireSession {
    func request(url: URL, callback: @escaping (AFDataResponse<Any>) -> Void) {
        AF.request(url).responseJSON { dataResponse in
            callback(dataResponse)
        }
    }
}
