//
//  Follower.swift
//  GithubFollowers
//
//  Created by Edgar Jonas Mesquita da Silva on 24/01/25.
//

import Foundation

struct Follower: Codable, Hashable {
    let login: String
    let avatarUrl: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(login)
    }
}
