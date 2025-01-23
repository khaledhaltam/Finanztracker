import SwiftUI

struct TestListe: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Fixierte Section oben
                HStack {
                    Text("Finanzübersicht")
                        .font(.headline)
                    Spacer()
                    Text("Insgesamt: 5000 €")
                        .foregroundColor(.green)
                }
                .padding()
                .background(Color(.systemBackground)) // Hintergrund für klare Abgrenzung
                .shadow(color: .gray.opacity(0.2), radius: 3, x: 0, y: 2) // Optionaler Schatten

                // Scrollbarer Bereich für die Liste
                List {
                    Section(header: Text("Debitkarten")) {
                        Text("Volksbank")
                        Text("Sparkasse")
                    }
                    
                    Section(header: Text("Kreditkarten")) {
                        Text("Amex Platinum")
                        Text("Amex Gold")
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Test")
        }
    }
}

#Preview {
    TestListe()
}
