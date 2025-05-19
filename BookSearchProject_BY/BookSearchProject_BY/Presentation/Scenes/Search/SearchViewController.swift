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

/// SearchView에서 발생하는 이벤트를 전달받는 delegate 프로토콜
protocol SearchViewDelegate: AnyObject {
    func searchView(_ searchView: SearchView, didSearch text: String)
    func searchView(_ searchView: SearchView, didSelectBook book: Book)
    func searchView(_ searchView: SearchView, didSelectRecentBook recentBook: RecentBook)
}


final class SearchViewController: UIViewController {
    
    // MARK: - Properties
    private let searchView = SearchView()
    private let searchVM: SearchViewModel
    private let disposeBag = DisposeBag()
    private var shouldRefreshRecentBooksOnModalDismiss = true
    
    /// 외부에서 서치바 접근할 수 있도록 프로퍼티 제공
    var searchBar: UISearchBar {
        return searchView.searchBar
    }
    
    // 책 목록이 바뀌면 콜렉션뷰 새로고침(VC → View로 데이터 전달)
    private var searchResults: [Book] = [] {
        didSet {
            searchView.update(searchResults: searchResults)
        }
    }
    
    /// 최근 본 책 데이터가 바뀌면 View에 반영
    private var recentBooks: [RecentBook] = [] {
        didSet {
            searchView.update(recentBooks: recentBooks)
        }
    }
    
    // MARK: - Initialization
    /// 뷰 컨트롤러 초기화
    init(searchVM: SearchViewModel = SearchViewModel()) {
        self.searchVM = searchVM
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    // 화면이 보일때마다 최근 본 책 갱신
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchVM.fetchRecentBooks()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindViewModel()
        addKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObserver()
    }
    
    // MARK: - Setup
    /// 초기 설정
    private func setup() {
        view.addSubview(searchView)
        setDelegate()
        setupConstraints()
    }
    
    /// SearchView delegate 및 컬렉션뷰 delegate 설정
    private func setDelegate() {
        searchView.configure(delegate: self)
        searchView.setCollectionViewDelegate(self)
    }
    
    private func setupConstraints() {
        searchView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    // MARK: - Binding
    /// 뷰모델 바인딩 설정
    private func bindViewModel() {
        bindSearchBar()
        bindSearchResults()
        bindRecentBooks()
        bindError()
        bindTapGesture()
    }
    
    /// 검색어 입력 후 검색 버튼 클릭 시 이벤트
    private func bindSearchBar() {
        searchBar.rx.searchButtonClicked
            .withLatestFrom(searchBar.rx.text.orEmpty)    /// 최신 검색어 가져오기
            .do(onNext: { [weak self] _ in
                self?.dismissKeyboard()    /// 키보드 숨기기
            })
            .bind(onNext: { [weak self] query in
                self?.searchVM.fetchBooks(query: query)
            })
            .disposed(by: disposeBag)
        
        /// 취소 버튼 클릭 시 이벤트(키보드 내리기)
        searchBar.rx.cancelButtonClicked
            .bind(onNext: { [weak self] in
                self?.dismissKeyboard()
            })
            .disposed(by: disposeBag)
    }
    
    /// 검색 결과 바인딩
    private func bindSearchResults() {
        searchVM.books
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] books in
                self?.searchResults = books
            }).disposed(by: disposeBag)
    }
    
    /// 최근 본 책 바인딩
    private func bindRecentBooks() {
        searchVM.recentBooks
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] books in
                self?.recentBooks = books
            }).disposed(by: disposeBag)
    }
    
    /// 에러 바인딩
    private func bindError() {
        searchVM.error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { error in
                print("에러 발생: \(error)")
            }).disposed(by: disposeBag)
    }
    
    /// 빈 공간 터치 시 키보드 내리기 위한 Gesture 바인딩
    private func bindTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    /// 키보드 내리기 액션
    @objc override func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - 안전한 배열 접근용 익스텐션
extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

