//
//  SearchBooksUseCase.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/16/25.
//
import RxSwift

import RxSwift

final class SearchBooksUseCase {
    /// 책 검색을 위한 레포지토리
    private let repository: SearchRepository
    /// 현재 검색 상태
    private var state: SearchState = .initial
    
    /// 레포지토리 의존성 주입을 위한 이니셜라이저
    init(repository: SearchRepository) {
        self.repository = repository
    }
    
    /// 책 검색 실행
    /// - Parameters: query: 검색어, page: 페이지 번호
    /// - Returns: 검색된 책 목록
    func execute(query: String, page: Int) -> Single<[Book]> {
        state.isLoading = true
        state.lastQuery = query
        state.currentPage = page
        
        return repository.searchBooks(query: query, page: page)
            .map { response in
                self.state.isEnd = response.meta.isEnd
                self.state.isLoading = false
                return response.documents
            }
    }
    
    /// 다음 페이지 로드
    func loadMore() {
        guard !state.isEnd,
              !state.isLoading,
              !state.lastQuery.isEmpty else { return }
        
        _ = execute(query: state.lastQuery, page: state.currentPage + 1)
    }
    
    /// 현재 검색 상태 반환
    var currentState: SearchState {
        return state
    }
    
    /// 검색을 취소하고 싶을 때 사용
    func cancelSearch() {
        repository.cancelSearch()
    }
}
