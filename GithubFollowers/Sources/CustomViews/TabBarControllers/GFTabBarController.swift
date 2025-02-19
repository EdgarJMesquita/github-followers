//
//  GFTabBarController.swift
//  GithubFollowers
//
//  Created by Edgar Jonas Mesquita da Silva on 29/01/25.
//

import Foundation
import UIKit

class GFTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemGreen
        
        UINavigationBar.appearance().tintColor = .systemGreen

        viewControllers = [createSearchNC(), createFavoritesListNC()]
    }
    
    func createSearchNC() -> UINavigationController {
        let searchVC = SearchVC()
        searchVC.title = "Procurar"
        searchVC.tabBarItem = UITabBarItem(title: "Procurar", image: UIImage(systemName: "magnifyingglass"), tag: 0)
        return UINavigationController(rootViewController: searchVC)
    }

    func createFavoritesListNC() -> UINavigationController {
        let favoritesListVC = FavoritesListVC()
        favoritesListVC.title = "Favoritos"
        favoritesListVC.tabBarItem = UITabBarItem(title: "Favoritos", image: UIImage(systemName: "star.fill"), tag: 1)
        return UINavigationController(rootViewController: favoritesListVC)
    }
}
