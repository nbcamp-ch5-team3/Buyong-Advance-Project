//
//  DefaultRecentBooksRepository.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/16/25.
//

final class DefaultRecentBooksRepository: RecentBooksRepository {
    private let manager: RecentBookManager
    
    init(manager: RecentBookManager = .shared) {
        self.manager = manager
    }
    
    func fetchAllBooks() -> [RecentBook] {
        return manager.fetchAllBooks()
    }
    
    func saveBook(_ book: Book) {
        manager.saveRecentBook(book: book)
    }
    
    func moveToFront(thumbnail: String) {
        if let book = manager.fetchBook(thumbnail: thumbnail) {
            manager.moveRecentBookToFront(recentBook: book)
        }
    }
}
