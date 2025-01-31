//
//  FollowersListVC.swift
//  GithubFollowers
//
//  Created by Edgar Jonas Mesquita da Silva on 19/01/25.
//

import Foundation
import UIKit

class FollowersListVC: GFDataLoadingViewVC {
    
    enum Section {
        case main
    }
    
    weak var delegate: FollowerListVCDelegate?
    private var dataSource: UICollectionViewDiffableDataSource<Section, Follower>?
    private var viewModel: FollowersListViewModel?
    
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: UIHelper.createThreeTableColumnFlowLayout(in: view))
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    
    init(username: String, delegate: FollowerListVCDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = FollowersListViewModel(username: username, delegate: self)
        title = "Seguidores"
        self.delegate = delegate
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewModel?.getFollowers()
  
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
        DispatchQueue.main.async {
            var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
            snapshot.appendSections([.main])
            snapshot.appendItems(followers)
            self.dataSource?.apply(snapshot, animatingDifferences: true)
        }
    }
    
    
    private func configureSearchController(){
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Pesquise pelo usuário"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    
    private func setup(){
        view.backgroundColor = .systemBackground

        setupNavigationItem()
        setupHierarchy()
        setupConstraints()
    }
    
    
    private func setupNavigationItem(){
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    
    override func updateContentUnavailableConfiguration(using state: UIContentUnavailableConfigurationState) {
        if let viewModel, viewModel.isSearching && viewModel.activeFollowers.isEmpty {
//            var config = UIContentUnavailableConfiguration.empty()
//            config.image = .init(systemName: "person.slash")
//            config.text = "Sem seguidores"
//
            contentUnavailableConfiguration = UIContentUnavailableConfiguration.search()
        } else {
            contentUnavailableConfiguration = nil
        }
    }
    
    @objc
    private func dismissVC(){
        dismiss(animated: true)
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
            viewModel?.nextPage()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let follower = viewModel?.activeFollowers[indexPath.item] else {
            return
        }
        
        delegate?.didTapFollower(for: follower.login)
        
        dismiss(animated: true)
    }
    
}

extension FollowersListVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        viewModel?.onSearch(for: searchController)
        setNeedsUpdateContentUnavailableConfiguration()
    }
    
}

extension FollowersListVC: FollowersListViewModelDelegate {
    
    func onShowAlert(with message: String?) {
        if let message {
            presentGFAlertOnMainThread(title: "Algo aconteceu", message: message, buttonTitle: "Ok")
        } else {
            presentDefaultError()
        }
    }
    
    
    func didChangeLoadingState(isLoading: Bool) {
        isLoading ? showLoadingView() : dismissLoadingView()
    }
    
    
    func didChangeFollowers(followers: [Follower]) {
        updateData(on: followers)
    }
    
}

protocol FollowerListVCDelegate: AnyObject {
    
    func didTapFollower(for username: String)
    
}
