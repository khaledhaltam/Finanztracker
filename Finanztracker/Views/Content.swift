//
//  ContentView.swift
//  Finanztracker
//
//  Created by Khaled Abuhaltam on 05.11.24.
//

import SwiftUI

struct Content: View {
    @StateObject private var data = Data() // Content-Instanz erstellen

    var body: some View {
        TabView {
            Tab("Konten", systemImage: "eurosign"){
                AccountsView()
                    .environmentObject(data)
            }
            .tabPlacement(.automatic)
            Tab("Verträge", systemImage: "mail.stack"){
                ContractsView()
            }
            Tab("Statistik", systemImage: "chart.bar"){
                StatisticsView()
                    .environmentObject(data)
            }
            Tab("Einstellungen", systemImage: "gearshape"){
                Settings()
            }
        }
    }
}

#Preview {
    Content()
}
