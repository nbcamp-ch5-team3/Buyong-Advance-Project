//
//  SavedBookUseCase.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/16/25.
//

final class SavedBookUseCase {
    private let repository: SavedBookRepository
    
    init(repository: SavedBookRepository) {
        self.repository = repository
    }
    
    func saveBook(title: String, author: String, price: Int64, thumbnail: String?, contents: String?) -> Bool {
        return repository.saveBook(title: title, author: author, price: price, thumbnail: thumbnail, contents: contents)
    }
    
    func fetchBooks() -> [SavedBook] {
        return repository.fetchBooks()
    }
    
    func deleteBook(_ book: SavedBook) {
        repository.deleteBook(book)
    }
    
    func deleteAllBooks() {
        repository.deleteAllBooks()
    }
}
