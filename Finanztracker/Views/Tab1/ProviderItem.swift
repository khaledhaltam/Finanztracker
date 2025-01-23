import SwiftUI

struct ProviderItem: View {
    let provider: ProviderDto

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

    // Berechneter Gesamtbetrag basierend auf den Transaktionen
    private var totalAmount: Double {
        provider.transactions.reduce(0) { $0 + $1.amount }
    }

    var body: some View {
        HStack {
            Image(systemName: provider.icon)
                .resizable()
                .frame(width: 30, height: 30)
                .padding(.trailing, 8)
            Text(provider.title)
            Spacer()
            Text(totalAmount, format: .currency(code: "EUR"))
                .foregroundColor(amountColor(for: totalAmount))
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    let f = ProviderDto(
        title: "Volksbank Mittelhessen (...9433)",
        icon: "eurosign.bank.building",
        transactions: [
            TransactionDto(title: "Netflix", amount: 14.99, date: Date()),
            TransactionDto(title: "Amazon", amount: 399.99, date: Date()),
            TransactionDto(title: "DönerKING", amount: 8.98, date: Date()),
        ],
        type: .debitCard
    )
    ProviderItem(provider: f)
}
