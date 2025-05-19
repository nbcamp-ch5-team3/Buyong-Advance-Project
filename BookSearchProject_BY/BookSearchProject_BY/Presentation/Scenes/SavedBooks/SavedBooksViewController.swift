//
//  SavedBooksViewController.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/9/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SavedBooksViewController: UIViewController {
    
    // MARK: - Properties
    private let savedBooksView = SavedBooksView()
    private let savedBooksVM: SavedBooksViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialization
    init(savedBooksVM: SavedBooksViewModel = SavedBooksViewModel()) {
        self.savedBooksVM = savedBooksVM
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        savedBooksVM.fetchBooks()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setTableView()
        bindViewModel()
    }
    
    // MARK: - setup
    private func setup() {
        view.addSubview(savedBooksView)
        savedBooksView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    /// 테이블뷰 셀 할당
    private func setTableView() {
        savedBooksView.tableView.register(SavedBooksTableViewCell.self, forCellReuseIdentifier: SavedBooksTableViewCell.id)
        savedBooksView.tableView.register(SavedEmptyStateCell.self, forCellReuseIdentifier: SavedEmptyStateCell.id)
    }
    
    // MARK: - Binding
    /// 뷰모델 바인딩 설정
    private func bindViewModel() {
        bindInputs()
        bindOutputs()
    }

    /// 입력 바인딩 설정
    private func bindInputs() {
        savedBooksView.deleteAllButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showDeleteAllAlert()
            })
            .disposed(by: disposeBag)
        
        savedBooksView.addBookButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigateToSearch()
            })
            .disposed(by: disposeBag)
    }
    
    /// 출력 바인딩 설정
    private func bindOutputs() {
        bindTableView()
        bindTableViewSelection()
        bindTableViewDeletion()
    }
    
    /// 테이블뷰 데이터 바인딩
    private func bindTableView() {
        savedBooksVM.displayBooks
            .bind(to: savedBooksView.tableView.rx.items) { tableView, row, item in
                switch item {
                case .empty:
                    let cell = tableView.dequeueReusableCell(withIdentifier: SavedEmptyStateCell.id, for: IndexPath(row: row, section: 0)) as! SavedEmptyStateCell
                    cell.selectionStyle = .none
                    return cell
                case .normal(let book):
                    let cell = tableView.dequeueReusableCell(withIdentifier: SavedBooksTableViewCell.id, for: IndexPath(row: row, section: 0)) as! SavedBooksTableViewCell
                    cell.configure(with: book)
                    return cell
                }
            }
            .disposed(by: disposeBag)
    }

    
    /// 테이블뷰 선택 이벤트 바인딩
    private func bindTableViewSelection() {
        savedBooksView.tableView.rx.itemSelected
            .withLatestFrom(savedBooksVM.displayBooks) { ($0, $1) }
            .subscribe(onNext: { [weak self] (indexPath, items) in
                guard let self = self else { return }
                let item = items[indexPath.row]
                switch item {
                case .normal(let book):
                    self.showDetailModal(for: book)
                case .empty:
                    break // 아무 동작 없음
                }
                self.savedBooksView.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
    }
                
    /// 테이블뷰 삭제 이벤트 바인딩
    private func bindTableViewDeletion() {
        savedBooksView.tableView.rx.itemDeleted
            .withLatestFrom(savedBooksVM.displayBooks) { ($0, $1) }
            .subscribe(onNext: { [weak self] (indexPath, items) in
                guard let self = self else { return }
                let item = items[indexPath.row]
                switch item {
                case .normal:
                    self.savedBooksVM.deleteBook(at: indexPath.row)
                case .empty:
                    break // 아무 동작 없음
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    // MARK: - Helper Methods
    /// 전체 삭제 확인 알림창 표시
    private func showDeleteAllAlert() {
        let alert = UIAlertController(
            title: "전체 삭제",
            message: "저장된 모든 책을 삭제하시겠습니까?",
            preferredStyle: .alert
        )
        
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            self?.savedBooksVM.deleteAllBooks()
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        [deleteAction, cancelAction].forEach { alert.addAction($0) }
        
        present(alert, animated: true)
    }
    
    /// 검색 화면으로 이동
    private func navigateToSearch() {
        tabBarController?.selectedIndex = 0
        if let searchVC = tabBarController?.viewControllers?.first as? SearchViewController {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                searchVC.searchBar.becomeFirstResponder()
            }
        }
    }
    
    /// 책 상세 정보 모달 표시
    private func showDetailModal(for book: Book) {
        let detailVC = BookDetailModalViewController()
        detailVC.configure(with: book, isFromSavedTab: true)
        detailVC.delegate = self
        detailVC.modalPresentationStyle = .pageSheet
        present(detailVC, animated: true)
    }
}

// MARK: - BookDetailModalDelegate
/// 책 상세 모달에서 '담기' 버튼을 누르면 모달을 닫는 함수
extension SavedBooksViewController: BookDetailModalDelegate {
    func didSaveBook(title: String, author: String, price: Int64, thumbnail: String?, contents: String?, isSaved: Bool) {
        dismiss(animated: true)
    }
    
    /// 모달이 닫힐 때 호출되는 함수 (현재는 아무 동작 없음, SearchView에서 사용)
    func modalDidDismiss() {
    }
}


// MARK: - UITableViewDelegate
/// 테이블뷰 셀을 왼쪽으로 스와이프할 때 '삭제' 액션을 제공하는 함수
extension SavedBooksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // 빈 상태 셀일 경우 스와이프 비활성화
        guard !savedBooksVM.books.value.isEmpty else { return nil }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] (action, view, completion) in
            self?.savedBooksVM.deleteBook(at: indexPath.row)
            completion(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}
