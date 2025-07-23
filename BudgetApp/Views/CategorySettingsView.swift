//
//  CategorySettingsView.swift
//  BudgetApp
//
//  Created by Colby Johnson on 7/18/25.
//

import SwiftUI

struct CategorySettingsView: View {
    @ObservedObject var budgetCategory: BudgetCategory
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @State private var name: String
    @State private var amount: String

    init(budgetCategory: BudgetCategory) {
        self.budgetCategory = budgetCategory
        _name = State(initialValue: budgetCategory.name ?? "")
        let formatter = NumberFormatter.currency
        let formattedAmount = formatter.string(from: NSNumber(value: budgetCategory.amount)) ?? ""
        _amount = State(initialValue: formattedAmount)
    }

    var body: some View {
        Form {
            Section(header: Text("Category Info")) {
                TextField("Name", text: $name)
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
            }

            Button("Save Changes") {
                saveChanges()
                dismiss()
            }
            .disabled(!isValid)
        }
        .navigationTitle("Settings")
        .hideKeyboardOnTap()
        .scrollDismissesKeyboard(.interactively)
    }

    private var isValid: Bool {
        !name.isEmpty && Double(amount) != nil
    }

    private func saveChanges() {
        budgetCategory.name = name
        budgetCategory.amount = Double(amount) ?? budgetCategory.amount
        try? viewContext.save()
    }
}


#Preview {
    let context = CoreDataManager.shared.persistentContainer.viewContext

    // Create a sample BudgetCategory
    let category = BudgetCategory(context: context)
    category.name = "Sample Category"
    category.amount = 100.0

    return NavigationStack {
        CategorySettingsView(budgetCategory: category)
            .environment(\.managedObjectContext, context)
    }
}
