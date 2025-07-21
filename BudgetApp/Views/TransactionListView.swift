//
//  TransactionListView.swift
//  BudgetApp
//
//  Created by Colby Johnson on 7/1/25.
//

import SwiftUI
import CoreData

struct TransactionListView: View {
    
    let transactions: [Transaction]
    @Binding var expandedID: NSManagedObjectID?
    let onDelete: (Transaction) -> Void
    
    var body: some View {
        List {
            ForEach(transactions, id: \.objectID) { transaction in
                TransactionRowView(
                    transaction: transaction,
                    isExpanded: expandedID == transaction.objectID,
                    onTap: {
                        withAnimation {
                            if expandedID == transaction.objectID {
                                expandedID = nil
                            } else {
                                expandedID = transaction.objectID
                            }
                        }
                    }
                )
            }
            .onDelete { index in
                guard let index = index.first else { return }
                onDelete(transactions[index])
            }
        }
    }
}
