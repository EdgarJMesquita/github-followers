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
            case .success(var favorites):
            
                    switch actionType {
                        case .add:
                            guard !favorites.contains(favorite) else {
                                completion(.alreadyInFavorites)
                                return
                            }
                            favorites.append(favorite)
                        
                        case .remove:
                            favorites.removeAll { $0.login == favorite.login }
                         
                    }
                    completion(save(favorites: favorites))
                 
                case .failure(let error):
                    completion(error)
                    break
            }
        }
    }
    
    
    static func retrieveFavorites(completion: @escaping (Result<[Follower], GFError>) -> Void) {
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
    
    
    static func retrieveFavorites() async throws -> [Follower] {
        guard let data = defaults.object(forKey: Keys.favorites) as? Data else {
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            let followers = try decoder.decode([Follower].self, from: data)
            return followers
        } catch {
            throw GFError.unableToGetFavorites
       
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
    
    
    static func checkFavorite(favorite: Follower) async -> Bool {
        do {
            let favorites = try await retrieveFavorites()
            return favorites.contains(favorite)
        } catch {
            return false
        }
    }
    
    
    static func toogleFavorite(favorite: Follower, completion: @escaping (Result<Bool,GFError>)->Void) {
        retrieveFavorites { result in
            switch result {
                case .success(var favorites):
                    if favorites.contains(favorite) {
                        favorites.removeAll { $0.login == favorite.login }
                    } else {
                        favorites.append(favorite)
                    }
                
                    if let error = save(favorites: favorites)  {
                        completion(.failure(error))
                        return
                    }
                    completion(.success(favorites.contains(favorite)))
    
                case .failure(let error):
                    completion(.failure(error))
    
            }
        }
    }
    
}
