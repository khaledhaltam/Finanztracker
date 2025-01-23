//
//  Contracts.swift
//  Finanztracker
//
//  Created by Khaled Abuhaltam on 05.11.24.
//

import SwiftUI

// Beispiel-Daten
let sampleContracts = [
    ContractDto(name: "Netflix", amount: -12.99, icon: "film.fill", nextPaymentDate: Date().addingTimeInterval(86400 * 15), frequency: "Monatlich"),
    ContractDto(name: "Spotify", amount: -9.99, icon: "music.note", nextPaymentDate: Date().addingTimeInterval(86400 * 10), frequency: "Monatlich"),
    ContractDto(name: "Fitnessstudio", amount: -49.99, icon: "heart.fill", nextPaymentDate: Date().addingTimeInterval(86400 * 20), frequency: "Monatlich"),
    ContractDto(name: "Amazon Prime", amount: -69.00, icon: "cart.fill", nextPaymentDate: Date().addingTimeInterval(86400 * 30), frequency: "Jährlich")
]

struct ContractsView: View {
    // Liste der Verträge
    @State private var contracts: [ContractDto] = sampleContracts
    @State private var showingAddContract = false

    // Berechnung der monatlichen Einnahmen und Ausgaben
    private var monthlyIncome: Double {
        contracts
            .filter { $0.amount > 0 }
            .map { monthlyAmount(for: $0) }
            .reduce(0, +)
    }

    private var monthlyExpenses: Double {
        contracts
            .filter { $0.amount < 0 }
            .map { monthlyAmount(for: $0) }
            .reduce(0, +)
    }

    // Methode zur Umrechnung von Beträgen in monatliche Werte
    private func monthlyAmount(for contract: ContractDto) -> Double {
        switch contract.frequency {
        case "Täglich":
            return contract.amount * 30 // Durchschnittlich 30 Tage pro Monat
        case "Wöchentlich":
            return contract.amount * 4.33 // Durchschnittlich 4.33 Wochen pro Monat
        case "Monatlich":
            return contract.amount
        case "Jährlich":
            return contract.amount / 12 // Auf monatlichen Betrag umrechnen
        default:
            return 0
        }
    }

    var body: some View {
        NavigationView {
            List {
                // Statistiken oben hinzufügen
                Section {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Monatliche Einnahmen")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text(monthlyIncome, format: .currency(code: "EUR"))
                                .font(.title3)
                                .foregroundColor(.green)
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("Monatliche Ausgaben")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text(monthlyExpenses, format: .currency(code: "EUR"))
                                .font(.title3)
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.vertical, 8)
                }

                // Abschnitt für tägliche Verträge
                if !dailyContracts.isEmpty {
                    Section("Täglich") {
                        ForEach(dailyContracts) { contract in
                            ContractItem(contract: contract)
                        }
                    }
                }

                // Abschnitt für wöchentliche Verträge
                if !weeklyContracts.isEmpty {
                    Section("Wöchentlich") {
                        ForEach(weeklyContracts) { contract in
                            ContractItem(contract: contract)
                        }
                    }
                }

                // Abschnitt für monatliche Verträge
                if !monthlyContracts.isEmpty {
                    Section("Monatlich") {
                        ForEach(monthlyContracts) { contract in
                            ContractItem(contract: contract)
                        }
                    }
                }

                // Abschnitt für jährliche Verträge
                if !yearlyContracts.isEmpty {
                    Section("Jährlich") {
                        ForEach(yearlyContracts) { contract in
                            ContractItem(contract: contract)
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Verträge")
            .navigationBarItems(trailing:
                                    Button(action: {
                showingAddContract = true
            }) {
                Image(systemName: "plus")
            }
            )
            .sheet(isPresented: $showingAddContract) {
                AddContractView(contracts: $contracts)
            }
        }
    }

    // Gefilterte Verträge basierend auf Frequenz
    private var dailyContracts: [ContractDto] {
        contracts.filter { $0.frequency == "Täglich" }
    }

    private var weeklyContracts: [ContractDto] {
        contracts.filter { $0.frequency == "Wöchentlich" }
    }

    private var monthlyContracts: [ContractDto] {
        contracts.filter { $0.frequency == "Monatlich" }
    }

    private var yearlyContracts: [ContractDto] {
        contracts.filter { $0.frequency == "Jährlich" }
    }
}





#Preview {
    ContractsView()
}
