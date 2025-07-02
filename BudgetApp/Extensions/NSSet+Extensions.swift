//
//  NSSet+Extensions.swift
//  BudgetApp
//
//  Created by Colby Johnson on 7/1/25.
//

import Foundation

extension NSSet {
    
    func toArray<T>() -> [T] {
        let array = self.map { $0 as! T }
        return array
    }
    
}
