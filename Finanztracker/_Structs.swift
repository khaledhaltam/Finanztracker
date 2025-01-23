//
//  Structs.swift
//  Finanztracker
//
//  Created by Khaled Abuhaltam on 06.11.24.
//

import Foundation

// Einzelne Finanzdienstleister in einer Kategorie
struct ProviderDto: Identifiable{
    let id = UUID()
    let title: String
    let icon: String
    var transactions: [TransactionDto]
    let type: ProviderType
}

// Transaktionen in einem Finanzdienstleister
struct TransactionDto: Identifiable {
    let id = UUID()
    let title: String
    let amount: Double
    let date: Date
    // category
}

// Modell für einen Vertrag
struct ContractDto: Identifiable {
    let id = UUID()
    let name: String
    let amount: Double
    let icon: String
    let nextPaymentDate: Date
    let frequency: String // z.B. "Monatlich", "Jährlich"
}

enum ProviderType: String, CaseIterable, Identifiable {
    case debitCard = "Debitkarte"
    case creditCard = "Kreditkarte"
    case other = "Sonstiges"
    
    var id: String { self.rawValue }
}

