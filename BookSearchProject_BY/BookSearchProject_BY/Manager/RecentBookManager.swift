//
//  RecentBookManager.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/14/25.
//

import UIKit
import CoreData

final class RecentBookManager {
    static let shared = RecentBookManager()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    // CRUD: C
    func saveRecentBook(book: Book) {
        // 1. 이미 있는 썸네일이면 삭제(중복 방지)
        if let existing = fetchBook(thumbnail: book.thumbnail ?? "") {
            context.delete(existing)
        }
        
        // 2. 새 객체 생성 및 값 할당
        let newBook = RecentBook(context: context)
        newBook.thumbnailImage = book.thumbnail
        newBook.title = book.title
        newBook.contents = book.contents ?? ""
        newBook.authors = book.authors.joined(separator: ",")
        newBook.price = Int64(book.price)
        newBook.createdAt = Date()
        
        
        // 3. 10개 초과 시 오래된 것 삭제
        let allBooks = fetchAllBooks()
        if allBooks.count > 10, let oldestBook = allBooks.sorted(by: { $0.createdAt ?? Date() < $1.createdAt ?? Date() }).first {
            context.delete(oldestBook)
        }
    
        // 4. 저장
        do {
            try context.save()
            print("저장 성공: \(context)")
        } catch {
            print("저장 실패: \(error)")
        }
    }
    
    // CRUD: R
    func fetchBook(thumbnail: String) -> RecentBook? {
        let request: NSFetchRequest<RecentBook> = RecentBook.fetchRequest()
        request.predicate = NSPredicate(format: "thumbnailImage == %@", thumbnail)
        return (try? context.fetch(request))?.first
    }
    
    // CRUD: R (All)
    func fetchAllBooks() -> [RecentBook] {
        let request: NSFetchRequest<RecentBook> = RecentBook.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        return (try? context.fetch(request)) ?? []
    }
    
    // CRUD: U (모달로 띄운 셀을 첫번째 셀로 이동하기 위한 날짜 갱신)
    func moveRecentBookToFront(recentBook: RecentBook) {
        recentBook.createdAt = Date()
        do {
            try context.save()
        } catch {
            print("맨 앞으로 이동 실패: \(error)")
        }
    }

}
