//
//  FinancialSection.swift
//  Finanztracker
//
//  Created by Khaled Abuhaltam on 06.11.24.
//

import SwiftUI

struct SectionProvider: View {
    let title: String
    let providerList: [ProviderDto]
    
    // Berechnete Eigenschaft für den Gesamtbetrag
    private var total: Double {
        providerList.reduce(0) { $0 + $1.amount }
    }
    
    // Berechnete Eigenschaft für die Farbe des Gesamtbetrags
    private var totalColor: Color {
        if total > 0 {
            return .green
        } else if total < 0 {
            return .red
        } else {
            return .gray
        }
    }
    
    var body: some View {
        Section(header: HStack {
            Text(title)
                .font(.body)
                .fontWeight(.bold)
                .foregroundColor(Color.gray)
            Spacer()
            Text(total, format: .currency(code: "EUR"))
                .font(.body)
                .fontWeight(.bold)
                .foregroundColor(totalColor)
        }
            .padding(.top)
        ) {
            ForEach(providerList) { provider in
                NavigationLink(destination: Transactions(provider: provider)){
                    Provider(provider: provider)
                }
            }
        }
        
    }
}
