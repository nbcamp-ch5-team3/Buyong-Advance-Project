//
//  SavedBookUseCase.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/16/25.
//

final class SavedBookUseCase {
    /// 저장된 책 데이터 접근을 위한 레포지토리
    private let repository: SavedBookRepository
    
    /// 레포지토리 의존성 주입을 위한 이니셜라이저
    init(repository: SavedBookRepository) {
        self.repository = repository
    }
    
    /// 새로운 책을 저장
    /// - Returns: 저장 성공 여부
    func saveBook(title: String, author: String, price: Int64, thumbnail: String?, contents: String?) -> Bool {
        return repository.saveBook(title: title, author: author, price: price, thumbnail: thumbnail, contents: contents)
    }
    
    /// 저장된 모든 책을 가져오기
    /// - Returns: 저장된 책 목록
    func fetchBooks() -> [SavedBook] {
        return repository.fetchBooks()
    }
    
    /// 특정 책 삭제
    /// - Parameter book: 삭제할 책 엔티티
    func deleteBook(_ book: SavedBook) {
        repository.deleteBook(book)
    }
    
    /// 저장된 모든 책 삭제
    func deleteAllBooks() {
        repository.deleteAllBooks()
    }
}
