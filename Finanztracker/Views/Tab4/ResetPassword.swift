//
//  ResetPasswordView.swift
//  Finanztracker
//
//  Created by Khaled Abuhaltam on 06.11.24.
//

import SwiftUI

struct ResetPassword: View {
    @State private var currentPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var showPasswordMismatchAlert = false
    @State private var showSuccessAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Aktuelles Passwort")) {
                    SecureField("Aktuelles Passwort", text: $currentPassword)
                }
                
                Section(header: Text("Neues Passwort")) {
                    SecureField("Neues Passwort", text: $newPassword)
                    SecureField("Neues Passwort bestätigen", text: $confirmPassword)
                }
                
                Section {
                    Button(action: {
                        // Validierung der Passwörter
                        if newPassword == confirmPassword && !newPassword.isEmpty {
                            // Aktion zum Zurücksetzen des Passworts
                            // Hier könntest du die Funktion zum Ändern des Passworts aufrufen
                            // resetPassword(currentPassword: currentPassword, newPassword: newPassword)
                            showSuccessAlert = true
                        } else {
                            showPasswordMismatchAlert = true
                        }
                    }) {
                        Text("Passwort zurücksetzen")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .alert(isPresented: $showPasswordMismatchAlert) {
                        Alert(
                            title: Text("Fehler"),
                            message: Text("Die neuen Passwörter stimmen nicht überein."),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                    .alert(isPresented: $showSuccessAlert) {
                        Alert(
                            title: Text("Erfolg"),
                            message: Text("Dein Passwort wurde erfolgreich geändert."),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }
            }
            .navigationTitle("Passwort zurücksetzen")
        }
    }
}

#Preview {
    ResetPassword()
}
