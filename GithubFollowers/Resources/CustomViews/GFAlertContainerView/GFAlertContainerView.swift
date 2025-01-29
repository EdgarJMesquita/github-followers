//
//  GFAlertContainerView.swift
//  GithubFollowers
//
//  Created by Edgar Jonas Mesquita da Silva on 29/01/25.
//

import UIKit

class GFAlertContainerView: UIStackView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        layer.cornerRadius = 16
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
        layer.masksToBounds = true
        
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        
        axis = .vertical
        spacing = 16
        alignment = .fill
        distribution = .equalCentering
        
        directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16,
                                                           leading: 16,
                                                           bottom: 16,
                                                           trailing: 16)
        isLayoutMarginsRelativeArrangement = true
    }
}
