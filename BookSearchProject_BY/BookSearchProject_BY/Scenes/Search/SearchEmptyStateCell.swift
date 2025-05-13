//
//  EmptyStateCell.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/12/25.
//

import UIKit

final class SearchEmptyStateCell: UICollectionViewCell {
    static let id = "SearchEmptyStateCell"
    
    private let messageLabel = UILabel().then {
        $0.text = "검색 결과가 없습니다"
        $0.textColor = .secondaryLabel
        $0.font = .systemFont(ofSize: 17, weight: .medium)
        $0.textAlignment = .center
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
