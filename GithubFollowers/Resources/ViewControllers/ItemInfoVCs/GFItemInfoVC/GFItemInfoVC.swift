//
//  GFItemInfoVC.swift
//  GithubFollowers
//
//  Created by Edgar Jonas Mesquita da Silva on 29/01/25.
//

import UIKit

class GFItemInfoVC: UIViewController {
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var itemInfoViewOne: GFItemInfoView = {
        let view = GFItemInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var itemInfoViewTwo: GFItemInfoView = {
        let view = GFItemInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var actionButton: GFButton = {
        let button = GFButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    
    let user: User
    weak var delegate: UserInfoVCDelegate?
    
    init(user: User, delegate: UserInfoVCDelegate) {
        self.user = user
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureActionButton()
    }
    
    private func configureActionButton(){
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func actionButtonTapped(){
        
    }
    
    private func setupUI(){
        view.layer.cornerRadius = 18
        view.backgroundColor = .secondarySystemBackground
        
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupHierarchy(){
        stackView.addArrangedSubview(itemInfoViewOne)
        stackView.addArrangedSubview(itemInfoViewTwo)
        view.addSubview(stackView)
        view.addSubview(actionButton)
    }
    
    private func setupConstraints(){
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            
            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
}
