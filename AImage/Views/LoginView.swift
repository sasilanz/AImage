//
//  AImageApp.swift
//  AImage
//
//  Created by Astrid Lanz on 17.12.2023.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var userManager: UserManager
    @State private var username = ""
    @State private var password = ""
    @State private var apiKey = ""

    var body: some View {
        ZStack {
            backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                LogoView()
                
                Spacer()
                
                Text("Login with your Username and Password to access your API Token from the Keychain and use this App")
                    .multilineTextAlignment(.center)
                    .padding(30)
                    
                
                TextField("Username", text: $username)
                    .padding(.horizontal, 50)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                SecureField("Password", text: $password)
                    .padding(.horizontal, 50)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                               
                Button("Login") {
                    userManager.login(username: username, password: password)
                }
                .buttonStyle(CustomButtonStyle())
                
                Spacer()
                
            }
            .padding()
            
        }
    }
    
}
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(UserManager.shared)
    }
}

