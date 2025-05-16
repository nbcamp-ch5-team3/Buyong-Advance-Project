//
//  SavedEmptyStateCell.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/13/25.
//

import UIKit

final class SavedEmptyStateCell: UITableViewCell {
    static let id = "SavedEmptyStateCell"
    
    private let messageLabel = UILabel().then {
        $0.text = "저장된 책이 없습니다"
        $0.textColor = .secondaryLabel
        $0.font = .systemFont(ofSize: 17, weight: .medium)
        $0.textAlignment = .center
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
