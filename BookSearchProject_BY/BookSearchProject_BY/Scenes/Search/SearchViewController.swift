//
//  SearchViewController.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/9/25.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class SearchViewController: UIViewController {
    
    private let searchView = SearchView()
    private let searchVM = SearchViewModel()
    private let disposeBag = DisposeBag()
    
    // 책 목록이 바뀌면 콜렉션뷰 새로고침(VC → View로 데이터 전달)
    private var searchResults: [Book] = [] {
        didSet {
            searchView.searchResults = searchResults
            searchView.reloadSearchResults()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind()
    }
    
    private func setup() {
        view.addSubview(searchView)
        searchView.delegate = self
        setupConstraints()
    }
    
    private func setupConstraints() {
        searchView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    private func bind() {
        // 2. VM의 책목록 -> VC의 데이터 갱신
        searchVM.books
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] books in
                self?.searchResults = books
            }).disposed(by: disposeBag)
        
        // 3. 에러처리
        searchVM.error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { error in
                print("에러 발생: \(error)")
            }).disposed(by: disposeBag)
    }
}

extension SearchViewController: SearchViewDelegate {
    // 1. 검색 버튼 클릭 -> VM에 검색 요청
    func searchView(_ searchView: SearchView, didSearch text: String) {
        searchVM.fetchBooks(query: text)
    }
    
    // detailVC.configure(with: book)
    func searchView(_ searchView: SearchView, didSelectBook book: Book) {
        let detailVC = BookDetailModalViewController()
        detailVC.configure(with: book)
        detailVC.delegate = self
        detailVC.modalPresentationStyle = .pageSheet
        present(detailVC, animated: true)
    }
}

// 담기 버튼 클릭 시 detailVC를 dismiss -> alert 띄우기
extension SearchViewController: BookDetailModalDelegate {
    func didSaveBook(title: String) {
        presentedViewController?.dismiss(animated: true) { [weak self] in
            let alert = UIAlertController(
                title: nil,
                message: "\(title) 책 담기 완료!",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            self?.present(alert, animated: true)
        }
    }
}
