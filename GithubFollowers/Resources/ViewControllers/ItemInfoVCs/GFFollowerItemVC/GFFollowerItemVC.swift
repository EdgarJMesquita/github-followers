//
//  GFFollowerItemVC.swift
//  GithubFollowers
//
//  Created by Edgar Jonas Mesquita da Silva on 29/01/25.
//

import UIKit

class GFFollowerItemVC: GFItemInfoVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        itemInfoViewOne.setData(type: .followers, withCount: user.followers)
        itemInfoViewTwo.setData(type: .following, withCount: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "Ver Seguidores")
 
    }
    
    override func actionButtonTapped() {
        delegate?.didTapGetFollowers(for: user)
    }
}

