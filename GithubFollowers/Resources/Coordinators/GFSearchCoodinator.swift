//
//  GFSearchCoodinator.swift
//  GithubFollowers
//
//  Created by Edgar Jonas Mesquita da Silva on 27/01/25.
//

import Foundation
import UIKit

class GFSearchCoodinator {
    var navigationController: UINavigationController?
    
    func start() -> UINavigationController? {
        let viewController = SearchVC(delegate: self)
        navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
}

extension GFSearchCoodinator: SearchProtocol {
    func navigateToFollowers(username: String) {
        let followersListVC = FollowersListVC(username: username)
        followersListVC.title = username
    
        self.navigationController?.pushViewController(followersListVC, animated: true)
    }
}
