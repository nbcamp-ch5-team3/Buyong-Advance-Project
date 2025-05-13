//
//  SavedBooksTableViewCell.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/13/25.
//

import UIKit
import SnapKit
import Then

final class SavedBooksTableViewCell: UITableViewCell {
    static let id = "SavedBooksTableViewCell"
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemBackground
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .systemBackground

        selectionStyle = .none

        contentView.addSubview(containerView)
        [titleLabel, authorLabel, priceLabel].forEach { containerView.addSubview($0) }
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.leading.trailing.equalToSuperview().inset(25)
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
            make.width.greaterThanOrEqualTo(60)
        }
    }
    
    func configure(with book: Book) {
        titleLabel.text = book.title.isEmpty ? "제목 없음" : book.title
        authorLabel.text = book.authors.first ?? "저자 미상"
        priceLabel.text = book.price == 0 ? "가격 미정" : "\(book.price.decimalFormatted)원"
    }
}
