//
//  AImageApp.swift
//  AImage
//
//  Created by Astrid Lanz on 17.12.2023.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var userManager: UserManager
    @State private var newPassword = ""
    @State private var newApiKey = ""
    @State private var activeAlert: ActiveAlert?
    
    enum ActiveAlert: Identifiable {
        case apiKeyUpdate(String), PWupdate(String), clearKeychain, logout

        var id: String {
            switch self {
            case .apiKeyUpdate(let message):
                return "apiKeyUpdate_\(message)"
            case .PWupdate(let message):
                return "PWupdate_\(message)"
            case .clearKeychain:
                return "clearKeychain"
            case .logout:
                return "logout"
            }
        }
    }

    
    var body: some View {
        ZStack {
            backgroundGradient.ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 20) {
                LogoView()
                Spacer()
                VStack {
                    if let username = userManager.getCurrentUsername() {
                        Text("You are logged in as \(username)")
                            .font(.title)
                            .multilineTextAlignment(.center)
                        
                    } else {
                        Text("Not logged in")
                            .font(.title)
                    }
                }
                
                ScrollView {
                    
                    apiKeySection
                    passwordSection
                    Spacer(minLength: 20)
                    clearKeychainSection
                    Spacer(minLength: 50)
                    logoutSection
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
            }
        }
        
        .alert(item: $activeAlert) { alertType in
            switch alertType {
            case .apiKeyUpdate(let message):
                return Alert(
                    title: Text("API Key Update"),
                    message: Text(message),
                    dismissButton: .default(Text("OK"))
                )
            case .PWupdate(let message):
                return Alert(
                    title: Text("Password Change"),
                    message: Text(message),
                    dismissButton: .default(Text("OK"))
                )
            case .clearKeychain:
                return Alert(
                    title: Text("Confirm Delete Keychain Entries"),
                    message: Text("Are you sure? This action cannot be undone."),
                    primaryButton: .destructive(Text("Delete")) {
                        userManager.clearKeychain()
                    },
                    secondaryButton: .cancel()
                )
            case .logout:
                return Alert(
                    title: Text("Confirm Logout"),
                    message: Text("Are you sure you want to log out?"),
                    primaryButton: .destructive(Text("Logout")) {
                        userManager.logout()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }

    private var apiKeySection: some View {
        VStack {
            Text("Change your API Token")
            SecureField("New API Token", text: $newApiKey)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 50)

            Button("Submit") {
                handleApiKeyUpdate()
            }
            .buttonStyle(CustomButtonStyle())
        }
    }

    private var passwordSection: some View {
        VStack {
            Text("Change your Password")
            SecureField("New Password", text: $newPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 50)

            Button("Submit") {
                handlePasswordUpdate()
            }
            .buttonStyle(CustomButtonStyle())
        }
    }

    private var clearKeychainSection: some View {
        VStack {
            Text("Delete all your data and re-register")
                .multilineTextAlignment(.center)
            Button("Clear Keychain") {
                activeAlert = .clearKeychain
            }
            .padding(5)
            .background(Color.blue)
            .foregroundColor(.gray)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1)
            )
        }
    }

    private var logoutSection: some View {
        
        Button("Logout") {
            activeAlert = .logout
        }
        .buttonStyle(CustomButtonStyle())
        
    }

    private func handleApiKeyUpdate() {
        if newApiKey.isEmpty {
            activeAlert = .apiKeyUpdate("API Key field is empty.")
        } else {
            let success = userManager.saveApiKey(apiKey: newApiKey)
            if success {
                activeAlert = .apiKeyUpdate("API Key successfully updated.")
            } else {
                activeAlert = .apiKeyUpdate("Failed to update API Key.")
            }
            newApiKey = success ? "" : newApiKey
        }
    }

    private func handlePasswordUpdate() {
        if newPassword.isEmpty {
            activeAlert = .PWupdate("Password field is empty.")
        } else if let username = userManager.getCurrentUsername() {
            let success = userManager.saveCredentials(username: username, password: newPassword)
            if success {
                activeAlert = .PWupdate("Password successfully updated for \(username).")
            } else {
                activeAlert = .PWupdate("Failed to update password for \(username).")
            }
            newPassword = success ? "" : newPassword
        } else {
            activeAlert = .PWupdate("No logged-in user found to update password.")
        }
    }

}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(UserManager.shared)
    }
}


