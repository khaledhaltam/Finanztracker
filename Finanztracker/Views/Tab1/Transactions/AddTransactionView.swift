import SwiftUI

struct AddTransactionView: View {
    @EnvironmentObject var data: Data
    @Binding var provider: ProviderDto
    @Environment(\.presentationMode) var presentationMode

    @State private var title: String = ""
    @State private var amount: String = ""
    @State private var date = Date()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Transaktionsdetails")) {
                    TextField("Titel", text: $title)
                    HStack {
                        TextField("Betrag eingeben", text: $amount)
                            .keyboardType(.decimalPad)
                            .onChange(of: amount) { newValue in
                                // Nur Zahlen, Punkt, und ein Minuszeichen am Anfang erlauben
                                let filtered = newValue.filter {
                                    "0123456789.-".contains($0)
                                }
                                if filtered != newValue {
                                    amount = filtered
                                }
                                if amount.contains("-"),
                                    !amount.starts(with: "-")
                                {
                                    // Entfernt Minuszeichen, wenn es nicht am Anfang steht
                                    amount = amount.replacingOccurrences(
                                        of: "-", with: "")
                                }
                            }
                        Button(action: {
                            // Umschalten zwischen negativ und positiv
                            if amount.starts(with: "-") {
                                amount = String(amount.dropFirst())  // Entfernt das Minus
                            } else {
                                amount = "-" + amount  // Fügt das Minus hinzu
                            }
                        }) {
                            Text(amount.starts(with: "-") ? "+" : "−")  // Dynamischer Buttontext
                                .font(.title)
                        }
                    }
                    DatePicker(
                        "Datum", selection: $date, displayedComponents: .date)
                }
            }
            .navigationTitle("Neue Transaktion")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Speichern") {
                        saveTransaction()
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Abbrechen") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }

    private func saveTransaction() {
        guard let transactionAmount = Double(amount), !title.isEmpty else {
            return
        }

        let newTransaction = TransactionDto(
            title: title, amount: transactionAmount, date: date)

        if let index = data.providers.firstIndex(where: { $0.id == provider.id }
        ) {
            data.providers[index].transactions.append(newTransaction)
        }

        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    AddTransactionView(
        provider: .constant(
            ProviderDto(
                title: "Volksbank Mittelhessen (...9433)",
                icon: "eurosign.bank.building",
                transactions: [],
                type: .debitCard
            )))
}
