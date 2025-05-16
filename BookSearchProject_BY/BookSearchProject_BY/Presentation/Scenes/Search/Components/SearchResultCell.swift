//
//  SearchResultCell.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/9/25.
//

import UIKit
import SnapKit
import Then

final class SearchResultCell: UICollectionViewCell {
    static let id = "SearchResultCell"
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .medium)
        $0.numberOfLines = 0
        $0.textColor = .label
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray6.cgColor
        contentView.clipsToBounds = true
        
        [titleLabel, authorLabel, priceLabel].forEach { contentView.addSubview($0)}
        setupConstraints()
    }
    
    private func setupConstraints() {
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

    func configure(with book: Book) {
        titleLabel.text = book.title.isEmpty ? "제목 없음" : book.title
        authorLabel.text = book.authors.first ?? "저자 미상"
        priceLabel.text = book.price == 0 ? "가격 미정" : "\(book.price.decimalFormatted)원"
    }
}
