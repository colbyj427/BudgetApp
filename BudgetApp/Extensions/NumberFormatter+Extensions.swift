//
//  NumberFormatter+Extensions.swift
//  BudgetApp
//
//  Created by Colby Johnson on 6/30/25.
//

import Foundation

extension NumberFormatter {
    static var currency: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }
}
