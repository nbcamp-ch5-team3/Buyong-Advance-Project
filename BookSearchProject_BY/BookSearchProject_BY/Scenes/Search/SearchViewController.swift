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

protocol SearchViewDelegate: AnyObject {
    func searchView(_ searchView: SearchView, didSearch text: String)
    func searchView(_ searchView: SearchView, didSelectBook book: Book)
    func searchView(_ searchView: SearchView, didSelectRecentBook recentBook: RecentBook)
}

final class SearchViewController: UIViewController {
    
    private let searchView = SearchView()
    private let searchVM = SearchViewModel()
    private let disposeBag = DisposeBag()
    private var shouldRefreshRecentBooksOnModalDismiss = true /// 갱신 플래그 추가
    
    // 서치바 외부 접근자 추가
    var searchBar: UISearchBar {
        return searchView.searchBar
    }
    
    // 책 목록이 바뀌면 콜렉션뷰 새로고침(VC → View로 데이터 전달)
    private var searchResults: [Book] = [] {
        didSet {
            searchView.searchResults = searchResults
            searchView.reloadSearchResults()
        }
    }
    
    // 썸네일 이미지 클릭 시 새로고침
    private var recentBooks: [RecentBook] = [] {
        didSet {
            searchView.recentBooks = recentBooks
            searchView.reloadRecentBooks(oldBooks: oldValue, newBooks: recentBooks)
        }
    }
    
    // 화면이 보일때마다 최근 본 책 갱신
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchVM.fetchRecentBooks()
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
        
        // 4. RecentBooks 데이터 바인딩
        searchVM.recentBooks
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] books in
                self?.recentBooks = books
            }).disposed(by: disposeBag)
    }
}

extension SearchViewController: SearchViewDelegate {
    // 이미지 썸네일 클릭 시 모달 띄우기
    func searchView(_ searchView: SearchView, didSelectRecentBook recentBook: RecentBook) {
        // 1. 최근 본 책을 맨 앞으로 이동 (createdAt 갱신)
        RecentBookManager.shared.moveRecentBookToFront(recentBook: recentBook)
        
        // 2. UI 갱신 (fetch해서 최신순으로 다시 불러오기)
        searchVM.fetchRecentBooks()
        
        // 3. 모달 띄우기 (모달 닫힐때 UI 갱신 x)
        shouldRefreshRecentBooksOnModalDismiss = false
        let book = Book(recentBook: recentBook)
        let detailVC = BookDetailModalViewController()
        detailVC.configure(with: book)
        detailVC.delegate = self
        detailVC.modalPresentationStyle = .pageSheet
        present(detailVC, animated: true)
    }
    
    
    // 1. 검색 버튼 클릭 -> VM에 검색 요청
    func searchView(_ searchView: SearchView, didSearch text: String) {
        searchVM.fetchBooks(query: text)
    }
    
    // detailVC.configure(with: book)
    func searchView(_ searchView: SearchView, didSelectBook book: Book) {
        // 1. 최근 본 책 저장
        shouldRefreshRecentBooksOnModalDismiss = true
        RecentBookManager.shared.saveRecentBook(book: book)
        
        // 2. 모달 띄우기
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
    
    // 모달이 내려갔을 때 항상 최근 본 책 갱신
    func modalDidDismiss() {
        if shouldRefreshRecentBooksOnModalDismiss {
            searchVM.fetchRecentBooks()
        }
        shouldRefreshRecentBooksOnModalDismiss = true    }
}

extension SearchView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SearchSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch SearchSection(rawValue: section) {
        case .searchResults:
            return max(searchResults.count, 1) /// 빈 상태일 때 1개
        case .recentBooks:
            return recentBooks.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = SearchSection(rawValue: indexPath.section)
        
        switch section {
        case .recentBooks:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentBookCell.id, for: indexPath) as? RecentBookCell else { return UICollectionViewCell()
            }
            
            let book = recentBooks[indexPath.row]
            cell.layer.cornerRadius = 40
            cell.clipsToBounds = true
            cell.configure(with: book.thumbnailImage)
            return cell
            
        case .searchResults:
            if searchResults.isEmpty {
                return collectionView.dequeueReusableCell(withReuseIdentifier: SearchEmptyStateCell.id, for: indexPath)
            } else {
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: SearchResultCell.id, for: indexPath
                ) as? SearchResultCell else { return UICollectionViewCell()
                }
                
                guard indexPath.row < searchResults.count else { /// searchResults 접근 시 index 범위 검사
                    print("Invalid indexPath: \(indexPath.row), count: \(searchResults.count)")
                    return UICollectionViewCell()
                }
                
                let book = searchResults[indexPath.row]
                cell.configure(with: book)
                return cell
            }
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            fatalError("지원하지 않는 kind")
        }
        let sectionType = SearchSection.allCases[indexPath.section]
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SectionHeaderView.id,
            for: indexPath
        ) as! SectionHeaderView
        
        // recentBooks가 없으면 헤더 숨김
        if sectionType == .recentBooks && recentBooks.isEmpty {
            headerView.isHidden = true
        } else {
            headerView.isHidden = false
            headerView.configure(title: sectionType.title)
        }
        return headerView
    }
    
}

extension SearchView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = SearchSection(rawValue: indexPath.section) else { return }
        
        switch section {
            // 검색결과 셀 클릭 시 이벤트 처리
        case .searchResults:
            guard !searchResults.isEmpty else { return }
            guard indexPath.row < searchResults.count else { return }
            let selectedBook = searchResults[indexPath.row]
            delegate?.searchView(self, didSelectBook: selectedBook)
            
            // 최근 본 채썸네일 이미지 클릭 시 이벤트 처리
        case .recentBooks:
            guard indexPath.row < recentBooks.count else { return }
            let selectedRecentBook = recentBooks[indexPath.row]
            delegate?.searchView(self, didSelectRecentBook: selectedRecentBook)
        }
    }
}

extension SearchView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        delegate?.searchView(self, didSearch: searchBar.text ?? "")
    }
}
