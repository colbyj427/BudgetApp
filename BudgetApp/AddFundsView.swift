//
//  AddFundsView.swift
//  BudgetApp
//
//  Created by Colby Johnson on 7/21/25.
//

import SwiftUI

struct AddFundsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var amount: String = ""
    
    var isFormValid: Bool {
        !name.isEmpty && !amount.isEmpty && amount.isNumeric && amount.isGreaterThan(0)
    }
    
    private func saveBudgetCategory() {
        print("Saving new funds.")
        let budgetCategory = BudgetCategory(context: viewContext)
        budgetCategory.name = name
        budgetCategory.amount = Double(amount)!
        do {
            print("\(budgetCategory)")
            try viewContext.save()
            dismiss()
        } catch {
            print(error)
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
                            saveBudgetCategory()
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
