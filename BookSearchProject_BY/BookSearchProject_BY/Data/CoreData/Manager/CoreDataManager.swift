//
//  CoreDataManager.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/13/25.
//

import CoreData
import UIKit

// 코어데이터 관리를 담당: 싱글톤 인스턴스
final class CoreDataManager {
    static let shared = CoreDataManager()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - Create
    /// - Returns: 저장 성공 여부
    func saveBook(title: String, author: String, price: Int64, thumbnail: String?, contents: String?) -> Bool {
        if isBookAlreadySaved(title: title, author: author) {
            return false
        }
        
        // 새로운 Book 엔티티 생성 및 속성 설정
        let newBook = SavedBook(context: context)
        newBook.title = title
        newBook.author = author
        newBook.price = price
        newBook.thumbnailImage = thumbnail
        newBook.contents = contents
        newBook.createdAt = Date()
        
        // 컨텍스트 저장 시도
        do {
            try context.save()
            print("저장 성공: \(context)")
            return true
        } catch {
            print("저장 실패 에러: \(error)")
            return false
        }
    }
    
    // MARK: - Read
    /// 저장된 모든 책을 최신순으로 조회
    /// - Returns: 저장된 책 목록 배열
        func fetchBooks() -> [SavedBook] {
        let request: NSFetchRequest<SavedBook> = SavedBook.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        // 생성일 기준 내림차순 정렬
        request.sortDescriptors = [sortDescriptor]
        do {
            let books = try context.fetch(request)
            return books
        } catch {
            print("불러오기 실패 에러: \(error)")
            return []
        }
    }
    
    // MARK: - Delete
    /// 특정 책 삭제
        func deleteBook(_ book: SavedBook) {
        context.delete(book)
        do {
            try context.save()
            print("삭제 성공")
        } catch {
            print("삭제 실패: \(error)")
        }
    }
    
    /// 저장된 모든 책 삭제
    func deleteAllBooks() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = SavedBook.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
            print("전체 삭제 성공")
        } catch {
            print("전체 삭제 실패: \(error)")
        }
    }
    
    // MARK: - Utility
    /// 책이 이미 저장되어 있는지 확인
    func isBookAlreadySaved(title: String, author: String) -> Bool {
        let fetchRequest: NSFetchRequest<SavedBook> = SavedBook.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@ AND author == %@", title, author)
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("중복 체크 실패: \(error)")
            return false
        }
    }
}
