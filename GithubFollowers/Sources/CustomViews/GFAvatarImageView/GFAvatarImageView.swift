//
//  GFAvatarImageView.swift
//  GithubFollowers
//
//  Created by Edgar Jonas Mesquita da Silva on 26/01/25.
//

import Foundation
import UIKit

class GFAvatarImageView: UIImageView {
    
    let placeholder = UIImage.avatarPlaceholder
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    
    private func setupView(){
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholder
        contentMode = .scaleAspectFit
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func downloadImage(from url: String) {
        Task { image = await NetworkManager.shared.downloadImage(from: url) ?? .avatarPlaceholder  }
    }

    
    func resetImage(){
        image = .avatarPlaceholder
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

