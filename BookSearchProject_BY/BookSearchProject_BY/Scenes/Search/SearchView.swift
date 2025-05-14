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
    
    weak var delegate: SearchViewDelegate?
    
    // 책 목록이 바뀌면 검색 결과 부분만 새로고침(View 내부에서 UI 새로고침)
    var searchResults: [Book] = [] {
        didSet {
            collectionView.reloadSections(IndexSet(integer: SearchSection.searchResults.rawValue))
        }
    }
    
    var recentBooks: [RecentBook] = [] {
        didSet {
            collectionView.reloadSections(IndexSet(integer: SearchSection.recentBooks.rawValue))
        }
    }
    
    var searchBar = UISearchBar().then {
        $0.placeholder = "검색어를 입력하세요"
        $0.searchTextField.backgroundColor = .secondarySystemBackground
        $0.searchBarStyle = .minimal
        $0.tintColor = .label
        
        let textField = $0.searchTextField
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true
        textField.font = UIFont.systemFont(ofSize: 17)
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.register(RecentBookCell.self, forCellWithReuseIdentifier: RecentBookCell.id)
        $0.register(SearchEmptyStateCell.self, forCellWithReuseIdentifier: SearchEmptyStateCell.id)
        $0.register(SearchResultCell.self, forCellWithReuseIdentifier: SearchResultCell.id)
        $0.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.id)
        $0.delegate = self
        $0.dataSource = self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        searchBar.delegate = self
        setup()
        reloadSearchResults()
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
                    widthDimension: .absolute(80),
                    heightDimension: .estimated(100)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 10
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
    
    // 데이터 갱신 함수
    func reloadSearchResults() {
        collectionView.reloadSections(IndexSet(integer: SearchSection.searchResults.rawValue))
    }
    
    func reloadRecentBooks(oldBooks: [RecentBook], newBooks: [RecentBook]) {
        guard oldBooks.count == newBooks.count else { return }
        for i in 0..<newBooks.count {
            if oldBooks[i] != newBooks[i] {
                let indexPath = IndexPath(row: i, section: SearchSection.recentBooks.rawValue)
                collectionView.reloadItems(at: [indexPath])
            }
        }
    }
}
