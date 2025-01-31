//
//  FollowersListViewModel.swift
//  GithubFollowers
//
//  Created by Edgar Jonas Mesquita da Silva on 31/01/25.
//

import UIKit

class FollowersListViewModel {
    
    private var page: Int = 1
    
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var filter: String?
    var hasMoreFollowers = true
    var isSearching = false
    let username: String
    
    weak var delegate: FollowersListViewModelDelegate?
    
    init(username: String, delegate: FollowersListViewModelDelegate) {
        self.username = username
        self.delegate = delegate
    }
    
    func getFollowers(){
        delegate?.didChangeLoadingState(isLoading: true)
        
        Task {
            do {
                let followers = try await NetworkManager.shared.getFollowers(for: username, page: page)
                updateFollowers(with: followers)
                delegate?.didChangeLoadingState(isLoading: false)
            } catch let error {
                if let gfError = error as? GFError  {
                    delegate?.onShowAlert(with: gfError.rawValue)
                } else {
                    delegate?.onShowAlert(with: "")
                }
                delegate?.didChangeLoadingState(isLoading: false)
            }
        }
    }
    
    var activeFollowers: [Follower] {
        isSearching ? filteredFollowers : followers
    }
    
    func nextPage(){
        guard hasMoreFollowers else { return }
        page += 1
        getFollowers()
    }
    
    private func updateFollowers(with newFollowers:[Follower]) {
        if newFollowers.count < 100 {
            hasMoreFollowers = false
        }
    
        followers.append(contentsOf: newFollowers)

        if isSearching, let filter, !filter.isEmpty  {
            filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
            delegate?.didChangeFollowers(followers: filteredFollowers)
            return
        }
        
        delegate?.didChangeFollowers(followers: self.followers)
    }
    
    func onSearch(for searchController: UISearchController){
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredFollowers.removeAll()
            delegate?.didChangeFollowers(followers: followers)
            isSearching = false
            return
        }
        isSearching = true
        
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        delegate?.didChangeFollowers(followers: filteredFollowers)
    }
}

protocol FollowersListViewModelDelegate: AnyObject {
    
    func onShowAlert(with message: String?)
    
    func didChangeLoadingState(isLoading: Bool)
    
    func didChangeFollowers(followers: [Follower])
    
}
