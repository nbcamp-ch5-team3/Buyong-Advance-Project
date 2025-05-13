//
//  RootTabBarController.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/9/25.
//

import UIKit

final class RootTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
    }
    
    private func setTabBar() {
        self.viewControllers = createTabBarControllers()

        self.tabBar.barTintColor = .systemBackground
        self.tabBar.tintColor = .label
        self.tabBar.unselectedItemTintColor = .gray
    }

    private func createTabBarControllers() -> [UIViewController] {
        let searchVC = createTabBarItem(viewController: SearchViewController(), title: "Search", imageName: "magnifyingglass")
        let SavedBooksVC = createTabBarItem(viewController: SavedBooksViewController(), title: "SavedBooks", imageName: "books.vertical")
        
        return [searchVC, SavedBooksVC]
    }
    
    private func createTabBarItem(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
        viewController.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: imageName), tag: 0)
        return viewController
    }
}

