//
//  SearchViewModel.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/12/25.
//

struct BookResponse: Decodable {
    let mata: Meta
    let documents: [Book]
}

struct Meta: Decodable {
    let isEnd: Bool
    let totalCount: Int
    let pageableCount: Int
    
    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
        case totalCount = "total_count"
        case pageableCount = "pageable_count"
    }
}

struct Book: Decodable {
    let title: String
    let author: [String]
    let price: Int
    let thumbnail: String?
    let contents: String?
}
