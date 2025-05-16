//
//  SavedBooksView.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/9/25.
//

import UIKit
import SnapKit
import Then

/// 저장된 책 목록을 표시하는 메인 뷰
final class SavedBooksView: UIView {

    // MARK: - UI Components
    let tableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
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
    
    private(set) var deleteAllButton = UIButton().then {
        $0.setTitleColor(.systemRed, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        $0.setTitle("전체 삭제", for: .normal)
    }
    
    private(set) var addBookButton = UIButton().then {
        $0.setTitleColor(.systemGreen, for: .normal)
        $0.tintColor = .label
        $0.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        $0.setTitle("책 추가", for: .normal)
    }
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setup() {
        self.backgroundColor = .systemBackground
        setupSubviews()
        setupConstraints()
    }
    
    /// 서브뷰 설정
    private func setupSubviews() {
        [deleteAllButton, headerLabel, addBookButton].forEach { headerStackView.addArrangedSubview($0) }
        [headerStackView, tableView].forEach { self.addSubview($0) }
    }
    
    ///오토레이아웃 설정
    private func setupConstraints() {
        headerStackView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(25)
            make.height.equalTo(44)
        }
        
        deleteAllButton.snp.makeConstraints { $0.width.equalTo(80) }
        addBookButton.snp.makeConstraints { $0.width.equalTo(80) }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerStackView.snp.bottom).offset(15)
            make.bottom.leading.trailing.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
