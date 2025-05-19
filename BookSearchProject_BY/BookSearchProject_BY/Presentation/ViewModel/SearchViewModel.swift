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
    
    /// Rx Subject (검색된 책 리스트 방출, 에러 방출, 최근 본 책 리스트 방출)
    let books = BehaviorSubject(value: [Book]())
    let error = PublishSubject<Error>()
    let recentBooks = BehaviorSubject(value: [RecentBook]())
    
    // MARK: - Initialization
    init() {
        let searchRepository = SearchBooksRepositoryImpl()
        let recentBooksRepository = RecentBooksRepositoryImpl()
        
        self.searchUseCase = SearchBooksUseCase(repository: searchRepository)
        self.recentBooksUseCase = RecentBooksUseCase(repository: recentBooksRepository)
    }
    
    // MARK: - Search Methods
    /// 책 검색을 실행하는 메서드
    /// - Parameters:query: 검색할 키워드,page: 검색할 페이지 번호 (기본값: 1), isLoadMore: 추가 로딩 여부
    func fetchBooks(query: String, page: Int = 1, isLoadMore: Bool = false) {
        // 새 검색이면 기존 데이터 초기화
        if !isLoadMore {
            books.onNext([])
        }
        
        // 실제 책 검색 실행
        searchUseCase.execute(query: query, page: page)
            .subscribe(onSuccess: { [weak self] newBooks in
                if isLoadMore {
                    // 추가 로딩이면 기존 데이터에 append
                    let prev = (try? self?.books.value()) ?? []
                    self?.books.onNext(prev + newBooks)
                } else {
                    // 새 검색이면 결과 덮어쓰기
                    self?.books.onNext(newBooks)
                }
            }, onFailure: { [weak self] error in
                // 에러 발생 시 error Subject에 전달
                self?.error.onNext(error)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Recent Books Methods
    /// 최근 본 책 리스트 불러오기
    func fetchRecentBooks() {
        let books = recentBooksUseCase.fetchRecentBooks()
        recentBooks.onNext(books)
    }
    
    /// 최근 본 책 저장
    func saveRecentBook(_ book: Book) {
        recentBooksUseCase.saveRecentBook(book)
    }
    
    /// 특정 썸네일의 최근 본 책을 리스트 맨 앞으로 이동
    func moveRecentBookToFront(thumbnail: String) {
        recentBooksUseCase.moveRecentBookToFront(thumbnail: thumbnail)
    }
    
    /// 검색 취소
    func cancelSearch() {
        searchUseCase.cancelSearch()
    }
    
    /// 썸네일로 최근 본 책 존재 여부 확인
    func isBookExists(thumbnail: String) -> Bool {
        return recentBooksUseCase.isBookExists(thumbnail: thumbnail)
    }

    // MARK: - Pagination
    /// 무한 스크롤 등에서 추가 데이터 로딩 필요 시 호출
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
    /// 현재 로딩 중인지 반환
    var isLoading: Bool {
        return searchUseCase.currentState.isLoading
    }
    
    /// 더 이상 불러올 데이터가 없는지 반환
    var isEnd: Bool {
        return searchUseCase.currentState.isEnd
    }
    
    /// 현재 페이지 반환
    var currentPage: Int {
        return searchUseCase.currentState.currentPage
    }
}
