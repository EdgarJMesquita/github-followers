//
//  FavoritesListVC.swift
//  GithubFollowers
//
//  Created by Edgar Jonas Mesquita da Silva on 17/01/25.
//

import Foundation
import UIKit

class FavoritesListVC: GFDataLoadingViewVC {
    
    private let viewModel = FavoritesListViewModel()
 
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.identifier)
        tableView.rowHeight = 80
     
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindTableViewDelegate()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadFavorites()
        setupNavigationItem()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
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
        return viewModel.favorites.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.identifier, for: indexPath) as? FavoriteCell else {
            return UITableViewCell()
        }
        
        let favorite = viewModel.favorites[indexPath.row]
       
        cell.configure(with: favorite)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = viewModel.favorites[indexPath.row]
        
        let userInfoVC = UserInfoVC(username: favorite.login)
        
        navigationController?.pushViewController(userInfoVC, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard editingStyle == .delete else { return }
        
        viewModel.removeFavorite(atIndex: indexPath.row) { [weak self] in
            guard let self else { return }
            tableView.deleteRows(at: [indexPath], with: .left)
            
            if viewModel.favorites.isEmpty {
                showEmptyStateView(with: "Sem favoritos?\nAdicione um na tela de seguidores.", in: view)
                return
            }
        }
    }
    
}

extension FavoritesListVC: FavoritesListViewModelDelegate {
    
    func didLoadFavorites(isEmpty: Bool) {
        tableView.reloadData()
        if isEmpty {
            showEmptyStateView(with: "Sem favoritos?\nAdicione um na tela de seguidores.", in: view)
            return
        }   
        dismissEmptyStateView()
    }
    
    func onAlert(message: String) {
        presentGFAlertOnMainThread(title: "Algo aconteceu", message: message, buttonTitle: "Ok")
    }
    
}
