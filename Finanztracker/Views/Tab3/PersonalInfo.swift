//
//  PersonalInfoView.swift
//  Finanztracker
//
//  Created by Khaled Abuhaltam on 06.11.24.
//

import SwiftUI

struct PersonalInfo: View {
    @State private var name: String = "Khaled Abuhaltam"
    @State private var email: String = "khaled@example.com"
    @State private var phone: String = "+49 123 456 7890"
    @State private var address: String = "Beispielstraße 123, 12345 Musterstadt"
    @State private var birthdate = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Persönliche Informationen")) {
                    TextField("Name", text: $name)
                        .textContentType(.name)
                        .autocapitalization(.words)
                    
                    TextField("E-Mail", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                    
                    TextField("Telefonnummer", text: $phone)
                        .textContentType(.telephoneNumber)
                        .keyboardType(.phonePad)
                    
                    DatePicker("Geburtsdatum", selection: $birthdate, displayedComponents: .date)
                }
                
                Section(header: Text("Adresse")) {
                    TextField("Adresse", text: $address)
                        .textContentType(.fullStreetAddress)
                        .autocapitalization(.words)
                }
                
                Section {
                    Button(action: {
                        // Aktion zum Speichern der Änderungen
                    }) {
                        Text("Änderungen speichern")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .navigationTitle("Persönliche Angaben")
        }
    }
}

#Preview {
    PersonalInfo()
}
