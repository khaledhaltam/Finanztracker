import SwiftUI

struct AccountsView: View {
    @EnvironmentObject var data: Data  // Zugriff auf das Data-Objekt

    @State private var providerToDelete: ProviderDto?  // Zum Speichern des zu löschenden Elements
    @State private var showingDeleteConfirmation = false  // Zeigt das Alert an

    @State private var showingAddContract = false

    // Berechnung des Gesamtbetrags
    private var totalBalance: Double {
        data.providers.flatMap { $0.transactions }.reduce(0) { $0 + $1.amount }
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
                Section(
                    header:
                        // "Alle Umsätze"-Abschnitt mit Gesamtberechnung
                        HStack {
                            Text("Alle Umsätze")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Color.gray)
                            Spacer()
                            Text(
                                totalBalance, format: .currency(code: "EUR")
                            )
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(amountColor(for: totalBalance))
                        }
                ) {
                    // Finanzabschnitte basierend auf dem Typ
                    ForEach(ProviderType.allCases) { type in
                        let filteredProviders = data.providers.filter {
                            $0.type == type
                        }
                        let sectionBalance = filteredProviders
                            .flatMap { $0.transactions }
                            .reduce(0) { $0 + $1.amount }

                        if !filteredProviders.isEmpty {
                            HStack {
                                Text(type.rawValue)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.gray)
                                Spacer()
                                Text(
                                    sectionBalance,
                                    format: .currency(code: "EUR")
                                )
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(
                                    amountColor(for: sectionBalance))
                            }
                            .padding(.top)

                            ForEach(filteredProviders) { provider in
                                NavigationLink(
                                    destination: ProviderView(
                                        provider: provider)
                                ) {
                                    ProviderItem(provider: provider)
                                }
                                .opacity(0)  // Versteckt die Pfeile, lässt aber die Interaktion intakt
                                .background(
                                    ProviderItem(provider: provider)

                                    // Ersetzt die versteckten Pfeile durch die tatsächliche Ansicht
                                )
                                .swipeActions {
                                    Button {
                                        providerToDelete = provider
                                        showingDeleteConfirmation = true
                                    } label: {
                                        Label("Löschen", systemImage: "trash")
                                    }
                                    .tint(.red)  // Zeige den Button in Rot an
                                }
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Konten")
            .navigationBarItems(
                trailing:
                    Button(action: {
                        showingAddContract = true
                    }) {
                        Image(systemName: "plus")
                    }
            )
            .sheet(isPresented: $showingAddContract) {
                AddProviderView()
                    .environmentObject(data)
            }
            .alert("Provider löschen", isPresented: $showingDeleteConfirmation)
            {
                Button("Abbrechen", role: .cancel) {}
                Button("Löschen", role: .destructive) {
                    if let providerToDelete = providerToDelete {
                        deleteProvider(providerToDelete)
                    }
                }
            } message: {
                Text("Möchten Sie diesen Provider wirklich löschen?")
            }
        }

    }
    private func deleteProvider(_ provider: ProviderDto) {
        if let index = data.providers.firstIndex(where: { $0.id == provider.id }
        ) {
            data.providers.remove(at: index)
        }
    }
}

#Preview {
    AccountsView()
        .environmentObject(Data())
}
