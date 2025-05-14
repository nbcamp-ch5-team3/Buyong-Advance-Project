//
//  SearchSection.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/14/25.
//

enum SearchSection: Int, CaseIterable {
    case recentBooks
    case searchResults
    
    var title: String {
        switch self {
        case .recentBooks: return "최근 본 책"
        case .searchResults: return "검색 결과"
        }
    }
}
