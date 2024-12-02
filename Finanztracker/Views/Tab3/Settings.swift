//
//  Settings.swift
//  Finanztracker
//
//  Created by Khaled Abuhaltam on 05.11.24.
//

import SwiftUI

struct Settings: View {
    @State private var isFaceIDEnabled = false
    
    var body: some View {
        NavigationView {
            List {
                HStack{
                    Spacer()
                    VStack{
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.gray)
                        Text("Khaled Abuhaltam")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                    }
                    .padding(.vertical)
                    Spacer()
                }
                // Konto-Abschnitt
                Section(header: Text("Konto")) {
                    NavigationLink(destination: PersonalInfo()) {
                        Label("Persönliche Angaben", systemImage: "person.crop.circle")
                    }
                    NavigationLink(destination: ResetPassword()) {
                        Label("Passwort zurücksetzen", systemImage: "key.viewfinder")
                    }
                }
                
                // Anpassungen-Abschnitt
                Section(header: Text("Anpassungen")) {
                    NavigationLink(destination: Widgets()) {
                        Label("Widgets", systemImage: "widget.small")
                    }
                    Toggle(isOn: $isFaceIDEnabled) {
                        Label("Face ID", systemImage: "faceid")
                    }
                }
                
                // Abmelde-Button
                Button("Abmelden") {
                    // Abmelden-Aktion
                }
                .foregroundColor(.red)
            }
            //.listStyle(.plain)
            .navigationTitle("Einstellungen")
        }
    }
}

#Preview {
    Settings()
}
