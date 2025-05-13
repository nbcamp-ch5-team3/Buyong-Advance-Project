//
//  SavedBooksViewController.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/9/25.
//

import UIKit
import SnapKit

final class SavedBooksViewController: UIViewController {
    
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
}
