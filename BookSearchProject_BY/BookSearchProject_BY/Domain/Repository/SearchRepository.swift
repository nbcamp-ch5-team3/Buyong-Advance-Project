//
//  SearchRepository.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/16/25.
//

import RxSwift

protocol SearchRepository {
    func searchBooks(query: String, page: Int) -> Single<BookResponse>
}
