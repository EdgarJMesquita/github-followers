//
//  GFButton.swift
//  GithubFollowers
//
//  Created by Edgar Jonas Mesquita da Silva on 17/01/25.
//

import Foundation
import UIKit

class GFButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(backgroundColor: UIColor, title: String){
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
        self.tintColor = .white
    }
    
    
    func set(backgroundColor: UIColor, title: String){
        self.backgroundColor = backgroundColor
        setTitle(title, for: .normal)
    }
    
    
    private func configure(){
        layer.cornerRadius = 10
        titleLabel?.textColor = .white
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func showLoadingIndicator(){
        DispatchQueue.main.async { [weak self] in
            var configuration = UIButton.Configuration.plain()
            configuration.imagePadding = 12
            configuration.showsActivityIndicator = true
            self?.isEnabled = false
            self?.configuration = configuration
        }
    }
    
    
    func hideLoadingIndicator(){
        DispatchQueue.main.async { [weak self] in
            var configuration = UIButton.Configuration.plain()
            configuration.imagePadding = 12
            configuration.showsActivityIndicator = false
            self?.isEnabled = true
            self?.configuration = configuration
        }
    }
    
}
