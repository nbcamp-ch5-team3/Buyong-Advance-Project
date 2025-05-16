//
//  SearchViewModel.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/12/25.
//

import Alamofire
import RxSwift

final class SearchViewModel {
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let apiKey = "fd377cd5d584a8c6f60b855dae5e5509"
    
    let books = BehaviorSubject(value: [Book]())
    let error = PublishSubject<Error>()
    
    // MARK: - Pagination Properties (무한 스크롤 구현을 위한 변수)
    /// 현재 페이지 번호, 마지막 페이지 여부, 로딩 상태, 마지막 검색어
    private(set) var currentPage = 1
    private(set) var isEnd = false
    private(set) var isLoading = false
    private var lastQuery = ""
    
    // MARK: - Recent Books
    let recentBooks = BehaviorSubject(value: [RecentBook]())
    
    // MARK: - Search Methods
    /// - Parameters: - query: 검색어, page: 페이지 번호 (기본값: 1), isLoadMore: 추가 로딩 여부
    func fetchBooks(query: String, page: Int = 1, isLoadMore: Bool = false) {
        // 새 검색이면 상태 초기화
        if !isLoadMore {
            currentPage = 1
            isEnd = false
            lastQuery = query
        }
        // 로딩 중이면 중복 요청 방지
        guard !isLoading else { return }
        isLoading = true
        
        // 검색어를 URL에 쓸 수 있도록 인코딩 (한글도 가능하도록 안전하게)
        guard let queryEncoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            error.onNext(NetworkError.invalidUrl)
            isLoading = false
            return
        }
        
        // page 파라미터 추가(무한 스크롤)
        let url = "https://dapi.kakao.com/v3/search/book?query=\(queryEncoded)&page=\(page)"
        
        let headers: HTTPHeaders = [
            "Authorization": "KakaoAK \(apiKey)"
        ]
        
        NetworkManager.shared.fetch(url: url, headers: headers)
            .subscribe(onSuccess: { [weak self] (response: BookResponse) in
                self?.isLoading = false
                self?.isEnd = response.meta.isEnd
                
                // 성공적으로 불러 왔을 때만 페이지 증가, 새 검색은 1로 초기화
                if isLoadMore {
                    // 기존 데이터에 append
                    let prev = (try? self?.books.value()) ?? []
                    self?.books.onNext(prev + response.documents)
                    self?.currentPage += 1
                } else {
                    // 새 검색이면 덮어쓰기
                    self?.books.onNext(response.documents)
                    self?.currentPage = 1
                }
            }, onFailure: { [weak self] error in
                self?.isLoading = false
                self?.error.onNext(error)
            })
            .disposed(by: disposeBag)
    }
    
    // ===== 최근 본 책 읽기 =====
    func fetchRecentBooks() {
        let books = RecentBookManager.shared.fetchAllBooks()
        recentBooks.onNext(books)
    }
    
    // 무한 스크롤 트리거 함수 (마지막 페이지거나 로딩 중이면 무시)
    func loadMoreBooksIfNeeded() {
        guard !isEnd, !isLoading, !lastQuery.isEmpty else { return }
        fetchBooks(query: lastQuery, page: currentPage + 1, isLoadMore: true)
    }
}
