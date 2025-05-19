//
//  SearchState.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/16/25.
//

import Foundation

/// 책 검색 상태를 관리하는 구조체
struct SearchState {
    var currentPage: Int
    var isEnd: Bool
    var isLoading: Bool
    var lastQuery: String
    
    /// 초기 상태를 반환하는 정적 프로퍼티
    static var initial: SearchState {
        return SearchState(currentPage: 1, isEnd: false, isLoading: false, lastQuery: "")
    }
}
