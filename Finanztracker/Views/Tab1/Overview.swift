import SwiftUI

struct Overview: View {

    @State private var showingAddContract = false

    // Beispiel-Daten für alle Finanzdienstleister
    private let providers = [
        ProviderDto(
            title: "Volksbank Mittelhessen (...9433)", amount: 1544.08,
            icon: "eurosign.bank.building",
            transactions: [
                TransactionDto(title: "Netflix", amount: 14.99, date: Date()),
                TransactionDto(title: "Amazon", amount: 399.99, date: Date()),
                TransactionDto(title: "DönerKING", amount: 8.98, date: Date()),
            ],
            type: .debitCard
        ),
        ProviderDto(
            title: "Sparkasse (...4100)", amount: 12.56,
            icon: "eurosign.bank.building",
            transactions: [
                TransactionDto(title: "Netflix", amount: 14.99, date: Date()),
                TransactionDto(title: "Amazon", amount: 399.99, date: Date()),
                TransactionDto(title: "DönerKING", amount: 8.98, date: Date()),
            ],
            type: .debitCard
        ),
        ProviderDto(
            title: "American Express Platinum Karte", amount: -2108.11,
            icon: "creditcard",
            transactions: [
                TransactionDto(title: "Netflix", amount: 14.99, date: Date()),
                TransactionDto(title: "Amazon", amount: 399.99, date: Date()),
                TransactionDto(title: "DönerKING", amount: 8.98, date: Date()),
            ],
            type: .creditCard
        ),
        ProviderDto(
            title: "American Express Gold Karte", amount: 0, icon: "creditcard",
            transactions: [
                TransactionDto(title: "Netflix", amount: 14.99, date: Date()),
                TransactionDto(title: "Amazon", amount: 399.99, date: Date()),
                TransactionDto(title: "DönerKING", amount: 8.98, date: Date()),
            ],
            type: .creditCard
        ),
        ProviderDto(
            title: "Bank of Norwegian", amount: -254.86, icon: "creditcard",
            transactions: [
                TransactionDto(title: "Netflix", amount: 14.99, date: Date()),
                TransactionDto(title: "Amazon", amount: 399.99, date: Date()),
                TransactionDto(title: "DönerKING", amount: 8.98, date: Date()),
            ],
            type: .creditCard
        ),
        ProviderDto(
            title: "PayPal", amount: 0, icon: "briefcase",
            transactions: [
                TransactionDto(title: "Netflix", amount: 14.99, date: Date()),
                TransactionDto(title: "Amazon", amount: 399.99, date: Date()),
                TransactionDto(title: "DönerKING", amount: 8.98, date: Date()),
            ],
            type: .other
        ),
    ]

    // Berechnung des Gesamtbetrags
    private var totalBalance: Double {
        providers.reduce(0) { $0 + $1.amount }
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
        NavigationView {
            List {
                // "Alle Umsätze"-Abschnitt mit Gesamtberechnung
                Section(
                    header:
                        HStack {
                            Text("Alle Umsätze")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(Color.gray)
                            Spacer()
                            Text(totalBalance, format: .currency(code: "EUR"))
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(amountColor(for: totalBalance))
                        }
                ) {
                }
                // Finanzabschnitte basierend auf dem Typ
                ForEach(ProviderType.allCases) { type in
                    let filteredProviders = providers.filter { $0.type == type }
                    let sectionBalance = filteredProviders.reduce(0) { $0 + $1.amount }

                    if !filteredProviders.isEmpty {
                        Section(
                            header:
                                HStack {
                                    Text(type.rawValue)
                                        .font(.headline)
                                    Spacer()
                                    Text(sectionBalance, format: .currency(code: "EUR"))
                                        .font(.headline)
                                        .foregroundColor(amountColor(for: sectionBalance))
                                }
                        ) {
                            ForEach(filteredProviders) { provider in
                                NavigationLink(
                                    destination: Transactions(
                                        provider: provider)
                                ) {
                                    Provider(provider: provider)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Finanzen")
            .navigationBarItems(
                trailing:
                    Button(action: {
                        showingAddContract = true
                    }) {
                        Image(systemName: "plus")
                    }
            )
            .sheet(isPresented: $showingAddContract) {
                AddProvider()
            }
        }
    }
}

#Preview {
    Overview()
}
