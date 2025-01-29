//
//  ErrorMessage.swift
//  GithubFollowers
//
//  Created by Edgar Jonas Mesquita da Silva on 26/01/25.
//

import Foundation


enum GFError: String, Error {
    case invalidUserName = "Este nome de usuário criou uma requisição inválida. Por favor tente novamente."
    case unableToComplete = "Não foi possível completar a requisição.Por favor tente novamente."
    case invalidResponse = "Resposta inválida do servidor. Por favor tente novamente."
    case invalidData = "Dados inválidos do servidor. Por favor tente novamente."
    case unableToFavorite = "Não foi possível favoritar este usuário."
    case unableToGetFavorites = "Não foi possível listar os favoritos."
    case alreadyInFavorites = "Você já favoritou esse usuário."
}
