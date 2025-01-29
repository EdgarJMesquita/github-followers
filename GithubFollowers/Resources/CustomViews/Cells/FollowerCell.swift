//
//  FollowerCell.swift
//  GithubFollowers
//
//  Created by Edgar Jonas Mesquita da Silva on 26/01/25.
//

import Foundation
import UIKit

class FollowerCell: UICollectionViewCell {
    static let identifier = "FollowerCell"
    
    lazy var avatarImageView: GFAvatarImageView = {
        let imageVIew = GFAvatarImageView(frame: .zero)
        imageVIew.translatesAutoresizingMaskIntoConstraints = false
        return imageVIew
    }()
    
    lazy var usernameTitle: GFTitleLabel = {
        let label = GFTitleLabel(textAlignment: .center, fontSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    func set(follower: Follower){
        usernameTitle.text = follower.login
        avatarImageView.downloadImage(from: follower.avatarUrl)
    }
    
    override func prepareForReuse() {
        usernameTitle.text = ""
        avatarImageView.resetImage()
    }
    
    private func setupUI(){
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupHierarchy(){
        contentView.addSubview(avatarImageView)
        contentView.addSubview(usernameTitle)
    }
    
    private func setupConstraints(){
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            avatarImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            usernameTitle.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            usernameTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            usernameTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            usernameTitle.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
