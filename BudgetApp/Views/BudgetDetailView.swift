//
//  BudgetDetailView.swift
//  BudgetApp
//
//  Created by Colby Johnson on 6/30/25.
//

import SwiftUI
import CoreData

struct BudgetDetailView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var budgetCategory: BudgetCategory
    @State private var title: String = ""
    @State private var amount: String = ""
    @State private var expandedTransactionID: NSManagedObjectID?

    
    private var isFormValid: Bool {
        !title.isEmpty && !amount.isEmpty && amount.isNumeric && amount.isGreaterThan(0)
    }
    
    private func saveTransaction() {
        print("Saving transaction")
        let transaction = Transaction(context: viewContext)
        transaction.title = title
        transaction.amount = Double(amount)!
        transaction.date = Date()
        
        print("budgetCategory objectID: \(budgetCategory.objectID)")
        print("isDeleted: \(budgetCategory.isDeleted)")
        print("context: \(budgetCategory.managedObjectContext == nil ? "nil" : "OK")")
        
        budgetCategory.addToTransactions(transaction)
        try? viewContext.save()
        print("Saved transaction")
    }
    
    private func removeTransaction(_ transaction: Transaction) {
        viewContext.delete(transaction)
        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Total: ")
                Text(budgetCategory.amount as NSNumber, formatter: NumberFormatter.currency)
            }.frame(maxWidth: .infinity, alignment: .leading).bold()
            Spacer()
            
            Form {
                TextField("Title", text: $title)
                TextField("Amount", text: $amount)
            }
            HStack {
                Spacer()
                Button("Add Transaction"){
                    saveTransaction()
                }.disabled(!isFormValid)
                Spacer()
            }
            HStack {
                VStack {
                    Text("Available:").frame(maxWidth: .infinity, alignment: .center).bold()
                    Text(budgetCategory.amount - budgetCategory.transactionsTotal as NSNumber, formatter:NumberFormatter.currency)
                        .frame(maxWidth: .infinity, alignment: .center).bold()
                }
                VStack {
                    Text("Spent: ").frame(maxWidth: .infinity, alignment: .center).bold()
                    Text(budgetCategory.transactionsTotal as NSNumber, formatter: NumberFormatter.currency)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .bold()
                }
            }
            TransactionListView(transactions: budgetCategory.transactionArray,
                expandedID: $expandedTransactionID,
                onDelete: { transaction in
                removeTransaction(transaction)
            })
            
        }.padding()
    }
}

struct BudgetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        
        let vc = CoreDataManager.shared.persistentContainer.viewContext
        let request = BudgetCategory.fetchRequest()
        let results = try! vc.fetch(request)
        NavigationStack {
            BudgetDetailView(budgetCategory: results[0]).environment(\.managedObjectContext, vc)
        }
    }
}
