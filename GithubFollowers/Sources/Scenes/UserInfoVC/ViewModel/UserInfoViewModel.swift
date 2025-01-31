//
//  UserInfoViewModel.swift
//  GithubFollowers
//
//  Created by Edgar Jonas Mesquita da Silva on 31/01/25.
//

import Foundation

class UserInfoViewModel {
    public private(set) var user: User?
    
    weak var delegate: UserInfoViewModelDelegate?
    
    func resetUser(){
        user = nil
    }
    
    func getUserInfo(for username: String) {
        Task {
            do {
                let user = try await NetworkManager.shared.getUserInfo(for: username)
                self.user = user
                delegate?.didLoadUser(user: user)
            } catch {
                if let gfError = error as? GFError {
                    delegate?.onShowAlert(message: gfError.rawValue)
                } else {
                    delegate?.onShowAlert(message: nil)
                }
            }
            delegate?.didChangeLoadingState(isLoading: false)
        }
    }
    
    func toggleFavorite(completion: @escaping (Result<Bool,GFError>)->Void){
        guard let user else { return }
        
        let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
        
        PersistenceManager.toogleFavorite(favorite: favorite) { result in
            completion(result)
        }
    }
}


protocol UserInfoViewModelDelegate: AnyObject {
    
    func onShowAlert(message: String?)
    
    func didChangeLoadingState(isLoading: Bool)
    
    func didLoadUser(user: User)
    
}
