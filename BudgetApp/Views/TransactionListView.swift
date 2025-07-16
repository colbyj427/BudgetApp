//
//  TransactionListView.swift
//  BudgetApp
//
//  Created by Colby Johnson on 7/1/25.
//

import SwiftUI

struct TransactionListView: View {
    
    let transactions: [Transaction]
    @Binding var expandedID: UUID?
    let onDelete: (Transaction) -> Void
    
    var body: some View {
        List {
            ForEach(transactions) { transaction in
                HStack {
                    Text(transaction.title ?? "No title")
                    Spacer()
                    Text(transaction.amount as NSNumber, formatter: NumberFormatter.currency)
                }
            }.onDelete { index in
                guard let index = index.first else { return }
                onDelete(transactions[index])
            }
        }
    }
}

struct TransactionListView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionListView(transactions: [], onDelete: { _ in })
    }
}
