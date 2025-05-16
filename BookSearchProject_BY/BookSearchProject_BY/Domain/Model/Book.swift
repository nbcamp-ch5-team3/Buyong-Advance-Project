//
//  Book.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/16/25.
//

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
        self.thumbnail = savedBook.thumbnailImage
        self.contents = savedBook.contents
    }
}

extension Book {
    init(recentBook: RecentBook) {
        self.title = recentBook.title ?? ""
        self.authors = (recentBook.authors ?? "").components(separatedBy: ",")
        self.price = Int(recentBook.price)
        self.thumbnail = recentBook.thumbnailImage
        self.contents = recentBook.contents
    }
}
