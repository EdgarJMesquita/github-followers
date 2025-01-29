//
//  Date+Extensions.swift
//  GithubFollowers
//
//  Created by Edgar Jonas Mesquita da Silva on 29/01/25.
//

import Foundation

extension Date {
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "pt_BR")
        return dateFormatter.string(from: self).capitalized(with: Locale(identifier: "en_US"))
    }
}
