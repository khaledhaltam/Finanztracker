import SwiftUI

struct AddProvider: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = ""
    @State private var amount: String = ""
    @State private var icon: String = "doc.text"
    @State private var providerType: ProviderType = .debitCard
    
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
                Section(header: Text("Details")) {
                    TextField("Name des Dienstleisters", text: $name)
                    
                    HStack {
                        TextField("Anfangsbetrag", text: $amount)
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
                
                Section(header: Text("Typ des Finanzdienstleisters")) {
                    Picker("Typ", selection: $providerType) {
                        ForEach(ProviderType.allCases) { type in
                            Text(type.rawValue)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section(header: Text("Symbol")) {
                    NavigationLink(destination: SymbolPicker(selectedIcon: $icon)) {
                        HStack {
                            Text("Symbol auswählen")
                            Spacer()
                            Image(systemName: icon)
                        }
                    }
                }
            }
            .navigationTitle("Neuer Finanzdienstleister")
            .navigationBarItems(
                leading: Button("Abbrechen") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Speichern") {
                    // Validierung und Hinzufügen des neuen Dienstleisters
                    if let amountValue = Double(amount), !name.isEmpty {
                        let newProvider = ProviderDto(
                            title: name,
                            amount: amountValue,
                            icon: icon,
                            transactions: [], // Leere Transaktionsliste
                            type: providerType // Enum-Typ speichern
                        )
                        // Hier könntest du den neuen Dienstleister speichern
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            )
        }
    }
}

#Preview {
    AddProvider()
}
