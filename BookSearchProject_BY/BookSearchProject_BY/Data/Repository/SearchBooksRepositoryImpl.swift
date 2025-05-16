//
//  DefaultSearchRepository.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/16/25.
//

import RxSwift
import Alamofire

/// 네트워크 요청을 처리하는 싱글톤 매니저
final class SearchBooksRepositoryImpl: SearchRepository {
    private var networkManager: NetworkManaging
    private let apiKey: String
    
    init(networkManager: NetworkManaging = NetworkManager.shared,
         apiKey: String = "fd377cd5d584a8c6f60b855dae5e5509") {
        self.networkManager = networkManager
        self.apiKey = apiKey
    }
    
    func searchBooks(query: String, page: Int) -> Single<BookResponse> {
        guard let queryEncoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return .error(NetworkError.invalidUrl)
        }
        
        let url = "https://dapi.kakao.com/v3/search/book?query=\(queryEncoded)&page=\(page)"
        let headers: HTTPHeaders = ["Authorization": "KakaoAK \(apiKey)"]
        
        cancelSearch() // 이전 검색 취소
        
        return networkManager.fetch(url: url, headers: headers)
    }
    
    func cancelSearch() {
        networkManager.currentDataTask?.cancel()
        networkManager.currentDataTask = nil
    }
    
    func isSearching() -> Bool {
        return networkManager.currentDataTask != nil
    }
}
