//
//  SavedBooksView.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/9/25.
//

import UIKit
import SnapKit
import Then

final class SavedBooksView: UIView {
    
    let tableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.rowHeight = 90
    }
    
    private let headerStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalCentering
        $0.spacing = 0
    }
    
    private let headerLabel = UILabel().then {
        $0.text = "저장한 책"
        $0.font = .systemFont(ofSize: 28, weight: .heavy)
        $0.textColor = .label
        $0.textAlignment = .center
    }
    
    private let deleteAllButton = UIButton().then {
        $0.setTitleColor(.systemRed, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        $0.setTitle("전체 삭제", for: .normal)
    }
    
    private let addBookButton = UIButton().then {
        $0.setTitleColor(.systemGreen, for: .normal)
        $0.tintColor = .label
        $0.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        $0.setTitle("책 추가", for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.backgroundColor = .systemBackground
        [deleteAllButton, headerLabel, addBookButton].forEach { headerStackView.addArrangedSubview($0) }
        [headerStackView, tableView].forEach { self.addSubview($0) }
        
        headerStackView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(25)
            make.leading.trailing.equalToSuperview().inset(25)
            make.height.equalTo(30)
        }
        
        deleteAllButton.snp.makeConstraints { $0.width.equalTo(80) }
        addBookButton.snp.makeConstraints { $0.width.equalTo(80) }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerStackView.snp.bottom).offset(15)
            make.bottom.leading.trailing.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
