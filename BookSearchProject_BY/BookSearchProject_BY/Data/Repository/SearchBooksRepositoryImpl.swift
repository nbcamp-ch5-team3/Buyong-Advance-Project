//
//  DefaultSearchRepository.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/16/25.
//

import RxSwift
import Alamofire

// MARK: - 책 검색 저장소 구현체(네트워크 요청을 처리하는 싱글톤 매니저)
final class SearchBooksRepositoryImpl: SearchRepository {
    private var networkManager: NetworkManaging
    private let apiKey: String
    
    /// 저장소 생성 시 네트워크 매니저와 API 키를 주입받는 생성자
    init(networkManager: NetworkManaging = NetworkManager.shared,
         apiKey: String = "fd377cd5d584a8c6f60b855dae5e5509") {
        self.networkManager = networkManager
        self.apiKey = apiKey
    }
    
    /// 검색어와 페이지로 책을 검색하는 네트워크 요청 함수
    func searchBooks(query: String, page: Int) -> Single<BookResponse> {
        guard let queryEncoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return .error(NetworkError.invalidUrl)
        }
        
        let url = "https://dapi.kakao.com/v3/search/book?query=\(queryEncoded)&page=\(page)"
        let headers: HTTPHeaders = ["Authorization": "KakaoAK \(apiKey)"]
        
        cancelSearch() // 이전 검색 취소
        
        return networkManager.fetch(url: url, headers: headers)
    }
    
    /// 현재 진행 중인 검색 네트워크 요청을 취소하는 함수
    func cancelSearch() {
        networkManager.currentDataTask?.cancel()
        networkManager.currentDataTask = nil
    }
    
    /// 현재 검색 중인지 여부를 반환하는 함수
    func isSearching() -> Bool {
        return networkManager.currentDataTask != nil
    }
}
