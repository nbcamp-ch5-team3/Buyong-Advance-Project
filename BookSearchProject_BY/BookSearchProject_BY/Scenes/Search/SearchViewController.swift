//
//  SearchTabBarViewController.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/9/25.
//

import UIKit

import SnapKit

class SearchViewController: UIViewController {
    
    private let searchView = SearchView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        view.addSubview(searchView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        searchView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
}
