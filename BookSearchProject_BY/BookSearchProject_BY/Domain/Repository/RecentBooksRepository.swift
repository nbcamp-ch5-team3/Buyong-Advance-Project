//
//  RecentBooksRepository.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/16/25.
//

import RxSwift

protocol RecentBooksRepository {
    func fetchAllBooks() -> [RecentBook]
    func saveBook(_ book: Book)
    func moveToFront(thumbnail: String)
}
