//
//  AImage2App.swift
//  AImage2
//
//  Created by Astrid Lanz on 17.12.2023.
//  refactored Version after Crash


import SwiftUI

let backgroundGradient = LinearGradient(
    colors: [Color.red, Color.blue],
    startPoint: .top, endPoint: .bottom)


struct ContentView: View {
    @EnvironmentObject var userManager: UserManager

    var body: some View {
        NavigationStack {
            if userManager.isLoggedIn {
                LoggedInView()
            } else if !userManager.isLoggedIn && userManager.isRegistered {
                    LoginView()
            } else {
                EntryView()
            }
        }
        .id(userManager.isLoggedIn)
        .id(userManager.isRegistered)
        .background(backgroundGradient.ignoresSafeArea())
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserManager.shared)
    }
}
