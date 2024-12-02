//
//  Contracts.swift
//  Finanztracker
//
//  Created by Khaled Abuhaltam on 05.11.24.
//

import SwiftUI

// Beispiel-Daten
let sampleContracts = [
    ContractDto(name: "Netflix", amount: 12.99, icon: "film.fill", nextPaymentDate: Date().addingTimeInterval(86400 * 15), frequency: "Monatlich"),
    ContractDto(name: "Spotify", amount: 9.99, icon: "music.note", nextPaymentDate: Date().addingTimeInterval(86400 * 10), frequency: "Monatlich"),
    ContractDto(name: "Fitnessstudio", amount: 49.99, icon: "heart.fill", nextPaymentDate: Date().addingTimeInterval(86400 * 20), frequency: "Monatlich"),
    ContractDto(name: "Amazon Prime", amount: 69.00, icon: "cart.fill", nextPaymentDate: Date().addingTimeInterval(86400 * 30), frequency: "Jährlich")
]

struct Contracts: View {
    // Liste der Verträge
    @State private var contracts: [ContractDto] = sampleContracts
    @State private var showingAddContract = false
    
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
    
    var body: some View {
        NavigationView {
            List {
                // Abschnitt für tägliche Verträge
                if !dailyContracts.isEmpty {
                    Section("Täglich") {
                        ForEach(dailyContracts) { contract in
                            Contract(contract: contract)
                        }
                    }
                }
                
                // Abschnitt für wöchentliche Verträge
                if !weeklyContracts.isEmpty {
                    Section("Wöchentlich") {
                        ForEach(weeklyContracts) { contract in
                            Contract(contract: contract)
                        }
                    }
                }
                
                // Abschnitt für monatliche Verträge
                if !monthlyContracts.isEmpty {
                    Section("Monatlich") {
                        ForEach(monthlyContracts) { contract in
                            Contract(contract: contract)
                        }
                    }
                }
                
                // Abschnitt für jährliche Verträge
                if !yearlyContracts.isEmpty {
                    Section("Jährlich") {
                        ForEach(yearlyContracts) { contract in
                            Contract(contract: contract)
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
                AddContract(contracts: $contracts)
            }
        }
    }
}





#Preview {
    Contracts()
}
