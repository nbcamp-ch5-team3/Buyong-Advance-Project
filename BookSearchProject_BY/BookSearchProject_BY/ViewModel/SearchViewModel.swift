//
//  SearchViewModel.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/12/25.
//

import Alamofire
import RxSwift
import RxCocoa

final class SearchViewModel {
    private let disposeBag = DisposeBag()
    private let apiKey = "fd377cd5d584a8c6f60b855dae5e5509"
    
    let books = BehaviorSubject(value: [Book]())
    let error = PublishSubject<Error>()
    
    func fetchBooks(query: String) {
        // 검색어를 URL에 쓸 수 있도록 인코딩
        guard let queryEncoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            error.onNext(NetworkError.invalidUrl)
            return
        }
        
        let url = "https://dapi.kakao.com/v3/search/book?query=\(queryEncoded)"
        
        let headers: HTTPHeaders = [
            "Authorization": "KakaoAK \(apiKey)"
        ]
        
        NetworkManager.shared.fetch(url: url, headers: headers)
            .subscribe(onSuccess: { [weak self] (response: BookResponse) in
                self?.books.onNext(response.documents)
            }, onFailure: {[weak self] error in
                self?.error.onNext(error)
            }) .disposed(by: disposeBag)
    }
}
