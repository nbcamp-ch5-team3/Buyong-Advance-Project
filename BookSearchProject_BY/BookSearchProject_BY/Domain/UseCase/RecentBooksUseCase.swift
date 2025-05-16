//
//  RecentBooksUseCase.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/16/25.
//

final class RecentBooksUseCase {
    /// 최근 본 책 데이터 접근을 위한 레포지토리
    private let repository: RecentBooksRepository
    
    /// 레포지토리 의존성 주입을 위한 이니셜라이저
    init(repository: RecentBooksRepository) {
        self.repository = repository
    }
    
    /// 최근 본 모든 책을 가져오기
    /// - Returns: 최근 본 책 목록
    func fetchRecentBooks() -> [RecentBook] {
        return repository.fetchAllBooks()
    }
    
    /// 새로운 책을 최근 본 목록에 저장
    /// - Parameter book: 저장할 책 정보
    func saveRecentBook(_ book: Book) {
        repository.saveBook(book)
    }
    
    /// 특정 책을 최근 본 목록의 맨 앞으로 이동
    /// - Parameter thumbnail: 이동할 책의 썸네일 URL
    func moveRecentBookToFront(thumbnail: String) {
        repository.moveToFront(thumbnail: thumbnail)
    }
    
    
    /// 특정 책이 이미 최근 본 목록에 존재하는지 확인
    func isBookExists(thumbnail: String) -> Bool {
        return repository.isBookExists(thumbnail: thumbnail)
    }
}
