//
//  String+Extensions.swift
//  GithubFollowers
//
//  Created by Edgar Jonas Mesquita da Silva on 19/01/25.
//

import Foundation
import UIKit

extension String {
    var isValidEmail: Bool {
        let emailFormat = "[A-Z0-9a-z.%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate (format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
    
    var isValidPassword: Bool {
        //Regex restricts to 8 character minimum, 1 capital letter, 1 lowercase letter, 1 number let passwordFormat
        let passwordFormat = "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}"
        let passwordPredicate = NSPredicate (format:"SELF MATCHES %@", passwordFormat)
        return passwordPredicate.evaluate(with: self)
    }
    
    var isGithubUsernameValid: Bool {
        let usernameFormat = "^[A-Za-z\\d](?:[A-Za-z\\d]|-(?=[A-Za-z\\d])){0,38}$"
        let usernamePredicate = NSPredicate (format:"SELF MATCHES %@", usernameFormat)
        return usernamePredicate.evaluate(with: self)
    }
}
