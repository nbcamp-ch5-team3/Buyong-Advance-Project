# 📚 Buyong Advance Project

## 1. 프로젝트 소개

Buyong Advance Project는 사용자가 다양한 책 정보를 쉽고 빠르게 검색하고, 관심 있는 책을 즐겨찾기하거나 최근 본 책을 한눈에 확인할 수 있는 iOS 앱  
카카오 책 검색 API를 활용해 실시간으로 도서 정보를 제공하며, 직관적인 UI와 간편한 책 관리 경험을 목표로 개발

---

## 2. 기술 스택 및 의존성

- **언어**: Swift
- **프레임워크**: UIKit, CoreData
- **아키텍처**: Clean Architecture, MVVM
- **라이브러리/툴**  
  - SnapKit (UI 레이아웃)
  - Kingfisher (이미지 캐싱)
  - RxSwift (반응형 프로그래밍)
  - Then (초기화 코드 간결화)
  - Kakao Book Search API (외부 데이터)

---

## 3. 폴더/아키텍처 구조

- **App**: 앱 진입점, AppDelegate, SceneDelegate 등 관리
- **Common**: Extension, Util 등 공통 기능 모음
- **Data**: CoreData, Network, Repository(구현) 담당
- **Domain**: Entity, Repository(인터페이스), UseCase 등 비즈니스 로직 구성
- **Presentation**: View, ViewController, ViewModel, Scene별 UI 구성
- **Resource**: 이미지, Info.plist 등 리소스 관리

```
BookSearchProject_BY
├── App
│   ├── AppDelegate.swift
│   ├── LaunchScreen.storyboard
│   └── SceneDelegate.swift
├── Common
│   └── Extension
│       ├── Int+.swift
│       └── Keyboard+.swift
├── Data
│   ├── CoreData
│   │   ├── Manager
│   │   │   ├── BookSearchProject_BY.xcdatamodeld
│   │   │   ├── RecentBook+CoreDataClass.swift
│   │   │   ├── RecentBook+CoreDataProperties.swift
│   │   │   ├── SavedBook+CoreDataClass.swift
│   │   │   └── SavedBook+CoreDataProperties.swift
│   ├── Network
│   │   ├── NetworkError.swift
│   │   └── NetworkManager.swift
│   └── Repository
│       ├── RecentBooksRepositoryImpl.swift
│       ├── SavedBookRepositoryImpl.swift
│       └── SearchBooksRepositoryImpl.swift
├── Domain
│   ├── Entity
│   │   ├── Book.swift
│   │   ├── BookResponse.swift
│   │   ├── SearchSection.swift
│   │   └── SearchState.swift
│   ├── Repository
│   │   ├── RecentBooksRepository.swift
│   │   ├── SavedBookRepository.swift
│   │   └── SearchRepository.swift
│   └── UseCase
│       ├── RecentBooksUseCase.swift
│       ├── SavedBookUseCase.swift
│       └── SearchBooksUseCase.swift
├── Presentation
│   ├── Common
│   │   └── SectionHeaderView.swift
│   ├── Core
│   │   └── RootTabBarController.swift
│   ├── Scenes
│   │   ├── BookDetailModal
│   │   │   ├── BookDetailModalView.swift
│   │   │   └── BookDetailModalViewController.swift
│   │   ├── SavedBooks
│   │   │   ├── Components
│   │   │   │   ├── SavedBooksTableViewCell.swift
│   │   │   │   └── SavedEmptyStateCell.swift
│   │   │   ├── SavedBooksView.swift
│   │   │   └── SavedBooksViewController.swift
│   │   └── Search
│   │       ├── Components
│   │       │   ├── RecentBookCell.swift
│   │       │   ├── SearchEmptyStateCell.swift
│   │       │   └── SearchResultCell.swift
│   │       ├── SearchView.swift
│   │       └── SearchViewController.swift
│   └── ViewModel
│       ├── SavedBooksViewModel.swift
│       └── SearchViewModel.swift
└── Resource
    ├── Assets.xcassets
    └── Info.plist
```

아키텍처는 Clean Architecture 기반으로 Domain, Data, Presentation 계층을 분리해 유지보수성과 확장성 강화

---

## 4. 설치 및 실행 방법

1. 저장소 클론  
   ```
   git clone https://github.com/nbcamp-ch5-team3/Buyong-Advance-Project.git
   ```
2. 의존성 설치  
   - CocoaPods  
     ```
     pod install
     ```
   - 또는 Swift Package Manager 사용 시 Xcode에서 자동 설치
3. Xcode에서 `.xcworkspace` 파일 열기
4. 실행 기기 선택 후 빌드 및 실행 (`⌘ + R`)

---

## 5. 주요 기능 및 기기 별 출력 화면

| ![iPhone 16 Pro](https://github.com/user-attachments/assets/01e40540-c8ba-4b56-bda7-ac39d1e95dab) | ![iPad mini (A17 Pro)](https://github.com/user-attachments/assets/80072e23-3e52-42be-abca-08d69b677258) | ![iPhone SE (3rd generation)](https://github.com/user-attachments/assets/0f9f8a5a-7a05-4c4e-9dab-bf50947536d0) |
| --- | --- | --- |
| iPhone 16 Pro | iPad mini (A17 Pro) | iPhone SE (3rd generation) |
| --- | --- | --- |
|![다크모드 대응](https://github.com/user-attachments/assets/fdfd103f-3d00-496c-bc23-8a35c4e9f788) | ![가로모드 대응](https://github.com/user-attachments/assets/8128be9e-eb3c-4efb-ae25-19be4a0ca200) | ![무한스크롤 구현](https://github.com/user-attachments/assets/e147438a-9b5b-4be0-8b0e-20a31cc735be) |
| --- | --- | --- |
| 다크모드 대응 | 가로모드 대응 | 무한스크롤 구현 |



---

## 6. 사용법/시나리오

1. 앱 실행 후 상단의 검색창에 책 제목이나 저자명 입력  
2. 검색 결과 리스트에서 원하는 책 선택  
3. 선택한 책의 상세 정보 화면에서 책 표지, 제목, 저자, 출판사, 설명 등 확인  
4. 상세 정보 화면에서 '즐겨찾기' 버튼을 눌러 관심 있는 책을 즐겨찾기 목록에 추가  
5. 하단 탭바의 '즐겨찾기' 메뉴에서 내가 저장한 책 리스트 확인 및 삭제  
6. 최근 본 책은 별도의 메뉴에서 자동으로 기록되어 다시 확인 가능  
7. 여러 기기에서 동일한 흐름으로 책 검색, 정보 확인, 즐겨찾기, 최근 본 책 관리 가능

---

## 10. 참고 자료

- [개인 노션 자료](https://daffodil-twist-1a4.notion.site/iOS-19e6b5542f2980d69684cfd775b8408d)
- [카카오 책 검색 API 공식 문서](https://developers.kakao.com/docs/latest/ko/daum-search/dev-guide#search-book)
