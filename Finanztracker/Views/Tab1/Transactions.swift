//
//  SwiftUIView.swift
//  Finanztracker
//
//  Created by Khaled Abuhaltam on 28.11.24.
//

import SwiftUI

struct Transactions: View {

    let provider: ProviderDto

    var body: some View {
        List {
            ForEach(provider.transactions) { transaction in

                Transaction(transaction: transaction)
            }
        }
        .listStyle(.plain)
        .navigationTitle(provider.title)
    }
}

#Preview {
    let provider = ProviderDto(
        title: "Volksbank Mittelhessen (...9433)", amount: 1544.08,
        icon: "eurosign.bank.building",
        transactions: [
            TransactionDto(title: "Netflix", amount: 14.99, date: Date()),
            TransactionDto(title: "Amazon", amount: 399.99, date: Date()),
            TransactionDto(title: "DönerKING", amount: 8.98, date: Date()),
        ],
        type: .debitCard
    )
    Transactions(provider: provider)
}
