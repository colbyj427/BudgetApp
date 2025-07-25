//
//  ContentView.swift
//  BudgetApp
//
//  Created by Colby Johnson on 6/11/25.
//

import SwiftUI
import CoreData

enum ActiveSheet: Identifiable {
    case addFunds, newCategory
    
    var id: Int {
        switch self {
        case .addFunds: return 0
        case .newCategory: return 1
        }
    }
}

//View is the view model in SwiftUI
struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(fetchRequest: BudgetCategory.all) private var budgetCategoryResults: FetchedResults<BudgetCategory>
    @FetchRequest(fetchRequest: TotalFunds.all) var totalFunds: FetchedResults<TotalFunds>

//    @State private var showingSheet: Bool = false
//    @State private var addFundsIsPresented: Bool = false
//    @State private var newCategoryIsPresented: Bool = false
    @State private var activeSheet: ActiveSheet?
    var remaining: Double = 0.0
    
    var total: Double {
        totalFunds.first?.amount ?? 0.0
    }
    
    let onDelete: (BudgetCategory) -> Void
    
    mutating func calcRemaining() {
        var t = 0.0
        budgetCategoryResults.forEach { category in
            t -= (category.amount - category.remaining)
        }
        remaining = t
    }
    
    func presentNewCategory() {
//        newCategoryIsPresented = true
//        addFundsIsPresented = false
//        showingSheet = true
        activeSheet = .newCategory
    }
    func presentAddFunds() {
//        newCategoryIsPresented = false
//        addFundsIsPresented = true
//        showingSheet = true
        activeSheet = .addFunds
    }
    
    var body: some View {
        NavigationStack {
            HStack {
                Text("Total:")
                Text(total as NSNumber, formatter: NumberFormatter.currency)
                Text("Remaining:")
                Text(remaining as NSNumber, formatter: NumberFormatter.currency)
                
            }
            List{
                ForEach(budgetCategoryResults) { budgetCategory in
                    NavigationLink(value: budgetCategory) {
                        VStack {
                            HStack{
                                Text(budgetCategory.name ?? "").onAppear {
                                }
                                Spacer()
                                Text(budgetCategory.amount as NSNumber, formatter: NumberFormatter.currency)
                            }
                            HStack{
                                Text("Remaining")
                                Spacer()
                                Text(budgetCategory.remaining as NSNumber, formatter: NumberFormatter.currency)
                            }
                        }
                    }
                }.onDelete { index in
                    guard let index = index.first else { return }
                    onDelete(budgetCategoryResults[index])
                }
            }
            .navigationDestination(for: BudgetCategory.self , destination: { budgetCategory
                in
                BudgetDetailView(budgetCategory: budgetCategory)
                })
//        This displays the categories when fetch is working
        }.toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Add Funds") {
                    presentAddFunds()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Add new Category") {
                    presentNewCategory()
                }
            }
        }.sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .addFunds:
                AddFundsView()
            case .newCategory:
                AddBudgetCategoryView()
            }
        }
        }
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ContentView(onDelete: { _ in }).environment(\.managedObjectContext, CoreDataManager.shared.persistentContainer.viewContext)
        }
    }
}
