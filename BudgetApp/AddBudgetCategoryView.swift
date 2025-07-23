//
//  AddBudgetCategoryView.swift
//  BudgetApp
//
//  Created by Colby Johnson on 6/11/25.
//

import SwiftUI

// View is the view Model in SwiftUI
struct AddBudgetCategoryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var amount: String = ""
    
    var isFormValid: Bool {
        !name.isEmpty && !amount.isEmpty && amount.isNumeric && amount.isGreaterThan(0)
    }
    
    private func saveBudgetCategory() {
        print("Saving a new category.")
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
        .hideKeyboardOnTap()
        .scrollDismissesKeyboard(.interactively)
    }
}

struct AddBudgetCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AddBudgetCategoryView()
        }
    }
}
