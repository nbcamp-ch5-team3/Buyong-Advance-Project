//
//  DefaultRecentBooksRepository.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/16/25.
//

// MARK: - 최근 본 책 저장소 구현체
final class RecentBooksRepositoryImpl: RecentBooksRepository {
    /// 최근 검색한 도서 데이터를 관리하는 매니저
    private let manager: RecentBookManager
    
    init(manager: RecentBookManager = .shared) {
        self.manager = manager
    }
    
    /// 모든 최근 본 책 목록을 가져오는 함수
    func fetchAllBooks() -> [RecentBook] {
        return manager.fetchAllBooks()
    }
    
    /// 최근 본 책을 저장하는 함수
    func saveBook(_ book: Book) {
        manager.saveRecentBook(book: book)
    }
    
    /// 썸네일로 최근 본 책을 찾아 맨 앞으로 이동시키는 함수
    func moveToFront(thumbnail: String) {
        if let book = manager.fetchBook(thumbnail: thumbnail) {
            manager.moveRecentBookToFront(recentBook: book)
        }
    }
    
    /// 썸네일로 최근 본 책의 존재 여부를 확인하는 함수
    func isBookExists(thumbnail: String) -> Bool {
        return manager.fetchBook(thumbnail: thumbnail) != nil
    }
}
