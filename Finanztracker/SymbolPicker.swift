import SwiftUI

struct SymbolPicker: View {
    @Binding var selectedIcon: String
    
    // Symbole für verschiedene Kategorien
    let categories: [String: [String]] = [
        "Allgemein": ["doc.text", "doc.richtext", "bookmark.fill", "calendar", "clock.fill", "bell.fill", "star.fill", "heart.fill"],
        "Haushalt": ["house.fill", "bed.double.fill", "tv.fill", "lightbulb.fill", "thermometer", "fanblades.fill", "fork.knife"],
        "Transport": ["car.fill", "bus.fill", "bicycle", "tram.fill", "airplane", "fuelpump.fill", "figure.walk", "figure.wave"],
        "Freizeit": ["cart.fill", "gift.fill", "gamecontroller.fill", "ticket.fill", "music.note", "theatermasks.fill", "wineglass.fill"],
        "Verträge": ["signature", "creditcard.fill", "dollarsign.circle.fill", "eurosign.circle.fill", "doc.append.fill", "doc.on.clipboard.fill"]
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(categories.keys.sorted(), id: \.self) { category in
                    VStack(alignment: .leading) {
                        Text(category)
                            .font(.headline)
                            .padding(.leading, 16)
                            .padding(.top, 16)
                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 20) {
                            ForEach(categories[category]!, id: \.self) { symbol in
                                Button(action: {
                                    selectedIcon = symbol
                                }) {
                                    VStack {
                                        Image(systemName: symbol)
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .padding()
                                            .background(selectedIcon == symbol ? Color.blue.opacity(0.2) : Color.clear)
                                            .cornerRadius(8)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Symbol auswählen")
        }
    }
}

// Vorschau für den SymbolPicker
struct SymbolPicker_Previews: PreviewProvider {
    static var previews: some View {
        // Beispielzustand für Vorschau
        @State var selectedIcon = "doc.text"
        
        SymbolPicker(selectedIcon: $selectedIcon)
    }
}
