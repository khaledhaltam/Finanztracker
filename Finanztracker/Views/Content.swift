//
//  ContentView.swift
//  Finanztracker
//
//  Created by Khaled Abuhaltam on 05.11.24.
//

import SwiftUI

struct Content: View {
    var body: some View {
        TabView {
            Tab("Übersicht", systemImage: "eurosign"){
                Overview()
            }
            .tabPlacement(.automatic)
            Tab("Verträge", systemImage: "mail.stack"){
                Contracts()
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
