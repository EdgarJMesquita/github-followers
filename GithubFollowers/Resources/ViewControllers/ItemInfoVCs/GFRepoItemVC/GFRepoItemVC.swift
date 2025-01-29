//
//  GFRepoItemVC.swift
//  GithubFollowers
//
//  Created by Edgar Jonas Mesquita da Silva on 29/01/25.
//

import UIKit

class GFRepoItemVC: GFItemInfoVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        itemInfoViewOne.setData(type: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.setData(type: .gists, withCount: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "Perfil do Github")
    }
    
    override func actionButtonTapped() {
        delegate?.didTapGitHubProfile(for: user)
    }
}
