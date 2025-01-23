import SwiftUI

struct TransactionView: View {
    let transaction: TransactionDto
    
    // Farbe für den Betrag basierend auf positiv oder negativ
    private var amountColor: Color {
        transaction.amount >= 0 ? .green : .red
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Titel der Transaktion
            Text(transaction.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            // Betrag der Transaktion
            Text(transaction.amount, format: .currency(code: "EUR"))
                .font(.title)
                .foregroundColor(amountColor)
            
            // Datum der Transaktion
            Text("Datum: \(transaction.date.formatted(.dateTime.day().month().year()))")
                .font(.headline)
                .foregroundColor(.gray)
            
            Spacer()
            
            // Zusätzliche Informationen oder Aktionen
            VStack(alignment: .leading, spacing: 8) {
                Text("Details")
                    .font(.headline)
                    .underline()
                
                Text("Kategorie: Beispielkategorie")
                Text("Zahlungsmethode: Karte")
                Text("Status: Abgeschlossen")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
            .padding(.horizontal)
        }
        .padding()
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let exampleTransaction = TransactionDto(
        title: "Einkauf Lidl",
        amount: -23.45,
        date: Date()
    )
    TransactionView(transaction: exampleTransaction)
}
