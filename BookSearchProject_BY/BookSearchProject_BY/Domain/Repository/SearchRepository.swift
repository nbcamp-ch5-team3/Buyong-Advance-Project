//
//  SearchRepository.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/16/25.
//

import RxSwift

//protocol SearchRepository {
//    func searchBooks(query: String, page: Int) -> Single<BookResponse>
//}


protocol SearchRepository {
    /// 카카오 책 검색 API를 통해 책을 검색하는 함수
    /// - Parameters:query: 검색어, page: 페이지 번호
    /// - Returns: Single 타입으로 래핑된 책 검색 응답 데이터
    func searchBooks(query: String, page: Int) -> Single<BookResponse>
    
    /// 검색 API 호출 취소
    func cancelSearch()
    
    /// 현재 검색이 진행 중인지 확인하는 함수
    /// - Returns: 검색 진행 여부를 Bool 값으로 반환
    func isSearching() -> Bool
}
