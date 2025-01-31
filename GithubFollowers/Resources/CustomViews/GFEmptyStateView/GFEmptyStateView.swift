//
//  GFEmptyStateView.swift
//  GithubFollowers
//
//  Created by Edgar Jonas Mesquita da Silva on 28/01/25.
//

import Foundation
import UIKit

class GFEmptyStateView: UIView {
    
    private lazy var messageLabel: GFTitleLabel = {
        let label = GFTitleLabel(textAlignment: .center, fontSize: 28)
        label.numberOfLines = 3
        label.textColor = .secondaryLabel
        return label
    }()
    
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .emptyStateLogo
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    
    convenience init(message: String){
        self.init(frame: .zero)
        messageLabel.text = message
    }
    
    
    private func setup(){
        setupHierarchy()
        setupConstraints()
    }
    
    
    private func setupHierarchy(){
        addSubviews(
            messageLabel,
            logoImageView
        )
    }
    
    
    private func setupConstraints(){
        let labelCenterYConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? -80 : -150
        
        let logoImageViewBottomConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 80 : 40
        
        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: labelCenterYConstant),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            messageLabel.heightAnchor.constraint(equalToConstant: 200),
            
            logoImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.3),
            logoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1.3),
            logoImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 170),
            logoImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: logoImageViewBottomConstant),
        ])
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
