//
//  BudgetAppApp.swift
//  BudgetApp
//
//  Created by Colby Johnson on 6/11/25.
//

import SwiftUI

enum Route: Hashable {
    case detail(BudgetCategory)
}

@main
struct BudgetAppApp: App {
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
                    .navigationDestination(for: Route.self, destination: { route in
                        switch route {
                        case .detail(let budgetCategory):
                            BudgetDetailView(budgetCategory: budgetCategory)
                        }
                    })
            }
            .environment(\.managedObjectContext, CoreDataManager.shared.persistentContainer.viewContext)
        }
    }
}
