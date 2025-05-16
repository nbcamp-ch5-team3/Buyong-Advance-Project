//
//  SavedBookRepository.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/16/25.
//

import Foundation

protocol SavedBookRepository {
    /// 새로운 책을  Core Data에 저장하는 함수
    /// - Parameters:
    ///   - title: 책 제목
    ///   - author: 저자
    ///   - price: 가격
    ///   - thumbnail: 썸네일 이미지 URL
    ///   - contents: 책 설명
    /// - Returns: 저장 성공 여부를 Bool 값으로 반환
    func saveBook(title: String, author: String, price: Int64, thumbnail: String?, contents: String?) -> Bool
    
    /// Core Data에서 저장된 모든 책을 조회하는 함수
    /// - Returns: 저장된 책 목록
    func fetchBooks() -> [SavedBook]
    
    /// Core Data에서 특정 책을 삭제하는 함수
    /// - Parameter book: 삭제할 책
    func deleteBook(_ book: SavedBook)
    
    /// Core Data에서 저장된 모든 책을 삭제하는 함수
    func deleteAllBooks()
    
    /// 특정 책이 이미 저장되어 있는지 확인하는 함수
    /// - Parameters:
    ///   - title: 책 제목
    ///   - author: 저자
    /// - Returns: 저장 여부를 Bool 값으로 반환
    func isBookAlreadySaved(title: String, author: String) -> Bool
}
