//
//  SearchView.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/9/25.
//

import UIKit

import SnapKit
import Then
import RxCocoa
import Kingfisher

final class SearchView: UIView {
    
    // MARK: - Properties
    weak var delegate: SearchViewDelegate?
    private(set) var searchResults: [Book] = []
    private(set) var recentBooks: [RecentBook] = []
    
    // MARK: - UI Components
    private(set) var searchBar = UISearchBar().then {
        $0.placeholder = "검색어를 입력하세요"
        $0.searchTextField.backgroundColor = .secondarySystemBackground
        $0.searchBarStyle = .minimal
        $0.tintColor = .label
        
        let textField = $0.searchTextField
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true
        textField.font = UIFont.systemFont(ofSize: 17)
    }
    
    private(set) lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.backgroundColor = .clear
        $0.dataSource = self
    }
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        reloadSearchResults()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setup() {
        self.backgroundColor = .systemBackground
        [ searchBar, collectionView ].forEach { self.addSubview($0) }
        setupConstraints()
        setupRegiserCells()
    }
    
    private func setupRegiserCells() {
        collectionView.register(RecentBookCell.self, forCellWithReuseIdentifier: RecentBookCell.id)
        collectionView.register(SearchEmptyStateCell.self, forCellWithReuseIdentifier: SearchEmptyStateCell.id)
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: SearchResultCell.id)
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.id)
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
    
    // MARK: - Private Methods
    // 데이터 갱신 함수
    private func reloadSearchResults() {
        collectionView.reloadSections(IndexSet(integer: SearchSection.searchResults.rawValue))
    }
    
    private func reloadRecentBooks(oldBooks: [RecentBook], newBooks: [RecentBook]) {
        guard oldBooks.count == newBooks.count else { return }
        for i in 0..<newBooks.count {
            if oldBooks[i] != newBooks[i] {
                let indexPath = IndexPath(row: i, section: SearchSection.recentBooks.rawValue)
                collectionView.reloadItems(at: [indexPath])
            }
        }
    }
    
    // MARK: - Public Methods
    func configure(delegate: SearchViewDelegate?) {
        self.delegate = delegate
    }
    
    func update(searchResults: [Book]) {
        self.searchResults = searchResults
        collectionView.reloadSections(IndexSet(integer: SearchSection.searchResults.rawValue))
    }
    
    func update(recentBooks: [RecentBook]) {
        self.recentBooks = recentBooks
        collectionView.reloadSections(IndexSet(integer: SearchSection.recentBooks.rawValue))
    }
    
    func setCollectionViewDelegate(_ delegate: UICollectionViewDelegate) {
        collectionView.delegate = delegate
    }
    
    func setSearchBarDelegate(_ delegate: UISearchBarDelegate) {
        searchBar.delegate = delegate
    }
}
