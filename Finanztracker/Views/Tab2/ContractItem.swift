//
//  Contract.swift
//  Finanztracker
//
//  Created by Khaled Abuhaltam on 28.11.24.
//

import SwiftUI

// View für eine einzelne Vertragszeile
struct ContractItem: View {
    let contract: ContractDto
    
    // Formatierer für das Datum
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    var body: some View {
        NavigationLink(destination: ContractView(contract: contract)) {
            VStack(alignment: .trailing) {
                HStack {
                    Label(contract.name, systemImage: contract.icon)
                        .lineLimit(1)
                    Spacer()
                    Text(contract.amount, format: .currency(code: "EUR"))
                        .fontWeight(.bold)
                }
                Text("Nächste Zahlung: \(contract.nextPaymentDate, formatter: dateFormatter)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 5)
        }
    }
}

#Preview {
    let contract = ContractDto(name: "Netflix", amount: 14.99, icon: "movieclapper", nextPaymentDate: Date(), frequency: "wöchentlich")
    ContractItem(contract: contract)
}
