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

class BookDetailModalView: UIView {
    
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
        setupDummyData()
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
            make.width.equalTo(120)
            make.height.equalTo(300)
            make.centerX.equalToSuperview()
        }
        
       contentStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(scrollView.snp.width).offset(-50)
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
    
    private func setupDummyData() {
        titleLabel.text = "해리포터와 아즈카반의 죄수 (Harry Potter and the Prisoner of Azkaban)"
        
        authorLabel.text = "J.K. 롤링 지음 | 문학수첩"
        
        if let url = URL(string: "https://image.yes24.com/goods/82946464/XL") {
            thumbnailImageView.kf.setImage(with: url)
        }
        
        priceLabel.text = "가격: 15,800원"
        
        contentsLabel.text = """
        호그와트 마법학교 3학년이 된 해리 포터. 이번에는 아즈카반이라는 마법사 감옥을 탈출한 죄수 시리우스 블랙이라는 살인마가 해리를 노린다는 소문이 돌지만, 해리는 호그와트에서 평소와 다름없이 생활한다.
        
        새 학기가 시작되고 디멘터라는 무시무시한 생명체가 호그와트를 지키게 되고, 해리는 이 디멘터와 마주칠 때마다 기절하고 만다. 루핀 교수의 도움으로 패트로누스 마법을 배우면서 디멘터에 대항하는 법을 익히게 되는데...
        
        해리는 시리우스 블랙의 진짜 정체와 부모님의 죽음에 얽힌 진실을 알게 되면서 예상치 못한 모험을 하게 됩니다.
        """
    }
}
