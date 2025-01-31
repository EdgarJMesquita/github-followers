//
//  UserModel.swift
//  GithubFollowers
//
//  Created by Edgar Jonas Mesquita da Silva on 24/01/25.
//

import Foundation

struct User: Decodable {
    let login: String
    let avatarUrl: String
    var name: String?
    var bio: String?
    var location: String?
    let publicRepos: Int
    let publicGists: Int
    let followers: Int
    let following: Int
    let createdAt: Date
    let htmlUrl: String

}

