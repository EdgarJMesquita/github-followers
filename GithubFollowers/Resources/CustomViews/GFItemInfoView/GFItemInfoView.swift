//
//  GFItemInfoView.swift
//  GithubFollowers
//
//  Created by Edgar Jonas Mesquita da Silva on 29/01/25.
//

import UIKit

enum ItemInfoType {
    case repos, gists, followers, following
}

class GFItemInfoView: UIView {
    
    private lazy var symbolImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .label
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    private lazy var titleLabel: GFTitleLabel = {
        let label = GFTitleLabel(textAlignment: .left, fontSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private lazy var countLabel: GFTitleLabel = {
        let label = GFTitleLabel(textAlignment: .center, fontSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    
    func setData(type: ItemInfoType, withCount count: Int){
        switch type {
            case .repos:
                symbolImageView.image = SFSymbols.repos
                titleLabel.text = "Public Repos"
                break
            case .gists:
                symbolImageView.image = SFSymbols.gists
                titleLabel.text = "Public Gists"
                break
            case .followers:
                symbolImageView.image = SFSymbols.followers
                titleLabel.text = "Followers"
                break
            case .following:
                symbolImageView.image = SFSymbols.following
                titleLabel.text = "Following"
                break
        }
        
        countLabel.text = String(count)
    }
    
    
    private func setupUI(){
        setupHierarchy()
        setupConstraints()
    }
    
    
    private func setupHierarchy(){
        addSubviews(
            symbolImageView,
            titleLabel,
            countLabel
        )
    }
    
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            symbolImageView.topAnchor.constraint(equalTo: topAnchor),
            symbolImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            symbolImageView.widthAnchor.constraint(equalToConstant: 20),
            symbolImageView.heightAnchor.constraint(equalToConstant: 20),
            
            titleLabel.centerYAnchor.constraint(equalTo: symbolImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: symbolImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 18),
            
            countLabel.topAnchor.constraint(equalTo: symbolImageView.bottomAnchor, constant: 4),
            countLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            countLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            countLabel.heightAnchor.constraint(equalToConstant: 18),
        ])
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
