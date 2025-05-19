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
    /// UseCase 인스턴스
    private let useCase: SavedBookUseCase
    private let disposeBag = DisposeBag()
    
    // MARK: - Outputs (저장된 책 목록,  에러 메시지, 데이터 스트림(빈 상태 구분)
    let books = BehaviorRelay<[Book]>(value: [])
    let showError = PublishRelay<String>()
    var displayBooks: Observable<[BookCellType]> {
        books
            .map { books in
                books.isEmpty ? [.empty] : books.map { .normal($0) }
            }
    }
    
    // MARK: - Initialization
    /// 뷰모델 초기화
    init(useCase: SavedBookUseCase = SavedBookUseCase(repository: SavedBookRepositoryImpl())) {
        self.useCase = useCase
    }
    
    // MARK: - Public Methods
    /// 저장된 모든 책 불러오기
    func fetchBooks() {
        let savedBooks = useCase.fetchBooks()
        let mappedBooks = savedBooks.map { Book(savedBook: $0) }
        books.accept(mappedBooks)
    }
    
    /// 특정 인덱스의 책 삭제
    func deleteBook(at index: Int) {
        guard let savedBook = useCase.fetchBooks()[safe: index] else { return }
        useCase.deleteBook(savedBook)
        fetchBooks()
    }
    
    /// 저장된 모든 책 삭제
    func deleteAllBooks() {
        useCase.deleteAllBooks()
        books.accept([])
    }
}
