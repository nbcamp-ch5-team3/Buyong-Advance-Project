//
//  SectionHeaderView.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/9/25.
//

import UIKit
import Then

final class SectionHeaderView: UICollectionReusableView {
    static let id = "SectionHeaderView"
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 28, weight: .heavy)
        $0.textColor = .label
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError( "init(coder:) has not been implemented" )
    }
    
    private func setupUI() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
}
