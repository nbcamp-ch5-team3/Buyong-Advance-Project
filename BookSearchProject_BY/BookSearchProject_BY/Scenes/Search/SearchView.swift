//
//  SearchView.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/9/25.
//

import UIKit

import SnapKit
import Then

final class SearchView: UIView {
    
    private let searchBar = UISearchBar().then {
        $0.placeholder = "검색어를 입력하세요"
        $0.searchTextField.backgroundColor = .secondarySystemBackground
        $0.searchBarStyle = .minimal
        $0.tintColor = .label
        
        let textField = $0.searchTextField
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true
        textField.font = UIFont.systemFont(ofSize: 18)
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        // 추후 BookResultCell에서 받아오는걸로 수정
        $0.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        $0.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.id)
        $0.delegate = self
        $0.dataSource = self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.backgroundColor = .systemBackground
        [ searchBar, collectionView ].forEach { self.addSubview($0) }
        setupConstraints()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            guard let sectionType = SearchSection(rawValue: sectionIndex) else { return nil }
            
            switch sectionType {
            case .recentBooks:
                // 최근 본 책 섹션: 가로 스크롤
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .estimated(80),
                    heightDimension: .estimated(80)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .estimated(80),
                    heightDimension: .estimated(100)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 10 // 그룹 간 간격
                section.contentInsets = .init(top: 10, leading: 25, bottom: 30, trailing: 25)
                
                // 섹션 헤더 추가
                let headerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(44)
                )
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
                section.boundarySupplementaryItems = [header]
                return section
                
            case .searchResults:
                // 검색 결과 섹션: 세로 스크롤
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(80)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(80)
                )
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .fixed(10) // 아이템 간 간격
                
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 10
                section.contentInsets = .init(top: 10, leading: 25, bottom: 10, trailing: 25)
                
                // 섹션 헤더 추가
                let headerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(44)
                )
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
                section.boundarySupplementaryItems = [header]
                return section
            }
        }
    }
    
    private func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(15)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(15)
            make.bottom.leading.trailing.equalTo(self.safeAreaLayoutGuide)
        }
    }
}

enum SearchSection: Int, CaseIterable {
    case recentBooks
    case searchResults
    
    var title: String {
        switch self {
        case .recentBooks: return "최근 본 책"
        case .searchResults: return "검색 결과"
        }
    }
}


extension SearchView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SearchSection.allCases.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch SearchSection(rawValue: section) {
        case .recentBooks: return 5
        case .searchResults: return 10
        default : return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        cell.backgroundColor = .systemGray5
        
        if indexPath.section == SearchSection.recentBooks.rawValue {
                cell.layer.cornerRadius = 40
            } else {
                cell.layer.cornerRadius = 8
            }
            cell.clipsToBounds = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SectionHeaderView.id,
            for: indexPath
        ) as? SectionHeaderView else { return UICollectionReusableView() }
        
        let sectionType = SearchSection.allCases[indexPath.section]
        headerView.configure(title: sectionType.title)
        return headerView
    }
}

extension SearchView: UICollectionViewDelegate {
    
}
