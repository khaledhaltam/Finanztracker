import SwiftUI

struct AddTransactionView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var provider: ProviderDto // Verwende Binding, um Änderungen vorzunehmen

    @State private var title: String = ""
    @State private var amount: String = ""
    @State private var date = Date()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Details")) {
                    TextField("Titel", text: $title)
                    TextField("Betrag", text: $amount)
                        .keyboardType(.decimalPad)
                    DatePicker("Datum", selection: $date, displayedComponents: .date)
                }

                Section {
                    Button(action: {
                        addTransaction()
                    }) {
                        HStack {
                            Spacer()
                            Text("Speichern")
                                .fontWeight(.bold)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Transaktion hinzufügen")
            .navigationBarItems(
                leading: Button("Abbrechen") {
                    dismiss()
                }
            )
        }
    }

    private func addTransaction() {
        // Logik zum Hinzufügen der Transaktion
        guard let amountValue = Double(amount) else { return }
        let newTransaction = TransactionDto(title: title, amount: amountValue, date: date)
        provider.transactions.append(newTransaction) // Transaktion zur Liste hinzufügen
        dismiss()
    }
}

#Preview {
    AddTransactionView(provider: .constant(ProviderDto(
        title: "Volksbank Mittelhessen (...9433)",
        icon: "eurosign.bank.building",
        transactions: [],
        type: .debitCard
    )))
}
