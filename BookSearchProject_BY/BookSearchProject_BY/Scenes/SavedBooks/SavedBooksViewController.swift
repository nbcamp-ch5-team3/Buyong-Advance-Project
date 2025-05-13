//
//  SavedBooksViewController.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/9/25.
//

import UIKit

import SnapKit

class SavedBooksViewController: UIViewController {
    
    private let savedBooksView = SavedBooksView()
    private var savedBooks: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTableView()
        fetchSavedBooks()
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
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fetchSavedBooks() {
        let savedCoreDataBooks = CoreDataManager.shared.fetchBooks()
        self.savedBooks = savedCoreDataBooks.map { Book(savedBook: $0) }
        savedBooksView.tableView.reloadData()
    }
    
}

extension SavedBooksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SavedBooksTableViewCell.id, for: indexPath) as? SavedBooksTableViewCell else {
            return UITableViewCell()
        }
        cell .configure(with: savedBooks[indexPath.row])
        return cell
    }
}
