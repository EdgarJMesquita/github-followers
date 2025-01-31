//
//  GFFollowerItemVC.swift
//  GithubFollowers
//
//  Created by Edgar Jonas Mesquita da Silva on 29/01/25.
//

import UIKit

class GFFollowerItemVC: GFItemInfoVC {
    
    weak var delegate: GFFollowerItemVCDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    init(user: User, delegate: GFFollowerItemVCDelegate) {
        super.init(user: user)
        self.delegate = delegate
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

protocol GFFollowerItemVCDelegate: AnyObject {
    func didTapGetFollowers(for user: User)
}
