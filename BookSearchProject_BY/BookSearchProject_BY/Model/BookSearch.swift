//
//  SearchViewModel.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/12/25.
//

struct BookResponse: Decodable {
    let meta: Meta
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
    let authors: [String]
    let price: Int
    let thumbnail: String?
    let contents: String?
}

// CoreData → Book 변환을 위한 이니셜라이저 추가
extension Book {
    init(savedBook: SavedBook) {
        self.title = savedBook.title ?? ""
        self.authors = [savedBook.author ?? ""]
        self.price = Int(savedBook.price)
        self.thumbnail = nil
        self.contents = nil
    }
}
