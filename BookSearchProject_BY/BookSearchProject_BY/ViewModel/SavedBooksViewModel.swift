//
//  SavedBooksViewModel.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/16/25.
//

import Foundation
import RxSwift
import RxRelay

final class SavedBooksViewModel {
    // MARK: - Properties
    private let useCase: SavedBookUseCase
    private let disposeBag = DisposeBag()
    
    // Output
    let books = BehaviorRelay<[Book]>(value: [])
    let showError = PublishRelay<String>()
    
    // MARK: - Initialization
    init(useCase: SavedBookUseCase = SavedBookUseCase(repository: SavedBookRepositoryImpl())) {
        self.useCase = useCase
    }
    
    // MARK: - Public Methods
    func fetchBooks() {
        let savedBooks = useCase.fetchBooks()
        let mappedBooks = savedBooks.map { Book(savedBook: $0) }
        books.accept(mappedBooks)
    }
    
    func deleteBook(at index: Int) {
        guard let savedBook = useCase.fetchBooks()[safe: index] else { return }
        useCase.deleteBook(savedBook)
        fetchBooks()
    }
    
    func deleteAllBooks() {
        useCase.deleteAllBooks()
        books.accept([])
    }
}
