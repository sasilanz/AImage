//
//  AImage2App.swift
//  AImage2
//
//  Created by Astrid Lanz on 17.12.2023.
//  refactored Version after Crash

import SwiftUI

@main
struct AImage2App: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(UserManager.shared)
        }
    }
}
