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
    
    // CRUD : Create
    func saveBook(title: String, author: String, price: Int64) {
        let newBook = SavedBook(context: context)
        newBook.title = title
        newBook.author = author
        newBook.price = price
        newBook.createdAt = Date()
        
        do {
            try context.save()
            print("저장 성공: \(context)")
        } catch {
            print("저장 실패 에러: \(error)")
        }
    }
    
    // CURD: Read
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
    
    // CURD: Delete
    func deleteBook(_ book: SavedBook) {
        context.delete(book)
        do {
            try context.save()
            print("삭제 성공")
        } catch {
            print("삭제 실패: \(error)")
        }
    }
    
    // CURD: ALL Delete
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

}
