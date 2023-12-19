//
//  AImageApp.swift
//  AImage
//
//  Created by Astrid Lanz on 17.12.2023.
//

import SwiftUI

struct LoggedInView: View {
    
    @EnvironmentObject var userManager: UserManager
    
    var body: some View {
        VStack {
            LogoView()
                .padding(.top, 20) // Add padding at the top of the LogoView
                .padding(.bottom, 60)
            
            VStack {
                
                Text("Explore how AI takes your text input to search for an Image. Have fun.")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding(20)
                Spacer(minLength: 20)
                
                NavigationLink("Go to AImage Search", destination: ImageSearchView())
                    .buttonStyle(CustomButtonStyle())
                    .padding()
                Spacer(minLength: 20)
                NavigationLink("My Profile", destination: ProfileView())
                    .buttonStyle(CustomButtonStyle())
                    .padding()
                
                NavigationLink("About", destination: AboutView())
                    .buttonStyle(CustomButtonStyle())
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        }
        .background(backgroundGradient
        .ignoresSafeArea())
    }
}

struct LoggedInView_Previews: PreviewProvider {
    static var previews: some View {
        LoggedInView()
            .environmentObject(UserManager.shared)
    }
}
