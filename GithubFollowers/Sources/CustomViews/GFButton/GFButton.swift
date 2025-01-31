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
    
    
    convenience init(color: UIColor, title: String, systemImaneName: String){
        self.init(frame: .zero)
        set(color: color, title: title, systemImaneName: systemImaneName)
        self.tintColor = .white
    }
    
    
    func set(color: UIColor, title: String, systemImaneName: String){
        configuration?.baseBackgroundColor = color
        configuration?.baseForegroundColor = color
        configuration?.title = title
        configuration?.image = UIImage(systemName: systemImaneName)
        configuration?.imagePadding = 12
    }
    
    
    private func configure(){
        configuration = .tinted()
        configuration?.cornerStyle = .medium
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func showLoadingIndicator(){
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            configuration?.showsActivityIndicator = true
            isEnabled = false
        }
    }
    
    
    func hideLoadingIndicator(){
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            configuration?.showsActivityIndicator = false
            isEnabled = true
        }
    }
    
}


#Preview {
    return GFButton(color: .systemGreen, title: "Hello Devs", systemImaneName: "info")
}
