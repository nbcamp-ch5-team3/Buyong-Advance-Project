//
//  RecentBooksUseCase.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/16/25.
//

protocol RecentBooksUseCase {
    func fetchRecentBooks() -> [RecentBook]
    func saveRecentBook(_ book: Book)
    func moveRecentBookToFront(thumbnail: String)
}
