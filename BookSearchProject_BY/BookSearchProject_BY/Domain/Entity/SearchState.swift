//
//  SearchState.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/16/25.
//

import Foundation

struct SearchState {
    var currentPage: Int
    var isEnd: Bool
    var isLoading: Bool
    var lastQuery: String
    
    static var initial: SearchState {
        return SearchState(currentPage: 1, isEnd: false, isLoading: false, lastQuery: "")
    }
}
