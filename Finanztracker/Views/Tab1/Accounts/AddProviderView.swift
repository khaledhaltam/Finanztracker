import SwiftUI

struct AddProviderView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var data: Data  // Zugriff auf das Data-Objekt

    @State private var name: String = ""
    @State private var icon: String = "doc.text"
    @State private var providerType: ProviderType = .debitCard

    @State private var showErrorForName = false
    @State private var showErrorForAmount = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Details")) {
                    VStack(alignment: .leading, spacing: 5) {
                        TextField("Name des Dienstleisters", text: $name)
                            .onChange(of: name) { _ in
                                showErrorForName = false
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(
                                        showErrorForName
                                            ? Color.red : Color.clear,
                                        lineWidth: 1)
                            )

                        if showErrorForName {
                            Text("Bitte geben Sie einen Namen ein.")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                }

                Section(header: Text("Typ des Finanzdienstleisters")) {
                    Picker("Typ", selection: $providerType) {
                        ForEach(ProviderType.allCases, id: \.self) { type in
                            Text(type.rawValue)
                        }
                    }
                }

                Section(header: Text("Symbol")) {
                    NavigationLink(
                        destination: SymbolPicker(selectedIcon: $icon)
                    ) {
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
                    // Validierung vor dem Speichern
                    validateAndSave()
                }
            )
        }
    }

    private func validateAndSave() {
        var isValid = true

        // Überprüfe den Namen
        if name.isEmpty {
            showErrorForName = true
            isValid = false
        }


        // Speichern, wenn alle Felder gültig sind
        if isValid {
            print("isValid")
            let newProvider = ProviderDto(
                title: name,
                icon: icon,
                transactions: [],  // Leere Transaktionsliste
                type: providerType  // Enum-Typ speichern
            )
            data.providers.append(newProvider)
            presentationMode.wrappedValue.dismiss()
            print("dimiss")

        }
    }
}

#Preview {
    AddProviderView()
        .environmentObject(Data())  // Vorschau mit einem Beispiel-Datenobjekt
}
