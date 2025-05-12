//
//  NetworkManager.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/12/25.
//

import Foundation
import Alamofire
import RxSwift

enum NetworkError: Error {
    case invalidUrl
    case dataFetchFail
    case decodingFail
}

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func fetch<T: Decodable>(url: String, headers: HTTPHeaders? = nil) -> Single<T> {
        return Single.create { observer in
            AF.request(url, headers: headers)
                .validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let value):
                        observer(.success(value))
                    case .failure(let error):
                        observer(.failure(error))
                    }
                }
            return Disposables.create()
        }
    }
}
