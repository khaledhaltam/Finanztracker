//
//  Transaction.swift
//  Finanztracker
//
//  Created by Khaled Abuhaltam on 28.11.24.
//

import SwiftUI

struct TransactionItem: View {
    
    let transaction: TransactionDto
    
    // Formatierer für das Datum
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    // Berechnete Eigenschaft für die Farbe basierend auf dem Betrag
    private func amountColor(for amount: Double) -> Color {
        if amount > 0 {
            return .green
        } else if amount < 0 {
            return .red
        } else {
            return .gray
        }
    }
    
    var body: some View {
        NavigationLink(destination: TransactionView(transaction: transaction)) {
            VStack(alignment: .trailing) {
                HStack {
                    Label(transaction.title, systemImage: "receipt")
                        .lineLimit(1)
                    Spacer()
                    Text(transaction.amount, format: .currency(code: "EUR"))
                        .foregroundColor(amountColor(for: transaction.amount))
                }
                Text("\(transaction.date, formatter: dateFormatter)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 5)
        }
    }
}

#Preview {
    TransactionItem(transaction: TransactionDto(title: "Netflix", amount: 14.99, date: Date()))
}
