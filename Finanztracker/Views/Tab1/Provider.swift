//
//  FinancialItemView.swift
//  Finanztracker
//
//  Created by Khaled Abuhaltam on 06.11.24.
//

import SwiftUI

struct Provider: View {
    let provider: ProviderDto

    // Berechnete Eigenschaft für die Farbe basierend auf dem Betrag
    private var amountColor: Color {
        if provider.amount > 0 {
            return .green
        } else if provider.amount < 0 {
            return .red
        } else {
            return .gray
        }
    }

    var body: some View {
        HStack {
            Image(systemName: provider.icon)
                .resizable()
                .frame(width: 30, height: 30)
                .padding(.trailing, 8)
            VStack(alignment: .leading) {
                Text(provider.title)
                    .font(.headline)
                Text(provider.amount, format: .currency(code: "EUR"))
                    .foregroundColor(amountColor)
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }

}

#Preview {
    let f = ProviderDto(
        title: "Volksbank Mittelhessen (...9433)", amount: 1544.08,
        icon: "eurosign.bank.building",
        transactions: [
            TransactionDto(title: "Netflix", amount: 14.99, date: Date()),
            TransactionDto(title: "Amazon", amount: 399.99, date: Date()),
            TransactionDto(title: "DönerKING", amount: 8.98, date: Date()),
        ],
        type: .debitCard
    )
    Provider(provider: f)
}
