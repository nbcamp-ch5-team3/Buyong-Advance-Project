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
    
    /// 새로운 책을 Core Data에 저장하는 메서드
    /// - Returns: 저장 성공 시 true, 실패 또는 중복 시 false
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
    
    /// Core Data에서 저장된 모든 책을 조회하는 메서드
    /// - Returns: 저장된 책 목록 배열
    func fetchBooks() -> [SavedBook] {
        return coreDataManager.fetchBooks()
    }
    
    /// Core Data에서 특정 책을 삭제하는 메서드
    /// - Parameter book: 삭제할 SavedBook 객체
    func deleteBook(_ book: SavedBook) {
        coreDataManager.deleteBook(book)
    }
    
    /// Core Data에서 저장된 모든 책을 삭제하는 메서드
    func deleteAllBooks() {
        coreDataManager.deleteAllBooks()
    }
    
    /// 책이 이미 저장되어 있는지 확인하는 메서드
    func isBookAlreadySaved(title: String, author: String) -> Bool {
        return coreDataManager.isBookAlreadySaved(title: title, author: author)
    }
}

// MARK: - Error Handling
/// 저장된 책 관련 작업 중 발생할 수 있는 에러 정의
extension SavedBookRepositoryImpl {
    enum SavedBookRepositoryError: LocalizedError {
        case saveFailed
        case fetchFailed
        case deleteFailed
        case duplicateBook
        
        var errorDescription: String? {
            switch self {
            case .saveFailed:
                return "책 저장에 실패했어요."
            case .fetchFailed:
                return "저장된 책 목록을 불러오는데 실패했어요."
            case .deleteFailed:
                return "책 삭제에 실패했어요."
            case .duplicateBook:
                return "이미 저장된 책이에요!"
            }
        }
    }
}
