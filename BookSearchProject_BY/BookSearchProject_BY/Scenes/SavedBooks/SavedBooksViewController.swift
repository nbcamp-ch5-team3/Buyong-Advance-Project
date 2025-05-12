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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
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
}
