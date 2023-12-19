//
//  AImageApp.swift
//  AImage
//
//  Created by Astrid Lanz on 17.12.2023.
//


import SwiftUI
import Combine
import Foundation

struct RegistrationView: View {
    @EnvironmentObject var userManager: UserManager
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var apiKey: String = ""
    @Environment(\.dismiss) private var dismiss
    @State private var showingAlert = false  // State variable for registration alert 
    @State private var alertMessage = ""
    
    
    var body: some View {
        ZStack {
            backgroundGradient.ignoresSafeArea()
            
            ScrollView {
                VStack {
                    LogoView()
                        .font(.title)
                        .padding(.bottom, 70)
                    Text("Registration")
                        .font(.title)
                    Text("Please register by entering a Username and a Password. To get started, you need to generate an API Token at [Replicate](https://replicate.com/account/api-tokens) for free. Your data will be stored within this Apps Keychain locally.")
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    TextField("Username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 50)
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 50)
                    
                    Text("Enter your  API token, which you generated at  [Replicate](https://replicate.com/account/api-tokens)")
                        .multilineTextAlignment(.center)
                        .padding(.top, 30)
                    
                    TextField("Your Replicate API token", text: $apiKey)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 50)
                    
                    Button("Register") {
                        let isSuccess = userManager.register(username: username, password: password, apiKey: apiKey)
                        if isSuccess {
                            dismiss()
                        }else {
                            alertMessage = "Registration failed. Please check your details and try again."
                            showingAlert = true
                        }
                    }
                    .buttonStyle(CustomButtonStyle())
                    
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                }
            }
        }
    }
}
    
struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
            .environmentObject(UserManager.shared)
    }
}


