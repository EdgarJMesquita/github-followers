//
//  SearchVC.swift
//  GithubFollowers
//
//  Created by Edgar Jonas Mesquita da Silva on 17/01/25.
//

import Foundation
import UIKit

class SearchVC: GFDataLoadingViewVC {
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = .ghLogo
        return imageView
    }()
    
    
    private lazy var usernameTextField: GFTextField = {
        let textField = GFTextField()
        textField.returnKeyType = .done
        return textField
    }()
    
    
    private lazy var callToActionButton: GFButton = {
        let button = GFButton(backgroundColor: .systemGreen, title: "Ver Seguidores")
        return button
    }()
    
    
    var isUserNameEntered: Bool {
        return usernameTextField.text?.isGithubUsernameValid ?? false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        usernameTextField.text = ""
    }
    
    
    private func addKeyboardDismissGesture(){
        let gestureRecognizer = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    
    @objc
    private func pushUserInfoVC(){
        usernameTextField.resignFirstResponder()
        guard let username = usernameTextField.text, username.isGithubUsernameValid else {
            presentGFAlertOnMainThread(title: "Atenção", message: "Preencha o usuário", buttonTitle: "Ok")
            return
        }
    
        let userInfoVC = UserInfoVC(username: username)
        self.navigationController?.pushViewController(userInfoVC, animated: true)
    }
    
    
    private func setup(){
        view.backgroundColor = .systemBackground
        
        usernameTextField.delegate = self
        callToActionButton.addTarget(self, action: #selector(pushUserInfoVC), for: .touchUpInside)
        
        setupHierarchy()
        setupConstraints()
        addKeyboardDismissGesture()
    }
    
    
    private func setupHierarchy(){
        view.addSubviews(
            logoImageView,
            usernameTextField,
            callToActionButton
        )
    }
    
    
    private func setupConstraints(){
        let topConstraintConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 20 : 80
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstraintConstant),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
        ])
        
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        NSLayoutConstraint.activate([
            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
}

extension SearchVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        pushUserInfoVC()
        return true
    }
    
}
