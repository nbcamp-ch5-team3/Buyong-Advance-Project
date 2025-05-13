//
//  SearchView.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/9/25.
//

import UIKit

import SnapKit
import Then

protocol SearchViewDelegate: AnyObject {
    func searchView(_ searchView: SearchView, didSearch text: String)
    func searchView(_ searchView: SearchView, didSelectBook book: Book)
}

final class SearchView: UIView {
    
    weak var delegate: SearchViewDelegate?
    
    // 책 목록이 바뀌면 검색 결과 부분만 새로고침(View 내부에서 UI 새로고침)
    var searchResults: [Book] = [] {
        didSet {
            collectionView.reloadSections(IndexSet(integer: SearchSection.searchResults.rawValue))
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
        $0.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
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
                    widthDimension: .estimated(80),
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
        case .searchResults:
            return max(searchResults.count, 1) // 빈 상태일 때 1개
        case .recentBooks:
            return 5
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = SearchSection(rawValue: indexPath.section)
        
        switch section {
        case .recentBooks:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            cell.backgroundColor = .systemGray5
            cell.layer.cornerRadius = 40
            cell.clipsToBounds = true
            return cell
        case .searchResults:
            if searchResults.isEmpty {
                return collectionView.dequeueReusableCell(withReuseIdentifier: SearchEmptyStateCell.id, for: indexPath)
            } else {
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: SearchResultCell.id, for: indexPath
                ) as? SearchResultCell else { return UICollectionViewCell() }
                guard indexPath.row < searchResults.count else { /// searchResults 접근 시 index 범위 검사
                    print("Invalid indexPath: \(indexPath.row), count: \(searchResults.count)")
                    return UICollectionViewCell()
                }
                let book = searchResults[indexPath.row]
                cell.configure(with: book)
                return cell
            }
        default:
            return UICollectionViewCell()
        }
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = SearchSection(rawValue: indexPath.section) else { return }
        
        switch section {
        case .searchResults:
            guard !searchResults.isEmpty else { return }
            guard indexPath.row < searchResults.count else { return }
            let selectedBook = searchResults[indexPath.row]
            delegate?.searchView(self, didSelectBook: selectedBook)
        case .recentBooks:
            // 최근 본 책 선택 처리
            break
        }
    }
}

extension SearchView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        delegate?.searchView(self, didSearch: searchBar.text ?? "")
    }
}
