//
//  FavoritesListVC.swift
//  GithubFollowers
//
//  Created by Edgar Jonas Mesquita da Silva on 17/01/25.
//

import Foundation
import UIKit

class FavoritesListVC: UIViewController {
    var favorites: [Follower] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.identifier)
        tableView.rowHeight = 80
     
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationItem()
        bindTableViewDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
    }
    
    private func getFavorites(){
        PersistenceManager.retrieveFavorites { [weak self] result in
            guard let self else { return }
            switch result {
                case .success(let favorites):
                    if favorites.isEmpty {
                        self.showEmptyStateView(with: "Sem favoritos?\nAdicione um na tela de seguidores.", in: view)
                        return
                    }
                    self.favorites = favorites
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.view.bringSubviewToFront(self.tableView)
                    }
                    
                case .failure(let error):
                    self.presentGFAlertOnMainThread(title: "Algo aconteceu", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    private func bindTableViewDelegate(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupUI(){
        view.backgroundColor = .systemBackground
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupHierarchy(){
        view.addSubview(tableView)
    }
    
    private func setupConstraints(){
        tableView.frame = view.bounds
    }
    
    private func setupNavigationItem(){
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Favoritos"
    }
}

extension FavoritesListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.identifier, for: indexPath) as? FavoriteCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: favorites[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let followerListVC = FollowersListVC(username: favorite.login)
        
        navigationController?.pushViewController(followerListVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard editingStyle == .delete else { return }
        
        let favorite = favorites[indexPath.row]
        favorites.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
        
        PersistenceManager.updateWith(favorite: favorite, actionType: .remove) { [weak self] error in
            guard let self else { return }
            
            guard let error else { return }
            
            self.presentGFAlertOnMainThread(title: "Algo aconteceu", message: error.rawValue, buttonTitle: "Ok")
            
        }
    }
}
