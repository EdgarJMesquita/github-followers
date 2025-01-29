//
//  UserInfoVC.swift
//  GithubFollowers
//
//  Created by Edgar Jonas Mesquita da Silva on 28/01/25.
//

import Foundation
import UIKit

class UserInfoVC: UIViewController {
    var username: String
    weak var delegate: FollowerListVCDelegate?
    
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
    
    private func setupViewController(){
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func getUserInfo(){
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self else { return }
            
            switch result {
                case .success(let user):
                    DispatchQueue.main.async { self.configureUIElements(with: user) }
                case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Algo aconteceu", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    private func configureUIElements(with user: User){
        self.addViewController(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
        self.addViewController(childVC: GFRepoItemVC(user: user, delegate: self), to: self.itemViewOne)
        self.addViewController(childVC: GFFollowerItemVC(user: user, delegate: self), to: self.itemViewTwo)
        self.dateLabel.text = "GitHub desde \(user.createdAt.convertToMonthYearFormat())"
    }
    
    @objc
    private func dismissVC(){
        dismiss(animated: true)
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
        view.addSubview(headerView)
        view.addSubview(itemViewOne)
        view.addSubview(itemViewTwo)
        view.addSubview(dateLabel)
    }
    
    private func setupConstraints(){
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: padding),
            itemViewOne.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: padding),
            itemViewTwo.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding ),
            dateLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: padding),
            dateLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}


protocol UserInfoVCDelegate: AnyObject {
    func didTapGitHubProfile(for user: User)
    func didTapGetFollowers(for user: User)
}

extension UserInfoVC: UserInfoVCDelegate {
    
    func didTapGitHubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            presentGFAlertOnMainThread(title: "Link inválido", message: "O link para este usuário está inválido.", buttonTitle: "Ok")
            return
        }
        
        presentSafariVC(with: url)
    }
    
    func didTapGetFollowers(for user: User) {
        guard user.followers != 0 else {
            presentGFAlertOnMainThread(title: "Sem seguidores", message: "\(user.login) não tem seguidores. Que pena 😔", buttonTitle: "Ok")
            return
        }

        delegate?.didRequestFollowers(for: user.login)
        dismissVC()
    }
    
}
