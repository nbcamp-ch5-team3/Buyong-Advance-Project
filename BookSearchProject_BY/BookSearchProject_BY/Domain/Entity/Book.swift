//
//  Book.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/16/25.
//

/// 책 정보를 나타내는 구조체 모델
struct Book: Decodable {
    let title: String
    let authors: [String]
    let price: Int
    let thumbnail: String?
    let contents: String?
}

// MARK: - CoreData Conversion
/// CoreData의 SavedBook 엔티티로부터 Book 인스턴스를 생성하는 이니셜라이저
extension Book {
    init(savedBook: SavedBook) {
        self.title = savedBook.title ?? ""
        self.authors = [savedBook.author ?? ""]
        self.price = Int(savedBook.price)
        self.thumbnail = savedBook.thumbnailImage
        self.contents = savedBook.contents
    }
}

// MARK: - RecentBook Conversion
/// CoreData의 RecentBook 엔티티로부터 Book 인스턴스를 생성하는 이니셜라이저
extension Book {
    init(recentBook: RecentBook) {
        self.title = recentBook.title ?? ""
        self.authors = (recentBook.authors ?? "").components(separatedBy: ",")
        self.price = Int(recentBook.price)
        self.thumbnail = recentBook.thumbnailImage
        self.contents = recentBook.contents
    }
}
