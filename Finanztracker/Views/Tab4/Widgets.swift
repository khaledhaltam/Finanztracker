//
//  WidgetsView.swift
//  Finanztracker
//
//  Created by Khaled Abuhaltam on 06.11.24.
//

import SwiftUI

struct Widgets: View {
    @State private var showBalanceWidget = true
    @State private var showTransactionsWidget = true
    @State private var updateFrequency = 15.0 // in Minuten
    @State private var selectedStyle = "Standard"
    
    let styles = ["Standard", "Kompakt", "Erweitert"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Widgets auswählen")) {
                    Toggle(isOn: $showBalanceWidget) {
                        Label("Kontostand anzeigen", systemImage: "banknote")
                    }
                    Toggle(isOn: $showTransactionsWidget) {
                        Label("Transaktionen anzeigen", systemImage: "list.bullet")
                    }
                }
                
                Section(header: Text("Widget-Stil")) {
                    Picker("Stil auswählen", selection: $selectedStyle) {
                        ForEach(styles, id: \.self) { style in
                            Text(style)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Aktualisierungshäufigkeit")) {
                    VStack(alignment: .leading) {
                        Text("Alle \(Int(updateFrequency)) Minuten aktualisieren")
                        Slider(value: $updateFrequency, in: 5...60, step: 5) {
                            Text("Aktualisierungshäufigkeit")
                        }
                    }
                }
            }
            .navigationTitle("Widget-Einstellungen")
        }
    }
}

#Preview {
    Widgets()
}
