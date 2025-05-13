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
        do {
            let books = try context.fetch(request)
            return books
        } catch {
            print("불러오기 실패 에러: \(error)")
            return []
        }
    }
}
