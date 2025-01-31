//
//  UserInfoVC.swift
//  GithubFollowers
//
//  Created by Edgar Jonas Mesquita da Silva on 28/01/25.
//

import Foundation
import UIKit

class UserInfoVC: GFDataLoadingViewVC {
    
    var username: String
    private var user: User?
 
    
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    
    lazy var contentView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 20
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    lazy var headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    lazy var itemViewOne: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    lazy var itemViewTwo: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    lazy var dateLabel: GFBodyLabel = {
        let label = GFBodyLabel(textAlignment: .center)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    init(username: String) {
        self.username = username
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewController()
        getUserInfo()
        setup()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    
    private func checkFavorite(){
        Task { [weak self] in
            guard let self, let user else { return }
            let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
            let isFavorite = await PersistenceManager.checkFavorite(favorite: favorite)
            updateFavoriteIcon(isFavorite: isFavorite)
        }
    }
    
    
    private func updateFavoriteIcon(isFavorite : Bool){
        let image = isFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        let favoriteButton = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(didTapFavorite))
        navigationItem.rightBarButtonItem = favoriteButton
    }
    
    
    private func setupViewController(){
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = false
    }
    
    
    private func getUserInfo(){
        showLoadingView()
        
        UIView.animate(withDuration: 0.25, animations: {
            self.scrollView.alpha = 0
        })
        
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self else { return }
            dismissLoadingView()
            switch result {
                case .success(let user):
                    self.user = user
                    DispatchQueue.main.async { self.configureUIElements() }
                case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Algo aconteceu", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    
    private func configureUIElements(){
        guard let user else { return }
        
        UIView.animate(withDuration: 0.25, animations: {
            self.scrollView.alpha = 1
        })
        
        removeChildViewController(from: headerView)
        removeChildViewController(from: itemViewOne)
        removeChildViewController(from: itemViewTwo)
        
        addViewController(childVC: GFUserInfoHeaderVC(user: user), to: headerView)
        
        addViewController(childVC: GFRepoItemVC(user: user, delegate: self), to: itemViewOne)
       
        addViewController(childVC: GFFollowerItemVC(user: user, delegate: self), to: itemViewTwo)
        
        dateLabel.text = "GitHub desde \(user.createdAt.convertToMonthYearFormat())"
        
        checkFavorite()
    }
    
    
    func removeChildViewController(from view: UIView){
        view.subviews.forEach { $0.removeFromSuperview() }
        
        for childVC in children {
            if childVC.view.isDescendant(of: view){
                childVC.willMove(toParent: nil)
                childVC.view.removeFromSuperview()
                childVC.removeFromParent()
            }
        }
    }
    
    
    @objc
    private func didTapFavorite(){
        guard let user else { return }
        
        let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
        
        PersistenceManager.toogleFavorite(favorite: favorite) { [weak self] result in
            guard let self else { return }
            
            switch result {
                case .success(let isFavorite):
                    updateFavoriteIcon(isFavorite: isFavorite)
                case .failure(let error):
                    presentGFAlertOnMainThread(title: "Algo aconteceu", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    
    private func addViewController(childVC: UIViewController, to containerView: UIView){
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    
    private func setup(){
        setupHierarchy()
        setupConstraints()
    }
    
    
    private func setupHierarchy(){
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [headerView, itemViewOne, itemViewTwo, dateLabel].forEach { view in
            contentView.addArrangedSubview(view)
        }
        
    }
    
    
    private func setupConstraints(){
        let itemHeight: CGFloat = 140
        
        scrollView.pinToEdges(of: view)
        
        contentView.pinToEdges(of: scrollView)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            headerView.heightAnchor.constraint(equalToConstant: 210),
            
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
}


extension UserInfoVC: GFRepoItemVCDelegate {
    
    func didTapGitHubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            presentGFAlertOnMainThread(title: "Link inválido", message: "O link para este usuário está inválido.", buttonTitle: "Ok")
            return
        }
        
        presentSafariVC(with: url)
    }
    
}


extension UserInfoVC: GFFollowerItemVCDelegate {
    
    func didTapGetFollowers(for user: User) {
        guard user.followers != 0 else {
            presentGFAlertOnMainThread(title: "Sem seguidores", message: "\(user.login) não tem seguidores. Que pena 😔", buttonTitle: "Ok")
            return
        }
        
        let followersList = FollowersListVC(username: user.login, delegate: self)
        let navigationController = UINavigationController(rootViewController: followersList)
        present(navigationController, animated: true)
    }
    
}

extension UserInfoVC: FollowerListVCDelegate {
    
    func didRequestFollowers(for username: String) {
        user = nil
        self.username = username
        getUserInfo()
    }
    
}
