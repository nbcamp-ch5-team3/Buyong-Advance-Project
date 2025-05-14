//
//  RecentBookCell.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/14/25.
//

import UIKit
import SnapKit
import Then

final class RecentBookCell: UICollectionViewCell {
    static let id = "RecentBookCell"
    
    let imageView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 40
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.addSubview(imageView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(80)
        }
    }
    
    func configure(with url: String?) {
        print("RecentBookCell configure 호출! 이미지 url: \(url ?? "nil")")
        imageView.image = nil
        guard let url = url, let url = URL(string: url) else { return }
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
    }
}
