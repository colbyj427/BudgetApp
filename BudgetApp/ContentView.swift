//
//  ContentView.swift
//  BudgetApp
//
//  Created by Colby Johnson on 6/11/25.
//

import SwiftUI
import CoreData

//View is the view model in SwiftUI
struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(fetchRequest: BudgetCategory.all) private var budgetCategoryResults: FetchedResults<BudgetCategory>
    @State private var showingSheet: Bool = false
//    @FetchRequest(entity: TotalFunds.entity(), sortDescriptors: []) var totalFunds: FetchedResults<TotalFunds>
//    @FetchRequest(fetchRequest: TotalFunds.fetchRequest()) var totalFunds: FetchedResults<TotalFunds>
    @FetchRequest(fetchRequest: TotalFunds.all) var totalFunds: FetchedResults<TotalFunds>
//    @FetchRequest(
//        entity: TotalFunds.entity(),
//        sortDescriptors: [NSSortDescriptor(keyPath: \TotalFunds.amount, ascending: true)]
//    ) var totalFunds: FetchedResults<TotalFunds>

    @State private var addFundsIsPresented: Bool = false
    @State private var newCategoryIsPresented: Bool = false
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
        showingSheet = true
        newCategoryIsPresented = true
        addFundsIsPresented = false
    }
    func presentAddFunds() {
        showingSheet = true
        newCategoryIsPresented = false
        addFundsIsPresented = true
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
            }.sheet(isPresented: $showingSheet) {
                if addFundsIsPresented {
                    AddFundsView()
                } else if newCategoryIsPresented {
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
