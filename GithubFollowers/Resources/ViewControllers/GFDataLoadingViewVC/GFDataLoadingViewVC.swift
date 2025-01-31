//
//  GFDataLoadingViewVC.swift
//  GithubFollowers
//
//  Created by Edgar Jonas Mesquita da Silva on 30/01/25.
//

import UIKit

class GFDataLoadingViewVC: UIViewController {
    private var containerView: UIView!
    
    func showLoadingView(){
        containerView = UIView(frame: view.bounds)
        let activitiIndicatorView = UIActivityIndicatorView(style: .large)
        
        view.addSubview(containerView)
        containerView.addSubview(activitiIndicatorView)
        
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        
        activitiIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activitiIndicatorView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            activitiIndicatorView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        ])
        
        activitiIndicatorView.startAnimating()
        
        UIView.animate(withDuration: 0.25) {
            self.containerView.alpha = 0.8
        }
    }
    
    func dismissLoadingView(){
        DispatchQueue.main.async {
            self.containerView.removeFromSuperview()
            self.containerView = nil
        }
    }
    
    func showEmptyStateView(with message: String, in view: UIView){
        let emptyStateView = GFEmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
        
    }
}
