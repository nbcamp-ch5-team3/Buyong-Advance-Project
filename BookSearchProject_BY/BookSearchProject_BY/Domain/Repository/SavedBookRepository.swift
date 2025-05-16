//
//  SavedBookRepository.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/16/25.
//

import Foundation

protocol SavedBookRepository {
    /// 새로운 책을 저장
    /// - Parameters:
    ///   - title: 책 제목
    ///   - author: 저자
    ///   - price: 가격
    ///   - thumbnail: 썸네일 이미지 URL
    ///   - contents: 책 설명
    /// - Returns: 저장 성공 여부
    func saveBook(title: String, author: String, price: Int64, thumbnail: String?, contents: String?) -> Bool
    
    /// 저장된 모든 책을 읽기
    /// - Returns: 저장된 책 목록
    func fetchBooks() -> [SavedBook]
    
    /// 특정 책을 삭제
    /// - Parameter book: 삭제할 책
    func deleteBook(_ book: SavedBook)
    
    /// 저장된 모든 책을 삭제
    func deleteAllBooks()
    
    /// 책이 이미 저장되어 있는지 확인
    /// - Parameters:
    ///   - title: 책 제목
    ///   - author: 저자
    /// - Returns: 저장 여부
    func isBookAlreadySaved(title: String, author: String) -> Bool
}
