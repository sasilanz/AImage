//
//  AImageApp.swift
//  AImage
//
//  Created by Astrid Lanz on 17.12.2023.
//

import SwiftUI

struct EntryView: View {
    @EnvironmentObject var userManager: UserManager
    
    var body: some View {
        VStack {
            LogoView()
                .padding(.top, 20)
            
            ScrollView {
                VStack {
                    welcomeText
                    descriptionText
                    registrationText
                    registerNowText
                    getstarted
                }
                
                .padding(30)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backgroundGradient.ignoresSafeArea())
    }
    
    private var welcomeText: some View {
        HStack {
            Text("Welcome to discover the world of ")
            + Text("A").foregroundColor(.blue)
            + Text("I").foregroundColor(.green)
            + Text("mage").foregroundColor(.black)
            + Text(" search")
        }
        .font(.title)
        .multilineTextAlignment(.center)
    }
    
    private var descriptionText: some View {
        Text("This App is my final project for [CS50](https://cs50.harvard.edu/x/2023/project/). It is actually a pretty unspectular App, which will search an image for you. The interesting fact though is, that the image is being searched by an AI. The result is therefore different from a Google Search and can be quite surprising.")
            .multilineTextAlignment(.center)
            .padding(10)
    }
    
    private var registrationText: some View {
        Text("During registration you will need to enter an API token, which you can generate at [Replicate](https://replicate.com/signin?next=/docs/get-started/swiftui) for free. The API token is required for this App to communicate with the replicate AI backend. Your data will be savely stored in the AImage Keychain locally. Once you are registered, you can always delete your data in your Profile.")
            .multilineTextAlignment(.center)
            .padding(10)
    }
    
    private var registerNowText: some View {
        Text("Register now to start exploring.")
            .font(.title)
            .padding(.top, 10)
    }
    
    private var getstarted: some View {
        NavigationLink("Get Started", destination: RegistrationView())
            .buttonStyle(CustomButtonStyle())
    }

}
#Preview {
    EntryView()
        .environmentObject(UserManager.shared)
}
