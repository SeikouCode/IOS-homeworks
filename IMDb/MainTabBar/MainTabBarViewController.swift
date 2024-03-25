//
//  MainTabBarViewController.swift
//  IMDb
//
//  Created by Aneli  on 16.02.2024.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    // MARK: - Private properties
    
    private let titles: [String] = ["Home", "For you", "Favorites", "Find", "Profile"]
    private let icons: [UIImage?] = [
        UIImage(named: "icon_home"),
        UIImage(named: "icon_for_you"),
        UIImage(named: "icon_favorite"),
        UIImage(named: "icon_search"),
        UIImage(named: "icon_profile"),
    ]
    
    private var allViewControllers = [
        UINavigationController(rootViewController: MainViewController()),
        ForYouViewController(),
//        UINavigationController(rootViewController: /*FavoriteViewController()*/),
        SearchViewController(),
        ProfileViewController()
    ]
    
    // MARK: - ViewController lidecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeTabBarViews()
    }
    
    // MARK: - Private methods
    
    private func makeTabBarViews() {
        view.backgroundColor = .systemGray
        tabBar.tintColor = .black
        tabBar.backgroundColor = .white
        
        setViewControllers(allViewControllers, animated: false)
        
        guard let items = self.tabBar.items else { return }
        
        for i in 0..<items.count {
            items[i].title = titles[i]
            items[i].image = icons[i]
        }
    }
}
