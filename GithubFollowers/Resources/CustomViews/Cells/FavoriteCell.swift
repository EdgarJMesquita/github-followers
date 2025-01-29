//
//  FavoriteCell.swift
//  GithubFollowers
//
//  Created by Edgar Jonas Mesquita da Silva on 29/01/25.
//

import Foundation
import UIKit

class FavoriteCell: UITableViewCell {
    static let identifier = "FavoriteCell"
    
    private lazy var avatarImageView: GFAvatarImageView = {
        let imageView = GFAvatarImageView(frame: .zero)
        return imageView
    }()
    
    private lazy var usernameLabel: GFTitleLabel = {
        let label = GFTitleLabel(textAlignment: .left, fontSize: 26)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    func configure(with favorite: Follower){
        avatarImageView.downloadImage(from: favorite.avatarUrl)
        usernameLabel.text = favorite.login
    }
    
    private func setupUI(){
        setupHierarchy()
        setupConstraints()
        
        accessoryType = .disclosureIndicator
    }
    
    private func setupHierarchy(){
        contentView.addSubview(avatarImageView)
        contentView.addSubview(usernameLabel)
    }
    
    private func setupConstraints(){
        let padding: CGFloat = 12
        
        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            
            usernameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 24),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
