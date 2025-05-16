//
//  SavedBooksTableViewCell.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/13/25.
//

import UIKit
import SnapKit
import Then

/// 저장된 책이 없을 때 표시되는 빈 상태 셀
final class SavedBooksTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let id = "SavedBooksTableViewCell"
    
    // MARK: - UI Components
    private let containerView = UIView().then {
        $0.backgroundColor = .systemBackground
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray6.cgColor
        $0.clipsToBounds = true
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .medium)
        $0.numberOfLines = 2
        $0.textColor = .label
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let authorLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 13, weight: .regular)
        $0.textColor = .secondaryLabel
    }
    
    private let priceLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .label
        $0.textAlignment = .right
    }
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    /// UI 초기 설정
    private func setup() {
        backgroundColor = .systemBackground
        selectionStyle = .none

        contentView.addSubview(containerView)
        [titleLabel, authorLabel, priceLabel].forEach { containerView.addSubview($0) }
        setupConstraints()
    }
    
    /// 오토레이아웃 설정
    private func setupConstraints() {
        configurePriorityConstraints()

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 25, bottom: 5, right: 25))
            make.height.equalTo(80)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.trailing.lessThanOrEqualTo(priceLabel.snp.leading).offset(-10)
            make.top.leading.equalToSuperview().inset(12)
        }
        
        authorLabel.snp.makeConstraints { make in
            make.trailing.lessThanOrEqualTo(priceLabel.snp.leading).offset(-8)
            make.leading.equalToSuperview().inset(12)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(12)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(12)
            make.width.equalTo(70)
        }
    }
    
    // MARK: - Helper Methods
    /// 레이블 컨텐츠 압축 저항 우선순위 설정
    private func configurePriorityConstraints() {
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        priceLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    /// 셀 데이터 구성
    func configure(with book: Book) {
        titleLabel.text = book.title.isEmpty ? "제목 없음" : book.title
        authorLabel.text = book.authors.first ?? "저자 미상"
        priceLabel.text = book.price == 0 ? "가격 미정" : "\(book.price.decimalFormatted)원"
    }
}
