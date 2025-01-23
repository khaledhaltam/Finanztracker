import SwiftUI
import Charts

struct StatisticsView: View {
    @EnvironmentObject var data: Data // Zugriff auf die Finanzdaten

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Gesamtübersicht
                    totalOverviewSection

                    // Einnahmen- und Ausgaben-Chart
                    incomeExpenseChart

                    // Kategorieübersicht
                    categoryBreakdownChart

                    // Top 3 Transaktionen
                    topTransactionsSection
                }
                .padding()
            }
            .navigationTitle("Statistiken")
        }
    }

    // MARK: - Gesamtübersicht
    private var totalOverviewSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Gesamtübersicht")
                .font(.headline)

            HStack {
                VStack(alignment: .leading) {
                    Text("Gesamtguthaben")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(totalBalance, format: .currency(code: "EUR"))
                        .font(.title3)
                        .foregroundColor(totalBalance >= 0 ? .green : .red)
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("Gesamteinnahmen")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(totalIncome, format: .currency(code: "EUR"))
                        .font(.title3)
                        .foregroundColor(.green)
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("Gesamtausgaben")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(totalExpenses, format: .currency(code: "EUR"))
                        .font(.title3)
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }

    // MARK: - Einnahmen- und Ausgaben-Chart
    private var incomeExpenseChart: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Einnahmen und Ausgaben")
                .font(.headline)

            Chart {
                BarMark(
                    x: .value("Kategorie", "Einnahmen"),
                    y: .value("Betrag", totalIncome)
                )
                .foregroundStyle(Color.green)

                BarMark(
                    x: .value("Kategorie", "Ausgaben"),
                    y: .value("Betrag", -totalExpenses)
                )
                .foregroundStyle(Color.red)
            }
            .frame(height: 200)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }

    // MARK: - Kategorieübersicht
    private var categoryBreakdownChart: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Kategorieübersicht")
                .font(.headline)

            Chart {
                ForEach(ProviderType.allCases, id: \ .self) { type in
                    let totalForCategory = data.providers
                        .filter { $0.type == type }
                        .flatMap { $0.transactions }
                        .reduce(0) { $0 + $1.amount }

                    BarMark(
                        x: .value("Kategorie", type.rawValue),
                        y: .value("Betrag", totalForCategory)
                    )
                    .foregroundStyle(totalForCategory >= 0 ? Color.green : Color.red)
                }
            }
            .frame(height: 200)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }

    // MARK: - Top 3 Transaktionen
    private var topTransactionsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Top 3 Transaktionen")
                .font(.headline)

            let topTransactions = data.providers
                .flatMap { $0.transactions }
                .sorted { $0.amount > $1.amount }
                .prefix(3)

            ForEach(topTransactions, id: \ .id) { transaction in
                HStack {
                    VStack(alignment: .leading) {
                        Text(transaction.title)
                            .font(.subheadline)
                        Text(transaction.date, style: .date)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Text(transaction.amount, format: .currency(code: "EUR"))
                        .font(.title3)
                        .foregroundColor(transaction.amount >= 0 ? .green : .red)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }

    // MARK: - Helper Properties
    private var totalBalance: Double {
        data.providers.flatMap { $0.transactions }.reduce(0) { $0 + $1.amount }
    }

    private var totalIncome: Double {
        data.providers.flatMap { $0.transactions }.reduce(0) { $0 + max($1.amount, 0) }
    }

    private var totalExpenses: Double {
        data.providers.flatMap { $0.transactions }.reduce(0) { $0 + min($1.amount, 0) }
    }

    private var averageIncome: Double {
        let incomes = data.providers.flatMap { $0.transactions.map { max($0.amount, 0) } }
        return incomes.isEmpty ? 0 : incomes.reduce(0, +) / Double(incomes.count)
    }

    private var averageExpenses: Double {
        let expenses = data.providers.flatMap { $0.transactions.map { min($0.amount, 0) } }
        return expenses.isEmpty ? 0 : expenses.reduce(0, +) / Double(expenses.count)
    }
}

#Preview {
    StatisticsView()
        .environmentObject(Data()) // Beispiel-Daten hinzufügen
}
