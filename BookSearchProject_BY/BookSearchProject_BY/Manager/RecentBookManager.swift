//
//  RecentBookManager.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/14/25.
//

import UIKit
import CoreData

// 최근 본 책 데이터를 관리: 싱글톤 인스턴스
final class RecentBookManager {
    static let shared = RecentBookManager()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    /// 최근 본 책의 최대 저장 개수
    private let maxRecentBooks = 10
    
    // MARK: - Create
    /// 최근 본 책 정보를 저장
    func saveRecentBook(book: Book) {
        // 1. 중복 데이터 처리
        if let existing = fetchBook(thumbnail: book.thumbnail ?? "") {
            context.delete(existing)
        }
        
        // 2. 새로운 RecentBook 엔티티 생성 및 데이터 설정
        let newBook = RecentBook(context: context)
        configureRecentBook(newBook, from: book)
        
        // 3. 최대 저장 개수 관리
        removeOldestBookIfNeeded()
        
        // 4. 컨텍스트 저장
        do {
            try context.save()
            print("최근 본 책 저장 성공: \(book.title)")
        } catch {
            print("최근 본 책 저장 실패: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Private Helpers
    /// RecentBook 엔티티 설정
    private func configureRecentBook(_ recentBook: RecentBook, from book: Book) {
        recentBook.thumbnailImage = book.thumbnail
        recentBook.title = book.title
        recentBook.contents = book.contents ?? ""
        recentBook.authors = book.authors.joined(separator: ",")
        recentBook.price = Int64(book.price)
        recentBook.createdAt = Date()
    }
    
    // MARK: - Read
    /// 특정 썸네일 URL을 가진 책 조회
    /// - Returns: 해당 썸네일을 가진 RecentBook 객체 (없으면 nil)
    func fetchBook(thumbnail: String) -> RecentBook? {
        let request: NSFetchRequest<RecentBook> = RecentBook.fetchRequest()
        request.predicate = NSPredicate(format: "thumbnailImage == %@", thumbnail)
        return (try? context.fetch(request))?.first
    }
    
    /// 저장된 모든 최근 본 책을 최신순으로 조회
    /// - Returns: RecentBook 배열
    func fetchAllBooks() -> [RecentBook] {
        let request: NSFetchRequest<RecentBook> = RecentBook.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        return (try? context.fetch(request)) ?? []
    }
    
    // MARK: - Update
    /// 특정 책을 최근 본 목록의 맨 앞으로 이동
    func moveRecentBookToFront(recentBook: RecentBook) {
        recentBook.createdAt = Date()
        do {
            try context.save()
        } catch {
            print("맨 앞으로 이동 실패: \(error)")
        }
    }
    
    /// 최대 저장 개수 초과 시 가장 오래된 항목 제거
    private func removeOldestBookIfNeeded() {
        let allBooks = fetchAllBooks()
        if allBooks.count >= maxRecentBooks,
           let oldestBook = allBooks.sorted(by: { $0.createdAt ?? Date() < $1.createdAt ?? Date() }).first {
            context.delete(oldestBook)
        }
    }
}
