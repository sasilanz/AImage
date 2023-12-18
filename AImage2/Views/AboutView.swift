//
//  AboutView.swift
//  AImage2
//
//  Created by Astrid Lanz on 17.12.2023.
//


import SwiftUI


struct AboutView: View {
    @EnvironmentObject var userManager: UserManager
    
    var body: some View {
        ZStack {
            backgroundGradient
                .ignoresSafeArea()

            VStack {
                // Logo at the top
                LogoView()

                // ScrollView for the rest of the content
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("About me")
                            .font(.title)
                            .padding(10)
                        Text("My name is Astrid, I am 59 years old and I live in Switzerland. I am new to iOS Software Development and wanted to give it a try. So this simple App is my first iOS App. ")
                            .padding(.bottom, 5)
                            //.multilineTextAlignment(.center)
                            .padding(5)

                        Text("About this app")
                            .font(.title)
                            .padding(10)

                        Text("This is my final Project for [CS50](https://cs50.harvard.edu/x/2023/project/). ")
                            .padding(5)
                        Text("This is an iOS App built with Xcode and SwiftUI and based on the [Replicate Swift Package](https://github.com/replicate/replicate-swift) to make AI predictions, in this case a text-based Image Search. The App is using the Replicate backend by making API calls. The API Stucture and the Model is defined in the Replicate Package. ")
                            .padding(5)
                        Text("Most important changes to the Replicate Package was the introduction of Keychain to savely store User Credentials and API token. Second important improvement was the modularisation of the actual ImageSearchView code in SwiftUI. ")
                            .padding(5)
                        Text("And finally a lot of energy and time went into a smooth User Experience, the registration and login flow. ")
                        
                        }
                        
                    }
                    .padding() // Adds padding around the VStack content
                }
            }
           
        }
    }




// In your preview
struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
            .environmentObject(UserManager.shared)
    }
}



#Preview {
    AboutView()
}

