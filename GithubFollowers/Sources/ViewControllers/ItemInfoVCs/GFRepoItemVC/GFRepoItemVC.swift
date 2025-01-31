//
//  GFRepoItemVC.swift
//  GithubFollowers
//
//  Created by Edgar Jonas Mesquita da Silva on 29/01/25.
//

import UIKit

class GFRepoItemVC: GFItemInfoVC {
    
    weak var delegate: GFRepoItemVCDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    init(user: User, delegate: GFRepoItemVCDelegate) {
        super.init(user: user)
        self.delegate = delegate
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setup(){
        itemInfoViewOne.setData(type: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.setData(type: .gists, withCount: user.publicGists)
        actionButton.set(color: .systemPurple, title: "Perfil do Github", systemImaneName: "person")
    }
    
    
    override func actionButtonTapped() {
        delegate?.didTapGitHubProfile(for: user)
    }
    
}

protocol GFRepoItemVCDelegate: AnyObject {
    func didTapGitHubProfile(for user: User)
}

