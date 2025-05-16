//
//  SearchSection.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/14/25.
//

/// 검색 화면의 섹션을 정의하는 열거형
enum SearchSection: Int, CaseIterable {
    case recentBooks
    case searchResults
    
    /// 각 섹션의 표시 제목
    var title: String {
        switch self {
        case .recentBooks: return "최근 본 책"
        case .searchResults: return "검색 결과"
        }
    }
}
