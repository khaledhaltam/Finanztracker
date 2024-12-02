//
//  Transaction.swift
//  Finanztracker
//
//  Created by Khaled Abuhaltam on 28.11.24.
//

import SwiftUI

struct Transaction: View {
    
    let transaction: TransactionDto
    
    // Formatierer für das Datum
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    var body: some View {
        NavigationLink(destination: TransactionDetails(transaction: transaction)) {
            VStack(alignment: .trailing) {
                HStack {
                    Label(transaction.title, systemImage: "transaction.icon")
                        .lineLimit(1)
                    Spacer()
                    Text(transaction.amount, format: .currency(code: "EUR"))
                        .fontWeight(.bold)
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
    Transaction(transaction: TransactionDto(title: "Netflix", amount: 14.99, date: Date()))
}
