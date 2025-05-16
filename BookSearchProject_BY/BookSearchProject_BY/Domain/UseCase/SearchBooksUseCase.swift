//
//  SearchBooksUseCase.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/16/25.
//
import RxSwift

protocol SearchBooksUseCase {
    func execute(query: String, page: Int) -> Single<[Book]>
    func loadMore()
    var currentState: SearchState { get }
}
