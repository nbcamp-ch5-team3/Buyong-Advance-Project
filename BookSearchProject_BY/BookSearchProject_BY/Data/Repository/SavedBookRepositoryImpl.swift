//
//  SavedBookRepositoryImpl.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/16/25.
//

import Foundation
import CoreData

final class SavedBookRepositoryImpl: SavedBookRepository {
    private let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager = .shared) {
        self.coreDataManager = coreDataManager
    }
    
    func saveBook(title: String, author: String, price: Int64, thumbnail: String?, contents: String?) -> Bool {
        // 중복 체크 후 저장
        if isBookAlreadySaved(title: title, author: author) {
            return false
        }
        
        return coreDataManager.saveBook(
            title: title,
            author: author,
            price: price,
            thumbnail: thumbnail,
            contents: contents
        )
    }
    
    func fetchBooks() -> [SavedBook] {
        return coreDataManager.fetchBooks()
    }
    
    func deleteBook(_ book: SavedBook) {
        coreDataManager.deleteBook(book)
    }
    
    func deleteAllBooks() {
        coreDataManager.deleteAllBooks()
    }
    
    func isBookAlreadySaved(title: String, author: String) -> Bool {
        return coreDataManager.isBookAlreadySaved(title: title, author: author)
    }
}

// MARK: - Error Handling
extension SavedBookRepositoryImpl {
    enum SavedBookRepositoryError: LocalizedError {
        case saveFailed
        case fetchFailed
        case deleteFailed
        case duplicateBook
        
        var errorDescription: String? {
            switch self {
            case .saveFailed:
                return "책 저장에 실패했습니다."
            case .fetchFailed:
                return "저장된 책 목록을 불러오는데 실패했습니다."
            case .deleteFailed:
                return "책 삭제에 실패했습니다."
            case .duplicateBook:
                return "이미 저장된 책이에요!"
            }
        }
    }
}
