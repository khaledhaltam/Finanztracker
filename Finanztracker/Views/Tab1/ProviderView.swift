import SwiftUI

struct ProviderView: View {
    @EnvironmentObject var data: Data
    var provider: ProviderDto

    @State private var showingAddTransaction = false

    var body: some View {
        VStack {
            VStack(spacing: 8) {
                Text("Kontostand")
                    .font(.headline)
                    .foregroundColor(.gray)
                Text(totalBalance, format: .currency(code: "EUR"))
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(amountColor(for: totalBalance))
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)
            .padding(.top)



            if provider.transactions.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "tray.and.arrow.down.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)

                    Text("Keine Transaktionen gefunden")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)

                    Text("Fügen Sie Ihre erste Transaktion hinzu, um den Überblick zu behalten.")
                        .multilineTextAlignment(.center)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)

                    Button(action: {
                        showingAddTransaction = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle")
                            Text("Erste Transaktion hinzufügen")
                                .fontWeight(.semibold)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                .padding()
            } else {
                List {
                    ForEach(sortedGroupedTransactions.keys.sorted(by: >), id: \.self) { dateKey in
                        if let transactions = sortedGroupedTransactions[dateKey] {
                            let monthBalance = transactions.reduce(0) { $0 + $1.amount }
                            let formattedMonth = formatDate(dateKey)

                            Section(header: MonthHeaderView(month: formattedMonth, balance: monthBalance)) {
                                ForEach(transactions) { transaction in
                                    TransactionItem(transaction: transaction)
                                }
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .navigationBarItems(
                    trailing:
                        Button(action: {
                            showingAddTransaction = true
                        }) {
                            Image(systemName: "plus")
                        }
                )
            }
        }
        .navigationTitle(provider.title)
        .sheet(isPresented: $showingAddTransaction) {
            AddTransactionView(provider: $data.providers[data.providers.firstIndex(where: { $0.id == provider.id })!])
                .environmentObject(data)
        }
    }

    private var totalBalance: Double {
        provider.transactions.reduce(0) { $0 + $1.amount }
    }

    private func amountColor(for amount: Double) -> Color {
        if amount > 0 {
            return .green
        } else if amount < 0 {
            return .red
        } else {
            return .gray
        }
    }

    private var sortedGroupedTransactions: [Date: [TransactionDto]] {
        // Gruppierung nach Jahr und Monat
        let grouped = Dictionary(grouping: provider.transactions) { transaction in
            Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: transaction.date))!
        }

        // Sortierung der Transaktionen in jeder Gruppe
        return grouped.mapValues { transactions in
            transactions.sorted { $0.date > $1.date }
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
}

struct MonthHeaderView: View {
    let month: String
    let balance: Double

    var body: some View {
        HStack {
            Text(month)
                .font(.headline)
            Spacer()
            Text(balance, format: .currency(code: "EUR"))
                .font(.headline)
                .foregroundColor(balance >= 0 ? .green : .red)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    let provider = ProviderDto(
        title: "Volksbank Mittelhessen (...9433)",
        icon: "eurosign.bank.building",
        transactions: [
            TransactionDto(title: "Netflix", amount: -12.99, date: Date().addingTimeInterval(-86400 * 2)),
            TransactionDto(title: "Amazon", amount: -50.00, date: Date().addingTimeInterval(-86400 * 30)),
            TransactionDto(title: "Gehaltszahlung", amount: 2000.00, date: Date().addingTimeInterval(-86400 * 60)),
            TransactionDto(title: "Spotify", amount: -9.99, date: Date().addingTimeInterval(-86400 * 90))
        ],
        type: .debitCard
    )
    ProviderView(provider: provider)
}
