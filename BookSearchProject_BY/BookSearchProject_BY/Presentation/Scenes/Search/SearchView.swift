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
    
    /// 컬렉션뷰 셀 등록
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
    /// 최근 본 책의 변경된 부분만 리로드 (최적화)
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
    /// delegate 설정
    func configure(delegate: SearchViewDelegate?) {
        self.delegate = delegate
    }
    
    /// 컬렉션뷰 delegate 설정
    func setCollectionViewDelegate(_ delegate: UICollectionViewDelegate) {
        collectionView.delegate = delegate
    }
    
    /// 검색 결과 데이터 갱신
    func update(searchResults: [Book]) {
        self.searchResults = searchResults
        collectionView.reloadSections(IndexSet(integer: SearchSection.searchResults.rawValue))
    }
    
    /// 최근 본 책 데이터 갱신
    func update(recentBooks: [RecentBook]) {
        let oldBooks = self.recentBooks
        self.recentBooks = recentBooks
        
        if oldBooks.count == recentBooks.count {
            // 개수가 같을 때는 변경된 아이템만 업데이트
            reloadRecentBooks(oldBooks: oldBooks, newBooks: recentBooks)
        } else {
            // 개수가 다르면 섹션 전체 리로드
            collectionView.reloadSections(IndexSet(integer: SearchSection.recentBooks.rawValue))
        }
    }
}

// MARK: - UICollectionViewDataSource 구현
extension SearchView: UICollectionViewDataSource {
    /// 섹션 개수 반환
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SearchSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch SearchSection(rawValue: section) {
        case .searchResults:
            return max(searchResults.count, 1) /// 빈 상태일 때 1개
        case .recentBooks:
            return recentBooks.count
        default:
            return 0
        }
    }
    
    /// 셀 반환 (검색 결과, 최근 본 책, 빈 상태 셀)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = SearchSection(rawValue: indexPath.section)
        
        switch section {
        case .recentBooks:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentBookCell.id, for: indexPath) as? RecentBookCell else { return UICollectionViewCell()
            }
            
            let book = recentBooks[indexPath.row]
            cell.layer.cornerRadius = 40
            cell.clipsToBounds = true
            cell.configure(with: book.thumbnailImage)
            return cell
            
        case .searchResults:
            guard !searchResults.isEmpty else {
                return collectionView.dequeueReusableCell(withReuseIdentifier: SearchEmptyStateCell.id, for: indexPath)
            }
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SearchResultCell.id, for: indexPath
            ) as? SearchResultCell else { return UICollectionViewCell()
            }
            
            guard indexPath.row < searchResults.count else { /// searchResults 접근 시 index 범위 검사
                print("Invalid indexPath: \(indexPath.row), count: \(searchResults.count)")
                return UICollectionViewCell()
            }
            
            let book = searchResults[indexPath.row]
            cell.configure(with: book)
            return cell
            
        case .none:
            return UICollectionViewCell()
        }
    }
    
    /// 섹션 헤더 반환
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            fatalError("지원하지 않는 kind")
        }
        let sectionType = SearchSection.allCases[indexPath.section]
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SectionHeaderView.id,
            for: indexPath
        ) as! SectionHeaderView
        
        // recentBooks가 없으면 헤더 숨김
        if sectionType == .recentBooks && recentBooks.isEmpty {
            headerView.isHidden = true
        } else {
            headerView.isHidden = false
            headerView.configure(title: sectionType.title)
        }
        return headerView
    }
}
