//
//  SavedEmptyStateCell.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/13/25.
//

import UIKit

final class SavedEmptyStateCell: UITableViewCell {
    
    // MARK: - Properties
    static let id = "SavedEmptyStateCell"
    
    // MARK: - UI Components
    private let messageLabel = UILabel().then {
        $0.text = "저장된 책이 없습니다"
        $0.textColor = .secondaryLabel
        $0.font = .systemFont(ofSize: 17, weight: .medium)
        $0.textAlignment = .center
    }
    
    // MARK: - Lifecycle
    /// 셀 초기화 메서드
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
        contentView.addSubview(messageLabel)
        setupConstraints()
    }
    
    /// 오토레이아웃 설정
    private func setupConstraints() {
        messageLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }
}
