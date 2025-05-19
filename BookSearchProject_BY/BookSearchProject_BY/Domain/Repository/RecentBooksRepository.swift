//
//  RecentBooksRepository.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/16/25.
//

import RxSwift

protocol RecentBooksRepository {
    /// UserDefaults에서 최근 본 모든 책을 조회하는 함수
    /// - Returns: 최근 본 책 목록
    func fetchAllBooks() -> [RecentBook]
    
    /// 새로운 책을 최근 본 목록에 저장하는 함수
    /// - Parameter book: 저장할 책 정보
    func saveBook(_ book: Book)
    
    /// 특정 책을 최근 본 목록의 맨 앞으로 이동하는 함수
    /// - Parameter thumbnail: 이동할 책의 썸네일 URL
    func moveToFront(thumbnail: String)
    
    /// 최근 본 목록에서 특정 책이 존재하는지 확인하는 함수
    /// - Parameter thumbnail: 확인할 책의 썸네일 URL
    /// - Returns: 존재 여부를 Bool 값으로 반환
    func isBookExists(thumbnail: String) -> Bool
}
