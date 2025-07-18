//
//  TransactionRowView.swift
//  BudgetApp
//
//  Created by Colby Johnson on 7/16/25.
//

import SwiftUI

struct TransactionRowView: View {
    let transaction: Transaction
    let isExpanded: Bool
    let onTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(transaction.title ?? "No title")
                Spacer()
                Text(transaction.amount as NSNumber, formatter: NumberFormatter.currency)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                onTap()
            }

            if isExpanded {
                Text("Date: \(formattedDate(transaction.date))")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top, 4)
            }
        }
        .padding(.vertical, 4)
    }

    private func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "Unknown date" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}


//#Preview {
//    TransactionRowView()
//}
