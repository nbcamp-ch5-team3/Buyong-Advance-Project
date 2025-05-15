//
//  CoreDataManager.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/13/25.
//

import CoreData
import UIKit

final class CoreDataManager {
    static let shared = CoreDataManager()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // CRUD : C
    func saveBook(title: String, author: String, price: Int64, thumbnail: String?, contents: String?) -> Bool {
        if isBookAlreadySaved(title: title, author: author) {
            return false
        }
        
        let newBook = SavedBook(context: context)
        newBook.title = title
        newBook.author = author
        newBook.price = price
        newBook.thumbnailImage = thumbnail
        newBook.contents = contents
        newBook.createdAt = Date()
        
        do {
            try context.save()
            print("저장 성공: \(context)")
            return true
        } catch {
            print("저장 실패 에러: \(error)")
            return false
        }
    }
    
    // CRUD: R
    func fetchBooks() -> [SavedBook] {
        let request: NSFetchRequest<SavedBook> = SavedBook.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        do {
            let books = try context.fetch(request)
            return books
        } catch {
            print("불러오기 실패 에러: \(error)")
            return []
        }
    }
    
    // CRUD: D
    func deleteBook(_ book: SavedBook) {
        context.delete(book)
        do {
            try context.save()
            print("삭제 성공")
        } catch {
            print("삭제 실패: \(error)")
        }
    }
    
    // CRUD: D (All)
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
    
    // 중복체크(title + author로 확인)를 위한 메서드
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
