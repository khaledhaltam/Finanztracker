//
//  Transaction.swift
//  Finanztracker
//
//  Created by Khaled Abuhaltam on 28.11.24.
//

import SwiftUI

struct TransactionItem: View {
    let transaction: TransactionDto

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(transaction.title)
                    .font(.headline)
                Text(transaction.date, style: .date)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text(transaction.amount, format: .currency(code: "EUR"))
                .font(.headline)
                .foregroundColor(transaction.amount >= 0 ? .green : .red)
        }
        .padding(.vertical, 4)
    }
}
#Preview {
    TransactionItem(transaction: TransactionDto(title: "Netflix", amount: 14.99, date: Date()))
}
