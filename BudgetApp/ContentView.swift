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
    
//    New
    @FetchRequest(fetchRequest: BudgetCategory.all) private var budgetCategoryResults: FetchedResults<BudgetCategory>
    @State private var isPresented: Bool = false
    
    var body: some View {
        NavigationStack {
            List(budgetCategoryResults) { budgetCategory in
                NavigationLink(value: budgetCategory) {
                    HStack{
                        Text(budgetCategory.name ?? "").onAppear {
                            print("ContentView appeared")
                        }
                        Spacer()
                        Text(budgetCategory.amount as NSNumber, formatter: NumberFormatter.currency)
                    }
                }
            }
            .navigationDestination(for: BudgetCategory.self , destination: { budgetCategory
                in
                BudgetDetailView(budgetCategory: budgetCategory)
                })
//        This displays the categories when fetch is working
        }.toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add new Category") {
                        isPresented = true
                    }
                }
            }.sheet(isPresented: $isPresented) {
                AddBudgetCategoryView()
            }
        }
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ContentView().environment(\.managedObjectContext, CoreDataManager.shared.persistentContainer.viewContext)
        }
    }
}
