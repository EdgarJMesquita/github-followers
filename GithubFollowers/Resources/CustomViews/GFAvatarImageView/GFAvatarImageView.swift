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
    let cache = NetworkManager.shared.cache
    
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
    
    func downloadImage(from urlString: String){
        NetworkManager.shared.downloadImage(from: urlString) { [weak self] image in
            guard let image else { return }
            DispatchQueue.main.async { [weak self] in
                self?.image = image
            }
        }
        
//        let cacheKey = NSString(string: urlString)
//        
//        if let image = cache.object(forKey: cacheKey) {
//            DispatchQueue.main.async { [weak self] in
//                self?.image = image
//            }
//            return
//        }
//        
//        
//        guard let url = URL(string: urlString) else { return }
//        
//        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
//            guard let self else { return }
//            
//            if error != nil { return }
//            
//            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//                return
//            }
//            
//            guard let data else { return }
//            
//            guard let image = UIImage(data: data) else { return }
//            
//            self.cache.setObject(image, forKey: cacheKey)
//            
//            DispatchQueue.main.async { [weak self] in
//                self?.image = image
//            }
//        }
//        
//        task.resume()
    }
    
    func resetImage(){
        image = .avatarPlaceholder
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
