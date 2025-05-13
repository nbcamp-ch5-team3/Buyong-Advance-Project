//
//  BookDetailView.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/9/25.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final class BookDetailModalView: UIView {
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = true
    }
    
    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.alignment = .fill
    }
    
    private let topPaddingView = UIView()
    
    let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 22, weight: .bold)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.lineBreakMode = .byCharWrapping
        $0.textColor = .label
    }
    
    let authorLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .secondaryLabel
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    let thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    let priceLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .medium)
        $0.textColor = .label
        $0.textAlignment = .center
    }
    
    let contentsLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.numberOfLines = 0
        $0.lineBreakMode = .byCharWrapping
        $0.textColor = .label
    }
    
    private let floatingButtonContainer = UIView().then {
        $0.backgroundColor = .systemBackground
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowRadius = 8
    }
    
    let closeButton = UIButton().then {
        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
        $0.backgroundColor = .systemGray5
        $0.layer.cornerRadius = 8
    }
    
    let saveButton = UIButton().then {
        $0.setTitle("담기", for: .normal)
        $0.backgroundColor = .systemBlue
        $0.layer.cornerRadius = 8
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .systemBackground
        
        // 스크롤뷰 및 스택뷰 설정
        addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        
        // 플로팅 버튼 컨테이너 설정
        addSubview(floatingButtonContainer)
        floatingButtonContainer.addSubview(closeButton)
        floatingButtonContainer.addSubview(saveButton)
        
        // 스택뷰에 컴포넌트 추가
        [topPaddingView,titleLabel, authorLabel, thumbnailImageView, priceLabel, contentsLabel].forEach { contentStackView.addArrangedSubview($0) }
        
        setupConstraints()
    }

    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(floatingButtonContainer.snp.top)
        }
        
        thumbnailImageView.snp.makeConstraints { make in
            make.height.equalTo(300)
            make.centerX.equalToSuperview()
        }
        
       contentStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(40)
            make.centerX.equalToSuperview()
        }
        
        contentsLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentStackView)
        }
        
        floatingButtonContainer.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(90)
        }
        
        closeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalTo(saveButton)
            make.width.equalTo(saveButton.snp.width).multipliedBy(0.3)
            make.height.equalTo(50)
        }
        
        saveButton.snp.makeConstraints { make in
            make.leading.equalTo(closeButton.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(16)
            make.height.equalTo(50)
        }
        
        topPaddingView.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
    }
    
    // Book 모델을 받아서 데이터를 세팅
    func configure(with book: Book) {
        titleLabel.text = book.title
        authorLabel.text = book.authors.joined(separator: " , ") + "지음"
        if let url = book.thumbnail, let url = URL(string: url) {
            thumbnailImageView.kf.setImage(with: url)
        }
        priceLabel.text = "가격: \(book.price.decimalFormatted)원"
        contentsLabel.text = book.contents
    }
}
