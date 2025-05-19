//
//  RootTabBarController.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/9/25.
//

import UIKit

// MARK: - 루트 탭바 컨트롤러
final class RootTabBarController: UITabBarController {

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    // MARK: - Setup
    /// 탭바의 뷰컨트롤러와 색상을 설정하는 함수
    private func setupTabBar() {
        self.viewControllers = createTabBarControllers()

        self.tabBar.barTintColor = .systemBackground
        self.tabBar.tintColor = .label
        self.tabBar.unselectedItemTintColor = .gray
    }

    // MARK: - Private Methods
    /// 각 탭에 들어갈 뷰컨트롤러 배열을 생성하는 함수
    private func createTabBarControllers() -> [UIViewController] {
        /// Search Tab
        let searchVC = createTabBarItem(viewController: SearchViewController(),
                                        title: "Search",
                                        imageName: "magnifyingglass"
        )
        
        /// SavedBooks Tab
        let savedBooksVC = SavedBooksViewController() /// 기본 초기화 사용
        let savedBooksNavController = createTabBarItem(
            viewController: UINavigationController(rootViewController: savedBooksVC),
            title: "SavedBooks",
            imageName: "books.vertical"
        )
        
        return [searchVC, savedBooksNavController]
    }
    
    /// 탭바 아이템을 생성하고 뷰컨트롤러에 적용하는 함수
    private func createTabBarItem(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
        viewController.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: imageName), tag: 0)
        return viewController
    }
}

