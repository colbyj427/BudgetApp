//
//  TotalFunds.swift
//  BudgetApp
//
//  Created by Colby Johnson on 7/22/25.
//


import Foundation
import CoreData

@objc(TotalFunds)
public class TotalFunds: NSManagedObject {
    @NSManaged public var amount: Double
}

extension TotalFunds {
    static var all: NSFetchRequest<TotalFunds> {
        let request = NSFetchRequest<TotalFunds>(entityName: "TotalFunds")
        request.sortDescriptors = []
        return request
    }
}

