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
    private let searchUseCase: SearchBooksUseCase
    private let recentBooksUseCase: RecentBooksUseCase
    
    let books = BehaviorSubject(value: [Book]())
    let error = PublishSubject<Error>()
    let recentBooks = BehaviorSubject(value: [RecentBook]())
    
    // MARK: - Initialization
    init(searchUseCase: SearchBooksUseCase, recentBooksUseCase: RecentBooksUseCase) {
        self.searchUseCase = searchUseCase
        self.recentBooksUseCase = recentBooksUseCase
    }
    
    // MARK: - Search Methods
    /// 책 검색을 실행하는 메서드
    /// - Parameters:query: 검색할 키워드, page: 검색할 페이지 번호 (기본값: 1), isLoadMore: 추가 로딩 여부
    func fetchBooks(query: String, page: Int = 1, isLoadMore: Bool = false) {
        // 새 검색이면 상태 초기화
        if !isLoadMore {
            books.onNext([])
        }
        
        searchUseCase.execute(query: query, page: page)
            .subscribe(onSuccess: { [weak self] newBooks in
                if isLoadMore {
                    // 기존 데이터에 append
                    let prev = (try? self?.books.value()) ?? []
                    self?.books.onNext(prev + newBooks)
                } else {
                    // 새 검색이면 덮어쓰기
                    self?.books.onNext(newBooks)
                }
            }, onFailure: { [weak self] error in
                self?.error.onNext(error)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Recent Books Methods
    func fetchRecentBooks() {
        let books = recentBooksUseCase.fetchRecentBooks()
        recentBooks.onNext(books)
    }
    
    func saveRecentBook(_ book: Book) {
        recentBooksUseCase.saveRecentBook(book)
    }
    
    func moveRecentBookToFront(thumbnail: String) {
        recentBooksUseCase.moveRecentBookToFront(thumbnail: thumbnail)
    }
    
    func cancelSearch() {
        searchUseCase.cancelSearch()
    }
    
    func isBookExists(thumbnail: String) -> Bool {
        return recentBooksUseCase.isBookExists(thumbnail: thumbnail)
    }

    // MARK: - Pagination
    func loadMoreBooksIfNeeded() {
        guard !searchUseCase.currentState.isEnd,
              !searchUseCase.currentState.isLoading,
              !searchUseCase.currentState.lastQuery.isEmpty else { return }
        
        fetchBooks(
            query: searchUseCase.currentState.lastQuery,
            page: searchUseCase.currentState.currentPage + 1,
            isLoadMore: true
        )
    }
    
    // MARK: - State Accessors
    var isLoading: Bool {
        return searchUseCase.currentState.isLoading
    }
    
    var isEnd: Bool {
        return searchUseCase.currentState.isEnd
    }
    
    var currentPage: Int {
        return searchUseCase.currentState.currentPage
    }
}
