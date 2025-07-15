//
//  BudgetCategory+CoreDataClass.swift
//  BudgetApp
//
//  Created by Colby Johnson on 7/1/25.
//

import Foundation
import CoreData

@objc(BudgetCategory)
public class BudgetCategory: NSManagedObject {
    
    var transactionsTotal: Double {
        guard let transactions = transactions else { return 0.0 }
        
        let transactionsArray: [Transaction] = transactions.toArray()
        return transactionsArray.reduce(0) {
            result, transaction in result + transaction.amount
        }
    }
    
    var remaining: Double {
        return self.amount - transactionsTotal
    }
    
    var transactionArray: [Transaction] {
        guard let transactions = transactions else {
            return []
        }
        return transactions.allObjects as! [Transaction]
    }
    
    static var all: NSFetchRequest<BudgetCategory> {
        let request = BudgetCategory.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return request
    }
    
}
