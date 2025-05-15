//
//  SavedBooksViewController.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/9/25.
//

import UIKit
import SnapKit

final class SavedBooksViewController: UIViewController, SavedBooksViewDelegate, BookDetailModalDelegate {
        
    private let savedBooksView = SavedBooksView()
    private var savedBooks: [Book] = []
    private var savedCoreDataBooks: [SavedBook] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchSavedBooks()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTableView()
        savedBooksView.delegate = self
    }
    
    private func setup() {
        view.addSubview(savedBooksView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        savedBooksView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    private func setupTableView() {
        let tableView = savedBooksView.tableView
        tableView.register(SavedBooksTableViewCell.self, forCellReuseIdentifier: SavedBooksTableViewCell.id)
        tableView.register(SavedEmptyStateCell.self, forCellReuseIdentifier: SavedEmptyStateCell.id)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fetchSavedBooks() {
        let fetched = CoreDataManager.shared.fetchBooks()
        self.savedCoreDataBooks = fetched
        self.savedBooks = fetched.map { Book(savedBook: $0) }
        savedBooksView.tableView.reloadData()
    }
    
    func didTapDeleteAllButton() {
        let alert = UIAlertController(title: "전체 삭제",
                                      message: "저장된 모든 책을 삭제하시겠습니까?",
                                      preferredStyle: .alert
        )
        let deleteAction = UIAlertAction(title: "삭제",
                                         style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            CoreDataManager.shared.deleteAllBooks()
            self.savedBooks.removeAll()
            self.savedCoreDataBooks.removeAll()
            self.savedBooksView.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        [deleteAction, cancelAction].forEach { alert.addAction($0) }
        
        present(alert, animated: true, completion: nil)
    }
    
    func didTapAddBookButton() {
        // 1. 첫 번째 탭(검색화면)으로 이동
        tabBarController?.selectedIndex = 0
        
        // 2. 탭 전환 후에 SearchViewController의 searchBar 활성화
        if let tabBarController = self.tabBarController,
           let searchVC = tabBarController.viewControllers?.first as? SearchViewController {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                searchVC.searchBar.becomeFirstResponder()
            }
        }
    }
    
    // 이미 저장된 책이므로 여기서는 특별한 처리가 필요 없음
    func didSaveBook(title: String, author: String, price: Int64, thumbnail: String?, contents: String?, isSaved: Bool) {
        dismiss(animated: true)
    }
    
    // 모달이 닫힐 때 데이터 갱신
    func modalDidDismiss() {
        fetchSavedBooks()
    }
}

extension SavedBooksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedBooks.isEmpty ? 1 : savedBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if savedBooks.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: SavedEmptyStateCell.id, for: indexPath) as! SavedEmptyStateCell
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: SavedBooksTableViewCell.id, for: indexPath) as! SavedBooksTableViewCell
            cell.configure(with: savedBooks[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // 목록이 아무것도 없다면 스와프 삭제 안보이게 처리
        if savedBooks.isEmpty {
                return nil
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            
            let coreDataBook = self.savedCoreDataBooks[indexPath.row]
            CoreDataManager.shared.deleteBook(coreDataBook)
            
            //배열에서 삭제하기
            self.savedCoreDataBooks.remove(at: indexPath.row)
            self.savedBooks.remove(at: indexPath.row)
            
            // 마지막 셀 삭제 -> 전체 reload, 여러개가 남아있을 때만 deleteRows 사용
            if self.savedBooks.isEmpty {
                tableView.reloadData()
            } else {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
            completionHandler(true)
        }
        deleteAction.backgroundColor = .white
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 빈 상태 셀이면 무시
        guard !savedBooks.isEmpty else { return }
        
        // 선택된 책 정보로 모달 표시
        let selectedBook = savedBooks[indexPath.row]
        let detailVC = BookDetailModalViewController()
        detailVC.configure(with: selectedBook, isFromSavedTab: true)
        detailVC.delegate = self
        detailVC.modalPresentationStyle = .pageSheet
        present(detailVC, animated: true)
        
        // 선택 표시 해제
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