// MARK: - SearchViewDelegate 구현
extension SearchViewController: SearchViewDelegate {
    /// 사용자가 검색어를 입력하고 검색 버튼을 눌렀을 때 검색을 실행하는 함수
    func searchView(_ searchView: SearchView, didSearch text: String) {
        searchVM.fetchBooks(query: text)
    }
    
    /// 검색 결과에서 책을 선택했을 때 상세 모달을 띄우고 최근 본 책에 추가하는 함수
    func searchView(_ searchView: SearchView, didSelectBook book: Book) {
        shouldRefreshRecentBooksOnModalDismiss = true
        RecentBookManager.shared.saveRecentBook(book: book)
        
        let detailVC = BookDetailModalViewController()
        detailVC.configure(with: book)
        detailVC.delegate = self
        detailVC.modalPresentationStyle = .pageSheet
        present(detailVC, animated: true)
    }
    
    /// 최근 본 책에서 책을 선택했을 때 상세 모달을 띄우고, 최근 본 책 순서를 갱신하는 함수
    func searchView(_ searchView: SearchView, didSelectRecentBook recentBook: RecentBook) {
        RecentBookManager.shared.moveRecentBookToFront(recentBook: recentBook)
        searchVM.fetchRecentBooks()
        
        shouldRefreshRecentBooksOnModalDismiss = false
        let book = Book(recentBook: recentBook)
        let detailVC = BookDetailModalViewController()
        detailVC.configure(with: book)
        detailVC.delegate = self
        detailVC.modalPresentationStyle = .pageSheet
        present(detailVC, animated: true)
    }
}

// MARK: - BookDetailModalDelegate 구현 (책 담기 알림 등)
extension SearchViewController: BookDetailModalDelegate {
    /// 상세 모달에서 '담기' 버튼 클릭 시 최근 본 책 순서 갱신 및 알림을 띄우는 함수
    func didSaveBook(title: String, author: String, price: Int64, thumbnail: String?, contents: String?, isSaved: Bool) {
        /// 1. 현재 보고 있는 책의 RecentBook 찾기
        if let thumbnail = thumbnail,
           let recentBook = RecentBookManager.shared.fetchBook(thumbnail: thumbnail) {
            
            /// 2. 최근 본 책을 맨 앞으로 이동
            RecentBookManager.shared.moveRecentBookToFront(recentBook: recentBook)
        }
        
        presentedViewController?.dismiss(animated: true) { [weak self] in
            /// 3. UI 업데이트
            self?.searchVM.fetchRecentBooks()
            
            /// 4. 알림 표시
            let message = isSaved ? "\(title) 책 담기 완료!" : "이미 저장된 책이에요!"
            let alert = UIAlertController(
                title: nil,
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            self?.present(alert, animated: true)
        }
    }
    
    /// 상세 모달이 내려갔을 때 최근 본 책 목록을 새로고침하는 함수
    func modalDidDismiss() {
        if shouldRefreshRecentBooksOnModalDismiss {
            searchVM.fetchRecentBooks()
        }
        shouldRefreshRecentBooksOnModalDismiss = true
    }
}

// MARK: - UICollectionViewDelegate 구현 (무한 스크롤, 셀 선택)
extension SearchViewController: UICollectionViewDelegate {
    /// 컬렉션뷰 스크롤 시, 리스트 끝에 가까워지면 추가 데이터 로딩을 트리거하는 함수
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        /// 리스트 끝에서 100pt 이내 진입 시 추가 요청
        if offsetY > contentHeight - frameHeight - 100 {
            searchVM.loadMoreBooksIfNeeded()
        }
    }
    
    /// 컬렉션뷰 셀을 선택했을 때, 섹션에 따라 적절한 액션(상세화면 진입 등)을 수행하는 함수
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = SearchSection(rawValue: indexPath.section) else { return }
        
        switch section {
        case .searchResults:
            let book = searchResults[safe: indexPath.row]
            if let book = book {
                self.searchView(self.searchView, didSelectBook: book)
            }
        case .recentBooks:
            let recentBook = recentBooks[safe: indexPath.row]
            if let recentBook = recentBook {
                self.searchView(self.searchView, didSelectRecentBook: recentBook)
            }
        }
    }
}
