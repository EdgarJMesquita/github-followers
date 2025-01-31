//
//  FavoritesListViewModel.swift
//  GithubFollowers
//
//  Created by Edgar Jonas Mesquita da Silva on 31/01/25.
//

import Foundation

class FavoritesListViewModel {
    public private(set) var favorites: [Follower] = []
    
    weak var delegate: FavoritesListViewModelDelegate?
    
    func removeFavorite(atIndex index: Int, completion: @escaping ()->Void){
        let favorite = favorites[index]
        
        PersistenceManager.updateWith(favorite: favorite, actionType: .remove) { [weak self] error in
            guard let self else { return }
            
            guard let error else {
                favorites.remove(at: index)
                completion()
                return
            }
            
            delegate?.onAlert(message: error.rawValue)
        }
    }
    
    func loadFavorites(){
        PersistenceManager.retrieveFavorites { [weak self] result in
            guard let self else { return }
            
            switch result {
                case .success(let favorites):
                    self.favorites = favorites
                    delegate?.didLoadFavorites(isEmpty: favorites.isEmpty)
                
                case .failure(let error):
                    delegate?.onAlert(message: error.rawValue)
            }
        }
    }
    
    
}

protocol FavoritesListViewModelDelegate: AnyObject {
    func didLoadFavorites(isEmpty: Bool)
    func onAlert(message: String)
}
