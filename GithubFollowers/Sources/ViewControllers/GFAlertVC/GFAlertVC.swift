//
//  GFAlertVC.swift
//  GithubFollowers
//
//  Created by Edgar Jonas Mesquita da Silva on 19/01/25.
//

import Foundation
import UIKit

class GFAlertVC: UIViewController {
    
    private lazy var contentView: GFAlertContainerView = {
        let view = GFAlertContainerView()
        return view
    }()
    
    
    private lazy var titleLabel: GFTitleLabel = {
        let label = GFTitleLabel(textAlignment: .center, fontSize: 20)
        return label
    }()
    
    
    private lazy var bodyLabel: GFBodyLabel = {
        let label = GFBodyLabel(textAlignment: .center)
        label.numberOfLines = 0
        return label
    }()
    
    
    private lazy var actionButton: GFButton = {
        let button = GFButton(color: .systemPink, title: "Ok", systemImaneName: "checkmark.circle")
        return button
    }()
    
    
    var alertTitle: String?
    var message: String?
    var buttonTitle: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    init(title: String, message: String, buttonTitle: String) {
        super.init(nibName: nil, bundle: nil)
        self.titleLabel.text = title
        self.bodyLabel.text = message
        self.actionButton.setTitle(buttonTitle, for: .normal)
        setup()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupGestures(){
        actionButton.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
    }
    
    
    @objc
    private func didTapActionButton(){
        dismiss(animated: true)
    }
    
    
    private func setup(){
        view.backgroundColor = .black.withAlphaComponent(0.75)
        setupHierarchy()
        setupConstraints()
        setupGestures()
    }
    
    
    private func setupHierarchy(){
        view.addSubview(contentView)
        contentView.addArrangedSubview(titleLabel)
        contentView.addArrangedSubview(bodyLabel)
        contentView.addArrangedSubview(actionButton)
    }
    
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentView.widthAnchor.constraint(equalToConstant: 280),
        ])
    }
    
}
