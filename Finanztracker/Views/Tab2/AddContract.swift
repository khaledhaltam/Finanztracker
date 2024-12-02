import SwiftUI

struct AddContract: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var contracts: [ContractDto]
    
    @State private var name: String = ""
    @State private var amount: String = ""
    @State private var icon: String = "doc.text"
    @State private var nextPaymentDate = Date()
    @State private var frequency: String = "Monatlich"
    
    let frequencies = ["Täglich", "Wöchentlich", "Monatlich", "Jährlich"]
    
    // Formatierte Anzeige des Betrags als Double, falls konvertierbar
    private var formattedAmount: String {
        if let doubleAmount = Double(amount) {
            return doubleAmount.formatted(.currency(code: "EUR"))
        }
        let zero = 0.00
        return zero.formatted(.currency(code: "EUR"))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section{
                    TextField("Titel", text: $name)
                    HStack {
                        TextField("\(formattedAmount)", text: $amount)
                            .keyboardType(.decimalPad)
                            .onChange(of: amount) { newValue in
                                // Filter für Zahlen und Dezimaltrennzeichen
                                let filtered = newValue.filter { "0123456789.,".contains($0) }
                                let standardized = filtered.replacingOccurrences(of: ",", with: ".")
                                if standardized != amount {
                                    amount = standardized
                                }
                            }
                        Text(formattedAmount)
                            .foregroundColor(.gray)
                    }
                }
                Section{
                    NavigationLink(destination: SymbolPicker(selectedIcon: $icon)) {
                        HStack {
                            Text("Symbol")
                            Spacer()
                            Image(systemName: icon)
                        }
                    }
                }
                Section{
                    DatePicker("Nächste Abbuchung", selection: $nextPaymentDate, displayedComponents: .date)
                    Picker("Intervall", selection: $frequency) {
                        ForEach(frequencies, id: \.self) { freq in
                            Text(freq)
                        }
                    }
                }
            }
            .navigationTitle("Neuer Vertrag")
            .navigationBarItems(leading:Button("Abbrechen") {
                presentationMode.wrappedValue.dismiss()
            },trailing:Button("Speichern") {
                // Validierung und Hinzufügen des neuen Vertrags
                if let amountValue = Double(amount), !name.isEmpty {
                    let newContract = ContractDto(
                        name: name,
                        amount: amountValue,
                        icon: icon,
                        nextPaymentDate: nextPaymentDate,
                        frequency: frequency
                    )
                    contracts.append(newContract)
                    presentationMode.wrappedValue.dismiss()
                }
            }
            )
        }
    }
}

#Preview {
    // Beispiel-Daten
    @Previewable @State var contracts = sampleContracts
    // Beispiel-Daten
    let sampleContracts = [
        ContractDto(name: "Netflix", amount: 12.99, icon: "film.fill", nextPaymentDate: Date().addingTimeInterval(86400 * 15), frequency: "Monatlich"),
        ContractDto(name: "Spotify", amount: 9.99, icon: "music.note", nextPaymentDate: Date().addingTimeInterval(86400 * 10), frequency: "Monatlich"),
        ContractDto(name: "Fitnessstudio", amount: 49.99, icon: "heart.fill", nextPaymentDate: Date().addingTimeInterval(86400 * 20), frequency: "Monatlich"),
        ContractDto(name: "Amazon Prime", amount: 69.00, icon: "cart.fill", nextPaymentDate: Date().addingTimeInterval(86400 * 30), frequency: "Jährlich")
    ]
    AddContract(contracts: $contracts)
}
