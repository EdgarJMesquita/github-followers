//
//  FollowersListVC.swift
//  GithubFollowers
//
//  Created by Edgar Jonas Mesquita da Silva on 19/01/25.
//

import Foundation
import UIKit

class FollowersListVC: UIViewController {
    enum Section {
        case main
    }
    
    private var username: String
    private var page: Int = 1
    private var dataSource: UICollectionViewDiffableDataSource<Section, Follower>?
    private var followers: [Follower] = []
    private var filteredFollowers: [Follower] = []
    private var hasMoreFollowers = true
    private var isSearching = false
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: UIHelper.createThreeTableColumnFlowLayout(in: view))
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    init(username: String) {
        self.username = username
        super.init(nibName: nil, bundle: nil)
        title = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getFollowers(username: username, page: page)
        configureDataSource()
        bindCollectionView()
        configureSearchController()
    }
    
    private func configureDataSource(){
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, follower in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: FollowerCell.identifier,
                    for: indexPath) as? FollowerCell
                else {
                    return UICollectionViewCell()
                }
                
                cell.set(follower: follower)
                return cell
            }
        )
    }
    
    private func bindCollectionView(){
        collectionView.delegate = self
    }
    
    private func updateData(on followers: [Follower]){
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        self.dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func configureSearchController(){
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Pesquise pelo usuário"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func getFollowers(username: String, page: Int){
        showLoadingView()
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            guard let self else { return }
            self.dismissLoadingView()
            switch result {
                case .success(let followers):
                    if followers.count < 100 {
                        self.hasMoreFollowers = false
                    }
                
                    self.followers.append(contentsOf: followers)
                    
                    if self.followers.isEmpty {
                        let message = "Esse usuário ainda não tem seguidores. Vá lá e siga! 🤓"
                        DispatchQueue.main.async { self.showEmptyStateView(with: message, in: self.view) }
                        return
                    }
    
                    self.updateData(on: self.followers)
                case .failure(let error):
                    self.presentGFAlertOnMainThread(title: "Algo aconteceu", message: error.rawValue, buttonTitle: "ok")
            }
        }
    }
    
    @objc
    private func addButtonTapped(){
        self.showLoadingView()
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self else { return }
            self.dismissLoadingView()
            
            switch result {
                case .success(let user):
                    let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
                    PersistenceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
                        if let error  {
                            self?.presentGFAlertOnMainThread(title: "Algo aconteceu", message: error.rawValue, buttonTitle: "Ok")
                            return
                        }
                        self?.presentGFAlertOnMainThread(title: "Sucesso", message: "Você favoritou \(user.login) 🥳", buttonTitle: "Hooray!")
                    }
                    break
                case .failure(let error):
                    self.presentGFAlertOnMainThread(title: "Algo aconteceu", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    private func setup(){
        view.backgroundColor = .systemBackground

        setupNavigationItem()
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupNavigationItem(){
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func setupHierarchy(){
        view.addSubview(collectionView)
    }
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension FollowersListVC: UICollectionViewDelegate{
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMoreFollowers else { return }
            page += 1
            getFollowers(username: username, page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredFollowers : followers
        let follower = activeArray[indexPath.item]
        
        let userInfoVC = UserInfoVC(username: username)
        userInfoVC.username = follower.login
        userInfoVC.delegate = self
        let navController = UINavigationController(rootViewController: userInfoVC)
        present(navController, animated: true)
    }
}

extension FollowersListVC: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            return
        }
        isSearching = true
        
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredFollowers)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        updateData(on: followers)
        isSearching = false
    }
}

protocol FollowerListVCDelegate: AnyObject {
    func didRequestFollowers(for username: String)
}

extension FollowersListVC: FollowerListVCDelegate {
    func didRequestFollowers(for username: String) {
        page = 1
        followers.removeAll()
        filteredFollowers.removeAll()
        self.username = username
        title = username
        collectionView.setContentOffset(.zero, animated: true)
        NetworkManager.shared.cache.removeAllObjects()
        getFollowers(username: username, page: page)
        dismiss(animated: true)
    }
}
