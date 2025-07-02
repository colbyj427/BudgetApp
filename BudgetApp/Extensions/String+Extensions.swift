//
//  Strings+Extensions.swift
//  BudgetApp
//
//  Created by Colby Johnson on 6/26/25.
//

import Foundation

extension String {
    var isNumeric: Bool {
        Double(self) != nil
    }
    func isGreaterThan(_ value: Double) -> Bool {
        guard self.isNumeric else {
            return false
        }
        return Double(self)! > value
    }
}
