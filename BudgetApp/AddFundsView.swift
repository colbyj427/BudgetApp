//
//  AddFundsView.swift
//  BudgetApp
//
//  Created by Colby Johnson on 7/21/25.
//

import SwiftUI
import CoreData

struct AddFundsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var amount: String = ""
    
    var isFormValid: Bool {
        !name.isEmpty && !amount.isEmpty && amount.isNumeric
    }
    
    private func saveFunds() {
        print("Saving new funds.")
        // Fetch existing TotalFunds or create a new one
        let request = NSFetchRequest<TotalFunds>(entityName: "TotalFunds")
        do {
            let results = try viewContext.fetch(request)
            let total = results.first ?? TotalFunds(context: viewContext) // use first or create new
            
            total.amount += Double(amount) ?? 0.0
            
            try viewContext.save()
            dismiss()
        } catch {
            print("Failed to fetch or save:", error)
        }
    }
    
    var body: some View {
        NavigationStack{
            Form{
                TextField("Title", text: $name)
                TextField("Amount", text: $amount).keyboardType(.decimalPad)
            }.toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if isFormValid {
                            saveFunds()
                        }
                    }.disabled(!isFormValid)
                }
            }
        }
    }
}

struct AddFundsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AddFundsView()
        }
    }
}
