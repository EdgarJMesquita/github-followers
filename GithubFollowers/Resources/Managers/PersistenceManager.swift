//
//  PersistenceManager.swift
//  GithubFollowers
//
//  Created by Edgar Jonas Mesquita da Silva on 29/01/25.
//

import Foundation


enum PersistenceActionType {
    case add, remove
}

enum PersistenceManager {
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let favorites = "favorites"
    }
    
    static func updateWith(favorite: Follower, actionType: PersistenceActionType, completion: @escaping (GFError?)->Void){
        retrieveFavorites { result in
            switch result {
            case .success(let favorites):
                    var retrievedFavorites = favorites
                    switch actionType {
                        case .add:
                            guard !retrievedFavorites.contains(favorite) else {
                                completion(.alreadyInFavorites)
                                return
                            }
                            retrievedFavorites.append(favorite)
                        
                        case .remove:
                            retrievedFavorites.removeAll { $0.login == favorite.login }
                         
                    }
                    completion(save(favorites: retrievedFavorites))
                 
                case .failure(let error):
                    completion(error)
                    break
            }
        }
    }
    
    static func retrieveFavorites(completion: @escaping (Result<[Follower],GFError>) -> Void) {
        guard let data = defaults.object(forKey: Keys.favorites) as? Data else {
            completion(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let followers = try decoder.decode([Follower].self, from: data)
            completion(.success(followers))
        } catch {
            completion(.failure(.unableToGetFavorites))
        }
    }
    
    static func save(favorites: [Follower]) -> GFError? {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return .unableToFavorite
        }
    }
}
